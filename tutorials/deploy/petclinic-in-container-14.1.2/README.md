# Deploy Spring Framework 5.3.x PetClinic to WLS 14.1.2 running in a container

This tutorial demonstrates how to deploy the [Spring Framework 5.3.x PetClinic](https://github.com/spring-petclinic/spring-framework-petclinic/tree/5.3.x) example application on WebLogic Server 14.1.2 running in a container (Docker or Podman, or other container preference).

> [!TIP]
> If you want to deploy the example application to WebLogic Server 15.1.1 (BETA), first follow the [Migrate Spring Framework PetClinic to WLS 15.1.1(BETA)](../../migrate/spring-framework-petclinic-15.1.1/README.md) tutorial, then follow the procedure here.

## Prerequisites

Before starting this tutorial, make sure you have the following:

- [Docker](https://docs.docker.com/get-docker/) or [Podman](https://podman.io/getting-started/installation) installed.
- Access to [Oracle WebLogic Server 14.1.2.0 Container Images](https://container-registry.oracle.com/ords/ocr/ba/middleware/weblogic) or have the [WebLogic Server 14.1.2](https://www.oracle.com/middleware/technologies/weblogic-server-installers-downloads.html) image available in your local repository.
- Java 17 or newer (full JDK not a JRE) installed. (To build and package the example application)
- [Maven 3.5+](https://maven.apache.org/install.html) installed. (To build and package the example application)
- [`git`](https://help.github.com/articles/set-up-git) command line tool installed. (To get the example application)

## Spring Framework PetClinic example

We'll step through this tutorial using the Spring Framework 5.3.x Pet Clinic example that is available [here](https://github.com/spring-petclinic/spring-framework-petclinic/tree/5.3.x) from the Spring Team, a PetClinic version with a plain old Spring Framework 5.3.x configuration and with a 3-layer architecture (i.e. presentation --> service --> repository).

![Spring Framework PetClinic](https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png)

## Steps

Follow these steps to deploy the Spring Framework 5.3.x PetClinic example on WebLogic Server 14.1.2 running in a container.

### Step 1: Pull the WebLogic Server 14.1.2 image

Make sure you have a WebLogic Server 14.1.2 container running. You can use Docker or Podman to run the container.

> [!NOTE]
> This image is the base image running with JDK 21 on Oracle Linux 9. You can use any variant of the image that suits your environment or tests.

<details open>

<summary>Using Docker</summary>

Pull the WebLogic Server 14.1.2 image from the Oracle Container Registry.

  If you haven't already done so, log in to the Oracle Container Registry[^ocrlogin]:

  ```shell
  docker login container-registry.oracle.com
  ```

  Pull the WebLogic Server 14.1.2 image:

  ```shell
  docker pull docker pull container-registry.oracle.com/middleware/weblogic:14.1.2.0-generic-jdk21-ol9
  ```
</details>

<details>

<summary>Using Podman</summary>

Pull the WebLogic Server 14.1.2 image from the Oracle Container Registry.

  If you haven't already done so, log in to the Oracle Container Registry[^ocrlogin]:

  ```shell
  podman login container-registry.oracle.com
  ```

  Pull the WebLogic Server 14.1.2 image:

  ```shell
  podman pull docker pull container-registry.oracle.com/middleware/weblogic:14.1.2.0-generic-jdk21-ol9
  ```

</details>

### Step 2: Have your WebLogic Server 14.1.2 container running

Run the WebLogic Server 14.1.2 container with a empty domain.

> [!TIP]
> This command runs the WebLogic Server 14.1.2 container with the admin server running on port `7001` and the management console running on port `9002`. The domain properties file is mounted to the container to set the user name and password for the WebLogic Server Administration Console.
> Change the user name and password in the `domain.properties` file to suit your environment; do not use the default values.

<details open>

<summary>Using Docker</summary>

```shell
<<EOF > domain.properties
username=weblogic
password=securepassword
EOF
docker run --rm -it -p 9002:9002 -p 7001:7001 --name wlsadmin --hostname wlsadmin -v ./domain.properties:/u01/oracle/properties/domain.properties container-registry.oracle.com/middleware/weblogic:14.1.2.0-generic-jdk21-ol9
```

</details>

<details>

<summary>Using Podman</summary>

```shell
<<EOF > domain.properties
username=weblogic
password=securepassword
EOF
podman run --rm -it -p 9002:9002 -p 7001:7001 --name wlsadmin --hostname wlsadmin -v ./domain.properties:/u01/oracle/properties/domain.properties container-registry.oracle.com/middleware/weblogic:14.1.2.0-generic-jdk21-ol9
```

</details>

### Step 3: Clone the `spring-framework-petclinic` repo from its original source

1. Clone the `spring-framework-petclinic` repo:

    ```shell
    git clone -b 5.3.x --single-branch https://github.com/spring-petclinic/spring-framework-petclinic.git
    ```

1. Change to the `spring-framework-petclinic` directory:

    ```shell
    cd spring-framework-petclinic
    ```

### Step 4: Prepare the Spring Framework 5.3.x PetClinic example to run on WebLogic Server 14.1.2

To run the Spring Framework 5.3.x PetClinic example on WebLogic Server 14.1.2, you need to do few updates, that can be done manually or using a special recipe to automatically do the changes.

<!-- <details>

<summary>Using OpenRewrite Recipes to automatically update</summary>

1. Run the following command to run OpenRewrite:

    ```shell
    mvn -U org.openrewrite.maven:rewrite-maven-plugin:run \
    -Drewrite.recipeArtifactCoordinates=com.oracle.weblogic.rewrite:rewrite-weblogic:RELEASE \
    -Drewrite.activeRecipes=com.oracle.weblogic.rewrite.examples.spring.SetupSpringFrameworkPetClinicFor1412
    ```

</details> -->

<details open>

<summary>Doing Manual updates</summary>

1. Update the DefaultServletHandler.

    If you run the Spring Framework 5.3.x PetClinic example on any Application server, you need to do that update as documented here [https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-config/default-servlet-handler.html](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-config/default-servlet-handler.html).

    Go to the `spring-framework-petclinic/src/main/resources/spring/mvc-core-config.xml` file and update the `<mvc:default-servlet-handler />` to include `default-servlet-name="DefaultServlet"`.

    ```xml
    <mvc:default-servlet-handler />
    ```

    to

    ```xml
    <mvc:default-servlet-handler default-servlet-name="DefaultServlet"/>
    ```

1. Configure to use taglib 2.1.

    Create a file named `implicit.tld` in the `spring-framework-petclinic/src/main/webapp/WEB-INF/tags/` directory and add the following content:

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <taglib version="2.1" xmlns="http://java.sun.com/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-jsptaglibrary_2_1.xsd">
        <tlib-version>1.0</tlib-version>
        <short-name>implicit</short-name>
    </taglib>
    ```

</details>

### Step 5: Build the WAR file

> [!IMPORTANT]
> This command is skipping the tests to speed up the build process. If you want to run the tests, you may need to migrate the test packages to versions supported by Java 17 or 21. After that, you can run the tests by removing the `-DskipTests` option.

1. Build the Spring Framework PetClinic example:

    ```shell
    mvn clean package -DskipTests
    ```

1. Locate the WAR file in the `target` folder:

    ```shell
    ls target/petclinic.war
    ```

### Step 6: Deploy the Spring Framework PetClinic example

Deploy the Spring Framework PetClinic example to the WebLogic Server 14.1.2 container using the WebLogic Server Remote Console.

1. If not already installed, download and install the WebLogic Server Remote Console (WRC) from [`github.com/oracle/weblogic-remote-console`](https://github.com/oracle/weblogic-remote-console/releases).

1. [Deploy](https://docs-uat.us.oracle.com/en/middleware/fusion-middleware/weblogic-remote-console/administer/deploying-applications.html#GUID-6148F650-4FB8-4F4E-A578-C733D275C0A2) and start the Spring Framework PetClinic example application.

### Step 7: Access the Spring Framework PetClinic example

Access the Spring Framework PetClinic example application using the WebLogic Server port.

Open a browser and go to a URL like this [one](http://localhost:7001/petclinic/):

  ```shell
  http://localhost:7001/petclinic/
  ```

<details>

<summary>Acknowledgements</summary>

- **Author** - Adao Oliveira Junior
- **Contributors** - Adao Oliveira Junior
- **Last Updated By/Date** - Adao Oliveira Junior/March 2025

</details>

[^ocrlogin]: You need to have an Oracle account to access the Oracle Container Registry and accept the license agreement to access the WebLogic container images [here](https://container-registry.oracle.com/ords/ocr/ba/middleware/weblogic). If you don't have an account, you can create one for free at [Create your Oracle Account](https://profile.oracle.com/myprofile/account/create-account.jspx).
