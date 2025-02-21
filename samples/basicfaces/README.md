# Basic Faces Example

Welcome to the Basic Faces example! This example demonstrates how to deploy a simple JSF application to WebLogic. Whether you're a seasoned developer or just beginning your journey, this example will showcase the powerful features of WebLogic and help you hit the ground running. Dive in and explore the possibilities!

## Packaging and running the application

Package the application using:

```shell
gradle build
```

>Note: If it builds correctly, you will see a `build/libs` directory with the `basicfaces-1.0.0-SNAPSHOT.war` file.

Deploy the application using the [WebLogic Remote Console](https://docs.oracle.com/en/middleware/fusion-middleware/weblogic-remote-console/administer/set-console.html) or the [WebLogic Scripting Tool](https://docs.oracle.com/en/middleware/fusion-middleware/14.1.2/wlstg/using_wlst.html) (WLST).

Access and test the application to make sure it works as expected. You can access the application at `https://localhost:7001/basicfaces`.
