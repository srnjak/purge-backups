#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$0")

# The project root
ROOT_DIR="$(realpath "$SCRIPT_DIR/..")"

echo "The project root directory is: $ROOT_DIR"

# The target directory
TARGET_DIR="$ROOT_DIR/target"

# Default values for deployment options
DEPLOY_USER=""
DEPLOY_PASSWORD=""
DEPLOY_REPO=""
PACKAGE_NAME=""

# Function to print usage information
function print_usage() {
  cat << EOF

Usage: $0 <command> [-u <username>] [-p <password>] [-r <repository_url>] [-n <package_name>]

Commands:
  clean      - Remove the target directory
  prepare    - Prepares the debian directory structure
  package    - Package the application into a .deb file
  deploy     - Deploy the .deb file to a repository

Options:
  -u <username>         - The username for the repository
  -p <password>         - The password for the repository
  -r <repository_url>   - The URL of the repository to deploy to
  -n <package_name>     - The name of the .deb package to create
EOF
}

# Function to check if an input value is empty or not
function check_input() {
  if [[ -z "$1" ]]; then
    echo "Error: $2 is missing or empty."
    exit 1
  fi
}

command=$1
shift

# Parse command-line options
while getopts ":u:p:r:n:" opt; do
  case ${opt} in
    u )
      DEPLOY_USER=${OPTARG}
      ;;
    p )
      DEPLOY_PASSWORD=${OPTARG}
      ;;
    r )
      DEPLOY_REPO=${OPTARG}
      ;;
    n )
      PACKAGE_NAME=${OPTARG}
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      print_usage
      exit 1
      ;;
    : )
      echo "Option -$OPTARG requires an argument." 1>&2
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Execute the appropriate command
case "$command" in
  clean)
    echo "Cleaning up..."
    rm -rf $TARGET_DIR
    ;;
  prepare)
    echo "Preparing..."
    $SCRIPT_DIR/generate_control_file.sh $ROOT_DIR
    $SCRIPT_DIR/deb_structure.sh $ROOT_DIR
    ;;
  package)
    echo "Packaging..."

    # Define the target path variable
    if [[ -z "$PACKAGE_NAME" ]]; then
      TARGET_PATH="$TARGET_DIR"
    else
      TARGET_PATH="$TARGET_DIR/$PACKAGE_NAME"
    fi

    dpkg-deb --build "$TARGET_DIR/purge-backups" "$TARGET_PATH"
    ;;
  deploy)
    echo "Deploying..."

    # Check deployment options
    check_input "$DEPLOY_USER" "Username"
    check_input "$DEPLOY_PASSWORD" "Password"
    check_input "$DEPLOY_REPO" "Repository URL"

    # Check package name option
    check_input "$PACKAGE_NAME" "Package name"

    # Check repository URL format
    if [[ ! "$DEPLOY_REPO" =~ ^https?:// ]]; then
      echo "Error: Invalid repository URL format. The URL should start with http:// or https://"
      exit 1
    fi

    echo "Deploying with username $DEPLOY_USER, and repository URL $DEPLOY_REPO..."
    curl -u "$DEPLOY_USER:$DEPLOY_PASSWORD" -H "Content-Type: multipart/form-data" --data-binary "@$TARGET_DIR/$PACKAGE_NAME" "$DEPLOY_REPO"

    ;;
  *)
    echo "Invalid command. Please use one of the following commands: clean, prepare, package, deploy."
    print_usage
    exit 1
    ;;
esac

exit 0
