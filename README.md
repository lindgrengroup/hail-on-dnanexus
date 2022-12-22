# hail-on-dnanexus

A DNAnexus app for running the latest [Hail](https://github.com/hail-is/hail) on a [Spark cluster](https://github.com/apache/spark) in [JupyterLab](https://github.com/jupyterlab/jupyterlab). This app was created as an up-to-date alternative to the [DXJupyterLab Spark Cluster](https://documentation.dnanexus.com/user/jupyter-notebooks/dxjupyterlab-spark-cluster) which only supported Hail 0.2.78 (19/10/2021).

Maintained by Barney Hill (barney.hill@ndph.ox.ac.uk) for usage within the Lindgren group. This app is an unofficial community app - not associated with DNAnexus.

## Installation
```
git clone git@github.com:lindgrengroup/hail-on-dnanexus.git
dx build hail-on-dnanexus -f
```

## Usage
```
dx run hail-on-dnanexus
```
- After around 5 minutes after running the app the Jupyter Lab link will be accessible through the DNAnexus monitor page. Once initialised the Spark control panel can be accessed from https://${JOBID}.dnanexus.cloud:8081/jobs.

- Once in the Jupyter lab the following extra code is required to get full read/write functionality: https://discuss.hail.is/t/how-should-i-use-hail-on-the-dnanexus-rap/2277

- DNAnexus files can be directly accessed with the prefix "file:///mnt/project/".

## Features
- __Hail 0.2.107 (latest as of 21/12/22)__
- Spark 3.2.0

## TODO
- Automatically create latest Hail builds on Spark 3.2.0 for usage in the app.
- Allow non-interactive execution of a Hail Python script.
