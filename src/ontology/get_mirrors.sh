#!/bin/sh

mkdir -p mirror

curl https://www.ebi.ac.uk/ols/ontologies/mondo/download > mirror/mondo.owl

curl https://www.ebi.ac.uk/ols/ontologies/uberon/download > mirror/uberon.owl

curl -L https://raw.githubusercontent.com/obophenotype/cell-ontology/master/cl-base.owl > mirror/cl.owl

curl https://raw.githubusercontent.com/EBISPOT/efo/master/src/ontology/efo-edit.owl > mirror/efo-edit.owl
