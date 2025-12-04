#!/bin/bash

WORKSPACE_PATH="/Users/yanmoroz/Development/flutter_projects/hr_tcc_project"

echo "Running code actions on all Dart files..."
echo ""

find "$WORKSPACE_PATH/lib" -name "*.dart" -type f | while read -r file; do
  echo "Processing: ${file#$WORKSPACE_PATH/}"
  
  # Run Dart fix (organizes imports, fixes issues)
  dart fix --apply "$file" 2>/dev/null
  
  # Format file (sorts members, formats code)
  dart format "$file" 2>/dev/null
  
  echo "  ✓ Completed"
done

echo ""
echo "✓ All files processed!"