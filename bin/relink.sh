#!/bin/bash

# Usage: bash scripts/relink.sh --type=scss --type=js --src=. --dest=../b --ignore=node_modules --ignore=some_other_dir

# Initialize arrays for types and ignore paths
TYPES=()
IGNORE_PATHS=()

# Parse arguments
for i in "$@"
do
case $i in
    --type=*)
    TYPES+=("${i#*=}")
    shift
    ;;
    --src=*)
    SRC_DIR="${i#*=}"
    shift
    ;;
    --dest=*)
    DEST_DIR="${i#*=}"
    shift
    ;;
    --ignore=*)
    IGNORE_PATHS+=("${i#*=}")
    shift
    ;;
    *)
    ;;
esac
done

# Ensure source and destination directories are provided
if [ -z "$SRC_DIR" ] || [ -z "$DEST_DIR" ]; then
    echo "Source and destination directories are required."
    exit 1
fi

# Remove existing symlinks in destination
find "$DEST_DIR" -type l -exec rm {} +

# Function to generate find command's ignore parameters
generate_ignore_params() {
    for ignore_path in "${IGNORE_PATHS[@]}"; do
        echo -n "! -path \"$SRC_DIR/$ignore_path/*\" "
    done
}

# Function to create symlinks for a specific type
create_symlinks() {
    local ext=$1
    local ignore_params=$(generate_ignore_params)
    eval find "$SRC_DIR" -type f $ignore_params -name "*.$ext" | while read -r src_file; do
        rel_path=$(realpath --relative-to="$DEST_DIR" "$src_file")
        symlink_name=$(echo "$rel_path" | sed 's/\//_/g')
        ln -s "$rel_path" "$DEST_DIR/$symlink_name"
    done
}

# Create symlinks for each type
for type in "${TYPES[@]}"; do
    create_symlinks "$type"
done
