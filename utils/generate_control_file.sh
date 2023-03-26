#!/bin/bash

set -o errexit
set -o nounset

# Check that required tools are installed
command -v sed >/dev/null 2>&1 || {
  echo >&2 "Error: sed is not installed."
  exit 1
}

# Get the project root directory from the command-line argument
PROJECT_ROOT=$1

# Check if the project root directory exists
if [ ! -d "$PROJECT_ROOT" ]; then
  echo "Error: Project root directory '$PROJECT_ROOT' does not exist."
  exit 1
fi

# Predefined variables
package=
version=
maintainer=
description=

# Read in the properties from project.properties
while IFS='=' read -r key value; do
  declare "$key=$value"
done < "$PROJECT_ROOT/project.properties"

# Define an array of the required variable names
required_vars=(package version maintainer description)

# Check if the required variables are set
for var in "${required_vars[@]}"; do
  : "${!var:?Error: $var variable not set in config.properties}"
done

# Create the target/DEBIAN directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/target/DEBIAN"

# Define the paths to the template and output files
template_file="$PROJECT_ROOT/src/debian/control"
output_file="$PROJECT_ROOT/target/DEBIAN/control"

# Print out some debug information
echo "Using template file: $template_file"
echo "Using output file: $output_file"
echo "Values of variables:"
echo "  package: $package"
echo "  version: $version"
echo "  maintainer: $maintainer"
echo "  description: $description"

# Replace the variables in the template with the values from the properties file
sed "s/{{package}}/$package/; \
     s/{{version}}/$version/; \
     s/{{maintainer}}/$maintainer/; \
     s/{{description}}/$description/" \
  $template_file > $output_file

echo "Control file generated successfully at $output_file"
