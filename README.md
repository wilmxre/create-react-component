# create-react-component

This repo provides a Bash script designed to generate a React functional component directory with a TypeScript (.tsx) and an index.tsx file. The script allows you to create the component with or without props.

## Usage

`yarn create-component [-n | --name] <component_name> [-p | --props] <prop1:type1> <prop2:type2> ...`

## Options

- -n, --name: Specifies the name of the directory and the React functional component file.
- -p, --props: Generates the interface for props and allows you to specify prop names and types.

## Example

To create a component named "MyComponent" with props "name: string" and "age: number," run:

`yarn create-component -n MyComponent -p name:string age:number`
