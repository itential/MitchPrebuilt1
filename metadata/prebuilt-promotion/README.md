<!-- This is a comment in md (Markdown) format, it will not be visible to the end user -->

<!-- Update the below line with your Pre-Built name -->
# Prebuilt Promotion

<!-- Leave TOC intact unless you've added or removed headers -->
## Table of Contents

- [Prebuilt Promotion](#prebuilt-promotion)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Installation Prerequisites](#installation-prerequisites)
  - [Requirements](#requirements)
  - [Environment variables](#environment-variables)
    - [Git Credentials (Bitbucket and Gitlab)](#git-credentials-bitbucket-and-gitlab)
    - [Host Override (optional) (Bitbucket and Gitlab)](#host-override-optional-bitbucket-and-gitlab)
    - [IAP Credentials (for Promote stage)](#iap-credentials-for-promote-stage)
    - [Integrating with GitLab](#integrating-with-gitlab)
    - [Integrating with Bitbucket](#integrating-with-bitbucket)
    - [Integrating with Github](#integrating-with-github)
  - [Features](#features)
  - [Pipeline Stages](#pipeline-stages)
  - [How to Install](#how-to-install)
  - [How to Run](#how-to-run)
  - [Additional Information](#additional-information)

## Overview

<!-- Write a few sentences about the Pre-Built and explain the use case(s) -->
<!-- Avoid using the word Artifact. Please use Pre-Built, Pre-Built Transformation or Pre-Built Automation -->
<!-- Ex.: The Migration Wizard enables IAP users to conveniently move their automation use cases between different IAP environments -->
<!-- (e.g. from Dev to Pre-Production or from Lab to Production). -->
The **Pre-built Promotion** pre-built takes an Admin Essentials installed artifact and creates a new project or updates an existing project in a specified code management platform (i.e. Gitlab, Github, Bitbucket) using the up-to-date artifact bundle. 

If the project and branch already exists in the specified group, it will create a new branch and open a merge/pull request (MR/PR) in the platform with any changes made in the lab environment. It will then trigger a pipeline that will promote the up-to-date bundle into a specified IAP environment. More details on the different stages of the pipeline can be found [below](#pipeline-stages).
<!-- Workflow(s) Image Placeholder - TO BE ADDED DIRECTLY TO GitLab -->
<!-- REPLACE COMMENT BELOW WITH IMAGE OF YOUR MAIN WORKFLOW -->
<table><tr><td>
  <img src="https://gitlab.com/itentialopensource/pre-built-automations/prebuilt-promotion/-/raw/release/2021.1/images/workflow.png" alt="workflow" width="800px">
</td></tr></table>
<!-- REPLACE COMMENT ABOVE WITH IMAGE OF YOUR MAIN WORKFLOW -->

## Installation Prerequisites

Users must satisfy the following pre-requisites:

<!-- Include any other required apps or adapters in this list -->
<!-- Ex.: EC2 Adapter -->
* Itential Automation Platform
  * `^2021.1`
* App-Artifacts
  * `^6.1.15`
* One of the following version control adapters
  * [GitLab Adapter](https://gitlab.com/itentialopensource/adapters/devops-netops/adapter-gitlab) (`^v0.8.0`)
  * [Bitbucket Adapter](https://gitlab.com/itentialopensource/adapters/devops-netops/adapter-bitbucket) (`^v0.4.0`)
  * [GitHub Adapter](https://gitlab.com/itentialopensource/adapters/devops-netops/adapter-bitbucket) (`^v0.3.0`)
  
## Requirements

This Pre-Built requires the following:
* Desired pre-built already installed/created in Admin Essentials
* In order to promote pre-built to the next IAP environment, pipeline runners would need to have access to this environment
* Defining the following pipeline variables in the respective code management platform required for the pipeline to run successfully. More details on these variables can be found in the next section.

## Environment variables
### Git Credentials (Bitbucket and Gitlab)

|Variable            |Example Value         |Description |
|--------------------|----------------------|------------|
|`CI_GIT_EMAIL`      |`example@gitlab.com`  |Email for Gitlab user running the pipeline. This will be used to setup Gitlab access within your pipeline environment.|
|`CI_GIT_USERNAME`     |`ci-bot-user`         |Username for Gitlab user running the pipeline. This will be used to setup Gitlab access within your pipeline environment.|
|`ID_RSA`              |Contents of private id_rsa key|Store the corresponding public key under SSH Keys in User Settings|

### Host Override (optional) (Bitbucket and Gitlab)
|Variable            |Example Value         |Description |
|--------------------|----------------------|------------|
|`CI_ORIGIN_HOSTNAME` (optional) |`git@self-hosted-gitlab.com`                      |Gitlab hostname. This will be used to setup Gitlab access within your pipeline environment. When this variable is not set, the hostname will default to `git@gitlab.com`|
|`CI_ORIGIN_SSH_PORT` (optional)| `2224` | Port that Gitlab is running SSH on. This variable should be set if the SSH client connection is not accessible via the default 22 port.

### IAP Credentials (for Promote stage)
If you do not want to promote your pre-built bundle to a higher IAP environment, set `PROMOTE = False` and disregard the variables in this section.
|Variable            |Example Value         |Description |
|--------------------|----------------------|------------|
|`PROMOTE` (optional, defaults to `True`)     |`True` or `False`| Determines if "promote" stage of pipeline will run.
|`IAP_HOSTNAME`        |`https://ACME.itential.com`| Used in promotion stage to connect to IAP|
|`IAP_TOKEN`          |`123_sample_token`| Required if using token authentication and NOT basic authentication|
|`IAP_USERNAME`        |`iap_user@itential.com`| Required if using basic authentication|
|`IAP_PW`              |`itential123`| Required if using basic authentication
|`IAP_PUSH_TO_LOCAL` (optional) |`True` or `False` | Determines what scope to push the target pre-built to. If this variable is not set, the scope will default to local. If this variable is set to false, the scope is set to the repository specified in the artifact.json file|

### Integrating with GitLab
From the GitLab UI, ensure that the necessary CI/CD variables are defined within the scope of your project. 

<table><tr><td>
  <img src="https://gitlab.com/itentialopensource/pre-built-automations/prebuilt-promotion/-/raw/release/2021.1/images/setEnvVarGitlab.png" alt="envVarPageGitlab" width="800px">
</td></tr></table>

### Integrating with Bitbucket
Ensure that the necessary Workspace variables are set in your Workspace settings in Bitbucket.

<table><tr><td>
  <img src="https://gitlab.com/itentialopensource/pre-built-automations/prebuilt-promotion/-/raw/release/2021.1/images/setEnvVarBitbucket.png" alt="envVarPageBitbucket" width="800px">
</td></tr></table>

### Integrating with Github
Under your Github organization settings, ensure that the necessary environmental variables are defined as Action secrets.

<table><tr><td>
  <img src="https://gitlab.com/itentialopensource/pre-built-automations/prebuilt-promotion/-/raw/release/2021.1/images/setEnvVarGithub.png" alt="envVarPageGithub" width="800px">
</td></tr></table>

## Features

The main benefits and features of the Pre-Built are outlined below.
* Performs rediscover on the pre-built if components are deleted or additional components are added
* Includes the necessary configuration files and scripts to run a CI/CD pipeline process that will
  * validate security of code and quality of manifest.json
  * version bump the pre-built bundle when pushing to master
  * generate an updated `artifact.json` file reflecting the changes made in the up-to-date artifact bundle
  * promote the `artifact.json` to the next IAP environment in the CI/CD process (e.g. staging). This step will overwrite exising components in IAP.

## Pipeline Stages
|Stage    |Description     |
|---------|----------------|
|quality  | lints code, test code quality, and ensures that there are no security vulnerabilities|
|test     | validates path links and schema of `manifest.json` |
|bump     | bumps pre-built version (only `master` branch) |
|generate | generates updated `artifact.json` file |
|promote  | promotes updated `artifact.json` to specified IAP environment using the credentials and hostname specified in the environmental variables |

## How to Install

To install the Pre-Built:

* Verify you are running a supported version of the Itential Automation Platform (IAP) as listed above in the [Requirements](#requirements) section in order to install the Pre-Built. 
* The Pre-Built can be installed from within App-Admin_Essential. Simply search for the name of your desired Pre-Built and click the install button (as shown below).

<!-- REPLACE BELOW WITH IMAGE OF YOUR PUBLISHED PRE-BUILT -->
<table><tr><td>
  <img src="https://gitlab.com/itentialopensource/pre-built-automations/prebuilt-promotion/-/raw/release/2021.1/images/install.png" alt="install" width="600px">
</td></tr></table>
<!-- REPLACE ABOVE WITH IMAGE OF YOUR PUBLISHED PRE-BUILT -->

<!-- OPTIONAL - Explain if external components are required outside of IAP -->
<!-- Ex.: The Ansible roles required for this Pre-Built can be found in the repository located at https://gitlab.com/itentialopensource/pre-built-automations/hello-world -->

## How to Run

Use the following to run the Pre-Built:

1. In Automation Catalog, find the Prebuilt Promotion entry.
2. Fill out the form (as shown below) with the appropriate values.  
3. Continue with all manual tasks in the workflow.
<table><tr><td>
  <img src="https://gitlab.com/itentialopensource/pre-built-automations/prebuilt-promotion/-/raw/release/2021.1/images/sampleFormData.png" alt="sampleForm" width="600px">
</td></tr></table>

Form Inputs (refer to above screenshot for example inputs)
1. Version Control Service - The adapter corresponding to the code management platform to push the target pre-built to
2. Project Name - Project name to Update/Create. Avoid using spaces in the name for Github Projects.
3. Group Path - Group path for subgroup
4. Re-discover - Perform re-discover (in case new/old components need to be added/removed from prebuilt bundle)
5. Prebuilt - Target pre-built to push
6. Project Path - Bitbucket project to create repo under. Only valid for Bitbucket projects
7. MR Type - Type of MR (patch/minor/major)
8. Commit Message -  Commit message to add for commit tasks
9. Target Branch - Target branch to set for MR

## Additional Information

Please use your Itential Customer Success account if you need support when using this Pre-Built.
