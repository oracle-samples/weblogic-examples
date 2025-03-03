<!--
  The code contain in this repository is a fork from https://github.com/spring-projects/spring-framework-petclinic

  The following changes were introduced in this version:
  * Removed trimDirectiveWhitespaces="true" from tag files under webapp/WEB-INF/tags/*.tag
  * Added a WebLogic Descriptor.  weblogic.xml
  * Removed jetty deployment descriptor
  * Added JSTL Tag definition petclinic.tld
  * Modified mvc-core-config.xml to include the handler servlet name
    <mvc:default-servlet-handler default-servlet-name="default"
  * Modifed POM.xml file to include updated dependencies.
  * Removed mvnw for Windows.   
 -->

# Spring PetClinic Sample Application

This repo is a fork of the [spring-projects/spring-framework-petclinic](https://github.com/spring-petclinic/spring-framework-petclinic/tree/5.3.x) repo.

This version is for the **Oracle WebLogic community** to deploy a Spring-based application on a specific **WebLogic Domain** release.
The example follows the same **3-layer architecture** (i.e. presentation --> service --> repository) included in the `spring-framework-petclinic` version.

<!--
## Understanding the Spring PetClinic application with a few diagrams

[ TODO: Update with Diagrams ]
 -->

## Running PetClinic

### Build the Web Application Archive (WAR) file
```bash
git clone https://github.com/oracle-samples/weblogic-examples.git
cd weblogic-examples/12_2_1_4/spring-petclinic
./mvnw clean package
```

### Deploy to a WebLogic domain

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


## Database configuration

In its default configuration, PetClinic uses an in-memory database (H2) which gets populated at startup with data.


## Working with PetClinic in your IDE

### Prerequisites
The following items should be installed in your system:
* Java 8 or JDK 11 (full JDK not a JRE)
* Maven 3.3+ (http://maven.apache.org/install.html)
* git command line tool (https://help.github.com/articles/set-up-git)
* WebLogic 12.2.1.4
* Your preferred IDE
  * Eclipse with the m2e plugin. **Note**: When m2e is available, there is an m2 icon in the Help -> About dialog. If m2e is not there, just follow the installation process here: http://www.eclipse.org/m2e/
  * [Spring Tools Suite](https://spring.io/tools) (STS)
  * IntelliJ IDEA


### Steps

1) On the command line:

    ```bash
    git clone https://github.com/oracle-samples/weblogic-examples.git
    cd weblogic-examples/12_2_1_4/spring-petclinic

    ```

1) Inside Eclipse or STS:

    ```
    File -> Import -> Maven -> Existing Maven project
    ```
    Then, either build on the command line `./mvnw generate-resources` or use the Eclipse launcher (right-click on the project and then, `Run As -> Maven install`) to generate the CSS.
    Configure an Oracle WebLogic domain, then deploy the `petclinic.war` file.

1) Inside IntelliJ IDEA:

    In the main menu, select `File > Open` and select the PetClinic [`pom.xml`](pom.xml) file. Click the `Open` button.

    CSS files are generated from the Maven build. You can either build them on the command line `./mvnw generate-resources`
    or right click on the `wls-spring-petclinic` project, then `Maven -> Generates sources and Update Folders`.

    Go to the `Run -> Edit Configuration` then configure a WebLogic Server instance. Deploy the `petclinic.war` file.
    Run the application by clicking the `Run` icon.

1) Navigate to PetClinic:

    Open [`http://localhost:8080`](http://localhost:8080) in your browser.

## Working with PetClinic in IntelliJ IDEA

### Prerequisites
The following items should be installed in your system.


## Looking for something in particular?

| Java Config |   |
|-------------|---|
| Java config branch | PetClinic uses XML configuration by default. If you'd like to use Java Config instead, there is a Java Config branch available [here](https://github.com/spring-petclinic/spring-framework-petclinic/tree/javaconfig). |

| Inside the 'Web' layer | Files |
|------------------------|-------|
| Spring MVC - XML integration | [mvc-view-config.xml](src/main/resources/spring/mvc-view-config.xml)  |
| Spring MVC - ContentNegotiatingViewResolver| [mvc-view-config.xml](src/main/resources/spring/mvc-view-config.xml) |
| JSP custom tags | [WEB-INF/tags](src/main/webapp/WEB-INF/tags), [createOrUpdateOwnerForm.jsp](src/main/webapp/WEB-INF/jsp/owners/createOrUpdateOwnerForm.jsp)|
| JavaScript dependencies | [JavaScript libraries are declared as webjars in the pom.xml](pom.xml) |
| Static resources config | [Resource mapping in Spring configuration](/src/main/resources/spring/mvc-core-config.xml#L30) |
| Static resources usage | [htmlHeader.tag](src/main/webapp/WEB-INF/tags/htmlHeader.tag), [footer.tag](src/main/webapp/WEB-INF/tags/footer.tag) |
| Thymeleaf | In the late 2016, the original [Spring Petclinic](https://github.com/spring-projects/spring-petclinic) has moved from JSP to Thymeleaf. |

| 'Service' and 'Repository' layers | Files |
|-----------------------------------|-------|
| Transactions | [business-config.xml](src/main/resources/spring/business-config.xml), [ClinicServiceImpl.java](src/main/java/org/springframework/samples/petclinic/service/ClinicServiceImpl.java) |
| Cache | [tools-config.xml](src/main/resources/spring/tools-config.xml), [ClinicServiceImpl.java](src/main/java/org/springframework/samples/petclinic/service/ClinicServiceImpl.java) |
| Bean Profiles | [business-config.xml](src/main/resources/spring/business-config.xml), [ClinicServiceJdbcTests.java](src/test/java/org/springframework/samples/petclinic/service/ClinicServiceJdbcTests.java), [PetclinicInitializer.java](src/main/java/org/springframework/samples/petclinic/PetclinicInitializer.java) |
| JDBC | [business-config.xml](src/main/resources/spring/business-config.xml), [jdbc folder](src/main/java/org/springframework/samples/petclinic/repository/jdbc) |
| JPA | [business-config.xml](src/main/resources/spring/business-config.xml), [jpa folder](src/main/java/org/springframework/samples/petclinic/repository/jpa) |
| Spring Data JPA | [business-config.xml](src/main/resources/spring/business-config.xml), [springdatajpa folder](src/main/java/org/springframework/samples/petclinic/repository/springdatajpa) |


# Contributing

The [issue tracker](/issues) is the preferred channel for bug reports, features requests and submitting pull requests.

For pull requests, editor preferences are available in the [editor config](.editorconfig) for easy use in common text editors. Read more and download plugins at <http://editorconfig.org>.

In case you find a bug suggested improvement for Spring Petclinic for WebLogic

Our issue tracker is available here: https://github.com/oracle-samples/weblogic-examples/issues

# Attribution

This repo is a fork of the [spring-projects/spring-framework-petclinic](https://github.com/spring-projects/spring-framework-petclinic) example, licensed under the Apache License 2.0. [License](LICENSE.txt) for spring-framework-petclinic is included in this repository.

# Code Changes

The following code changes where introduced from `spring-framework-petclinic`:
  * Removed trimDirectiveWhitespaces="true" from tag files under [tag](src/main/webapp/WEB-INF/tags/)
  * [WebLogic descriptor](src/main/webapp/WEB-INF/weblogic.xml) added.  
  * Removed jetty deployment descriptor
  * [JSTL Tag descriptor](src/main/webapp/WEB-INF/petclinic.tld) added.
  * Modified mvc-core-config.xml to include the handler servlet name
    <mvc:default-servlet-handler default-servlet-name="default">.
  * [Maven Pom](pom.xml)file modified to update dependencies.
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
