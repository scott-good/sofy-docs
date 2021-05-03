---
title: Domains & Certificates
layout: default
parent: Kubernetes Administration
grand_parent: Installing Solutions
nav_order: 3
---
# **Applying a Domain and SSL Certificate to your Solution**

By default, a SoFy solution will create its own self signed SSL certificate. This is meant for initial development and testing and will throw many warnings and cause issues on most HTTP clients, including browsers and some of the most common programmatic client libraries. There are options to apply your own domain name and a recognized SSL certificate to a Solution; these quick start instructions will describe the simpler method, using the Let's Encrypt service to dynamically generate a certificate.  

You will need the following prerequisites:

  *  A cluster in GCP configured to run a Solution
  *  A domain name, for example one purchased from https://domains.google.com/


This document will go through the following steps:
*  Configuring your domain name and DNS zone
*  Creating a GCP service account with the DNS Administrator role
*  Creating a Kubernetes secret with the service account credentials
*  Configuring your solution to use the domain name and request certificate generation at install
*  Accessing your Solution using the domain name and validating the certificate
____
## **I. Configure your Domain Name and DNS Zone**

1. Log into your GCP account at https://console.cloud.google.com.
2. Navigate to **Network Services** > **Cloud DNS** and click **Create Zone**.
3. Enter a name for the zone and your domain name in 'DNS name' then click **create**.
4. When you click on the newly created zone, you will see a list of DNS servers, which need to be copied into your domain name configuration.
5. Log into https://domains.google.com; in 'My Domains' click on the domain name that you are using for the Solution.
6. Navigate to **DNS** then select **Use custom name servers**.
7. Cut and paste the DNS servers (one at a time, do not include the trailing '.') from the GCP Cloud DNS page to the Google domain name entry, then save.

____
## **II. Create a GCP Service Account with the DNS Administrator Role**

  1. Log into your GCP trial account at https://console.cloud.google.com.
  2. Navigate to **IAM & Admin** > **Service Accounts** and click on **Create service account**.
  3. Choose a name for the service account and ID (or accept the default ID); make a note of your service ID.
  4. In the menu of roles, find **DNS** and select **DNS Administrator**, then continue.
  5. Click on **Create key** and select **JSON**. The key will be generated - download to your local machine.
  6. Find the downloaded key file and rename it to "credentials.json," then upload that file to your GCP Cloud Shell.

____
## **III. Create a Kubernetes secret with the service account credentials**
```
kubectl create secret generic gcp-service-account-secret --from-file=./credentials.json
```
____
## **IV. Configure your solution to use the domain name and to request certificate generation at install**

There are two ways to do this: a) unpack, edit, and then repack the solution Helm chart, or b) use the existing Helm chart but provide the configuration as override on the Helm install command


**Option A:** Unpack, edit, and repack the solution Helm chart
1. Untar the solution chart and edit the top-level 'values.yaml' file. Near the top of the file you will see 'global:' and nested under that, 'domain: - edit the value of the domain property to be a subdomain of your domain name, for example:

```yaml
global:
  domain: "sol1.alexmul.dev"
```
2. Search for the 'certificate:' property in the same file, and add/edit these values. The GCP project ID can be seen by clicking the down-arrow next to your project name in the GCP console.  

```yaml
certificate:
  type: "production"
  email: ${YOUR_GCP_ACCOUNT_EMAIL}
  dns:
    type: "clouddns"
    project: ${YOUR_GCP_PROJECT_ID}  
    serviceAccountSecretRef:
      name: ${YOUR_GCP_SERVICE_ACCOUNT_SECRET_NAME}
      key: "credentials.json"
```
for example,

```yaml
certificate:
  type: "production"
  email: "sofy.mulholland@gmail.com"
  existingCertificateSecret: ""
  dns:
    type: "clouddns"
    project: "dark-airway-256814"
    region: ""
    accessKeyID: ""
    serviceAccountSecretRef:
      name: "gcp-service-account-secret"
      key: "credentials.json"
```
3.  Optional: Edit the top-level 'chart.yaml' file and increment the version number of the chart. It is a best practice to increment the version number when any change is made to the Helm chart.

4. Repackage the Helm chart with the 'Helm package' command.  

5. Install your modified Helm chart:

 ```
 helm install [my-release-name] [my-solution.tgz] --set global.hclImagePullSecret=[secret-name]
 ```


**Option B:** Install your original Helm chart with additional configuration override on the install command, similar to this:

 ```
 helm install udeploy alex-deploy-0.1.0.tgz  --set global.hclImagePullSecret=secret-name,global.hclImagePullSecret=secret-name,anchor.config.hostname=https://hclsoftware.compliance.flexnetoperations.com,anchor.config.serverID=\\{default\\}=D4U85APR0XN9,global.domain=udepsol.alexmul.com,certificate.type=production,certificate.email=sofy.mulholland@hcl.com,certificate.dns.type=clouddns,certificate.dns.project=dark-airway-256814,certificate.dns.serviceAccountSecretRef.name=gcp-service-account-secret,certificate.dns.serviceAccountSecretRef.key=credentials.json
 ```

____
## **V. Access your Solution using the domain name and validiate the certificate**

For example:

```
https://sofy-console.sol1.alexmul.dev
```
