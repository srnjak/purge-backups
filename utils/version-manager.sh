#!/bin/bash

export var suffix="prev"

function usage {
  cat << EOF
Usage: $0 <project_root> --release|--new-preview|--new-version [<new_version>]

Options:
  --release       Strip any suffix from the current version.
  --new-preview   Increase the minor part of the version and add a $suffix suffix,
                  unless the version already has a "${suffix}X" suffix, in which case
                  it will increase that number.
  --new-version   Specify a new version to use.

Arguments:
  <project_root>  The root directory of the project, containing the
                  project.properties file.
  <new_version>   The new version to use, if --new-version is specified.
EOF
}

# Check that argument is provided
if [ -z "$1" ]; then
  usage
  exit 1
fi

# Set variables
project_root=$1
properties_file="${project_root}/project.properties"

# Check that properties file exists
if [ ! -f "$properties_file" ]; then
  echo "Error: project.properties file not found in ${project_root}"
  exit 1
fi

# Get current version from properties file
current_version=$(grep "^version=" "$properties_file" | cut -d "=" -f 2)

# Determine which option was selected and update version accordingly
case "$2" in
  --release)
    new_version=$(echo "$current_version" | cut -d "~" -f 1)
    ;;
  --new-preview)
    if [[ $current_version =~ "$suffix"[0-9]+$ ]]; then
      prev_number=$(echo "$current_version" | grep -Eo "[0-9]+$")
      new_pre_number=$(($prev_number + 1))
      new_version=$(echo "$current_version" | sed "s/${suffix}[0-9]\+$/$suffix$new_pre_number/")
    else
      # version has no suffix, increment the minor version and add the prev1 suffix
      minor=$(echo "$current_version" | grep -Eo '[0-9]+~?[a-zA-Z]*$' | grep -Eo '[0-9]+$')
      new_minor=$(($minor + 1))
      new_version=$(echo "$current_version" | sed "s/[0-9]\+~\?[a-zA-Z]*$/""$new_minor""~${suffix}1/")
    fi
    ;;
  --new-version)
    if [ -z "$3" ]; then
      echo "Error: new version argument missing"
      usage
      exit 1
    fi
    new_version=$3
    ;;
  *)
    usage
    exit 1
    ;;
esac

# Update properties file with new version
sed -i "s/^version=.*/version=$new_version/" "$properties_file"

echo "$new_version"
