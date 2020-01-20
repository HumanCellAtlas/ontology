# ----------------------------------------
# Standard Constants
# ----------------------------------------
# these can be overwritten on the command line

OBO=http://ontology.data.humancellatlas.org/ontologies
ONT=hcao
BASE=$(OBO)/$(ONT)
SRC=$(ONT)-edit.owl
RELEASEDIR=../..
ROBOT= ../../bin/robot
OWLTOOLS= ../../bin/owltools
USECAT= --use-catalog
SPARQLDIR = ../sparql
UBERON_IMPORT=mirror/uberon.owl
#UBERON_IMPORT=../imports/euarchontoglires-basic.owl
#UBERON_IMPORT="http://purl.obolibrary.org/obo/uberon/subsets/euarchontoglires-basic.owl"
#CL_IMPORT=../imports/cl.owl
CL_IMPORT=mirror/cl.owl
FBBI=../imports/fbbi.owl
#EDAM=../imports/edam.owl
FMA_IMPORT=../imports/fma.owl
#CL_IMPORT="http://purl.obolibrary.org/obo/cl.owl"
EFO_MIRROR=mirror/efo.owl

# ----------------------------------------
# Top-level targets
# ----------------------------------------

some: $(ONT).owl sparql_test

all: all_imports all_anatomy all_cells  go_cell_cycle.owl efo_slim.owl fbbi_hcao.owl $(ONT).owl

test: sparql_test all
prepare_release: all
	cp $(ONT).owl efo_slim.owl fbbi_hcao.owl $(RELEASEDIR) &&\
	echo "Release files are now in $(RELEASEDIR) - now you should commit, push and make a release on github"

# ----------------------------------------
# Main release targets
# ----------------------------------------

# remove -T terms_to_delete.txt
# by default we use Elk to perform a reason-relax-reduce chain
# after that we annotate the ontology with the release versionInfo
# The main release target needs breaking into separate steps to avoid ROBOT exception
$(ONT).owl: $(SRC) uberon_human_extended.owl cl_human.owl go_cell_cycle.owl terms_to_delete.txt
	$(ROBOT) merge --input $(SRC) --input go_cell_cycle.owl --input uberon_human_extended.owl --input cl_human.owl -o hcao_merged.owl &&\
	$(ROBOT) remove --input hcao_merged.owl -T terms_to_delete.txt -p false -o hcao_cleaned.owl &&\
	$(ROBOT) reason --input hcao_cleaned.owl -r ELK reduce -r ELK annotate -V $(BASE)/releases/`date +%Y-%m-%d`/$(ONT).owl -o $@


#$(ONT).obo: $(ONT).owl
#	$(ROBOT) convert -i $< -f obo -o $(ONT).obo.tmp && mv $(ONT).obo.tmp $@

# ----------------------------------------
# Extract modules
# ----------------------------------------

#top_module_to_remote.owl:
#	 $(ROBOT) merge --input $(SRC) --input uberon_human.owl --input cl_human.owl relax reduce extract --method BOT --term-file terms_to_delete.txt --output top_module_to_remote.owl

all_anatomy: uberon_import.txt uberon_with_fma_labels.ttl uberon_human.owl $(UBERON_IMPORT) uberon_human_extended.owl

#../imports/euarchontoglires-basic.obo:
#	sed -i.bak '/property_value\: provenance_notes/d' ../imports/euarchontoglires-basic.obo

# extract human uberon terms (which FMA xref) with FMA label
uberon_import.txt: $(UBERON_IMPORT)
	$(ROBOT) query --input $(UBERON_IMPORT) --query ../sparql/select_human_anatomy_subset.sparql uberon_import.txt

# generate human uberon with FMA prefLabels

uberon_with_fma_labels.ttl: ../imports/fma.owl
	$(ROBOT) merge --input ../imports/fma.owl --input $(UBERON_IMPORT) query --format ttl --construct ../sparql/construct_fma_labels.sparql uberon_with_fma_labels.ttl

uberon_manual.owl: uberon_manual_import.txt
	$(ROBOT) extract --method BOT --input $(UBERON_IMPORT) --term-file $< -o $@

uberon_human.owl: uberon_with_fma_labels.ttl uberon_manual.owl uberon_import.txt
	$(ROBOT) extract --method BOT --input $(UBERON_IMPORT) --term-file uberon_import.txt merge --input uberon_with_fma_labels.ttl --input uberon_manual.owl --output uberon_human.owl

# extract human cells from CTO ontology (based on FMA xref)

all_cells: cell_import_auto.txt cell_import.txt cl_human.owl

cell_import_auto.txt: $(CL_IMPORT)
	$(ROBOT) query --input $(CL_IMPORT) --query ../sparql/select_human_cell_subset.sparql cell_import_auto.txt

cell_import.txt: cell_import_auto.txt cell_import_manual.txt
	cat cell_import_auto.txt cell_import_manual.txt > cell_import.txt

