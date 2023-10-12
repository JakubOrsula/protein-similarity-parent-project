#!/bin/bash -ex

export LD_LIBRARY_PATH=/home/ubuntu/gesamt_distance/build/distance

CORES_COUNT=$(nproc --all)
java -Djava.util.concurrent.ForkJoinPool.common.parallelism="$CORES_COUNT" -jar ./JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar --run computeDistances