# Manager of updates to the searching database

## Out of the box run on the remote

Check [separate guide for remote deployment](./remote_orchestration/README.md).

## Local development

A configuration file for JetBrains IDEs is included which should be loaded automatically.

### Build

```shell
mvn assembly:assembly -DdescriptorId=jar-with-dependencies
```

+ output can be found in `JOIntegration/target/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar`.

### Run

Project is shipped as _batteries included_ - ready to run out of the box.


1. in the same directory as the `.jar` file is, create a `run.properties` file.
   + you can take inspiration from either in `JOIntegration/src/main/resources/run.properties.example`
   + or from `JOIntegration/src/main/java/com/example/services/configuration/AppConfig.java` which uses the file
1. make sure that the [gesamt library](https://github.com/krab1k/gesamt_distance) is compiled and you know the path to the binary
   + use the path to set `export LD_LIBRARY_PATH=` environment variable
   + example path: `/home/jakub/Documents/src/gesamt_distance/build/distance`
1. run CliApp main method
   + you will need to specify which stage of the solution you want to run
   + see CliApp.java for the details and possible stages

+ If you need to tunnel to the database:
  + `ssh -L 13306:localhost:3306 -T <remote deployment>`

## Development

### Managing dependencies

#### Gesamt library

+ the library is provided in the `resources/lib` folder
  + the library is tested on Linux Mint 21, for non-corresponding ubuntu/debian versions you will need to compile the lib yourself
+ the source code for the library can be found here: [github](https://github.com/JakubOrsula/gesamt_distance/tree/jo-integration)
+ compiling the library for this project requires modification of native bindigs, these modifications are on branch `jo-integration` of the library so you just need to compile that branch
+ follow the instructions in the library's readme to compile the library, then copy the `libProteinDistance.so` binary to the resources folder

#### VMMetricSpaceTechniques, VMGenericTools, VMFSMetricSpace

+ these are projects of [Vladimir Mic](https://is.muni.cz/osoba/v.mic)
+ they are forked to maintain control over their versions
+ if you need to update them, either update the fork or point the repos to the upstream