cl_human.owl: cell_import.txt
	$(ROBOT) extract --method BOT --input $(CL_IMPORT) --term-file cell_import.txt --output cl_human.owl

go_cell_cycle.owl: ../imports/go.owl
	$(ROBOT) extract -i ../imports/go.owl --method MIREOT -b GO:0022403 -o go_cell_cycle.owl

efo_slim.owl: ../imports/efo_inferred.owl efo_slim.txt
	$(ROBOT) extract -i ../imports/efo_inferred.owl --method MIREOT -B efo_slim.txt annotate --ontology-iri http://ontology.data.humancellatlas.org/ontologies/efo -o efo_slim.owl

microscopy_seed.txt: ../imports/fbbi.owl
	echo "'microscopy'" | $(OWLTOOLS) $< --reasoner-query -r elk -d --stdin | cut -d ' ' -f2 > $@

microscopy_label_seed.txt: ../imports/fbbi.owl
	echo "'fluorescent label'" | $(OWLTOOLS) $< --reasoner-query -r elk -d --stdin | cut -d ' ' -f2 > $@

fbbi_terms.txt: microscopy_seed.txt microscopy_label_seed.txt
	cat $+ > $@

fbbi_hcao.owl: fbbi_terms.txt
	$(ROBOT) extract --method BOT --input $(FBBI) --term-file fbbi_terms.txt annotate --ontology-iri http://ontology.data.humancellatlas.org/ontologies/fbbi --output $@

#generate data branch slim from EDAM
#data_terms.txt: ../imports/edam.owl
#	echo "'Data'" | $(OWLTOOLS) $< --reasoner-query -r elk -d --stdin | cut -d ' ' -f2 > $@

#edam_hcao.owl: data_terms.txt
#	$(ROBOT) extract --method BOT --input $(EDAM) --term-file data_terms.txt annotate --ontology-iri http://ontology.data.humancellatlas.org/ontologies/edam --output $@


#generate a small MIREOT extract of FMA from leaf terms in fma_import_manual.txt and with FMA:82472 as upper, then rename the upper term to its UBERON equivalent
fma_uberon.owl: fma_import_manual.txt
	$(ROBOT) extract --input $(FMA_IMPORT) --method MiREOT -L fma_import_manual.txt -u FMA:82472 rename --mappings fma_uberon_mappings.csv --output $@

#extract the descendants of the UBERON term into a separate file
fma_descendants.owl: fma_uberon.owl
	$(ROBOT) filter --input $< --term UBERON:0000064 --select "annotations descendants" --output $@

#remove all annotations from the FMA-UBERON slim
#fma_uberon_no_annotations.owl: fma_uberon.owl
#	$(ROBOT) remove --input $< --axioms annotation --output $@

#merge the annotation-less slim and the descendants with annotations into the uberon_human slim
uberon_human_extended.owl: fma_descendants.owl uberon_human.owl
	$(ROBOT) merge --input fma_descendants.owl --input uberon_human.owl relax reduce --output $@



# ----------------------------------------
# Import modules
# ----------------------------------------
# Most ontologies are modularly constructed using portions of other ontologies
# These live in the imports/ folder
# These can be regenerated with make all_imports

IMPORTS = 
IMPORTS_OWL = ../imports/efo_inferred.owl #$(patsubst %, imports/%_import.owl,$(IMPORTS)) $(patsubst %, imports/%_import.obo,$(IMPORTS))

# Make this target to regenerate ALL
all_imports: $(IMPORTS_OWL)

#Build efo_inferred.owl
../imports/efo_inferred.owl: $(EFO_MIRROR)
	$(ROBOT) -v reason -s true -m true -r hermit -i $< -o $@


# ----------------------------------------
# Release
# ----------------------------------------
# copy from staging area (this directory) to top-level
# release: $(ONT).owl $(ONT).obo efo_slim.owl
#	cp $^ $(RELEASEDIR) && cp imports/* $(RELEASEDIR)/imports

#release: $(ONT).owl  efo_slim.owl
#	cp $^ $(RELEASEDIR)

# ----------------------------------------
# Sparql queries: Q/C
# ----------------------------------------

# these live in the ../sparql directory, and have suffix -violation.sparql
# adding the name here will make the violation check live
VCHECKS = equivalent-classes trailing-whitespace owldef-self-reference xref-syntax nolabels

# run all violation checks
VQUERIES = $(foreach V,$(VCHECKS),$(SPARQLDIR)/$V-violation.sparql)
sparql_test: $(SRC)
	$(ROBOT) verify -i $< --queries $(VQUERIES) -O reports/

# ----------------------------------------
# Sparql queries: Reports
# ----------------------------------------

REPORTS = basic-report class-count-by-prefix edges xrefs obsoletes synonyms
REPORT_ARGS = $(foreach V,$(REPORTS),-s $(SPARQLDIR)/$V.sparql reports/$V.tsv)
all_reports: $(SRC)
	$(ROBOT) query -f tsv -i $< $(REPORT_ARGS)
