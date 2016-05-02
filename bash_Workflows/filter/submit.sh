echo "\n\n\n\n\n\n\n\n\n\n"
clear

echo "Deleting experiment files..."
./delete.sh

echo "Restoring provenance database..."
./restore.sh

echo "Executing scientific workflow..."
./execute.sh
