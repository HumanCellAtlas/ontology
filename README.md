[![Build Status](https://travis-ci.org/HumanCellAtlas/ontology.svg?branch=master)](https://travis-ci.org/HumanCellAtlas/ontology)

# hcao

An application ontology for the Human Cell Atlas.  

## Components: 

### Anatomy:

Mamalian anatomy and cell type terms from Uberon and the cell ontology;  Human-specific labels from the Foundational Model of Anatomy

## Versions

### Stable release versions

The latest version of the ontology can always be found at:

http://purl.obolibrary.org/obo/hcao.owl

(note this will not show up until the request has been approved by obofoundry.org)

### Editors' version

Editors of this ontology should use the edit version, [src/ontology/hcao-edit.owl](src/ontology/hcao-edit.owl)

## Build a OLS docker instance with ontologies in

```
docker build . -t hcao-ols
docker run -p 8080:8080 -t hcao-ols 
``` 

## Contact

Please use this GitHub repository's [Issue tracker](https://github.com/HumanCellAtlas/ontology/issues) to request new terms/classes or report errors or specific concerns related to the ontology.

## Acknowledgements

This ontology repository was created using the [ontology starter kit](https://github.com/INCATools/ontology-starter-kit)
