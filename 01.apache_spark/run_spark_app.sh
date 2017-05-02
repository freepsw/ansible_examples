#!/bin/bash

/opt/spark/spark-2.0.0-bin-hadoop2.7/bin/spark-submit  \
  --master spark://dev05:7077  \
  --class org.apache.spark.examples.SparkPi  \
  /opt/spark/spark-2.0.0-bin-hadoop2.7/examples/jars/spark-examples_2.11-2.0.0.jar   1000
