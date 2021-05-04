---
title: Kubernetes Administration
layout: default
parent: Installing Solutions
has_children: true
nav_order: 2
---
# **Installing Solutions Overview for Kubernetes Administrators**

These instructions are designed for experienced Kubernetes users and list the steps for Solution install. If you need more details on any step, see the **Installing Solutions: Step-by-step Instructions** Guide. Supported versions of Kubernetes, Helm, and Cert-Manager are listed in the **Supported Kubernetes Environments** Guide.

You will need the following:

* Cert-Manager must be installed in the target cluster
* Each Solution must be in a separate namespace
* Pull secret created using your HCL repository credentials
* Solution chart installed, providing the pull secret and details of your license server

```
helm install [release-name] [file-name] --set global.hclImagePullSecret=[secret-name] --set hclFlexnetURL=[flexnet-url] --set hclFlexnetID=[flexnet-id]
```
To configure the 'hclFlexnetURL' and 'hclFlexnetID' value override you will need to specify your own license server information. For more information about these fields see **How to Connect a Solution to a Flexnet License Server**. If you do not specify these values, some Solution contents may not initialize properly or have full function available until you enter your license server information via the Solution Console 'Settings' selection.
