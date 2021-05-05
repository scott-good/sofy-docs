---
title: Quick Start - GCP Trial
layout: default
parent: Installing Solutions
nav_order: 1
---

# **Installing Solutions Getting Started with Solutions in a Google Cloud Platform Trial Account Tutorial**

These instructions are designed for those new to Kubernetes, and have simplified steps to:
* Create a trial account in Google Cloud Platform (GCP)
* Create a Kubernetes cluster using Google Kubernetes Environment (GKE), in the GCP Trial Account.
* Prepare the cluster for install of a SoFy Solution.
* Install and access the SoFy Solution in the cluster.


You can install more than one solution in a cluster, if there are sufficient resources, but each solution must be installed in a separate namespace.  The steps shown below will install a solution into the cluster's default namespace.  To repeat the installation with additional solutions, rerun the setup and specify a different namespace,  then install the solution into the new namespace.  

You will need the following to get started:
* A valid credit card. (Google states that you will not be charged for the trial account.)
* A Solution chart downloaded from SoFy to your local file system.  On the Solution detail page, there is a download icon near the top right-hand corner.
* Details of the FlexNet license server that contain your entitlements to run the HCL Software included in your solution.  Alternatively, you can install a solution without these values, and add them later through the Solution Console 'Settings', but some of the software may not be fully functional until that is done.
* Your CLI secret for the HCL docker registry. Instructions to obtain your CLI secret will be provided further down the documentation when it is needed.


