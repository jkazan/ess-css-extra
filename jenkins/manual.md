## jenkins

This folder contains the file used by Jenkins to run the various pipelines.

css-pipeline is the jenkinsfile that builds and tests the CS-Studio -community, ess -development and -production

css-devenv-integration-pipeline is the jenkinsfile that creates a virtual machine and launches the lates cs-studio production version. It needs the testcs.json file to specify how the virtual machine should be created. The folder scripts contains the scripts that will be ran on the virtual machine specified by testcs.json.        

### Step by step creation of a pipeline

1.	Have Jenkins 2.x with pipeline and version control plugins installed.
2.	Press “New Item” [top left].
3.	Choose name and the item type “Pipeline”.
4.	In the menu furthest down called “pipeline” change the definition to “Pipeline script from SCM”.
5.	Paste the url to the repo containing the Jenkinsfile and the path to it from within the repo (this repo).

### Config for the pipelines

For reusability, the script is reliant on parameters from the user. These parameters are to be inputted through configuring jenkins and require the plug in "environment injector".
The option **Prepare an environment for the run** then gets available for the user. Variables can then be defined in the textfield **Properties Content**.

The css-devenv-integration-pipeline is intended to be ran after the production version has been built by css-pipeline. In order to make a pipeline start after another you need to make the second pipeline listen to the previous job as nan upstream. Do this by adding the configuration property "Build after other projects are built" under "Build Triggers", there you can set any type of project as upstream.  

### Default environments used at ESS

#### CS-Studio Community Edition

```
csstudioRepo=https://github.com/ControlSystemStudio
displayBuilderRepo=https://github.com/kasemir/org.csstudio.display.builder
repoBranch=master
buildFolder=css-ce
email=test@replace.se
useArtifactory=false

```

#### ESS CS-Studio development

```
csstudioRepo=https://github.com/ESSICS
displayBuilderRepo=https://github.com/kasemir/org.csstudio.display.builder
repoBranch=master
buildFolder=ess-css-development
email=test@replace.se
useArtifactory=true
artifactoryServerID=<replace>
artifactoryFolder=development

```

#### ESS CS-Studio production

```
csstudioRepo=https://github.com/ESSICS
displayBuilderRepo=https://github.com/ESSICS/org.csstudio.display.builder
repoBranch=production
buildFolder=ess-css-production
email=test@replace.se
useArtifactory=true
artifactoryServerID=<replace>
artifactoryFolder=production

```

### Adding slack integration

1. Download slack notification plugin for jenkins.
2. Go to the slack url <teamname>.slack.com/apps/ and find jenkins integration.
3. Press "add configuration" for the channel you want to add the integration to.
4. Copy and add the Team domain, token and channel name for the pipeline script.

Currently Slack is not used to notify user's abount the pipeline.

#### Example

```
slackSend message: "Build Started", token: 'AKrq2kTrwtrFjepxe6OFC5Lu', channel: "<theChannel>", teamDomain: "teamName"
```

### Jenkinsfile syntax references

[Supported steps (predefined methods) for the jenkins file](https://jenkins.io/doc/pipeline/steps/)

[Syntax reference, includes almost everything needed](https://jenkins.io/doc/book/pipeline/syntax/)

### Useful tips

* Use triple ' (''') for a literal string.
* Substitution (using $variable) requires explicit string sign ("").
* The "steps" are ran on the slave, other is ran on the master.
* Variables declared in the "environment"-block are accessible from the slave as exported variables.
