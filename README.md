# iris-analytics-template
This is a template for InterSystems IRIS Analytics (DeepSee) solutions.
The template contains a very basic example of the BI solution which contains one source class, data, one cube, two pivots and one dashboard.

## Installation 

### ZPM
It's packaged with ZPM so it could be installed as:
```
zpm "install iris-analytics-sample"
```
then open http://localhost:32791/dsw/index.html#/IRISAPP

### Docker
The repo is dockerised so you can  clone/git pull the repo into any local directory

```
$ git clone https://github.com/intersystems-community/iris-analytics-template.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d
```
and open then http://localhost:32791/dsw/index.html#/IRISAPP

Or, open the cloned folder in VSCode, start docker-compose and open the URL via VSCode menu:
<img width="799" alt="Screenshot 2020-11-15 at 20 17 12" src="https://user-images.githubusercontent.com/2781759/99191744-ba02af00-277f-11eb-8568-e43aa9a0029c.png">


## How to start coding
### Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

This repository is ready to code in VSCode with ObjectScript plugin.
Install [VSCode](https://code.visualstudio.com/), [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.
Open /src/cls/PackageSample/ObjectScript.cls class and try to make changes - it will be compiled in running IRIS docker container.
![docker_compose](https://user-images.githubusercontent.com/2781759/87149599-3c063700-c2b9-11ea-9250-9b5d42ec4932.gif)

[Read more about folder setup for InterSystems ObjectScript](https://community.intersystems.com/post/simplified-objectscript-source-folder-structure-package-manager)

The script in Installer.cls will import everything you place under /src into IRIS.

## How this sample was created

The class and data were taken from covid19 CSV [Johns Hopkins repository](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports).

zpm "install csvgen" will import csvgen package which lets to create class and import data with the following line:
```
set file="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/11-14-2020.csv"
zw ##class(community.csvgen).GenerateFromURL(file,",","dc.irisbi.covid19")
```
The cube was generated from with:
```
zw ##class(%DeepSee.WizardUtils).%GenerateCubeDefinition("dc.irisbi.covid19","CovidCube","dc.irisbi.covid19cube",1)
```

### Deployment
To deploy this project via ZPM or docker we need:
classes, data and DFI.
Cube class [dc.irisbi.Covid19Cube.cls](https://github.com/intersystems-community/iris-analytics-template/blob/438c93f67e9a6f55d6a5598b8d3f4b9ca0fc8634/src/dc/irisbi/covid19cube.cls) was exported manually via Server view in VSCode.



[Pivots and dashboard](https://github.com/intersystems-community/iris-analytics-template/blob/438c93f67e9a6f55d6a5598b8d3f4b9ca0fc8634/src/dfi/Covid19/)  were created manually and then were exported with isc dev to the format, which standard import procedures and ZPM can import:
```
zpm "install isc-dev"
do ##class(dev.code).workdir("/irisdev/app/src")
d ##class(dev.code).export("*.DFI")
```
And [data](https://github.com/intersystems-community/iris-analytics-template/blob/438c93f67e9a6f55d6a5598b8d3f4b9ca0fc8634/src/gbl/dc.irisbi.covid19D.xml) was exported via standard export utility:
```
do $System.OBJ.Export("dc*.GBL","/irisdev/app/src/gbl/dc.irisbi.covid19D.xml",,.errors)
```

after that ZPM module.xml was created manually which includes classes, DFI, global and calls %DeepSee.Utils("Covid19Cube") to build the cube data.



## What's inside the repository

### Dockerfile

The simplest dockerfile which starts IRIS and imports Installer.cls and then runs the Installer.setup method, which creates IRISAPP Namespace and imports ObjectScript code from /src folder into it.
Use the related docker-compose.yml to easily setup additional parametes like port number and where you map keys and host folders.
Use .env/ file to adjust the dockerfile being used in docker-compose.


### .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

[Read about all the files in this article](https://community.intersystems.com/post/dockerfile-and-friends-or-how-run-and-collaborate-objectscript-projects-intersystems-iris)
