---
title: FlexNet Licensing
layout: default
parent: Kubernetes Administration
grand_parent: Installing Solutions
nav_order: 3
---
# **How to Connect a Solution to a FlexNet License Server**

## **FlexNet Licensing Overview**

HCL Software is protected by runtime license checks performed against a license server, which runs as an external process. Multiple HCL Software products can perform checks against the same license server. A separate license server is provided for each customer account, containing the product license entitlements for that account. The license server technology is called FlexNet Embedded. License servers are generally hosted in the cloud and accessed over the public network; these are termed Cloud License Servers. Some products allow the option of running the license server within a private network; these are termed Local License Servers. In both cases, the license server is populated with the purchased product entitlements, and the installed HCL Software products are configured to make calls to that license server to validate the required entitlement.

## **FlexNet Licensing in SoFy**
When HCL Software products are run in a SoFy Solution, the license server information can be set centrally for the solution and it will then be used by all the products in the solution. The Solution Console can be used to view the entitlement information held by that license server and will display a warning if the solution includes a product for which the license server does not include an entitlement.

When you install a solution into your own environment, you must provide your FlexNet License Server URL and FlexNet License Server ID, so that the solution can connect to the license server.  

## **How to Determine your hclFlexnetURL and hclFlexnetID**
Your FlexNet information should be obtained from your organization's license administrator. The hclFlexnetID will be unique to your organization. If your organization uses a CLS (Cloud License Server), the hclFlexnetURL will in most cases be: 

```
hclFlexnetURL=https://hclsoftware.compliance.flexnetoperations.com
```

If you have administrative rights to the [FlexNet Operations Portal](https://hclsoftware.flexnetoperations.com/flexnet/operationsportal) then you can retrieve the ID for your existing Cloud License Server(s) in **Devices** view. You may also use the **Devices** view to create new Cloud License Server(s) and manage the entitlements mapped to a given Cloud License Server.  

If your organization uses a locally installed license server, the URL will include a domain specific to your organization or an IP address and port typically in the 27000-27009 range.

**There are two ways you can set the license server information in a solution:**
*  When installing the solution, use override to the hclFlexnetURL and hclFlexnetID properties, for example:

    ```
    helm install my-release-name my-solution.tgz --set hclFlexnetURL=https://hclsoftware.compliance.flexnetoperations.com --set hclFlexnetID=ABCD1235654543 --set global.hclImagePullSecret=my-sofy-secret
    ```
*  After installing the solution, using the Solution Console:
    1. Within the Solution Console, click on the **Gear** icon and select **Manage License Server**
    2. Provide your FlexNet License Server URL and FlexNet Server ID
    3. Click **Apply** and your license will be applied

Note that some product services may not initialize until the license server has been configured and may require a restart to connect to the license server. This can be achieved by deleting the relevant pod, which can be done through the *Pods* view in the Solution Console.

Both methods will allow you to view and change the current settings through the Solution Console, and to view the license entitlements in the license server.
___


## **Working with Multiple License Servers**

If your license entitlement for one product is in a different license server, you can configure that product to send requests directly to your other license server by setting the same properties on that service. For example, if your HCL Informix entitlements are in a separate license server, specify it as below:


```
helm install my-release-name my-solution.tgz --set hclFlexnetURL=[license server URL] --set hclFlexnetID=[license server ID] --set informix.hclFlexnetURL=[informix license server URL] --set informix.hclFlexnetID=[informix license server ID] --set global.hclImagePullSecret=secret-name
```

Information for that license server will not be displayed by the Solution Console, and any warning about missing license entitlements for that product can be ignored.
