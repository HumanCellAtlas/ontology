#!/bin/sh

mkdir -p mirror

curl -L https://www.ebi.ac.uk/ols/ontologies/mondo/download > mirror/mondo.owl

curl -L https://www.ebi.ac.uk/ols/ontologies/uberon/download > mirror/uberon.owl

curl -L https://www.ebi.ac.uk/ols/ontologies/fma/download > ../imports/fma.owl

curl -L https://www.ebi.ac.uk/ols/ontologies/fbbi/download > ../imports/fbbi.owl

curl -L https://www.ebi.ac.uk/ols/ontologies/hsapdv/download > ../imports/hsapdv.owl

curl -L https://www.ebi.ac.uk/ols/ontologies/go/download > ../imports/go-basic.obo

curl -L curl https://www.ebi.ac.uk/ols/ontologies/cl/download > mirror/cl.owl

curl -L https://www.ebi.ac.uk/ols/ontologies/efo/download  > mirror/efo.owl