**Note:** If you already have a GCP Account, skip to section II.
___
## **I. Create a GCP trial account**
1. Create a Gmail account (unless you want to use an existing account):
   * [Signup](https://accounts.google.com/signup) for a new Gmail account.

2. Create a Google GCP Trial Account: https://cloud.google.com/gcp/
   * Click the **Get started for free** button.
   * Enter the email of existing account or account created earlier.


   **Note:** You will be asked to provide credit card information. Google states that it will not be charged unless you explicitly upgrade from the free trial to a paid account.
   
___
## **II. Sign-in to GCP, create a top-level project and a new Kubernetes cluster**
1. [Login here](https://console.cloud.google.com/kubernetes) to the GCP console using your account information.
    * Once logged in, you should land in the **Kubernetes Engine** > **Cluster** view.
    * You will be prompted to create a project.  

2. Select **Create Project** to build your top-level GCP project.
    *	No organization is required.

3. Select **Create cluster**.
4. On the left-hand side, click on **Cluster basics**.
   * Name your cluster.
   * Use Zonal clusters with the default version of GKE.  

   **Note:** Initially we’d recommend using the static version (requires manual updates) and not the release channel.

5. Next, on the left-hand side, click on **Node Pools**. Then select **default-pool**.
    * By default, the node pool will have 3 nodes. We recommend to modify this to 2 nodes. Select size number of nodes: 2

6. Next, size you nodes according to your solution. Select **Nodes** within the **default-pool**.
   * The Solution Detail page includes estimated resource needs for the solution.
   
7. Select Machine Type
      * For example, for a solution that requires 6 vCPU and 13 GB memory, you could select e2-standard-4 (2 nodes of 4 vCPU, 16 GB memory)

8. Click **Create**. Your cluster should take around 3-5 minutes to be ready.

___
## **III. Connect to your cluster using Google Cloud Shell**
1. In the Kubernetes Clusters view, click **Connect** next to your newly created cluster.

2. Select the button to **Run in Cloud Shell**.

3. After accepting a one-time prompt, the shell will be launched with your first command “gcloud container…” pre-typed. Click **Enter** to execute this command which connects kubectl to your cluster.
     * Verify you are connected to your cluster with the following command that should show more than a dozen Pods already running in in the kube-system namespace in your cluster:

        ```
        kubectl get pods --all-namespaces
        ```
4. The minimum version of Helm for HCL SoFy is documented in **Supported Kubernetes Versions / Cluster requirements and limitations**.  To install a supported version of Helm, please run the following command:

   ```
   wget https://hclcr.io/files/sofy/scripts/get-helm3.sh && source get-helm3.sh
   ```

___
## **IV. Prepare the cluster for running SoFy Solutions**

This step will install Cert-Manager in the cluster, and create an 'image pull secret' in the namespace that allows access to the docker registry where the HCL images are held.

**Use this command in your google cloud shell to download and run the setup script:**
```
   wget https://hclcr.io/files/sofy/scripts/gcp-trial-setup-harbor.sh && source gcp-trial-setup-harbor.sh

```  
* You will be prompted to enter your username and CLI secret. To obtain this, follow the steps below:

    * Log into https://hclcr.io with the **LOGIN VIA OIDC PROVIDER** button. You will use your HCL/SoFy ID credentials.  If you need to create a username in the registry, it is recommended that you use your email address.
    * In the top right corner, click on the dropdown for your username to get to your “User Profile”.
    * From your User Profile you can copy the pre-generated CLI secret, or you can enter a secret of your choice.  We recommend you enter a string that you will remember, to avoid returning to the registry each time you need the CLI secret.  
    * Note: This script does take a few minutes and has a bit of a pause when installing Cert-Manager.  

___
## **V. Install a SoFy solution**
Once the above steps have been completed, all the required prerequisites will be installed. Now you are ready to install a SoFy solution.

**Note:** In the commands below, the --namespace flag is only required if you are not using the default namespace; it is included here to help if you use a non-default namespace.  

1. Upload your solution chart to the Cloud Shell.
   * From the three-dot menu, click **Upload File** and navigate to the chart in your local file system.  

   **Note:** **Upload File** does not overwrite existing files in your cloud shell filesystem, so if you modify your solution and upload a new copy, be sure to delete the old file first.  You can use the 'ls' command to list files and 'rm *filename*' to delete a file.


2. Install your solution as follows:  A helm install requires a release-name, which you can choose. If you don’t specify one you must include the --generate-name flag:

   ```
   helm install {release-name} {solution file name} --set hclFlexnetURL={flexnet-url},hclFlexnetID={flexnet-id} --namespace default
   ```
   **Note:** For this example, we will install a solution using the release name 'my-dx' in the default namespace:

   ```
   helm install my-dx my-solution-0.1.0.tgz --set hclFlexnetURL=https://hclsoftware.compliance.flexnetoperations.com,hclFlexnetID=ABC54HDG67WS --namespace default
   ```
   To configure the 'hclFlexnetURL' and 'hclFlexnetID' value overrides you will need to specify your own license server information.  For more information about these fields see **How to connect a Solution to a Flexnet License Server**. If you do not specify these values, some solution contents may not initialize properly or have full function available until you enter your license server information via the Solution Console 'Settings'.

   Additional value overrides can be added to the helm install command as needed (for example if you have used a non-default name for the image pull secret):

    | Override  | Command Line Argument  |
    |---|---|
    | Custom ImagePullSecret name  | --set global.sofyImagePullSecret={secret-name}  |
    |Any other value overrides | --set {name}={value} |

    Now you can use kubectl or helm commands to manage your deployed solution generated by SoFy.

3. Monitor your solution pods to determine when the installation has completed and the pods are ready.
   ```
   kubectl get pods --namespace default
   ```
   The solution will be ready to access when all pods are in 'Running' or 'Completed' state, and the 'Running' pods are all 'READY'.  For example, the output should be similar to this, where the READY column indicates when the running pods are ready to use.  Pods that have completed are used to initialize other services and will not be in ready state:

   ```
   NAME                                                READY   STATUS      RESTARTS   AGE
   gcp1-access-control-service-5759f5fdbd-srd4j        1/1     Running     0          74m
   gcp1-acs-kc-postgresql-0                            1/1     Running     0          74m
   gcp1-alexgcp1-kube-state-metrics-6d775b968b-kksjj   1/1     Running     0          74m
   gcp1-ambassador-88b456cbd-l7vph                     1/1     Running     0          74m
   gcp1-ambassador-88b456cbd-lj94l                     1/1     Running     0          74m
   gcp1-ambassador-88b456cbd-z2g6f                     1/1     Running     0          74m
   gcp1-anchor-657c5c5569-zq5c7                        1/1     Running     0          74m
   gcp1-grafana-769b8f7bb4-cck27                       2/2     Running     0          74m
   gcp1-grafana-job-jxjqw                              0/1     Completed   1          74m
   gcp1-keycloak-0                                     1/1     Running     0          74m
   gcp1-openldap-5f5866945b-ng6ft                      1/1     Running     0          74m
   gcp1-product-design-mongo-bdf84fb6f-fdv62           1/1     Running     0          74m
   gcp1-product-design-redis-master-0                  1/1     Running     0          74m
   gcp1-product-designer-client-5dc979df4f-2bwqk       1/1     Running     0          74m
   gcp1-product-designer-server-7f5b59f4f4-bfllh       1/1     Running     0          74m
   gcp1-product-runtime-c4d66cc54-qjhqf                1/1     Running     1          74m
   gcp1-prometheus-server-757bd5c746-fq7t4             2/2     Running     0          74m
   gcp1-snoop-788f87594f-mkvz4                         1/1     Running     0          74m
   gcp1-sofy-console-d66cf776c-494xc                   1/1     Running     0          74m
   gcp1-solution-controller-7c8bcfd59f-cktvq           1/1     Running     0          74m
   ```

   If you see pods with a status of ErrImagePull or ImagePullBackOff, check that you are installing to the correct namespace.

   If the pods seem to remain in Pending status for a long time, there may not be sufficient resources in the cluster.  You can use the GCP dashboard to examine cluster resources, or run this command to query a specific pod:

   ```
   kubectl describe pods {pod name} --namespace default
   ```
   The last line of the output gives a useful diagnosis of the problem, for example:
   ```
   Warning  FailedScheduling  40s (x24 over 28m)  default-scheduler  0/2 nodes are available: 2 Insufficient memory.
   ```

4. Once the pods are ready, find the external IP for the solution, which will be assigned to the ambassador service:

   ```
   kubectl get svc {release-name}-ambassador --namespace default
   ```
   The output should be similar to this:

   ```
    NAME                 TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                                                                                                      
                                                                                                                                                                 AGE
   gcpprod-ambassador   LoadBalancer   10.48.1.192   35.226.228.226   80:31299/TCP,443:31379/TCP,2222:30537/TCP,31116:32031/TCP,3030:31394/TCP,3031:31525/TCP,3032:31565/TCP,3033:3
   0959/TCP,3034:32123/TCP,3035:31855/TCP,3036:30515/TCP,3037:31103/TCP,3038:32227/TCP,3039:31334/TCP,3040:32044/TCP,3041:32125/TCP,3042:30903/TCP,3043:31559/TCP   17m

   ```
   The external IP in the above example is 35.226.228.226.

   Enter the EXTERNAL-IP into this link to access the Solution Console app in your browser: https://sofy-console.EXTERNAL-IP.nip.io/ . You will see some warnings about the certificate used in the solution; it is safe to accept these and proceed to the Solution Console application. Log in to the application with the default userid and password:  **sol-admin** and **pass**.

   The solution console provides information about all parts of the solution, as well as links to the home pages of the included products and services.

5.  When you are finished with your solution, you can uninstall it with this command:
      ```
      helm delete {release-name} --namespace default
      ```

      Be aware that the trial credit in your account will be used for resources assigned to the cluster, even if there is nothing running in it.  If you don't plan to use your cluster for a while, you may consider deleting it and then recreating when you need it again.
___
## **VI. Security of your GCP Cluster**
GKE is not secure by default. Any resources with an External IP in your new cluster will be accessible. There are a few important things you should do to lock down your cluster:

**Create Master Authorized Network for your Cluster**
1.	Navigate to **Kubernetes Engine** > **Clusters**
2.	Edit your cluster and set Master authorized networks to “Enabled”. This will ensure that your cluster API can only be accessed by GCP (in your Cloud Shell). If you want to use a local kubectl to connect to your cluster, you can add your own IP address as well (e.g 1.2.3.4/32)

**Create a Firewall Rule for your Cluster**
1.	Navigate to your GCP account Firewall rules page.
2.	Lock down your Firewall rules and stay on top of them
    * GCP creates some wide open firewall rules allowing ssh and other protocols to your GCP resources.  The allowed client IP addresses are set to “0.0.0.0/0” which effectively means open to the internet.  We will show you how to delete those below.
    * Also when deploying “LoadBalancer” services in GKE, you will get a public IP address for the service and firewall rules will be automatically created letting the internet get to the service’s exposed ports. To address this:
       * First create a firewall rule to allow your IP address to access everything:
          * **VPC network** > **Firewall rules** > **Create Firewall Rule**:
             * **Name:** let-me-in (or whatever name you like)
             * **Targets:** All instances in the network
             * **Source IP ranges:** {your IP}/32.  For example 1.2.3.4/32
             * **Protocols and ports:** “Allow all”
3.	Regularly review your firewall rules and delete any that have 0.0.0.0/0 in the IP Range.  Here is one-liner that will do that:

    ```
    gcloud compute firewall-rules list --format="table(name,sourceRanges.list():label=SRC_RANGES)" |grep "0.0.0.0/0" | grep -Eo '^[^ ]+' | while read line; do gcloud compute firewall-rules delete $line; done
    ```
