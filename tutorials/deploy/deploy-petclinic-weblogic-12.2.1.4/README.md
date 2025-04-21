# Deploy Spring Framework PetClinic to WebLogic Server 12.2.1.4
This tutorial demonstrates how to deploy the [Spring Framework PetClinic](https://github.com/spring-petclinic/spring-framework-petclinic/tree/5.3.x) example application to WebLogic Server 12.2.1.4 running on an Oracle Linux host. For a containerized deployment, see [Deploy Spring Framework PetClinic to WLS 14.1.2 running in a container](../../deploy/petclinic-container-14.1.2/README.md).

> [!TIP]
> If you want to deploy the example application to WebLogic Server 15.1.1 (BETA), first follow the [Migrate Spring Framework PetClinic to WLS 15.1.1(BETA)](../../migrate/spring-framework-petclinic-15.1.1/README.md) tutorial, then follow the procedure here.


# Spring PetClinic Sample Application

The Spring Framework PetClinic application is a fork of the [spring-projects/spring-framework-petclinic](https://github.com/spring-petclinic/spring-framework-petclinic/tree/5.3.x) repo.

This version is for the **Oracle WebLogic community** to deploy a Spring-based application on a specific **WebLogic Domain** release.
The example follows the same **3-layer architecture** (i.e. presentation --> service --> repository) included in the `spring-framework-petclinic` version.

## Prerequisites

Before starting this tutorial, make sure you have the following:
- [WebLogic Server 12.2.1.4](https://www.oracle.com/middleware/technologies/weblogic-server-installers-downloads.html) installed on a Virtual Machine or physical server.
- A WebLogic Domain created.

## Spring Framework PetClinic example

This tutorial deploys an approved Spring Framework 5.3.x  [fork](https://github.com/spring-petclinic/spring-framework-petclinic/tree/5.3.x) from the Spring Team, a PetClinic version with a plain Spring Framework 5.3.x configuration and with a 3-layer architecture (i.e. presentation --> service --> repository) updated to run on WebLogic 12.2.1.4

![Spring Framework PetClinic](https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png)

## Steps

### Step 1: Clone the `weblogic-examples` repo with the Spring Framework PetClinic tutorial

1. Clone the `weblogic-examples` repo:

    ```shell
    git clone https://github.com/oracle-samples/weblogic-examples.git
    ```

2. Go to the `deploy-petclinic-weblogic-12.2.1.4` tutorial folder:

    ```shell
    cd weblogic-examples/tutorials/deploy/deploy-petclinic-weblogic-12.2.1.4
    ls -a
     total 24
    -rwxrwxr-x. 1 opc opc  5002 Mar 18 05:54 init_petclinic.sh
    -rw-rw-r--. 1 opc opc 10196 Mar 18 06:08 README.md    
    -rw-rw-r--. 1 opc opc  1166 Mar 18 00:50 weblogic.xml
    ```


### Step 2: Update the `Spring Framework PetClinic 5.3.x` fork with WebLogic dependencies

This step runs the `init_petclinic.sh` script to clone the 5.3.x branch from the Spring Framework Repository and update it with WebLogic dependencies.

```shell
    bash init_petclinic.sh
```
Example output after WebLogic dependencies have been added.

   ```shell
        Cloning into './spc-b_5_3_x'...
        remote: Enumerating objects: 6172, done.
        remote: Counting objects: 100% (824/824), done.
        remote: Compressing objects: 100% (48/48), done.
        remote: Total 6172 (delta 790), reused 776 (delta 776), pack-reused 5348 (from 1)
        Receiving objects: 100% (6172/6172), 1.30 MiB | 37.05 MiB/s, done.
        Resolving deltas: 100% (3042/3042), done.
        Weblogic.xml added...
        layout.tag updated...
        localDate.tag updated...
        default handler set in Spring Framework config...
        DONE updating Spring Petclinic Framework branch 5.3.x
        Exiting...
   ```

### Step 4: Build the WAR file

> [!IMPORTANT]
> This command is skipping the tests to speed up the build process. If you want to run the tests, you may need to migrate the test packages to versions supported by Java 17 or 21. After that, you can run the tests by removing the `-DskipTests` option.

1. Build the Spring Framework PetClinic example:

    ```shell
    cd spc-b_5_3_x   #or directory name for cloned Spring Framework PetClinic repository
    mvn clean package -DskipTests
    ```

1. Locate the WAR file in the `target` folder:

    ```shell
    ls target/petclinic.war
    ```

### Step 5: Deploy the Spring Framework PetClinic example

Use any of the following deployment tools for deploying the PetClinic application to a WebLogic domain.

#### WebLogic Remote Console

You can use the [WebLogic Remote Console](https://docs.oracle.com/en/middleware/fusion-middleware/weblogic-remote-console/administer/set-console.html) to manage the deployment process of applications to WebLogic Server. For more information, see [Deploying Applications](https://docs-uat.us.oracle.com/en/middleware/fusion-middleware/weblogic-remote-console/administer/deploying-applications.html) in the _Oracle WebLogic Remote Console Online Help_.

For general information about the application deployment process, see [Understanding WebLogic Server Deployment](https://docs.oracle.com/en/middleware/fusion-middleware/weblogic-server/12.2.1.4/depgd/understanding.html) in _Deploying Applications to Oracle WebLogic Server_.

Installing an application makes its physical file or directory known to WebLogic Server.

This procedure applies to all of the deployment units listed in [Supported Deployment Units](https://docs.oracle.com/en/middleware/fusion-middleware/weblogic-server/12.2.1.4/depgd/understanding.html#GUID-DC6C0B59-7560-4A6F-964B-201480072A3D).

1. In the Edit Tree, go to Deployments, then App Deployments.

1. Select New.

1. Enter a name for the application.

1. Select the servers and clusters to which you want to deploy the application.

1. Make the archive file or exploded directory known to the Administration Server.
      -  If the application is on your file system and you need to upload it to the Administration Server, enable the Upload option. Then, beside Source, click Choose File to browse to the application’s location on your system.
      -  If the application is already in the file system of the Administration Server, disable the Upload option. Then, in the Source Path field, enter the file path to the application.

1. Add a deployment plan, choose another staging mode, or set application behavior at deployment.

1. Click Create.

You can view the status of running deployment tasks on the **Monitoring Tree: Deployments: Deployment Tasks** page.

Your new application appears under the App Deployment node. You can make additional changes to the application on this page.

You must start an application before it can process client requests.

#### WebLogic Maven plug-in
WebLogic Server provides support for Maven through the provisioning of plug-ins that enable you to perform various operations on WebLogic Server from within a Maven environment.  For more information, see [Using the WebLogic Maven Plug-In for Deployment](https://docs.oracle.com/en/middleware/fusion-middleware/weblogic-server/12.2.1.4/depgd/maven_deployer.html).

```bash
./mvnw com.oracle.weblogic:weblogic-maven-plugin:deploy -Dsource=target/petclinic.war -Duser=<WebLogic Admin User> -Dpassword=<WebLogic Password>
```

#### weblogic.Deployer

In order to deploy an application or module to a domain, the deployment file(s) must be accessible to the domain's Administration Server. If the files do not reside on the Administration Server machine or are not available to the Administration Server machine via a network mounted directory, use the `-upload` option to upload the files before deploying them.  For more information, see [Deploying Applications and Modules with weblogic.Deployer](https://docs.oracle.com/en/middleware/fusion-middleware/weblogic-server/12.2.1.4/depgd/deploy.html).

```bash
java weblogic.Deployer -adminurl http://<AdminServer IP>:<Port, defaults to 7001> -username <WebLogic Admin User>
   -password password=<WebLogic Password> -deploy -upload target/petclinic.war
```

#### WebLogic Server Administration Console
Oracle WebLogic Server Administration Console is a Web browser-based, graphical user interface that you use to manage an Oracle WebLogic Server domain. It is accessible from any supported Web browser with network access to the Administration Server.

In the left pane of the WebLogic Server Administration Console and select **Deployments**. For more information, see [Deploy and configure resources](https://docs.oracle.com/en/middleware/fusion-middleware/weblogic-server/12.2.1.4/wlach/core/index.html) in the _Administration Console Online Help_.

After deploying, you can access the PetClinic application here: [`http://AdminServerIP:7001/`](http://localhost:8080/).


### Step 6: Access the Spring Framework PetClinic example

Access the Spring Framework PetClinic example application using the WebLogic Server port.

Open a browser and go to:

  ```shell
  http://localhost:7001/petclinic
  ```

# Code Changes

The following code changes where introduced from `spring-framework-petclinic`:
  * Removed trimDirectiveWhitespaces="true" from tag files under [tag](src/main/webapp/WEB-INF/tags/)
  * [WebLogic descriptor](src/main/webapp/WEB-INF/weblogic.xml) added.  
  * Removed Jetty deployment descriptor
  * [JSTL Tag descriptor](src/main/webapp/WEB-INF/petclinic.tld) added.
  * Modified mvc-core-config.xml to include the handler servlet name
    <mvc:default-servlet-handler default-servlet-name="default">.
  * Maven [Pom file](pom.xml) modified to update dependencies.
  * mvnw wrapper removed.


# License

Copyright (c) 2025 Oracle and/or its affiliates.

Released under the Universal Permissive License v1.0 as shown at https://oss.oracle.com/licenses/upl/.


# Release Notes
##  Known Issues
*  Building PetClinic WAR file using JDK 17 or JDK 21 leads to:
   ```shell
        ...Caused by: java.lang.IllegalArgumentException: Unsupported class file major version 67
        at org.jacoco.agent.rt.internal_f3994fa.asm.ClassReader.<init>(ClassReader.java:196)
        at org.jacoco.agent.rt.internal_f3994fa.asm.ClassReader.<init>(ClassReader.java:177)
        at org.jacoco.agent.rt.internal_f3994fa.asm.ClassReader.<init>(ClassReader.java:163)
        at
    ```
* PetClinic menu bar displays label "ERROR".
  This is an expected Petclinic application feature to test how Spring Framework handle errors.
  Also, the center pane will display the following message :
  ```"Expected: controller used to showcase what happens when an exxception is thrown"```.
