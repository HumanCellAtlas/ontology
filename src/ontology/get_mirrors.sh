#!/bin/sh

mkdir -p mirror

curl https://www.ebi.ac.uk/ols/ontologies/mondo/download > mirror/mondo.owl

curl https://www.ebi.ac.uk/ols/ontologies/uberon/download > mirror/uberon.owl

curl -L https://raw.githubusercontent.com/obophenotype/cell-ontology/master/cl.owl > mirror/cl.owl

curl -L https://github.com/EBISPOT/efo/releases/download/current/efo.owl > mirror/efo.owl

