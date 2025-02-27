# Migrate Spring Framework PetClinic to WLS 15.1.1 (BETA)

Oracle provides OpenRewrite recipes to help you upgrade your applications to new WebLogic and Java versions, and to Jakarta EE. This tutorial demonstrates how to use the recipes to upgrade a sample application to run on WebLogic Server 15.1.1 with JDK 21 and Jakarta EE 9.1.

## Spring Framework PetClinic Example

We'll step through this tutorial using the Spring Framework PetClinic example that is available on this GitHub repo: [`spring-framework-petclinic-12.2.1.4` sample](../../../samples/spring-framework-petclinic-12.2.1.4/). This is a fork of the approved [fork](https://github.com/spring-petclinic/spring-framework-petclinic/tree/5.3.x) from Spring Team, a Petclinic version with a plain old Spring Framework 5.3.x configuration and with a 3-layer architecture (i.e. presentation --> service --> repository) and was modified to run on WebLogic 12.2.1.4. We will run the `rewrite-weblogic` recipes locally, so we'll need a copy of the code locally, too.

![Spring Framework PetClinic](https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png)

### Step 1: Start by making sure that you have the prerequisites

1. Make sure that you have Java 8 or later installed.
1. Make sure that you have Maven 3.x installed.
1. Clone the `weblogic-examples` repo:

    ```shell
    git clone https://github.com/oracle-samples/weblogic-examples.git
    ```

1. Go to the `spring-framework-petclinic-12.2.1.4` folder:

    ```shell
    cd weblogic-examples/samples/spring-framework-petclinic-12.2.1.4
    ```

### Step 2: Sync Maven dependencies

For OpenRewrite to run, Maven dependencies must be resolved. If needed, run `mvn clean install` for missing dependencies:

```shell
mvn clean install
```

Or, you can use other commands as well, such as `mvn dependency:resolve`.

### Step 3: Run the Maven command to run OpenRewrite

For this example, we will upgrade the Spring Framework PetClinic application to run on WebLogic Server 15.1.1 with JDK 21, including Jakarta EE 9.1. Alternatively, you can upgrade the application to run on WebLogic Server 15.1.1 with JDK 17.

1. Open a terminal at the `spring-framework-petclinic-12.2.1.4` folder.

    You must open to the folder where the POM file is located:
    ``` weblogic-examples/samples/spring-framework-petclinic-12.2.1.4 ```

    Preferably, you should open a terminal within your IDE so that you can easily review changes to the source files after running the recipes.

    ![VSCode - open an integrated terminal](../../images/integ-terminal-vscode.png)

1. Run the following command to run OpenRewrite:

    ```shell
    mvn -U org.openrewrite.maven:rewrite-maven-plugin:run \
      -Drewrite.recipeArtifactCoordinates=com.oracle.weblogic.rewrite:rewrite-weblogic:0.4.4,org.openrewrite.recipe:rewrite-spring:RELEASE,org.openrewrite.recipe:rewrite-hibernate:RELEASE \
      -Drewrite.activeRecipes=com.oracle.weblogic.rewrite.UpgradeTo1511,org.openrewrite.java.migrate.UpgradeToJava21,com.oracle.weblogic.rewrite.JakartaEE9_1,com.oracle.weblogic.rewrite.spring.framework.UpgradeToSpringFramework_6_2,com.oracle.weblogic.rewrite.hibernate.MigrateHibernate4JakartaEE9 \
      -Drewrite.exportDatatables=true
    ```
**Note** that this command updates the application to use Java 21. If you want to upgrade to Java 17 instead, replace `UpgradeToJava21` with `UpgradeToJava17`.

This command applies the following recipes:

- `com.oracle.weblogic.rewrite.UpgradeTo1511`
- `org.openrewrite.java.migrate.UpgradeToJava21`
- `com.oracle.weblogic.rewrite.JakartaEE9_1`
- `com.oracle.weblogic.rewrite.spring.framework.UpgradeToSpringFramework_6_2`
- `com.oracle.weblogic.rewrite.hibernate.MigrateHibernate4JakartaEE9`

OpenRewrite updates the `spring-framework-petclinic-12.2.1.4` code in the following ways:

- `pom.xml` – updates versions, dependencies, and namespaces
- Source files –
  - Updates Java dependencies and related statements.
  - Updates WebLogic API dependencies and related statements.
  - For removed APIs with no replacement, OpenRewrite inserts a comment in the code stating that the API usage needs to be resolved or removed.
  - Updates Jakarta API usage to Jakarta EE 9.1 version.
  - Updates Spring Framework APIs to version 6.2.
  - Sets proper Hibernate API versions to work with Java 21 and Jakarta EE 9.1.


### Step 3: Review the results

The easiest way to see the results of the upgrade is to compare the updated files to the previous version in GitHub or in your IDE.

For example, the following image shows file changes for the ```pom.xml``` file in VS Code:

![pom file with changes](../../images/pom-sbs.png)

The following image shows a source file with code changes applied:
![source file with changes](../../images/coffee-java-sbs.png)

### Step 4: Deploy the application

Optionally, if you have a WebLogic 15.1.1 domain available, deploy the Spring Framework PetClinic example application using your standard deployment tools.
