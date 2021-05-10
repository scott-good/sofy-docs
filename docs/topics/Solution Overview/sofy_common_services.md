---
title: SoFy Common Services
layout: default
parent: Solution Overview
nav_order: 2
---

# **SoFy Common Services**

These services can be used to provide enhanced management and security of your Solution:

## **Solution Console**
The Solution Console  application provides a simplified solution administration experience, including:
*	Kubernetes cluster info, which is filtered to only show the information for the solution resources; this is useful if you are new to Kubernetes or are operating in a large cluster, but are only concerned with the solution application
*	URLs for the services and products selected from the SoFy Catalog - these include links to product GUIs, REST API swagger UIs, and base URLs for REST APIs
*	Easy setting of FlexNet License Server properties for HCL licensed content
*	Links to other common services in the solution:
  * the [Grafana](https://grafana.com/) monitoring dashboard
  * the [KeyCloak](https://www.keycloak.org/) GUI to manage users, passwords, and access controls
  * the [Prometheus](https://prometheus.io/) GUI for low-level access to monitoring data
* Access to logs for all pods in the solution

If the Solution is running in the SoFy Sandbox, a link to the Solution Console is displayed in the Solution Details view.
If you have installed the Solution in your own environment, the URL for the Solution Console will be displayed at completion of the Helm install. It can also be constructed using the external-IP assigned to the ambassador services as follows: h<span>ttps://sofy-console.{external-IP}/

The default Administrator ID is "sol-admin" and Password is "pass" - use this to login to your SoFy Sandbox.


## **Access Control Service (ACS)**
ACS is an optional service that provides both authentication and authorization controls for traffic accessing the solution external IP. When included in a Solution, the ACS is registered as the authentication service for Ambassador and by default, it will be called to examine every request. The following default users and passwords are created for each new Solution:

* *user/pass* allows access to SoFy Catalog services
* *sol-admin/pass* allows access to SoFy Catalog services and to Solution Console 

Users and passwords can be managed through the Keycloak component that is included in ACS. A link to the Keycloak GUI is available in the Solution Console  application as follows: h<span>ttps://sofy-kc.{solution-ip}.

## **Monitoring Dashboard**

The optional Monitoring service includes Prometheus, to gather and store monitoring data, and Grafana, to display that data in visual dashboards.
