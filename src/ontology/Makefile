# ----------------------------------------
# Standard Constants
# ----------------------------------------
# these can be overwritten on the command line

OBO=http://purl.obolibrary.org/obo
ONT=hcao
BASE=$(OBO)/$(ONT)
SRC=$(ONT)-edit.owl
RELEASEDIR=../..
ROBOT= ../../bin/robot
OWLTOOLS= ../../owltools
USECAT= --use-catalog
SPARQLDIR = ../sparql
UBERON_IMPORT=../imports/euarchontoglires-basic.owl
#UBERON_IMPORT="http://purl.obolibrary.org/obo/uberon/subsets/euarchontoglires-basic.owl"
CL_IMPORT=../imports/cl.owl
#CL_IMPORT="http://purl.obolibrary.org/obo/cl.owl"

# ----------------------------------------
# Top-level targets
# ----------------------------------------

all: sparql_test all_imports $(ONT).owl all_anatomy all_cells
test: sparql_test all
prepare_release: all
	cp $(ONT).owl $(ONT).obo $(RELEASEDIR) &&\
	mkdir -p $(RELEASEDIR)/imports &&\
	cp imports/*{owl,obo} $(RELEASEDIR)/imports &&\
	git add $(RELEASEDIR)/imports/*{obo,owl} &&\
	(test -f subsets/*owl && cp subsets/*{owl,obo} $(RELEASEDIR)/subsets && git add $(RELEASEDIR)/subsets/* || echo "no subsets") &&\
	echo "Release files are now in $(RELEASEDIR) - now you should commit, push and make a release on github"

# ----------------------------------------
# Main release targets
# ----------------------------------------

# remove -T terms_to_delete.txt
# by default we use Elk to perform a reason-relax-reduce chain
# after that we annotate the ontology with the release versionInfo
$(ONT).owl: $(SRC) uberon_human.owl cl_human.owl terms_to_delete.txt
	$(ROBOT) merge --input $(SRC) --input uberon_human.owl --input cl_human.owl remove -T terms_to_delete.txt reason -r ELK reduce -r ELK annotate -V $(BASE)/releases/`date +%Y-%m-%d`/$(ONT).owl -o $@
#$(ONT).obo: $(ONT).owl
#	$(ROBOT) convert -i $< -f obo -o $(ONT).obo.tmp && mv $(ONT).obo.tmp $@

# ----------------------------------------
# Extract modules
# ----------------------------------------

#top_module_to_remote.owl:
#	 $(ROBOT) merge --input $(SRC) --input uberon_human.owl --input cl_human.owl relax reduce extract --method BOT --term-file terms_to_delete.txt --output top_module_to_remote.owl

all_anatomy: uberon_import.txt uberon_with_fma_labels.ttl uberon_human.owl ../imports/euarchontoglires-basic.obo

../imports/euarchontoglires-basic.obo:
	sed -i.bak '/property_value\: provenance_notes/d' ../imports/euarchontoglires-basic.obo

# extract human uberon terms (which FMA xref) with FMA label
uberon_import.txt: $(UBERON_IMPORT)
	$(ROBOT) query --input $(UBERON_IMPORT) query --select ../sparql/select_human_anatomy_subset.sparql uberon_import.txt

# generate huamn uberon with FMA prefLabels

uberon_with_fma_labels.ttl: ../imports/fma.owl
	$(ROBOT) merge --input ../imports/fma.owl --input $(UBERON_IMPORT) query --format ttl --construct ../sparql/construct_fma_labels.sparql uberon_with_fma_labels.ttl

uberon_human.owl: uberon_with_fma_labels.ttl uberon_import.txt
	$(ROBOT) extract --method BOT --input $(UBERON_IMPORT) --term-file uberon_import.txt merge --input uberon_with_fma_labels.ttl --output uberon_human.owl

# extract human cells from CTO ontology (based on FMA xref)

all_cells: cell_import.txt cl_human.owl

cell_import.txt: $(CL_IMPORT)
	$(ROBOT) query --input $(CL_IMPORT) --select ../sparql/select_human_cell_subset.sparql cell_import.txt

cl_human.owl: cell_import.txt
	$(ROBOT) extract --method BOT --input $(CL_IMPORT) --term-file cell_import.txt --output cl_human.owl


# ----------------------------------------
# Import modules
# ----------------------------------------
# Most ontologies are modularly constructed using portions of other ontologies
# These live in the imports/ folder
# These can be regenerated with make all_imports

IMPORTS = 
IMPORTS_OWL = $(patsubst %, imports/%_import.owl,$(IMPORTS)) $(patsubst %, imports/%_import.obo,$(IMPORTS))

# Make this target to regenerate ALL
all_imports: $(IMPORTS_OWL)

# Use ROBOT, driven entirely by terms lists NOT from source ontology
imports/%_import.owl: mirror/%.owl imports/%_terms.txt
	$(ROBOT) extract -i $< -T imports/$*_terms.txt --method BOT -O $(BASE)/$@ -o $@
.PRECIOUS: imports/%_import.owl

# we use owltools for making the obo file until: https://github.com/ontodev/robot/issues/64
imports/%_import.obo: imports/%_import.owl
	$(OWLTOOLS) $(USECAT) $< -o -f obo $@

# clone remote ontology locally, perfoming some excision of relations and annotations
mirror/%.owl: $(SRC)
	$(OWLTOOLS) $(OBO)/$*.owl --remove-annotation-assertions -l -s -d --remove-dangling-annotations  -o $@
.PRECIOUS: mirror/%.owl

# ----------------------------------------
# Release
# ----------------------------------------
# copy from staging area (this directory) to top-level
release: $(ONT).owl $(ONT).obo
	cp $^ $(RELEASEDIR) && cp imports/* $(RELEASEDIR)/imports

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
