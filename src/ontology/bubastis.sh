mkdir -p diffs
java -jar ../../bin/bubastis_1_3.jar -ontology1 "https://raw.githubusercontent.com/ebi-ait/ontology/master/hcao.owl" -ontology2 "hcao.owl" -output ./diffs/hcao_bubastis_diff.txt
java -jar ../../bin/bubastis_1_3.jar -ontology1 "https://raw.githubusercontent.com/ebi-ait/ontology/master/efo_slim.owl" -ontology2 "efo_slim.owl" -output ./diffs/efo_slim_bubastis_diff.txt
java -jar ../../bin/bubastis_1_3.jar -ontology1 "https://raw.githubusercontent.com/ebi-ait/ontology/master/fbbi_hcao.owl" -ontology2 "fbbi_hcao.owl" -output ./diffs/fbbi_hcao_diff.txt

