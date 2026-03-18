@echo off
echo Exporting Superset dashboards...

docker exec superset_app superset export-dashboards -f /app/dashboards.zip

echo Copying file...
docker cp superset_app:/app/dashboards.zip .

echo Extracting...
tar -xf dashboards.zip

echo Checking changes...
git status

echo Adding to git...
git add .

echo Committing...
git commit -m "Auto backup %date% %time%"

echo Pushing to GitHub...
git push

echo Done!
pause