@echo off
REM ---------------------------
REM Step 1: Extract the Talend Job Archive
REM ---------------------------
echo Extracting Talend Job archive...
if not exist "E:\School\project\ETL\Project_ETL_Northwind_dub_02_0.1\Project_ETL_Northwind_dub_02" (
    mkdir "E:\School\project\ETL\Project_ETL_Northwind_dub_02_0.1\Project_ETL_Northwind_dub_02"
)

powershell -Command "Expand-Archive -Path 'E:\School\project\ETL\Project_ETL_Northwind_dub_02_0.1.zip' -DestinationPath 'E:\School\project\ETL\Project_ETL_Northwind_dub_02_0.1\Project_ETL_Northwind_dub_02' -Force"

REM ---------------------------
REM Step 2: Verify and Run the Talend Job
REM ---------------------------
echo Checking if Talend Job exists...
if exist "E:\School\project\ETL\Project_ETL_Northwind_dub_02_0.1\Project_ETL_Northwind_dub_02\Project_ETL_Northwind_dub_02_run.bat" (
    echo Running the Talend Job...
    cd /d "E:\School\project\ETL\Project_ETL_Northwind_dub_02_0.1\Project_ETL_Northwind_dub_02"
    call Project_ETL_Northwind_dub_02_run.bat
	echo Running the Talend Job is Done !!!!	
) else (
    echo ERROR: Project_ETL_Northwind_dub_02_run.bat not found! Extraction might have failed.
    pause
    exit /b
)


timeout /t 10 /nobreak

REM ---------------------------
REM Step 3: Run the Python Dashboard Script
REM ---------------------------
echo Starting the Dashboard Script...
py "E:\School\project\dach\dashboard.py"

pause
