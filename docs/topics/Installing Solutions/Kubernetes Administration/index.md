---
title: Kubernetes Administration
layout: default
parent: Installing Solutions
has_children: true
nav_order: 2
---
# **Installing Solutions Overview for Kubernetes Administrators**

These instructions are designed for experienced Kubernetes users and list the steps for solution install. If you need more details on any step, see the **Installing Solutions: Step-by-step instructions** guide. Supported versions of Kubernetes, Helm and Cert-Manager are listed in the **Supported Kubernetes Environments** guide.

You will need the following:

* Cert-Manager must be installed in the target cluster
* Each solution must be in a separate namespace
* Create a pull secret using your HCL repository credentials
* Install the solution chart, providing the pull secret and details of your license server

```
helm install [release-name] [file-name] --set global.hclImagePullSecret=[secret-name] --set hclFlexnetURL=[flexnet-url] --set hclFlexnetID=[flexnet-id]
```
To configure the 'hclFlexnetURL' and 'hclFlexnetID' value overrides you will need to specify your own license server information.  For more information about these fields see **How to connect a Solution to a Flexnet License Server**. If you do not specify these values, some solution contents may not initialize properly or have full function available until you enter your license server information via the Solution Console 'Settings'.