#!/bin/sh

mkdir -p mirror

mkdir -p ../imports

curl -L http://purl.obolibrary.org/obo/mondo.obo > mirror/mondo.obo && ../../bin/robot convert -i mirror/mondo.obo -f owl -o mirror/mondo.owl

curl -L http://purl.obolibrary.org/obo/uberon.owl > mirror/uberon.owl

curl -L http://purl.obolibrary.org/obo/fma.owl > ../imports/fma.owl

curl -L http://purl.obolibrary.org/obo/fbbi.owl > ../imports/fbbi.owl

curl -L http://purl.obolibrary.org/obo/hsapdv.owl > ../imports/hsapdv.owl

curl -L http://purl.obolibrary.org/obo/go.owl > ../imports/go.owl

curl -L http://purl.obolibrary.org/obo/cl.owl > mirror/cl.owl

curl -L http://www.ebi.ac.uk/efo/efo.owl  > mirror/efo.owl

curl -L https://www.ebi.ac.uk/ols/ontologies/edam/download  > ../imports/edam.owl



