#!/bin/bash

# MatrixFilter Naming Fix Script
# This script finds and replaces all incorrect "Flanger" references with "Filter"

echo "========================================"
echo "MatrixFilter Naming Fix Script"
echo "========================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter for changes
total_files_changed=0

# Function to show what would be changed
show_preview() {
    echo -e "${YELLOW}Preview of changes:${NC}"
    echo ""
    
    echo "Files containing 'Flanger' (case variations):"
    grep -r -i "flanger" . --exclude-dir={.git,build*,external} --exclude="*.{o,so,dll,dylib}" 2>/dev/null | head -20
    
    echo ""
    echo -e "${YELLOW}Total files with 'Flanger' references:${NC}"
    grep -r -i -l "flanger" . --exclude-dir={.git,build*,external} --exclude="*.{o,so,dll,dylib}" 2>/dev/null | wc -l
}

# Function to perform the replacement
do_replacement() {
    echo -e "${GREEN}Starting replacement...${NC}"
    echo ""
    
    # Find all files (excluding build directories and binaries)
    find . -type f \
        -not -path "./.git/*" \
        -not -path "*/build*/*" \
        -not -path "*/external/*" \
        -not -name "*.o" \
        -not -name "*.so" \
        -not -name "*.dll" \
        -not -name "*.dylib" \
        -not -name "*.a" \
        -not -name "fix_naming.sh" \
        | while read file; do
        
        # Check if file contains any variation of "flanger"
        if grep -q -i "flanger" "$file" 2>/dev/null; then
            echo -e "${YELLOW}Processing:${NC} $file"
            
            # Create backup
            cp "$file" "$file.bak"
            
            # Perform replacements (case-sensitive)
            sed -i 's/MatrixFlanger/MatrixFilter/g' "$file"
            sed -i 's/MATRIXFLANGER/MATRIXFILTER/g' "$file"
            sed -i 's/MATRIX_FLANGER/MATRIX_FILTER/g' "$file"
            sed -i 's/matrix-flanger/matrix-filter/g' "$file"
            sed -i 's/matrix_flanger/matrix_filter/g' "$file"
            sed -i 's/matrixflanger/matrixfilter/g' "$file"
            sed -i 's/Flanger/Filter/g' "$file"
            sed -i 's/FLANGER/FILTER/g' "$file"
            sed -i 's/flanger/filter/g' "$file"
            
            ((total_files_changed++))
            echo -e "${GREEN}  ✓ Updated${NC}"
        fi
    done
    
    echo ""
    echo -e "${GREEN}Replacement complete!${NC}"
    echo -e "Total files changed: ${total_files_changed}"
}

# Function to restore from backup
restore_backup() {
    echo -e "${YELLOW}Restoring from backup...${NC}"
    find . -name "*.bak" | while read backup; do
        original="${backup%.bak}"
        mv "$backup" "$original"
        echo "Restored: $original"
    done
    echo -e "${GREEN}Restore complete!${NC}"
}

# Function to clean up backups
cleanup_backups() {
    echo -e "${YELLOW}Cleaning up backup files...${NC}"
    find . -name "*.bak" -delete
    echo -e "${GREEN}Cleanup complete!${NC}"
}

# Main menu
echo "What would you like to do?"
echo "1) Preview changes (safe - no modifications)"
echo "2) Apply fixes (creates .bak backups)"
echo "3) Restore from backups"
echo "4) Clean up backup files"
echo "5) Exit"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
    1)
        show_preview
        ;;
    2)
        show_preview
        echo ""
        read -p "Proceed with replacement? (y/n): " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            do_replacement
            echo ""
            echo -e "${YELLOW}Backup files (.bak) have been created.${NC}"
            echo "Run this script again and choose option 3 to restore if needed."
        else
            echo "Cancelled."
        fi
        ;;
    3)
        restore_backup
        ;;
    4)
        cleanup_backups
        ;;
    5)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo "Done!"
