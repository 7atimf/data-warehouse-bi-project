import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output
import pandas as pd
import plotly.express as px
from sqlalchemy import create_engine

# Database connection details (Replace with your actual credentials)
db_connection_str ='mysql+mysqlconnector://root:hatim7atim@localhost/dwh_dim'  # Replace with your actual credentials
engine = create_engine(db_connection_str)

# --- Data Retrieval Functions ---
def get_sales_overview_data():
    query = """SELECT
                    SUM(TotalSalesAmount) AS total_sales,
                    COUNT(DISTINCT CustomerID) AS unique_customers
                FROM SalesFact;"""
    try:
        df = pd.read_sql(query, engine)
        print(df.columns)
    except Exception as e:
        print(f"Database query error: {e}")
        return pd.DataFrame()
    return df

def get_sales_by_category():
    query = """SELECT
                p.Category_Name,
                SUM(s.TotalSalesAmount) AS total_sales
            FROM SalesFact s
            JOIN Product_Dim p ON s.ProductID = p.Product_Id
            GROUP BY p.Category_Name
            ORDER BY total_sales DESC;"""
    try:
        df = pd.read_sql(query, engine)
        print(df.columns)
    except Exception as e:
        print(f"Database query error: {e}")
        return pd.DataFrame()
    return df

def get_top_selling_products():
    query = """SELECT
                p.Product_Name,
                SUM(s.TotalSalesAmount) AS total_sales
            FROM SalesFact s
            JOIN Product_Dim p ON s.ProductID = p.Product_Id
            GROUP BY p.Product_Name
            ORDER BY total_sales DESC
            LIMIT 10;"""
    try:
        df = pd.read_sql(query, engine)
        print(df.columns)
    except Exception as e:
        print(f"Database query error: {e}")
        return pd.DataFrame()
    return df

def get_sales_by_country():
    query = """SELECT
        c.Country,
        SUM(s.TotalSalesAmount) AS total_sales
    FROM SalesFact s
    JOIN Customer_Dim c ON s.CustomerID = c.Customer_Id
    GROUP BY c.Country
    ORDER BY total_sales DESC;"""
    try:
        df = pd.read_sql(query, engine)
        print(df.columns)
    except Exception as e:
        print(f"Database query error: {e}")
        return pd.DataFrame()

    return df

def get_supplier_avg_delivery_time():
    query = """SELECT
               s.Supplier_Name,
               AVG(s.Avg_Delivery_Time_Days) AS avg_delivery
           FROM
              Supplier_Dim s
           GROUP BY
               s.Supplier_Name
           ORDER BY
               avg_delivery DESC;"""
    try:
        df = pd.read_sql(query, engine)
        print(df.columns)
    except Exception as e:
        print(f"Database query error: {e}")
        return pd.DataFrame()

    return df

# --- Styles ---
main_color = '#FFFACD'  # LemonChiffon - A soft yellow
secondary_color = '#FAF0E6'  # Linen - Off-white
# main_color = '#f0f8ff'  # AliceBlue - A soft, inviting blue
# secondary_color = '#e6f7ff'  # Very Light blue,

tab_style = {
    'borderBottom': '1px solid #d6d6d6',
    'padding': '6px',
    'fontWeight': 'bold',
    'backgroundColor': main_color,
    'color': '#333'
}

tab_selected_style = {
    'borderTop': '1px solid #d6d6d6',
    'borderBottom': '1px solid #d6d6d6',
    'backgroundColor': secondary_color,
    'color': '#333',
    'padding': '6px'
}

card_style = {
    'backgroundColor': secondary_color,
    'color': '#333',
    'padding': '10px',
    'textAlign': 'center',
    'borderRadius': '5px',
    'boxShadow': '0 2px 4px rgba(0,0,0,0.1)'
}

# --- App Definition ---
app = dash.Dash(__name__)

