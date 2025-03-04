# Deploy Spring Framework PetClinic to WLS 14.1.2 running in a container

This tutorial demonstrates how to deploy the [Spring Framework PetClinic](/samples/spring-framework-petclinic-12.2.1.4/) example application on WebLogic Server 14.1.2 running in a container (Docker or Podman, or other preference).

## Prerequisites

Before starting this tutorial, make sure you have the following:

- [Docker](https://docs.docker.com/get-docker/) or [Podman](https://podman.io/getting-started/installation) installed.
- Access to [Oracle WebLogic Server 14.1.2.0 Container Images](https://container-registry.oracle.com/ords/ocr/ba/middleware/weblogic) or have the [WebLogic Server 14.1.2](https://www.oracle.com/middleware/technologies/weblogic-server-installers-downloads.html) image available in your local repository.
- The [Spring Framework PetClinic](/samples/spring-framework-petclinic-12.2.1.4/) example.

## Spring Framework PetClinic example

We'll step through this tutorial using the Spring Framework PetClinic example that is available on this GitHub repo: [`spring-framework-petclinic-12.2.1.4`](../../../samples/spring-framework-petclinic-12.2.1.4/). This is a fork of the approved [fork](https://github.com/spring-petclinic/spring-framework-petclinic/tree/5.3.x) from the Spring Team, a PetClinic version with a plain Spring Framework 5.3.x configuration and with a 3-layer architecture (i.e. presentation --> service --> repository) and was modified to run on WebLogic 12.2.1.4 and 14.1.2.

![Spring Framework PetClinic](https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png)

## Steps

Follow these steps to deploy the Spring Framework PetClinic example on WebLogic Server 14.1.2 running in a container.

### Step 1: Pull the WebLogic Server 14.1.2 image

Make sure you have a WebLogic Server 14.1.2 container running. You can use Docker or Podman to run the container.

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

  > **Note**: This image is the base image running with JDK 21 on Oracle Linux 9. You can use any variant of the image that suits your environment or tests.

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

  > **Note**: This image is the base image running with JDK 21 on Oracle Linux 9. You can use any variant of the image that suits your environment or tests.

</details>

### Step 2: Have your WebLogic Server 14.1.2 container running

Run the WebLogic Server 14.1.2 container with a empty domain.

<details open>

<summary>Using Docker</summary>

```shell
<<EOF > domain.properties
username=weblogic
password=securepassword
EOF
docker run --rm -it -p 9002:9002 -p 7001:7001 --name wlsadmin --hostname wlsadmin -v ./domain.properties:/u01/oracle/properties/domain.properties container-registry.oracle.com/middleware/weblogic:14.1.2.0-generic-jdk21-ol9
```

> **Note**: This command runs the WebLogic Server 14.1.2 container with the admin server running on port `7001` and the management console running on port `9002`. The domain properties file is mounted to the container to set the user name and password for the WebLogic Server Administration Console.
> Change the user name and password in the `domain.properties` file to suit your environment; do not use the default values.

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

> **Note**: This command runs the WebLogic Server 14.1.2 container with the admin server running on port `7001` and the management console running on port `9002`. The domain properties file is mounted to the container to set the user name and password for the WebLogic Server Administration Console.
> Change the user name and password in the `domain.properties` file to suit your environment; do not use the default values.

</details>

### Step 3: Clone the `weblogic-examples` repo with the Spring Framework PetClinic example

1. Clone the `weblogic-examples` repo:

    ```shell
    git clone https://github.com/oracle-samples/weblogic-examples.git
    ```

1. Go to the `spring-framework-petclinic-12.2.1.4` folder:

    ```shell
    cd weblogic-examples/samples/spring-framework-petclinic-12.2.1.4
    ```

### Step 4: Install and generate the WAR file

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

### Step 5: Deploy the Spring Framework PetClinic example

Deploy the Spring Framework PetClinic example to the WebLogic Server 14.1.2 container using the WebLogic Server Remote Console.

1. If not already installed, download and install the WebLogic Server Remote Console (WRC) from [`github.com/oracle/weblogic-remote-console`](https://github.com/oracle/weblogic-remote-console/releases).

1. [Deploy](https://docs-uat.us.oracle.com/en/middleware/fusion-middleware/weblogic-remote-console/administer/deploying-applications.html#GUID-6148F650-4FB8-4F4E-A578-C733D275C0A2) and start the Spring Framework PetClinic example application.

Optionally, if you have a WebLogic 15.1.1 domain available, deploy the Spring Framework PetClinic example application using your standard deployment tools.

### Step 6: Access the Spring Framework PetClinic example

Access the Spring Framework PetClinic example application using the WebLogic Server port.

Open a browser and go to:

    ```shell
    http://localhost:7001/petclinic
    ```

[^ocrlogin]: You need to have an Oracle account to access the Oracle Container Registry and accept the license agreement to access the WebLogic container images [here](https://container-registry.oracle.com/ords/ocr/ba/middleware/weblogic). If you don't have an account, you can create one for free at [Create your Oracle Account](https://profile.oracle.com/myprofile/account/create-account.jspx).
