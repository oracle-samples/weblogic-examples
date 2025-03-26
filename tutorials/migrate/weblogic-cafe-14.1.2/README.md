# Migrate WebLogic Cafe to WLS 14.1.2

As of WebLogic Server 14.1.2, Oracle provides OpenRewrite recipes to help you upgrade your applications to new WebLogic and Java versions. This tutorial demonstrates how to use the recipes to upgrade a sample application to run on WebLogic Server 14.1.2 with JDK 21.

## WebLogic Cafe example

We'll step through this tutorial using the WebLogic Cafe example that is available on GitHub: [`https://github.com/microsoft/weblogic-on-azure`](https://github.com/microsoft/weblogic-on-azure). This is a simplified Java EE application that is used in many demos. We will run the `rewrite-weblogic` recipes locally, so we'll need a copy of the code locally, too.

### Step 1: Start by making sure that you have the prerequisites

1. Make sure that you have Java 8 or later installed.
1. Make sure that you have Maven 3.x installed.
1. Clone the `weblogic-on-azure` repo:

    ```shell
    git clone https://github.com/microsoft/weblogic-on-azure.git
    ```

    ```shell
    cd weblogic-on-azure/javaee/weblogic-cafe
    ```

### Step 2: Sync Maven dependencies

For OpenRewrite to run, Maven dependencies must be resolved. If needed, run `mvn clean install` for missing dependencies.

1. Open a terminal at the `weblogic-cafe` folder.

     You must open to the folder where the POM file is located:
     ``` weblogic-on-azure/javaee/weblogic-cafe ```

     Preferably, you should open a terminal within your IDE so that you can review the changes to the source files.

     ![VSCode - open an integrated terminal](../../images/integ-terminal-vscode.png)

1. Run the following command for missing dependencies.     

     ```shell
     mvn clean install
     ```

     Or, you can use other commands as well, such as `mvn dependency:resolve`.

### Step 3: Run the Maven command to run OpenRewrite

For this example, we will upgrade the WebLogic Cafe application to run on WebLogic Server 14.1.2 with JDK 21. Alternatively, you can upgrade the application to run on WebLogic Server 14.1.2 with JDK 17.

1. From the terminal open at the `weblogic-cafe` folder, run the following command to run OpenRewrite:

    ```shell
    mvn -U org.openrewrite.maven:rewrite-maven-plugin:run \
      -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:RELEASE,com.oracle.weblogic.rewrite:rewrite-weblogic:LATEST \
      -Drewrite.activeRecipes=org.openrewrite.java.migrate.UpgradeToJava21,com.oracle.weblogic.rewrite.UpgradeTo1412
    ```
**Note** that this command updates the application to use Java 21. If you want to upgrade to Java 17 instead, replace `UpgradeToJava21` with `UpgradeToJava17`.


The command applies the following recipes:

- `com.oracle.weblogic.rewrite.UpgradeTo1412`
- `org.openrewrite.java.migrate.UpgradeToJava21`

OpenRewrite updates the `weblogic-cafe` code in the following ways:

- `pom.xml` – Updates versions and namespaces.
- Source files –
  - Updates Java dependencies and related statements.
  - Updates WebLogic API dependencies and related statements.
  - For removed APIs with no replacement, OpenRewrite inserts a comment in the code stating that the API usage needs to be resolved or removed.

### Step 4: Review the results

The easiest way to see the results of the upgrade is to compare the updated files to the previous version in GitHub or in your IDE.

For example, the following image shows file changes for the ```pom.xml``` file in VS Code:

![pom file with changes](../../images/pom-sbs.png)

The following image shows a source file with the code changes applied:

![source file with changes](../../images/coffee-java-sbs.png)

### Step 5: Build and deploy the application

To build the updated application, run this command:
```shell
mvn clean package -Dmaven.test.skip
```

Optionally, if you have a WebLogic 14.1.2 domain available, deploy the WebLogic Cafe example application using your standard deployment tools, such as the [WebLogic Remote Console](https://docs.oracle.com/en/middleware/fusion-middleware/weblogic-remote-console/administer/set-console.html).

As supplied, the application needs a database and a JDBC data source configuration to deploy successfully. Instructions for setting up a PostgreSQL database and a JDBC data source are available in the original [example instructions](https://github.com/microsoft/weblogic-on-azure/blob/main/javaee/README.md).

#### Quick-Deployment option

You can optionally deploy the application so that it will use a local Derby database. This is a great option for demos and other dev-centric single-server use cases.

The quick-deployment option requires two changes:
1. Before starting the WebLogic Server instance, in the shell window where you want to start WebLogic Server, you must set the `DERBY_FLAG` value to `"true"`:

   ```
   DERBY_FLAG="true"
   export DERBY_FLAG
   ```
   Then run ```startWebLogic.sh``` to start the admin server. The startup process will start Derby so that it is ready to interact with the application.

2. Add a JDBC data source to your WebLogic domain, to connect to the local data source with the following properties:
   ```
   <name>webcafe</name>
   <datasource-type>GENERIC</datasource-type>
   <jdbc-driver-params>
      <url>jdbc:derby://localhost:1527/weblogic;ServerName=localhost;databaseName=weblogic;create=true</url>
      <driver-name>org.apache.derby.jdbc.ClientXADataSource</driver-name>
      <properties>
        <property>
          <name>databaseName</name>
          <value>weblogic;create=true</value>
        </property>
        <property>
          <name>serverName</name>
          <value>localhost</value>
        </property>
        <property>
          <name>user</name>
          <value>webcafe</value>
        </property>
        <property>
          <name>portNumber</name>
          <value>1527</value>
        </property>
      </properties>
      <password-encrypted>placeholder</password-encrypted>
    </jdbc-driver-params>
    <jdbc-data-source-params>
      <jndi-name>jdbc/WebLogicCafeDB</jndi-name>
      <global-transactions-protocol>TwoPhaseCommit</global-transactions-protocol>
    </jdbc-data-source-params>
   ```



After making these changes to your environment,  build the application:

```shell
mvn clean package -Dmaven.test.skip
```

Then, you can deploy the ```weblogic-cafe.war``` file to the WebLogic Server 14.1.2 instance that you started in step 1 of the quick-deployment option.
