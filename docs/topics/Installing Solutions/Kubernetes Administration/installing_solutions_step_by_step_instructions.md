---
title: Install Step-By-Step
layout: default
parent: Kubernetes Administration
grand_parent: Installing Solutions
nav_order: 2
---
# **Installing Solutions Step-By-Step Instructions**
These instructions are designed for those who have an existing Kubernetes environment, and detail the steps for solution install. Supported versions of Kubernetes, Helm, and Cert-Manager are listed in the **Supported Kubernetes Environments** guide. If you need more details on any step, see the **Installing Solutions: Getting Started with a GCP Trial Account Tutorial**, which also provides a script that automates most of the setup.

You will need permissions to install to the Kubernetes cluster. Use of a cluster that supports dynamic PV is recommended.

To install your solution:

1. Install a supported version of Helm 3.
   ```
   wget https://hclcr.io/files/sofy/scripts/get-helm3.sh && source get-helm3.sh
   ```

2. Install Cert-Manager in your cluster.
   * This script can be used to perform the Cert-Manager install, or to examine the commands required:  https://hclcr.io/files/sofy/scripts/cert-manager-setup.sh.


3. Create a namespace for your solution (optional)
    * Each solution must be installed in a separate namespace. If you install into the default namespace you can omit the --namespace parameters on the remaining commands.
      ```
      kubectl create namespace [name]
      ```


4. Create an image pull secret in the solution namespace
    ```
    kubectl create secret docker-registry [secret-name] --docker-server=hclcr.io --docker-username=[sofy userid] --docker-password=[CLI secret] --namespace=[solution namespace]
    ```
    * To set your Harbor CLI secret, login to hclcr.io with your HCL/SoFy credentials, selecting LOGIN VIA OIDC PROVIDER.  
    * Open your User Profile (in the top right corner, click on the dropdown for your username) and enter a secret string of your choice.  
    * Use this string as the CLI secret in the command shown above.

5. Use Helm to install the solution chart
    
    The solution chart can be downloaded from the SoFy application, on the solution details screen. 
    ```
    helm install [release-name] [file-name] --namespace [solution-namespace] --set global.hclImagePullSecret=[secret-name] --set hclFlexnetURL=[flexnet-url] --set hclFlexnetID=[flexnet-id]
    ```
    Summary of the variables above:
    * **[release-name]** A Helm release name that is not already used
    * **[file-name]** The file name of your downloaded solution
    * **[solution-namespace]** The namespace you are installing your solution into
    * **[secret-name]** The name of your pull secret created in Step #4
    * **[flexnet-url],[flexnet-id]** Your license server information. For more information about these fields see **How to Connect a Solution to a FlexNet License Server** below. If you do not specify these values, some solution contents may not initialize properly or have full function available until you enter your license server information via the Solution Console *Settings* 
    
    You may need to set additional values overrides for the specific contents of your solution, see the documentation for those products and services in the SoFy Catalog.

    If you are using an AWS EKS cluster, add this annotation to the solution's ambassador service so it can receive an external IP:
    ```
    kubectl annotate svc [solution-ambassador-svc] -n [solution-namespace] service.beta.kubernetes.io/aws-load-balancer-internal=0.0.0.0/0
    ```
    **Note:** The process of assigning an external LoadBalancer IP address to the annotated service may take a few minutes.

    ```
    kubectl get cm [releasename]-domain -o yaml
    ```
    The output will be similar to the following. You will need the value of the HOST field:

    ```
    apiVersion: v1
    data:
        HOST: 10.190.16.62.nip.io
        HOST_PROTOCOL: https
    kind: ConfigMap   
    ```

6.  Access the Solution Console

    Once the install has completed and all pods are ready, enter the HOST into this link to access the Solution Console app in your browser: h<span>ttps://sofy-console.[HOST]. You will see some warnings about the certificate used in the solution; it is safe to accept these and proceed to the Solution Console application. Log in to the application with the default User ID (userid) and password: sol-admin and pass.

    The solution console provides information about all parts of the solution, as well as links to the home pages of the included products and services.

    The Tutorial **Installing Solutions: Getting Started with Solutions in a Google Cloud Platform Trial Account Tutorial** provides detail on viewing the status of the install process and various troubleshooting tips.

