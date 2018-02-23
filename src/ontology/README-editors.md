These notes are for the EDITORS of hcao

This project was created using the [ontology starter kit](https://github.com/cmungall/ontology-starter-kit). See the site for details.

For more details on ontology management, please see the [OBO tutorial](https://github.com/jamesaoverton/obo-tutorial) or the [Gene Ontology Editors Tutorial](go-protege-tutorial.readthedocs.io)

## Editors Version

The editors version is [hcao-edit.owl](hcao-edit.owl)

** DO NOT EDIT hcao.obo OR hcao.owl in the top level directory **

[../../hcao.owl](../../hcao.owl) is the release version

## HCAO build process

HCAO conatin ontology terms for human cell types, anatomy and life stages. These are imported from a human subset of CL and UBERON and the HSAPDV ontology.

### How the modules are generated

*uberon_human.owl* -  We use the [../imports/euarchontoglires-basic.obo](../imports/euarchontoglires-basic.obo) file as the base import for human antatomy. To extract the human subset we create a module from all UBERON terms that have an xref to FMA. To select this subset we use a sparql query in
[../sparql/select_human_anatomy_subset.sparql](../sparql/select_human_anatomy_subset.sparql). For this list of terms we do a standard BOT module extarction from [../imports/euarchontoglires-basic.obo](../imports/euarchontoglires-basic.obo)

To provide more human friendly labels for the antomy we add the labels from FMA [../imports/fma.owl](../imports/fma.owl) using skos:prefLabel property. The labels are extracted from [../imports/fma.owl](../imports/fma.owl) using the query in [../sparql/construct_fma_labels.sparql](../sparql/construct_fma_labels.sparql) and merged into the [uberon_human.owl](uberon_human.owl) file.

*cl_human.owl* -  In addition to the cell types referenced by the human anatomy moduel we get additional cell types from CL again by looking for FMA xrefs for cell types. These are extracted using the SPARQL query in [../sparql/select_human_cell_subset.sparql](../sparql/select_human_cell_subset.sparql). A module of CL is extracted from these terms and merged into [hcao.owl](hcao.owl). 

*go_cell_cycle.owl* - cell cycle phases are taken from GO http://purl.obolibrary.org/obo/GO_0022403

### EFO slim

We also build a slim of EFO for experimental processes, instruments, biological macromolecules, organisms/strains, protocols and units. The lsit of branches to extract from EFO are stored in [../imports/efo_slim.txt](../imports/efo_slim.txt)

## Release Manager notes

You should only attempt to make a release AFTER the edit version is
committed and pushed, and the travis build passes.

to release:

    cd src/ontology
    make

If this looks goo
d type:

    make prepare_release

This generates derived files such as hcao.owl and hcao.obo and places
them in the top level (../..). The versionIRI will be added.

Commit and push these files.

    git commit -a

And type a brief description of the release in the editor window

Finally type

    git push origin master

IMMEDIATELY AFTERWARDS (do *not* make further modifications) go here:

 * https://github.com/obophenotype/hcao/releases
 * https://github.com/obophenotype/hcao/releases/new

The value of the "Tag version" field MUST be

    vYYYY-MM-DD

The initial lowercase "v" is REQUIRED. The YYYY-MM-DD *must* match
what is in the versionIRI of the derived hcao.owl (data-version in
hcao.obo).

Release title should be YYYY-MM-DD, optionally followed by a title (e.g. "january release")

Then click "publish release"

__IMPORTANT__: NO MORE THAN ONE RELEASE PER DAY.

The PURLs are already configured to pull from github. This means that
BOTH ontology purls and versioned ontology purls will resolve to the
correct ontologies. Try it!

 * http://purl.obolibrary.org/obo/hcao.owl <-- current ontology PURL
 * http://purl.obolibrary.org/obo/hcao/releases/YYYY-MM-DD.owl <-- change to the release you just made

For questions on this contact Chris Mungall or email obo-admin AT obofoundry.org

# Travis Continuous Integration System

Check the build status here: [![Build Status](https://travis-ci.org/obophenotype/hcao.svg?branch=master)](https://travis-ci.org/obophenotype/hcao)

Note: if you have only just created this project you will need to authorize travis for this repo. Go to [https://travis-ci.org/profile/obophenotype](https://travis-ci.org/profile/obophenotype) for details

