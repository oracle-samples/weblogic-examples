# Migrate WebLogic Cafe to WLS 15.1.1 (BETA)

Oracle provides OpenRewrite recipes to help you upgrade your applications to new WebLogic and Java versions, and to Jakarta EE. This tutorial demonstrates how to use the recipes to upgrade a sample application to run on WebLogic Server 15.1.1 with JDK 21 and Jakarta EE 9.1.

## WebLogic Cafe Example

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

For OpenRewrite to run, Maven dependencies must be resolved. If needed, run `mvn clean install` for missing dependencies:

```shell
mvn clean install
```

Or, you can use other commands as well, such as `mvn dependency:resolve`.

### Step 3: Run the Maven command to run OpenRewrite

For this example, we will upgrade the WebLogic Cafe application to run on WebLogic Server 15.1.1 with JDK 21, including Jakarta EE 9.1. Alternatively, you can upgrade the application to run on WebLogic Server 15.1.1 with JDK 17.

1. Open a terminal at the `weblogic-cafe` folder.

    You must open to the folder where the POM file is located:
    ``` weblogic-on-azure/javaee/weblogic-cafe ```

    Preferably, you should open a terminal within your IDE so that you can review the changes to the source files.

    ![VSCode - open an integrated terminal](../../images/integ-terminal-vscode.png)

1. Run the following command to run OpenRewrite:

    ```shell
    mvn -U org.openrewrite.maven:rewrite-maven-plugin:run \
      -Drewrite.recipeArtifactCoordinates=com.oracle.weblogic.rewrite:rewrite-weblogic:LATEST \
      -Drewrite.activeRecipes=com.oracle.weblogic.rewrite.UpgradeTo1511,org.openrewrite.java.migrate.UpgradeToJava21,com.oracle.weblogic.rewrite.JakartaEE9_1 \
      -Drewrite.exportDatatables=true
    ```

This command applies the following recipes:

- `com.oracle.weblogic.rewrite.UpgradeTo1511`
- `org.openrewrite.java.migrate.UpgradeToJava21`
- `com.oracle.weblogic.rewrite.JakartaEE9_1`

OpenRewrite updates the `weblogic-cafe` code in the following ways:

- `pom.xml` – updates versions, dependencies, and namespaces
- Source files –
  - Updates Java dependencies and related statements.
  - Updates the Jakarta version from Jakarta EE 8 to Jakarta EE 9.1, including changing the ```javax``` namespace to ```jakarta```.
  - Updates WebLogic API dependencies and related statements.
  - For removed APIs with no replacement, OpenRewrite inserts a comment in the code stating that the API usage needs to be resolved or removed.

### Step 3: Review the results

The easiest way to see the results of the upgrade is to compare the updated files to the previous version in GitHub or in your IDE.

For example, the following image shows file changes for the ```pom.xml``` file in VS Code:

![pom file with changes](../../images/pom-sbs.png)

The following image shows a source file with code changes applied:

![source file with changes](../../images/coffee-java-sbs.png)

### Step 4: Build and deploy the application

To build the updated application, execute this command:
```shell
mvn clean package -Dmaven.test.skip
```

Optionally, if you have a WebLogic 15.1.1 domain available, deploy the WebLogic Cafe example application using your standard deployment tools, such as the WebLogic Remote Console.

As supplied, the application needs a database and a JDBC datasource configuration to deploy successfully. Instructions for setting up a PostgreSQL database and a JDBC datasource are available in the original [example instructions](https://github.com/microsoft/weblogic-on-azure/blob/main/javaee/README.md).

#### Quick-Deployment option

You can optionally deploy the application so that it will use a Derby database and a default JDBC datasource. This is a great option for demos and other dev-centric single-server use cases.

The quick deployment option requires two changes:
1. Before starting the WebLogic Server instance, you must set the DERBY_FLAG value to "true" in the shell window where you want to start WebLogic Server:

```shell
DERBY_FLAG="true"
export DERBY_FLAG
```
Then call ```startWebLogic.sh``` to start the admin server. The startup process will start Derby so that it is ready to interact with the application.

2. Update the ```persistence.xml``` file so that JPA will use the default data source and will connect to the Derby database:

In ```weblogic-on-azure/javaee/weblogic-cafe/src/main/resources/META-INF/persistence.xml```, find the following code block:
```
	<persistence-unit name="coffees">
		<jta-data-source>jdbc/WebLogicCafeDB</jta-data-source>
		<properties>
			<property
				name="jakarta.persistence.schema-generation.database.action"
				value="create" />
			<property name="openjpa.jdbc.SynchronizeMappings"
				value="buildSchema" />
			<property name="eclipselink.logging.level.sql" value="FINE" />
			<property name="eclipselink.logging.parameters" value="true" />
			<property name="hibernate.show_sql" value="true" />
		</properties>
		<shared-cache-mode>NONE</shared-cache-mode>
	</persistence-unit>
```
Replace the whole ```persistence-unit``` with this code block:
```shell
    <persistence-unit name="coffees">
        <provider>org.eclipse.persistence.jpa.PersistenceProvider</provider>
        <jta-data-source>java:comp/DefaultDataSource</jta-data-source>
        <properties>
            <property name="jakarta.persistence.schema-generation.database.action"
                value="create" />
            <property name="openjpa.jdbc.SynchronizeMappings"
                value="buildSchema" />
            <property name="eclipselink.target-database"
                value="org.eclipse.persistence.platform.database.DerbyPlatform"/>
            <property name="eclipselink.target-server" value="localhost"/>
            <property name="eclipselink.logging.level" value="FINEST"/>
            <property name="eclipselink.logging.parameters" value="true" />
            <property name="eclipselink.ddl-generation" value="create-or-extend-tables"/>                               
        </properties>
    </persistence-unit>
```

Save the file and then build the app: 

```shell
mvn clean package -Dmaven.test.skip
```

You can then deploy the ```weblogic-cafe.war``` file to the WebLogic Server 15.1.1 instance that you started in step 1 of the quick deployment option.


