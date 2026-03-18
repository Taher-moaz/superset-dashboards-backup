@echo off
echo Exporting Superset dashboards...

docker exec superset_app superset export-dashboards -f /app/dashboards.zip

echo Copying file...
docker cp superset_app:/app/dashboards.zip .

echo Extracting...
tar -xf dashboards.zip

echo Finding export folder...
for /d %%i in (dashboard_export_*) do set folder=%%i

echo Repacking...
cd %folder%
tar -cf ../dashboards_ready.zip dashboards charts datasets metadata.yaml
cd ..

echo Sending to Superset...
docker cp dashboards_ready.zip superset_app:/app/dashboards.zip

echo Importing...
docker exec superset_app superset import-dashboards -p /app/dashboards.zip --overwrite

echo Saving to Git...
git add .
git commit -m "Auto backup %date% %time%"
git push

echo Done!
pause