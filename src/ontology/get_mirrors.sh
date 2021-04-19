#!/bin/sh

mkdir -p mirror

mkdir -p ../imports
echo "DOWNLOADING MONDO..."
curl -L http://purl.obolibrary.org/obo/mondo.obo > mirror/mondo.obo && ../../bin/robot convert -i mirror/mondo.obo -f owl -o mirror/mondo.owl && echo "MONDO DOWNLOADED"

echo "DOWNLOADING UBERON..."
curl -L http://purl.obolibrary.org/obo/uberon.owl > mirror/uberon.owl && echo "UBERON DOWNLOADED"

echo "DOWNLOADING FMA..."
curl -L http://purl.obolibrary.org/obo/fma.owl > ../imports/fma.owl && echo "FMA DOWNLOADED"

echo "DOWNLOADING FBBI..."
curl -L http://purl.obolibrary.org/obo/fbbi.owl > ../imports/fbbi.owl && echo "FBBI DOWNLOADED"

echo "DOWNLOADING HSAPDV..."
curl -L http://purl.obolibrary.org/obo/hsapdv.owl > ../imports/hsapdv.owl && echo "HSAPDV DOWNLOADED"

echo "DOWNLOADING GO..."
curl -L http://purl.obolibrary.org/obo/go.owl > ../imports/go.owl && echo "GO DOWNLOADED"

echo "DOWNLOADING CL..."
curl -L http://purl.obolibrary.org/obo/cl.owl > mirror/cl.owl && echo "CL DOWNLOADED"

echo "DOWNLOADING CLO..."
curl -L http://purl.obolibrary.org/obo/clo.owl > mirror/clo.owl && echo "CLO DOWNLOADED"

echo "DOWNLOADING EFO..."
curl -L http://www.ebi.ac.uk/efo/efo.owl  > mirror/efo.owl && echo "EFO DOWNLOADED"

echo "DOWNLOADING EDAM..."
curl -L https://www.ebi.ac.uk/ols/ontologies/edam/download  > ../imports/edam.owl && echo "EDAM DOWNLOADED"



