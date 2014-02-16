'use strict'

angular.module('fi.seco.void',['fi.seco.sparql']).factory('voidService', (sparql) ->
  prefixes = '''
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX  owl: <http://www.w3.org/2002/07/owl#>
    PREFIX xsd:   <http://www.w3.org/2001/XMLSchema#>
    PREFIX dc: <http://purl.org/dc/elements/1.1/>
    PREFIX void: <http://rdfs.org/ns/void#>
    PREFIX void-ext: <http://ldf.fi/void-ext#>
    PREFIX foaf: <http://xmlns.com/foaf/0.1/>
    PREFIX sioc: <http://rdfs.org/sioc/ns#>
    PREFIX prov: <http://www.w3.org/ns/prov#>

    '''
  queries = {
    'General' : prefixes + '''
    SELECT ?triples ?distinctIRIReferences ?distinctLiterals ?distinctBlankNodes ?distinctRDFNodes ?properties ?distinctSubjects ?distinctObjects ?distinctIRIReferenceSubjects ?distinctBlankNodeSubjects ?distinctIRIReferenceObjects ?distinctBlankNodeObjects ?classes ?propertyClasses ?objectClasses ?sparqlEndpoint ?datatypes ?languages {
      |BEGINGRAPH|
      OPTIONAL { |DATASET| void:triples ?triples }
      OPTIONAL { |DATASET| void:classes ?classes }
      OPTIONAL { |DATASET| void-ext:propertyClasses ?propertyClasses }
      OPTIONAL { |DATASET| void-ext:objectClasses ?objectClasses }
      OPTIONAL { |DATASET| void-ext:distinctIRIReferences ?distinctIRIReferences }
      OPTIONAL { |DATASET| void-ext:distinctLiterals ?distinctLiterals }
      OPTIONAL { |DATASET| void-ext:distinctBlankNodes ?distinctBlankNodes }  
      OPTIONAL { |DATASET| void-ext:distinctRDFNodes ?distinctRDFNodes }
      OPTIONAL { |DATASET| void:distinctSubjects ?distinctSubjects }  
      OPTIONAL { |DATASET| void:distinctObjects ?distinctObjects }
      OPTIONAL { |DATASET| void:properties ?properties }
      OPTIONAL { |DATASET| void-ext:distinctIRIReferenceSubjects ?distinctIRIReferenceSubjects }
      OPTIONAL { |DATASET| void-ext:distinctBlankNodeSubjects ?distinctBlankNodeSubjects }
      OPTIONAL { |DATASET| void-ext:distinctIRIReferenceObjects ?distinctIRIReferenceObjects }
      OPTIONAL { |DATASET| void-ext:distinctBlankNodeObjects ?distinctBlankNodeObjects }
      OPTIONAL { |DATASET| void-ext:datatypes ?datatypes }
      OPTIONAL { |DATASET| void-ext:languages ?languages }
      OPTIONAL { |DATASET| void:sparqlEndpoint ?sparqlEndpoint }
      |ENDGRAPH|
    }
    '''
    'Property' : prefixes + '''
    SELECT ?p ?triples ?distinctSubjects ?distinctIRIReferenceSubjects ?distinctBlankNodeSubjects ?distinctObjects ?distinctIRIReferenceObjects ?distinctBlankNodeObjects ?distinctLiterals {
      |BEGINGRAPH|
      |DATASET| void:propertyPartition ?partition .
      ?partition void:property ?p .
      OPTIONAL { ?partition void:triples ?triples }
      OPTIONAL { ?partition void:distinctSubjects ?distinctSubjects }
      OPTIONAL { ?partition void-ext:distinctIRIReferenceSubjects ?distinctIRIReferenceSubjects }
      OPTIONAL { ?partition void-ext:distinctBlankNodeSubjects ?distinctBlankNodeSubjects }
      OPTIONAL { ?partition void:distinctObjects ?distinctObjects }
      OPTIONAL { ?partition void-ext:distinctIRIReferenceObjects ?distinctIRIReferenceObjects }
      OPTIONAL { ?partition void-ext:distinctBlankNodeObjects ?distinctBlankNodeObjects }
      OPTIONAL { ?partition void-ext:distinctLiterals ?distinctLiterals }
      |ENDGRAPH|
    }
    ORDER BY DESC(?triples)
    LIMIT 50
    '''
    'Object Datatype' : prefixes + '''
    SELECT ?datatype ?entities {
      |BEGINGRAPH|
      |DATASET| void-ext:objectLiteralDatatypePartition ?partition .
      ?partition void-ext:datatype ?datatype .
      ?partition void:entities ?entities .
      |ENDGRAPH|
    }
    ORDER BY DESC(?entities)
    LIMIT 25
    '''
    'Object Language' : prefixes + '''
    SELECT ?language ?entities {
      |BEGINGRAPH|
      |DATASET| void-ext:objectLiteralLanguagePartition ?partition .
      ?partition void-ext:language ?language .
      ?partition void:entities ?entities .
      |ENDGRAPH|
    }
    ORDER BY DESC(?entities)
    LIMIT 25
    '''
    'Object Literal' : prefixes + '''
    SELECT ?o ?triples {
      |BEGINGRAPH|
      |DATASET| void-ext:objectPartition ?partition .
      ?partition void-ext:object ?o .
      ?partition void:triples ?triples .
      FILTER(isLiteral(?o))
      |ENDGRAPH|
    }
    ORDER BY DESC(?triples)
    LIMIT 50
    '''
    'Object Resource' : prefixes + '''
    SELECT ?o ?triples {
      |BEGINGRAPH|
      |DATASET| void-ext:objectPartition ?partition .
      ?partition void-ext:object ?o .
      ?partition void:triples ?triples .
      FILTER(!isLiteral(?o))
      |ENDGRAPH|
    }
    ORDER BY DESC(?triples)
    LIMIT 50
    '''
    'Subject' : prefixes + '''
    SELECT ?s ?triples {
      |BEGINGRAPH|
      |DATASET| void-ext:subjectPartition ?partition .
      ?partition void-ext:subject ?s .
      ?partition void:triples ?triples .
      |ENDGRAPH|
    }
    ORDER BY DESC(?triples)
    LIMIT 50
    '''
    'Subject Namespace' : prefixes + '''
    SELECT ?subjectNamespace ?entities {
      |BEGINGRAPH|
      |DATASET| void-ext:subjectNamespacePartition ?partition .
      ?partition void-ext:namespace ?subjectNamespace .
      ?partition void:entities ?entities .
      |ENDGRAPH|
    }
    ORDER BY DESC(?entities)
    LIMIT 25
    '''
    'Subject Type' : prefixes + '''
    SELECT ?class ?entities {
      |BEGINGRAPH|
      |DATASET| void:classPartition ?partition .
      ?partition void:class ?class .
      ?partition void:entities ?entities .
      |ENDGRAPH|
    }
    ORDER BY DESC(?entities)
    LIMIT 25
    '''
    'Object Namespace' : prefixes + '''
    SELECT ?objectNamespace ?entities {
      |BEGINGRAPH|
      |DATASET| void-ext:objectNamespacePartition ?partition .
      ?partition void-ext:namespace ?objectNamespace .
      ?partition void:entities ?entities .
      |ENDGRAPH|
    }
    ORDER BY DESC(?entities)
    LIMIT 25
    '''
    'Object Type' : prefixes + '''
    SELECT ?objectClass ?entities {
      |BEGINGRAPH|
      |DATASET| void-ext:objectClassPartition ?partition .
      ?partition void:class ?objectClass .
      ?partition void:entities ?entities .
      |ENDGRAPH|
    }
    ORDER BY DESC(?entities)
    LIMIT 25
    '''
    'Property Namespace' : prefixes + '''
    SELECT ?propertyNamespace ?entities {
      |BEGINGRAPH|
      |DATASET| void-ext:propertyNamespacePartition ?partition .
      ?partition void-ext:namespace ?propertyNamespace .
      ?partition void:entities ?entities .
      |ENDGRAPH|
    }
    ORDER BY DESC(?entities)
    LIMIT 25
    '''
    'Property Type' : prefixes + '''
    SELECT ?propertyClass ?entities {
      |BEGINGRAPH|
      |DATASET| void-ext:propertyClassPartition ?partition .
      ?partition void:class ?propertyClass .
      ?partition void:entities ?entities .
      |ENDGRAPH|
    }
    ORDER BY DESC(?entities)
    LIMIT 25
    '''
  }
  calculationQueries = {
    'Subject Class Count' : '''
        SELECT (COUNT(DISTINCT ?type) AS ?classes) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          ?s a ?type .
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
    '''
    'Property Class Count' : '''
        SELECT (COUNT(DISTINCT ?type) AS ?propertyClasses) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          ?p a ?type .
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
    '''
    'Object Class Count' : '''
        SELECT (COUNT(DISTINCT ?type) AS ?objectClasses) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          ?o a ?type .
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
    '''
    'Triple Part Counts' : '''
        SELECT (COUNT(DISTINCT ?s) AS ?distinctSubjects) (COUNT(DISTINCT ?p) AS ?properties) (COUNT(DISTINCT ?o) AS ?distinctObjects) (COUNT(*) AS ?triples) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
    '''
    'RDF Node Count' : '''
        SELECT (COUNT(DISTINCT ?n) AS ?distinctRDFNodes) {
          |BEGINGRAPH|
          {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?s AS ?n)
          } UNION {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?p AS ?n)
          } UNION {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?o AS ?n)
          }
          |ENDGRAPH|
        }
    '''
    'Literal Count' : '''
        SELECT (COUNT(DISTINCT ?o) AS ?distinctLiterals) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isLiteral(?o))
          |ENDGRAPH|
        }
    '''
    'Datatype Count' : '''
        SELECT (COUNT(DISTINCT datatype(?o)) AS ?datatypes) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isLiteral(?o) && datatype(?o)!="")
          |ENDGRAPH|
        }
    '''
    'Language Count' : '''
        SELECT (COUNT(DISTINCT lang(?o)) AS ?languages) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isLiteral(?o) && lang(?o)!="")
          |ENDGRAPH|
        }
    '''
    'IRI Reference Count' : '''
        SELECT (COUNT(DISTINCT ?n) AS ?distinctIRIReferences) {
          |BEGINGRAPH|
          {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?s AS ?n)
          } UNION {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?p AS ?n)
          } UNION {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?o AS ?n)
          }
          FILTER(isIRI(?n))
          |ENDGRAPH|
        }
    '''
    'Blank Node Count' : '''
        SELECT (COUNT(DISTINCT ?n) AS ?distinctBlankNodes) {
          |BEGINGRAPH|
          {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?s AS ?n)
          } UNION {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?p AS ?n)
          } UNION {
            |BEFORECONSTRAINT|
            ?s ?p ?o .
            |AFTERCONSTRAINT|
            BIND (?o AS ?n)
          }
          FILTER(isBlank(?n))
          |ENDGRAPH|
        }
    '''
    'IRI Reference Subject Count' : '''
        SELECT (COUNT(DISTINCT ?s) AS ?distinctIRIReferenceSubjects) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isIRI(?s))
          |ENDGRAPH|
        }
    '''
    'Blank Node Subject Count' : '''
       SELECT (COUNT(DISTINCT ?s) AS ?distinctBlankNodeSubjects) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isBlank(?s))
          |ENDGRAPH|
        }
    '''
    'IRI Reference Object Count' : '''
        SELECT (COUNT(DISTINCT ?o) AS ?distinctIRIReferenceObjects) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isIRI(?o))
          |ENDGRAPH|
        }
    '''
    'Blank Node Object Count' : '''
        SELECT (COUNT(DISTINCT ?o) AS ?distinctBlankNodeObjects) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isBlank(?o))
          |ENDGRAPH|
        }
    '''
    'Property Type' : '''
    SELECT ?propertyClass ?entities {
      {
        SELECT ?propertyClass (COUNT(DISTINCT ?p) AS ?entities) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          OPTIONAL { ?p a ?type1 }
          BIND(COALESCE(?type1,<http://www.w3.org/2000/01/rdf-schema#Resource>) AS ?propertyClass)
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
        GROUP BY ?propertyClass
        ORDER BY DESC(?entities)
        LIMIT 25
      }
    }
    '''
    'Property Namespace' : '''
    SELECT ?propertyNamespace ?entities {
      {
        SELECT ?propertyNamespace (COUNT(DISTINCT ?p) AS ?entities) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isIRI(?p))
          BIND(str(?p) AS ?str)
          FILTER(CONTAINS(?str,"/") || CONTAINS(?str,"#"))
          BIND (IRI(REPLACE(?str,"(.*[#/]).*","$1")) AS ?propertyNamespace)
          |ENDGRAPH|
        }
        GROUP BY ?propertyNamespace
        ORDER BY DESC(?entities)
        LIMIT 25
      }
    }
    '''
    'Property' : '''
    SELECT ?p ?triples (?distinctLiterals+?distinctIRIReferenceObjects+?distinctBlankNodeObjects AS ?distinctObjects) ?distinctLiterals ?distinctIRIReferenceObjects ?distinctBlankNodeObjects (?distinctIRIReferenceSubjects+?distinctBlankNodeSubjects AS ?distinctSubjects) ?distinctIRIReferenceSubjects ?distinctBlankNodeSubjects {
      {
        SELECT ?p (COUNT(*) AS ?triples) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
        GROUP BY ?p
        ORDER BY DESC(?triples)
        LIMIT 50
      }
      OPTIONAL {
        SELECT ?p (COUNT(DISTINCT ?o) AS ?distinctLiterals) {
          {
            SELECT ?p {
              |BEGINGRAPH|
              |BEFORECONSTRAINT|
              ?s ?p ?o .
              |AFTERCONSTRAINT|
              |ENDGRAPH|
            }
            GROUP BY ?p
            ORDER BY DESC(?triples)
            LIMIT 50
          }
          |BEGINGRAPH|
          ?s ?p ?o .
          FILTER(isLiteral(?o))
          |ENDGRAPH|
        }
        GROUP BY ?p
      }
      OPTIONAL {
        SELECT ?p (COUNT(DISTINCT ?o) AS ?distinctIRIReferenceObjects) {
          {
            SELECT ?p {
              |BEGINGRAPH|
              |BEFORECONSTRAINT|
              ?s ?p ?o .
              |AFTERCONSTRAINT|
              |ENDGRAPH|
            }
            GROUP BY ?p
            ORDER BY DESC(?triples)
            LIMIT 50
          }
          |BEGINGRAPH|
          ?s ?p ?o .
          FILTER(isIRI(?o))
          |ENDGRAPH|
        }
        GROUP BY ?p
      }
      OPTIONAL {
        SELECT ?p (COUNT(DISTINCT ?o) AS ?distinctBlankNodeObjects) {
          {
            SELECT ?p {
              |BEGINGRAPH|
              |BEFORECONSTRAINT|
              ?s ?p ?o .
              |AFTERCONSTRAINT|
              |ENDGRAPH|
            }
            GROUP BY ?p
            ORDER BY DESC(?triples)
            LIMIT 50
          }
          |BEGINGRAPH|
          ?s ?p ?o .
          FILTER(isBlank(?o))
          |ENDGRAPH|
        }
        GROUP BY ?p
      }
      OPTIONAL {
        SELECT ?p (COUNT(DISTINCT ?s) AS ?distinctIRIReferenceSubjects) {
          {
            SELECT ?p {
              |BEGINGRAPH|
              |BEFORECONSTRAINT|
              ?s ?p ?o .
              |AFTERCONSTRAINT|
              |ENDGRAPH|
            }
            GROUP BY ?p
            ORDER BY DESC(?triples)
            LIMIT 50
          }
          |BEGINGRAPH|
          ?s ?p ?o .
          FILTER(isIRI(?s))
          |ENDGRAPH|
        }
        GROUP BY ?p
      }
      OPTIONAL {
        SELECT ?p (COUNT(DISTINCT ?s) AS ?distinctBlankNodeSubjects) {
          {
            SELECT ?p {
              |BEGINGRAPH|
              |BEFORECONSTRAINT|
              ?s ?p ?o .
              |AFTERCONSTRAINT|
              |ENDGRAPH|
            }
            GROUP BY ?p
            ORDER BY DESC(?triples)
            LIMIT 50
          }
          |BEGINGRAPH|
          ?s ?p ?o .
          FILTER(isBlank(?s))
          |ENDGRAPH|
        }
        GROUP BY ?p
      }
    }
    '''
    'Subject Type' : '''
    SELECT ?class ?entities {
      {
        SELECT ?class (COUNT(DISTINCT ?s) AS ?entities) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          OPTIONAL { ?s a ?type1 }
          BIND(COALESCE(?type1,<http://www.w3.org/2000/01/rdf-schema#Resource>) AS ?class)
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
        GROUP BY ?class
        ORDER BY DESC(?entities)
        LIMIT 25
      }
    }
    '''
    'Subject Namespace' : '''
    SELECT ?subjectNamespace ?entities {
      {
        SELECT ?subjectNamespace (COUNT(DISTINCT ?s) AS ?entities) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isIRI(?s))
          BIND(str(?s) AS ?str)
          FILTER(CONTAINS(?str,"/") || CONTAINS(?str,"#"))
          BIND (IRI(REPLACE(?str,"(.*[#/]).*","$1")) AS ?subjectNamespace)
          |ENDGRAPH|
        }
        GROUP BY ?subjectNamespace
        ORDER BY DESC(?entities)
        LIMIT 25
      }
    }
    '''
    'Subject' : '''
    SELECT ?s ?triples {
      {
        SELECT ?s (COUNT(*) AS ?triples) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          FILTER(isIRI(?s))
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
        GROUP BY ?s
        ORDER BY DESC(?triples)
        LIMIT 50
      }
    }
    '''
    'Object Type' : '''
    SELECT ?objectClass ?entities {
      {
        SELECT ?objectClass (COUNT(DISTINCT ?o) AS ?entities) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          FILTER (!isLiteral(?o))
          OPTIONAL { ?o a ?type1 }
          BIND(COALESCE(?type1,<http://www.w3.org/2000/01/rdf-schema#Resource>) AS ?objectClass)
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
        GROUP BY ?objectClass
        ORDER BY DESC(?entities)
        LIMIT 25
      }
    }
    '''
    'Object Namespace' : '''
    SELECT ?objectNamespace ?entities {
      {
        SELECT ?objectNamespace (COUNT(DISTINCT ?o) AS ?entities) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          |AFTERCONSTRAINT|
          FILTER(isIRI(?o))
          BIND(str(?o) AS ?str)
          FILTER(CONTAINS(?str,"/") || CONTAINS(?str,"#"))
          BIND (IRI(REPLACE(?str,"(.*[#/]).*","$1")) AS ?objectNamespace)
          |ENDGRAPH|
        }
        GROUP BY ?objectNamespace
        ORDER BY DESC(?entities)
        LIMIT 25
      }
    }
    '''
    'Object Resource' : '''
    SELECT ?o ?triples {
      {
        SELECT ?o (COUNT(*) AS ?triples) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          FILTER(isIRI(?o))
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
        GROUP BY ?o
        ORDER BY DESC(?triples)
        LIMIT 50
      }
    }
    '''
    'Object Datatype' : '''
    SELECT ?datatype ?entities {
      {
        SELECT ?datatype (COUNT(DISTINCT ?o) AS ?entities) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          FILTER(isLiteral(?o) && datatype(?o)!='')
          |AFTERCONSTRAINT|
          BIND(datatype(?o) AS ?datatype)
          |ENDGRAPH|
        }
        GROUP BY ?datatype
        ORDER BY DESC(?entities)
        LIMIT 25
      }
    }
    '''
    'Object Language' : '''
    SELECT ?language ?entities {
      {
        SELECT ?language (COUNT(DISTINCT ?o) AS ?entities) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          FILTER(isLiteral(?o) && lang(?o)!='')
          |AFTERCONSTRAINT|
          BIND(lang(?o) AS ?language)
          |ENDGRAPH|
        }
        GROUP BY ?language
        ORDER BY DESC(?entities)
        LIMIT 25
      }
    }
    '''
    'Object Literal' : '''
    SELECT ?o ?triples {
      {
        SELECT ?o (COUNT(*) AS ?triples) {
          |BEGINGRAPH|
          |BEFORECONSTRAINT|
          ?s ?p ?o .
          FILTER(isLiteral(?o))
          |AFTERCONSTRAINT|
          |ENDGRAPH|
        }
        GROUP BY ?o
        ORDER BY DESC(?triples)
        LIMIT 50
      }
    }
    '''
  }
  insertQueries = {
    'Subject Class Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void:classes ?classes .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Property Class Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:propertyClasses ?propertyClasses .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Object Class Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:objectClasses ?objectClasses .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Triple Part Counts' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void:distinctSubjects ?distinctSubjects .
        |PARTITIONIRI| void:distinctObjects ?distinctObjects .
        |PARTITIONIRI| void:properties ?properties .
        |PARTITIONIRI| void:triples ?triples .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'RDF Node Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:distinctRDFNodes ?distinctRDFNodes .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'IRI Reference Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:distinctIRIReferences ?distinctIRIReferences .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Blank Node Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:distinctBlankNodes ?distinctBlankNodes .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Literal Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:distinctLiterals ?distinctLiterals .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Datatype Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:datatypes ?datatypes .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Language Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:languages ?languages .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'IRI Reference Subject Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:distinctIRIReferenceSubjects ?distinctIRIReferenceSubjects .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Blank Node Subject Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:distinctBlankNodeSubjects ?distinctBlankNodeSubjects .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'IRI Reference Object Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:distinctIRIReferenceObjects ?distinctIRIReferenceObjects .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Blank Node Object Count' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:distinctBlankNodeObjects ?distinctBlankNodeObjects .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Subject Type' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void:classPartition _:b .
        _:b void:class ?class .
        _:b void:entities ?entities .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Subject Namespace' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:subjectNamespacePartition _:b .
        _:b void-ext:namespace ?subjectNamespace .
        _:b void:entities ?entities .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Subject' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:subjectPartition _:b .
        _:b void-ext:subject ?s .
        _:b void:triples ?triples .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Property Type' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:propertyClassPartition _:b .
        _:b void:class ?propertyClass .
        _:b void:entities ?entities .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Property Namespace' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:propertyNamespacePartition _:b .
        _:b void-ext:namespace ?propertyNamespace .
        _:b void:entities ?entities .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Property' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void:propertyPartition _:b .
        _:b void:property ?p .
        _:b void:triples ?triples .
        _:b void-ext:distinctLiterals ?distinctLiterals .
        _:b void-ext:distinctIRIReferenceObjects ?distinctIRIReferenceObjects .
        _:b void-ext:distinctBlankNodeObjects ?distinctBlankNodeObjects .
        _:b void-ext:distinctIRIReferenceSubjects ?distinctIRIReferenceSubjects .
        _:b void-ext:distinctBlankNodeSubjects ?distinctBlankNodeSubjects .
        _:b void:distinctSubjects ?distinctSubjects .
        _:b void:distinctObjects ?distinctObjects .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Object Type' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:objectClassPartition _:b .
        _:b void:class ?objectClass .
        _:b void:entities ?entities .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Object Namespace' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:objectNamespacePartition _:b .
        _:b void-ext:namespace ?objectNamespace .
        _:b void:entities ?entities .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Object Resource' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:objectPartition _:b .
        _:b void-ext:object ?o .
        _:b void:triples ?triples .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Object Datatype' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:objectLiteralDatatypePartition _:b .
        _:b void-ext:datatype ?datatype .
        _:b void:entities ?entities .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Object Language' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:objectLiteralLanguagePartition _:b .
        _:b void-ext:language ?language .
        _:b void:entities ?entities .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
    '''
    'Object Literal' : prefixes + '''
      INSERT {
        |BEGINUPDATEGRAPH|
        |DATASETTOPARTITION1|
        |PARTITIONIRI| void-ext:objectPartition _:b .
        _:b void-ext:object ?o .
        _:b void:triples ?triples .
        |ENDUPDATEGRAPH|
      } WHERE {
        { |DATASETTOPARTITION2| }
      '''
  }
  insertMetadataQuery =  prefixes + '''
    INSERT DATA {
      |BEGINUPDATEGRAPH|
      |DATASETIRI| a void:Dataset .
      |DATASETIRI| void:sparqlEndpoint |SPARQLENDPOINT| .
      |DATASETIRI| prov:generatedBy _:a .
      _:a a prov:Activity .
      _:a prov:startedAtTime "|STARTTIME|"^^xsd:dateTime .
      _:a prov:wasAssociatedWith _:b .
      _:b a prov:Agent .
      _:b sioc:ip_address "|IPADDRESS|" .
      |ENDUPDATEGRAPH|
    }
  '''
  insertEndTimeQuery =  prefixes + '''
    INSERT {
      |BEGINUPDATEGRAPH|
      ?a prov:endedAtTime "|ENDTIME|"^^xsd:dateTime .
      |ENDUPDATEGRAPH|
    } WHERE {
      |BEGINUPDATEGRAPH|
      |DATASETIRI| prov:generatedBy ?a .
      |ENDUPDATEGRAPH|
    }
  '''
  getConstraints = (stat, value) ->
    beforeConstraint = ''
    afterConstraint = ''
    switch stat
      when "Subject"
        beforeConstraint = "BIND(#{value} AS ?s)"
      when "Subject Type"
        afterConstraint = "?s a #{value} ."
      when "Subject Namespace"
        afterConstraint = "FILTER (STRSTARTS(STR(?s),STR(#{value})))"
      when "Property"
        beforeConstraint = "BIND(#{value} AS ?p)"
      when "Property Type"
        afterConstraint = "?p a #{value} ."
      when "Property Namespace"
        afterConstraint = "FILTER (STRSTARTS(STR(?p),STR(#{value})))"
      when "Object Resource", "Object Literal"
        beforeConstraint = "BIND(#{value} AS ?o)"
      when "Object Type"
        afterConstraint = "?o a #{value} ."
      when "Object Namespace"
        afterConstraint = "FILTER (STRSTARTS(STR(?o),STR(#{value})))"
      when "Object Datatype"
        afterConstraint = "FILTER(isLiteral(?o) && datatype(?o)=#{value})"
      when "Object Language"
        afterConstraint = "FILTER(isLiteral(?o) && lang(?o)=#{value})"
    { beforeConstraint : beforeConstraint, afterConstraint : afterConstraint }
  getPossibleLimitsQuery = prefixes + '''
    SELECT ?limitStat ?limitObject {
      |BEGINGRAPH|
      |DATASETIRI| ?limitProperty ?partition .
      ?partition ?limitProperty2 ?limitObject .
      FILTER(?limitObject!=rdfs:Resource)
      FILTER(?limitStat!='Object Resource' || isIRI(?limitObject))
      FILTER(?limitStat!='Object Literal' || isLiteral(?limitObject))
      VALUES (?limitStat ?limitProperty ?limitProperty2) {
        ('Property' void:propertyPartition void:property)
        ('Subject Type' void:classPartition void:class)
        ('Subject' void-ext:subjectPartition void-ext:subject)
        ('Object Resource' void-ext:objectPartition void-ext:object)
        ('Object Literal' void-ext:objectPartition void-ext:object)
        ('Subject Namespace' void-ext:subjectNamespacePartition void-ext:namespace)
        ('Property Namespace' void-ext:propertyNamespacePartition void-ext:namespace)
        ('Object Namespace' void-ext:objectNamespacePartition void-ext:namespace)
        ('Property Type' void-ext:propertyClassPartition void:class)
        ('Object Type' void-ext:objectClassPartition void:class)
        ('Object Datatype' void-ext:objectLiteralDatatypePartition void-ext:datatype)
        ('Object Language' void-ext:objectLiteralLanguagePartition void-ext:language)
      }
      |ENDGRAPH|
    }
  '''
  {
    generalStatQueries : [
      'Subject Class Count'
      'Property Class Count'
      'Object Class Count'
      'Triple Part Counts'
      'RDF Node Count'
      'Literal Count'
      'Datatype Count'
      'Language Count'
      'IRI Reference Count'
      'Blank Node Count'
      'IRI Reference Subject Count'
      'Blank Node Subject Count'
      'IRI Reference Object Count'
      'Blank Node Object Count'
    ]
    generateStats : [
      'Subject Class Count'
      'Property Class Count'
      'Object Class Count'
      'Triple Part Counts'
      'RDF Node Count'
      'Literal Count'
      'Datatype Count'
      'Language Count'
      'IRI Reference Count'
      'Blank Node Count'
      'IRI Reference Subject Count'
      'Blank Node Subject Count'
      'IRI Reference Object Count'
      'Blank Node Object Count'
      'Subject Type'
      'Subject Namespace'
      'Subject'
      'Property Type'
      'Property Namespace'
      'Property'
      'Object Type'
      'Object Namespace'
      'Object Resource'
      'Object Datatype'
      'Object Language'
      'Object Literal'
    ]
    partitionStatInfo : {
      'Subject Type' : { partitionProperty1: 'void:classPartition', partitionProperty2 : 'void:class', binding: 'class' }
      'Subject Namespace' : { partitionProperty1: 'void-ext:subjectNamespacePartition', partitionProperty2 : 'void-ext:namespace', binding : 'subjectNamespace' }
      'Subject' : { partitionProperty1: 'void-ext:subjectPartition', partitionProperty2 : 'void-ext:subject', binding: 's' }
      'Property Type' : { partitionProperty1: 'void-ext:propertyClassPartition', partitionProperty2 : 'void:class', binding: 'propertyClass' }
      'Property Namespace' : { partitionProperty1: 'void-ext:propertyNamespacePartition' , partitionProperty2 : 'void-ext:namespace', binding: 'propertyNamespace' }
      'Property' : { partitionProperty1: 'void:propertyPartition', partitionProperty2 : 'void:property', binding: 'p' }
      'Object Type' : { partitionProperty1: 'void-ext:objectClassPartition', partitionProperty2 : 'void:class', binding: 'objectClass' }
      'Object Namespace' : { partitionProperty1: 'void-ext:objectNamespacePartition', partitionProperty2 : 'void-ext:namespace', binding: 'objectNamespace' }
      'Object Resource' : { partitionProperty1: 'void-ext:objectPartition', partitionProperty2 : 'void-ext:object', binding: 'o' }
      'Object Datatype' : { partitionProperty1: 'void-ext:datatypePartition', partitionProperty2 : 'void-ext:datatype' , binding: 'datatype' }
      'Object Language' : { partitionProperty1: 'void-ext:languagePartition', partitionProperty2 : 'void-ext:language', binding: 'language' }
      'Object Literal' : { partitionProperty1: 'void-ext:objectPartition', partitionProperty2 : 'void-ext:object', binding: 'o' }
    }
    getPossibleLimits : (endpoint,graphIRI,datasetIRI) ->
      sparql.query(endpoint,getPossibleLimitsQuery
      .replace(/\|BEGINGRAPH\|/g,if graphIRI? && graphIRI!='' then " GRAPH <#{graphIRI}> {" else "")
      .replace(/\|ENDGRAPH\|/g,if graphIRI? && graphIRI!='' then " } " else "")
      .replace(/\|DATASETIRI\|/g,datasetIRI))
    insertMetadata : (updateEndpoint,updateGraphIRI,endpoint,datasetIRI,startTime,ipaddress) ->
      sparql.update(
        updateEndpoint,insertMetadataQuery
          .replace(/\|DATASETIRI\|/g,datasetIRI)
          .replace(/\|BEGINUPDATEGRAPH\|/g,if updateGraphIRI? && updateGraphIRI!='' then " GRAPH <#{updateGraphIRI}> {" else "")
          .replace(/\|ENDUPDATEGRAPH\|/g,if updateGraphIRI? && updateGraphIRI!='' then " } " else "")
          .replace(/\|SPARQLENDPOINT\|/g,endpoint)
          .replace(/\|IPADDRESS\|/g,ipaddress)
          .replace(/\|STARTTIME\|/g,startTime)
      )
    insertEndTime : (updateEndpoint,updateGraphIRI,datasetIRI,endTime) ->
      sparql.update(
        updateEndpoint,insertEndTimeQuery
          .replace(/\|DATASETIRI\|/g,datasetIRI)
          .replace(/\|BEGINUPDATEGRAPH\|/g,if updateGraphIRI? && updateGraphIRI!='' then " GRAPH <#{updateGraphIRI}> {" else "")
          .replace(/\|ENDUPDATEGRAPH\|/g,if updateGraphIRI? && updateGraphIRI!='' then " } " else "")
          .replace(/\|ENDTIME\|/g,endTime)
      )
    getStatistic : (endpoint,graphIRI,datasetIRI,stat,limitStat,limitTarget,options) ->
      if (limitTarget?)
        dataset="<#{datasetIRI}> #{this.partitionStatInfo[limitStat].partitionProperty1} ?cpartition . ?cpartition #{this.partitionStatInfo[limitStat].partitionProperty2} #{limitTarget} . ?cpartition"
      else
        dataset="<#{datasetIRI}>"
      sparql.query(endpoint,queries[stat]
        .replace(/\|BEGINGRAPH\|/g,if graphIRI? && graphIRI!='' then " GRAPH <#{graphIRI}> {" else "")
        .replace(/\|ENDGRAPH\|/g,if graphIRI? && graphIRI!='' then " } " else "")
        .replace(/\|DATASET\|/g,dataset),options)
    calculateStatistic : (endpoint,graphIRI,stat,limitStat,limitTarget,options) ->
      constraints = getConstraints(limitStat,limitTarget)
      sparql.query(endpoint,calculationQueries[stat]
        .replace(/\|BEFORECONSTRAINT\|/g,constraints.beforeConstraint)
        .replace(/\|AFTERCONSTRAINT\|/g,constraints.afterConstraint)
        .replace(/\|BEGINGRAPH\|/g,if graphIRI? && graphIRI!='' then " GRAPH <#{graphIRI}> {" else "")
        .replace(/\|ENDGRAPH\|/g,if graphIRI? && graphIRI!='' then " } " else ""),options)
    calculateAndInsertStatistic : (updateEndpoint,updateGraphIRI,stat,datasetIRI,queryEndpoint,graphIRI,limitStat,limitTarget) ->
      if (limitTarget?)
        constraints = getConstraints(limitStat,limitTarget)
        partitionProperty1 = this.partitionStatInfo[limitStat].partitionProperty1
        partitionProperty2 = this.partitionStatInfo[limitStat].partitionProperty2
        partitionIRI = "?apartition"
        datasetToPartition1 = ''
        datasetToPartition2 = "<#{datasetIRI}> #{partitionProperty1} #{partitionIRI} . #{partitionIRI} #{partitionProperty2} #{limitTarget} ."
      else
        constraints = { beforeConstraint : '', afterConstraint : '' }
        partitionIRI = "<#{datasetIRI}>"
        datasetToPartition1 = ''
        datasetToPartition2 = ''
      query = insertQueries[stat]+'''
      {
      SERVICE <|QUERYENDPOINT|> {
      ''' + calculationQueries[stat] + '}}}'
      sparql.update(updateEndpoint,query
        .replace(/\|BEGINUPDATEGRAPH\|/g,if updateGraphIRI? && updateGraphIRI!='' then " GRAPH <#{updateGraphIRI}> {" else "")
        .replace(/\|ENDUPDATEGRAPH\|/g,if updateGraphIRI? && updateGraphIRI!='' then " } " else "")
        .replace(/\|BEGINGRAPH\|/g,if graphIRI? && graphIRI!='' then " GRAPH <#{graphIRI}> {" else "")
        .replace(/\|ENDGRAPH\|/g,if graphIRI? && graphIRI!='' then " } " else "")
        .replace(/\|QUERYENDPOINT\|/g,queryEndpoint).replace(/\|DATASETTOPARTITION1\|/g,datasetToPartition1)
        .replace(/\|DATASETTOPARTITION2\|/g,datasetToPartition2).replace(/\|PARTITIONIRI\|/g,partitionIRI)
        .replace(/\|BEFORECONSTRAINT\|/g,constraints.beforeConstraint)
        .replace(/\|AFTERCONSTRAINT\|/g,constraints.afterConstraint))
    insertReadyStatistic : (updateEndpoint,updateGraphIRI,datasetIRI,stat,limitStat,limitTarget,data) ->
      if (limitTarget?)
        partitionProperty1 = this.partitionStatInfo[limitStat].partitionProperty1
        partitionProperty2 = this.partitionStatInfo[limitStat].partitionProperty2
        partitionIRI = "?apartition"
        datasetToPartition1 = ''
        datasetToPartition2 = "<#{datasetIRI}> #{partitionProperty1} #{partitionIRI} . #{partitionIRI} #{partitionProperty2} #{limitTarget} ."
      else
        partitionIRI = '<' + datasetIRI + '>'
        datasetToPartition1 = ''
        datasetToPartition2 = ''
      values = "VALUES ( "
      for svar in data.head.vars
        values = values + "?" + svar + " "
      values = values + ") { "
      for binding in data.results.bindings
        values = values + '( '
        for svar in data.head.vars
          values = values + sparql.bindingToString(binding[svar]) + ' '
        values = values + ') '
      values = values + "}"
      datasetToPartition2 = datasetToPartition2 + values
      query = insertQueries[stat] + '}'
      sparql.update(updateEndpoint,query
        .replace(/\|BEGINUPDATEGRAPH\|/g,if updateGraphIRI? && updateGraphIRI!='' then " GRAPH <#{updateGraphIRI}> {" else "")
        .replace(/\|ENDUPDATEGRAPH\|/g,if updateGraphIRI? && updateGraphIRI!='' then " } " else "")
        .replace(/\|DATASETTOPARTITION1\|/g,datasetToPartition1)
        .replace(/\|DATASETTOPARTITION2\|/g,datasetToPartition2)
        .replace(/\|PARTITIONIRI\|/g,partitionIRI))
  }
)