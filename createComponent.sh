#!/bin/bash

# Default values
directory_name=""
props=()
generate_props=false

# Process command-line options using getopts
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n | --name)
      directory_name=$2
      shift 2
      ;;
    -p | --props)
      generate_props=true
      shift
      while [[ $# -gt 0 ]] && [[ "$1" != -* ]]; do
        props+=("$1")
        shift
      done
      ;;
    *)
      break
      ;;
  esac
done

if [ -z "$directory_name" ]; then
  echo "Usage: $0 [-n | --name] <directory_name> [-p | --props] <prop1:type1> <prop2:type2> ..."
  exit 1
fi

tsx_file="${directory_name}/${directory_name}.tsx"
index_file="${directory_name}/index.tsx"

# Create the directory
mkdir "$directory_name"

# Create the .tsx file inside the directory with the desired content
echo "import React from 'react';" > "$tsx_file"
echo "" >> "$tsx_file"

# Generate the interface if the flag is set
if $generate_props; then
  echo "interface ${directory_name}Props {" >> "$tsx_file"
  for prop in "${props[@]}"; do
    echo "  $prop;" >> "$tsx_file"
  done
  echo "}" >> "$tsx_file"
  echo "" >> "$tsx_file"
fi

# Conditionally include the interface in the function signature
if $generate_props; then
  if [ ${#props[@]} -ne 0 ]; then
    props_names=($(printf "%s\n" "${props[@]}" | cut -d ':' -f 1))
    props_string=$(IFS=','; echo "${props_names[*]}")
    echo "export const ${directory_name}: React.FC<${directory_name}Props> = ({${props_string}}) => {" >> "$tsx_file"
  else
    echo "export const ${directory_name}: React.FC<${directory_name}Props> = () => {" >> "$tsx_file"
  fi
else
  echo "export const ${directory_name}: React.FC = () => {" >> "$tsx_file"
fi

echo "  return <></>;" >> "$tsx_file"
echo "};" >> "$tsx_file"

# Create the index.tsx file with the export statement
echo "export * from './${directory_name}.tsx'" > "$index_file"

# Echo whether props were used or not
if $generate_props; then
  echo "Directory '$directory_name' created with necessary files and interface generated."
else
  echo "Directory '$directory_name' created with necessary files, no interface generated."
fi
