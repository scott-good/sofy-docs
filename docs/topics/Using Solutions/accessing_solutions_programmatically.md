---
title: Accessing Programmatically
layout: default
parent: Using Solutions
nav_order: 3
---
# **Accessing Solutions Programmatically**

Many of the SoFy Catalog services in a solution contain REST APIs, which are simple to use in client applications. The code examples shown below are written in Java, using the HTTP Client that was new in Java version 11 (java.net.http.HttpClient), but with REST you can choose from many programming languages and REST libraries for your application.

## Discovering REST API Documentation for SoFy Catalog Services

There are two ways to discover the REST APIs provided by SoFy Catalog services and products. Both rely on the API being documented using the Swagger v2 or OpenAPI v3 standard:

* **SoFy Catalog**
	* Click on a catalog card to view its documentation. The *API Documentation* tab will contain available REST API documentation. 
In the catalog, this is simply a rendering of the documentation; there is no live instance of the service available, so the REST API method cannot be run in this environment. The documentation is provided as reference for your application coding.


* **Swagger UIs in Deployed Solutions**
	* In some cases, a live Swagger or OpenAPI UI is available within a service or product once it is deployed in an installed solution. Links to these UIs are shown in the Solution Console in the *General Information* for each entry, under the *API Explorer* tag. 

## Discovering REST API Base URLs in Deployed Solutions

REST API base URLs are displayed in the Solution Console, in the *General Information* for each entry, under the *API BASE* tag.

## Handling Self-Signed Certificates

By default, SoFy generates a self-signed SSL/TLS certificate for each solution. For production use, it is recommended that you override this with a certificate generated for your own domain name. In development, you may choose to operate with the provided certificate.  

In Java applications, one approach to self-signed certificates is to override the default trust manager with one that does not validate certificate chains:
 ```
import java.net.http.HttpClient;
import java.security.GeneralSecurityException;
import java.security.cert.X509Certificate;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

...

		// Create a trust manager that does not validate certificate chains
		TrustManager[] trustAllCerts = new TrustManager[] {
				new X509TrustManager() {     
					public java.security.cert.X509Certificate[] getAcceptedIssuers() {
						return new X509Certificate[0];
					}
					public void checkClientTrusted(
							java.security.cert.X509Certificate[] certs, String authType) {
					}
					public void checkServerTrusted(
							java.security.cert.X509Certificate[] certs, String authType) {
					}
				}
		};

		// Create the all-trusting trust manager
		SSLContext sc = null;
		try {
			sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new java.security.SecureRandom());
		} catch (GeneralSecurityException e) {
		}

		// Also need to tell the client to not compare request host names with the certificate content
		final Properties props = System.getProperties();
		props.setProperty("jdk.internal.httpclient.disableHostnameVerification", Boolean.TRUE.toString());

		// set the all-trusting trust manager on the client builder
		HttpClient.Builder builder = HttpClient.newBuilder();
		builder.sslContext(sc);

		// Create HTTP Client to send requests to solution services
		HttpClient sol_client = builder
				.version(Version.HTTP_1_1)
				.build();

```

## Authenticate to Obtain a JSON Web Token (JWT)
If the Access Control Service (ACS) is included in the solution, you first need to authenticate to ACS and then receive a JWT to include on any subsequent API call. Authentication is achieved through a GET request to the *h<span>ttps://sofy-auth.{external.ip}.nip.io/login* endpoint using the HTTP Basic authentication protocol.

There are two User IDs (userids) that are created for every solution and you can add more User IDs if you wish.

| Userid			| Default password			| Access |
| ----------- | ----------- | ----------- |
| user				| pass						| catalog services |
| sol-admin			| pass						| all services (including Solution Console)|

To access Solution Console, use the *sol-admin* administrator id.

The User ID (userid) and password must be Base64 encoded and included in the **Authorization** HTTP header, as shown in the example below:

