# ModDoRelease

What this will create is:
* a zipped folder for thunderstore with the readme, changelog, icon, manifest (created by this script), and folder with your mod files in it
* a zipped folder for github with a folder with your mod files in it
<br>
For the thunderstore package it will then upload it to thunderstore and for the github pakage it will create a release and upload the github package to it.
<br>
**Note: This does zero error handling**

## Requirements

This relies on the [thunderstore cli](https://github.com/thunderstore-io/thunderstore-cli) and the github [cli](https://cli.github.com/).  
For those clis to work, in your environment variables you must have the variable GH_TOKEN with your github authorization token and the variable TCLI_AUTH_TOKEN with your thunderstore authorization token.  

## For each mod 

* Place the DoRelease.ps1 in your solution directory.  
* Change the necesssary information at the top of DoRelease.ps1 and adjust any of the paths (i.e., assetsPath, dllPath).  
* For the thunderstore cli you also need the thunderstore.toml in the solution directory.  
* For the thunderstore package you also need your mod icon and readme in the solution directory.  
* For github this script get the last change from the changelog to make the body of the release notes so for both packages you will need a changelog in the solution directory.  

## Each time before you publish a release

* Update the version at Properties\\Assemblyinfo.cs. This script grabs the version from your dll.
* Update the changelog
  
