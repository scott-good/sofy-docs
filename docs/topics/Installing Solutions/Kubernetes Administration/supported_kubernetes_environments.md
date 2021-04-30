---
title: Supported Environments
layout: default
parent: Kubernetes Administration
grand_parent: Installing Solutions
nav_order: 1
---

# **Supported Kubernetes Environments**

There are many options for your own Kubernetes environment:

- **open source** Kubernetes can be used for a self-managed environment
- most **public cloud** vendors provide supported Kubernetes installations, for example Google Kubernetes Engine and Amazon Elastic Kubernetes Service
- some **private cloud** platforms include Kubernetes that can be run in your data center or public cloud account.

The design goal of HCL SoFy is to allow solutions to run in any Kubernetes environment. Solution dependencies are on core Kubernetes only, with no use of vendor-specific services. With a growing number of Kubernetes vendors, however, solutions are tested on a specific set, which is listed below. If you run SoFy solutions in a different environment, we will do our best to address any issues you have, but we may need to work with you to debug problems that appear to be specific to your environment.

Please note that individual products and services in the SoFy Catalog may document their own support policies for different Kubernetes versions and providers.

## **Tested Kubernetes Environments**

- Google Kubernetes Engine
- Amazon Elastic Kubernetes Service
- Red Hat OpenShift Container Platform
  - OpenShift security policies mean that most Helm charts will not work out of the box. Please check the documentation for the individual catalog items to see if instructions are provided for installation on OpenShift.

## **Supported Kubernetes Versions**

The Kubernetes project couples frequent releases with a [strict compatibility policy](https://kubernetes.io/docs/reference/using-api/deprecation-policy/), to allow rapid innovation of the platform but to minimize impacts of those updates to existing applications. Most update problems can be avoided by using only generally available (stable) APIs, but even those may sometimes be deprecated and eventually removed. Solutions built on the current version of SoFy are supported when run on the following tested Kubernetes versions:

- 1.16
- 1.17
- 1.18

## **Cluster requirements and limitations**

- Cert-Manager must be installed in the cluster; version 0.15.1 or later.
- Each solution must be installed in a separate namespace.
- The Helm 3 client must be used to install solutions; supported version: 3.3.0 or later.