```
		String idpw = "user:pass";
		String encodedString = Base64.getEncoder().encodeToString(idpw.getBytes());
		// replace with your own solution's external ip address
		ext_ip = "34.67.88.109.nip.io";

		HttpResponse response = null;
		try {
			String url = "https://sofy-auth." + ext_ip + "/login";

			HttpRequest request = HttpRequest.newBuilder()
					.uri(URI.create(url))
					.GET()
					.timeout(Duration.ofSeconds(150))
					.header("accept", "application/json")
					.header("Authorization", "Basic "+encodedString)
					.build();

			// Send a request using the HTTPClient that was created with the all-trusting trust manager
			response = sol_client.send(request, BodyHandlers.ofString());

			switch (response.statusCode()) {
			case (200):
			    // Success - extract JWT from Auth header and save it for future requests
			    HttpHeaders headers = response.headers();
			    List<String> auths = headers.allValues("Authorization");
			    // Header requires 'Bearer' before actual token value
			    token = "Bearer "+(String)response.body();
				// You may want to persist the token at this point   					    
			    break;
			case (404):
				System.out.println("sofy-auth login not found, perhaps ACS not included in this solution");
				break;
			case (500):
				// Workaround: ACS may take a short time to complete initialization
				System.out.println("sofy-auth login returned 500, will retry once after a short pause");
				Thread.sleep(60000);
				loginToSolution(idpw, soldomain);
				break;
			default:
				System.out.println("sofy-auth login failed: "+response.statusCode());
				System.out.println(response.body());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}

```

The JWT will be valid for 5 minutes and then will expire, after which re-authentication will be necessary. If you wish to query the expiry time of the token, the code below shows how to do that using the Auth0 java-jwt library.  

```
import com.auth0.jwt.JWT;
import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.interfaces.DecodedJWT;
...
        DecodedJWT jwt = null;
	    String jwtString = token.replace("Bearer ","");

	    try {	    			
	    	jwt = JWT.decode(jwtString);

	    	Date expiryTime = jwt.getExpiresAt();
	    	Date now = new Date();
	    	System.out.println("token expires at: "+expiryTime);
	    	System.out.println("time now is: "+now);
	    	tokenExpired = now.after(expiryTime);
	    	if (tokenExpired)
	    		 System.out.println("Token for solution access is already expired - expect 401/403 the re-authentication");
	    		 // Could choose to re-login here, but an unexpired token may still expire between this point and the next API call	    	
	    	} catch (JWTDecodeException exception){
	    		 System.out.println("JWT decode failed for token: "+jwtString);
	    		 exception.printStackTrace();
	    	}

```
## Call the Catalog Service REST API

Once you have the URL for the REST method you want to call, an HTTP client that will handle self-signed certificates (unless you have applied your own domain/certificate), and the authorization token (if ACS is used in your solution), then you are ready to make a call to a catalog service REST API.

There are a couple of workarounds shown in the example below, with a counter to limit the retry attempts.
```
	private static void callApi() {
		HttpResponse response = null;
		apiCallCounter++;

		if (apiCallCounter > apiCallRetryLimit) {
			System.out.println("Reached max attempts to call solution REST API, giving up");
			return;
		}
		boolean tokenExpired = false;

		try {
			String url = "https://test-data-synth." + ext_ip + "/datasynth/1.0/data/ccVisa?count=5";

			HttpRequest.Builder builder = HttpRequest.newBuilder();
			if (acs) {
				builder.header("Authorization", token);  // be careful not to add null token (-> NPE)
			HttpRequest request = builder
					.uri(URI.create(url))
					.GET()
					.timeout(Duration.ofSeconds(90))
					.header("accept", "application/json")
					.build();

			response =
					sol_client.send(request, BodyHandlers.ofString());
			switch (response.statusCode()) {
			case (200):
				System.out.println("tds GET returned 200");
				JSONArray testDataJson = new JSONArray((String)response.body());
				System.out.println(testDataJson.toString(4));
				break;
			case (307):
				System.out.println("*** RC 307 Redirect - suggests protected method was called without auth header data");
				break;
			case (401):
			case (403):
				System.out.println("*** Authentication/Authorization issue, RC: "+response.statusCode());
				System.out.println("May be token expiry, re-authenticate (once) and retry");
				// call method with login logic shown above
				loginToSolution("user:pass", ext_ip);
				apiCallCounter = apiCallRetryLimit -1;
				callApi();
				break;
			case (404):
				System.out.println("*** 404: tds records not found... service may not be included or not running");
				break;
			case (503):
				System.out.println("*** 503 returned - wait 5 seconds then try again");
				Thread.sleep(5000);
				callApi();
			break;
			default:
				System.out.println("*** tds home access failed: "+response.statusCode());
				System.out.println("response body: "+response.body());
				System.out.println("response headers:: "+response.headers());
			}

		}catch(Exception e) {
			e.printStackTrace();
		}
	}
```