# --- Layout ---
app.layout = html.Div(
    style={
        'backgroundColor': main_color,
        'color': '#333',
        'fontFamily': 'Arial, sans-serif',
        'padding': '0px'
    },
    children=[
        html.H1(children='Tableau de bord des ventes Northwind', style={'textAlign': 'center', 'padding': '20px', 'color': '#007BFF'}),

        # Overview Section
        html.Div(style={'padding': '20px'}, children=[
            html.H2('Aperçu - Indicateurs clés de performance', style={'textAlign': 'center', 'color': '#007BFF'}),
            html.Div(className='row', children=[
                html.Div(className='four columns', children=[
                    html.Div(className='card', style=card_style, children=[
                        html.H4('Ventes Totales'),
                        html.P(id='total-sales-kpi-overview')
                    ])
                ]),
                html.Div(className='four columns', children=[
                    html.Div(className='card', style=card_style, children=[
                        html.H4('Clients Uniques'),
                        html.P(id='unique-customers-kpi-overview')
                    ])
                ]),
            ]),
            html.H2('Aperçu - Ventes par Pays', style={'textAlign': 'center', 'marginTop': '20px', 'color': '#007BFF'}),
            dcc.Graph(id='sales-by-country-graph'),
            html.Div(id='dummy-trigger-overview', style={'display': 'none'})  # Dummy component
        ]),

        # Product Analysis Section
        html.Div(style={'padding': '20px'}, children=[
            html.H2('Analyse des Produits - Ventes par Catégorie de Produits', style={'textAlign': 'center', 'color': '#007BFF'}),
            dcc.Graph(id='category-sales-graph'),
            html.H2('Analyse des Produits - Meilleurs Produits Vendus', style={'textAlign': 'center', 'color': '#007BFF'}),
            dcc.Graph(id='top-products-graph'),
            html.Div(id='dummy-trigger-product', style={'display': 'none'})  # Dummy component
        ]),

        # Supplier Analysis Section
        html.Div(style={'padding': '20px'}, children=[
            html.H2('Analyse des Fournisseurs - Délai de Livraison Moyen des Fournisseurs', style={'textAlign': 'center', 'color': '#007BFF'}),
            dcc.Graph(id='supplier-avg-delivery-graph'),
            html.Div(id='dummy-trigger-supplier', style={'display': 'none'})  # Dummy component
        ]),
    ]
)

# --- Callbacks ---
# Callback for KPIs on Overview tab
@app.callback(
    Output('total-sales-kpi-overview', 'children'),
    Input('dummy-trigger-overview', 'id')  # Use the dummy component
)
def update_overview_kpis(dummy_id):
    df = get_sales_overview_data()
    if df.empty:
        return "No Data", "No Data"
    if not df.empty and len(df)>0:
     total_sales = "${:,.2f}".format(df['total_sales'][0])
     unique_customers = df['unique_customers'][0]
    else:
      total_sales = "No Data"
      unique_customers =  "No Data"
    return total_sales, unique_customers

# Callback for Sales by Country Graph on Overview tab
@app.callback(
    Output('sales-by-country-graph', 'figure'),
    Input('dummy-trigger-overview', 'id')  # Use the dummy component
)
def update_sales_by_country(dummy_id):
    df = get_sales_by_country()
    if df.empty:
        return {}
    fig = px.bar(df, x="Country", y="total_sales", title='Ventes par Pays', color='Country')
    fig.update_layout(plot_bgcolor='rgba(255,255,255,0.25)', paper_bgcolor='rgba(255,255,255,0.25)', font_color='#333')
    return fig

# Callback for Product Category Graph
@app.callback(
    Output('category-sales-graph', 'figure'),
    Input('dummy-trigger-product', 'id')  # Dummy input to trigger initial load
)
def update_category_sales(dummy_id):
    df = get_sales_by_category()
    if df.empty:
        return {}
    fig = px.bar(df, x="Category_Name", y="total_sales", title='Ventes Totales par Catégorie de Produits', color='Category_Name')
    fig.update_layout(plot_bgcolor='rgba(255,255,255,0.25)', paper_bgcolor='rgba(255,255,255,0.25)', font_color='#333')
    return fig

# Callback for Top Selling Products Graph
@app.callback(
    Output('top-products-graph', 'figure'),
    Input('dummy-trigger-product', 'id')
)
def update_top_products(dummy_id):
    df = get_top_selling_products()
    if df.empty:
        return {}
    fig = px.bar(df, x="Product_Name", y="total_sales", title='Top 10 des Produits les Plus Vendus', color='Product_Name')
    fig.update_layout(plot_bgcolor='rgba(255,255,255,0.25)', paper_bgcolor='rgba(255,255,255,0.25)', font_color='#333')
    return fig

# Callback for Supplier Average Delivery Bar Graph
@app.callback(
    Output('supplier-avg-delivery-graph', 'figure'),
    Input('dummy-trigger-supplier', 'id')
)
def update_supplier_delivery(dummy_id):
    df = get_supplier_avg_delivery_time()
    if df.empty:
        return {}
    fig = px.bar(df, x="Supplier_Name", y="avg_delivery", title='Délai de Livraison Moyen par Fournisseur', color='Supplier_Name')
    fig.update_layout(plot_bgcolor='rgba(255,255,255,0.25)', paper_bgcolor='rgba(255,255,255,0.25)', font_color='#333')
    return fig

# Run the app
if __name__ == '__main__':
    app.run_server(debug=True)