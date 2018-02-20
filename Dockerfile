FROM simonjupp/ebi-ols:3.1.1

ENV OLS_HOME /opt/ols
ENV JAVA_OPTS "-Xmx1g"
ENV SOLR_VERSION 5.5.3

ADD ols/ols-config.yaml ${OLS_HOME}		
#ADD ols/obo-config.yaml ${OLS_HOME}		

RUN mkdir ${OLS_HOME}/ontologies
ADD *.owl ${OLS_HOME}/ontologies/
RUN ls -l ${OLS_HOME}/ontologies/

## Prepare configuration files
ADD ols/application.properties ${OLS_HOME}

## Start MongoDB and 
### Load configuration into MongoDB
RUN mongod --smallfiles --fork --logpath /var/log/mongodb.log \ 
    && cd ${OLS_HOME} \ 
    && java -jar ${OLS_HOME}/ols-config-importer.jar \
    && sleep 10

## Start MongoDB and SOLR
## Then start the indexation process cd /etc/init.d/
RUN mongod --smallfiles --fork --logpath /var/log/mongodb.log \
  && /opt/solr-${SOLR_VERSION}/bin/solr -Dsolr.solr.home=${OLS_HOME}/solr-5-config/ -Dsolr.data.dir=${OLS_HOME} \  
  && java ${JAVA_OPTS} -Dols.home=${OLS_HOME} -jar ${OLS_HOME}/ols-indexer.jar  

## Expose the tomcat port 
EXPOSE 8080

CMD cd ${OLS_HOME} \
    && mongod --smallfiles --fork --logpath /var/log/mongodb.log \
    && /opt/solr-${SOLR_VERSION}/bin/solr -Dsolr.solr.home=${OLS_HOME}/solr-5-config/ -Dsolr.data.dir=${OLS_HOME} \
    && java -jar -Dols.home=${OLS_HOME} ols-boot.war

