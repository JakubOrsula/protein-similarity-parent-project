# Manager of updates to the searching database

## Build

```shell
mvn assembly:assembly -DdescriptorId=jar-with-dependencies
```

+ output can be found in `JOIntegration/target/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar`.

## Run 

1. in the same directory as the `.jar` file is, create a `run.properties` file.
   + you can take inspiration from either in `JOIntegration/src/main/resources/run.properties`
   + or from `JOIntegration/src/main/java/com/example/services/configuration/AppConfig.java` which uses the file
2. the database is not automatically set up and is clunky at the moment
   + you need to manually apply the first migration
   + copy the data for all tables
3. make sure that the [gesamt library](https://github.com/krab1k/gesamt_distance) is compiled and you know the path to the binary
   + use the path to set `LD_LIBRARY_PATH` environment variable
   + example path: `/home/jakub/Documents/src/gesamt_distance/build/distance`
4. run the program
   + if you want to limit number of system threads used use  `-Djava.util.concurrent.ForkJoinPool.common.parallelism=8` with desired number of threads
   + ```sh
    /home/jakub/.jdks/openjdk-20.0.1/bin/java -Dfile.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 -jar /home/jakub/git/school/diplomka/diplomka_impl/JOIntegration/target/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar
    ```

+ If you need to tunnel to database:
  + `ssh -L 13306:localhost:3306 -T protein-jo`
## Development

+ tbd

```shell
rsync -av /home/jakub/git/school/diplomka/diplomka_impl/JOIntegration/target/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar protein-jo:/home/ubuntu/protein-search/bin/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar
```

If you need to regenerate csv pivot files use and replace `,` with `;`
```mysql
SELECT
CONCAT('"', pivot1, '"') AS quoted_pivot1,
CONCAT('"', pivot2, '"') AS quoted_pivot2
FROM
pivotPairsFor64pSketches
ORDER BY
sketchBitOrder;
```