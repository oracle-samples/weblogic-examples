# WebLogic Examples and Tutorials

Welcome to the WebLogic Examples repository! Here, you'll find tutorials and examples that will help you get started with WebLogic quickly. Whether you're a seasoned developer or just beginning your journey, these examples will showcase the powerful features of WebLogic and help you hit the ground running. Dive in and explore the possibilities!

## Get started

> [!TIP]
> If you are looking for an example that runs on a specific version of WebLogic, please check out the corresponding branch. For example, if you are looking for an example that runs on WebLogic 14.1.2, please check out the `14.1.2` branch.

To get started, clone the repository and navigate to the example in which you are interested. Each example contains a `README.md` file that provides detailed instructions on how to run the example. To run the example on your local machine, follow the instructions in the `README.md` file.

```bash
git clone https://github.com/oracle-samples/weblogic-examples.git
cd weblogic-examples
```

### Examples

| Example                                                                                                                                         | Source | Description | Runs on 15.1.1 | 14.1.2 | 12.2.1.4 | Builder | Highlights |
|-------------------------------------------------------------------------------------------------------------------------------------------------| --- | --- | --- | --- | --- | --- | --- |
| [Basic Faces](./samples/basicfaces/README.md)                                                                                                   | `basicfaces` [repo](./samples/basicfaces/) | A simple JSF application that demonstrates how to deploy a web application to WebLogic. | ✅ </br> Not optimized for Jakarta EE 9.1 descriptors. | ✅ | ✅ | Gradle | JSF |
| [Simple Servlet](./samples/simpleservlet/README.md)                                                                                             | `simpleservlet` [repo](./samples/simpleservlet/) | A simple servlet application that demonstrates how to deploy a web application to WebLogic. | ✅ | ❌ | ❌ | Maven | servlet <br/> Jakarta EE 9.1 |
| [WebLogic Cafe](https://github.com/microsoft/weblogic-on-azure/blob/main/README.md)                                                             | Microsoft `weblogic-on-azure` [repo](https://github.com/microsoft/weblogic-on-azure) | A sample application that showcases the WebLogic on Azure solution. | 🟡 [^1] | ✅ | ✅ | Maven | OpenRewrite |
| [Spring Framework PetClinic (WLS 12.2.1.4)](./tutorials/deploy/deploy-petclinic-weblogic-12.2.1.4/README.md) | `spring-petclinic` [repo](./tutorials/deploy/deploy-petclinic-weblogic-12.2.1.4) | A well-known Spring Framework demo application modified to run on WebLogic 12.2.1.4. | 🟡 [^2] | ✅ | ✅ | Maven | Spring Framework 5.3.x |

[^1]: To deploy WebLogic Cafe to WebLogic 15.1.1 (BETA), follow this [tutorial](https://github.com/oracle-samples/weblogic-examples/blob/main/tutorials/migrate/weblogic-cafe-15.1.1/README.md) to upgrade the application to use Jakarta EE 9.1 and Java 21 on WebLogic.

[^2]: To deploy Spring Framework PetClinic to WebLogic 15.1.1 (BETA), **first** follow the app migration [tutorial](https://github.com/oracle-samples/weblogic-examples/blob/main/tutorials/migrate/spring-framework-petclinic-15.1.1/README.md), then follow the deploy tutorial [here](https://github.com/oracle-samples/weblogic-examples/blob/main/tutorials/deploy/deploy-petclinic-container-14.1.2/README.md).



### Tutorials

| Tutorial | Description |
| --- | --- |
| [Migrate WebLogic Cafe to WLS 14.1.2](./tutorials/migrate/weblogic-cafe-14.1.2/README.md) | This tutorial shows you how to upgrade the WebLogic Cafe sample application to WebLogic 14.1.2 and Java 21. |
| [Migrate WebLogic Cafe to WLS 15.1.1(BETA)](./tutorials/migrate/weblogic-cafe-15.1.1/README.md) | This tutorial shows you how to upgrade the WebLogic Cafe sample application to WebLogic 15.1.1 (BETA), Java 21, and Jakarta EE 9.1. |
| [Migrate Spring Framework PetClinic to WLS 15.1.1(BETA)](./tutorials/migrate/spring-framework-petclinic-15.1.1/README.md) | This tutorial shows you how to upgrade the Spring Framework PetClinic sample application to WebLogic 15.1.1 (BETA), Java 21, Jakarta EE 9.1, and Spring Framework 6.2.x. |
| [Deploy Spring Framework PetClinic to WLS 14.1.2 running in a container](./tutorials/deploy/petclinic-in-container-14.1.2/README.md) | This tutorial shows you how to deploy the Spring Framework PetClinic 12.2.1.4 example application on WebLogic Server 14.1.2 running in a container (Docker or Podman). |
| [Deploy Spring Framework PetClinic to WLS 12.2.1.4](./tutorials/deploy/deploy-petclinic-weblogic-12.2.1.4/README.md) | This tutorial shows you how to deploy the Spring Framework PetClinic 12.2.1.4 example application on WebLogic Server 12.2.1.4 running on an Oracle Linux host. |

## Get help

We have a public Slack channel where you can get in touch with us, to ask questions about WebLogic and the examples, or give us feedback or suggestions about features and improvements you would like to see. We would love to hear from you.

To join our channel, please visit this [site](https://join.slack.com/t/oracle-weblogic/shared_invite/zt-2tgq767tj-i4ip6suUiW2Cgykb~rMijg) to get an invitation. The invitation email will include details on how to access our Slack workspace. After you are logged in, please go to #general and say, "Hello!"

## Contributing

This project welcomes contributions from the community. Before submitting a pull request, please [review our contribution guide](./CONTRIBUTING.md).

## Security

Please consult the [security guide](./SECURITY.md) for our responsible security vulnerability disclosure process.

## License

Copyright (c) 2025 Oracle and/or its affiliates.

Released under the Universal Permissive License v1.0 as shown at
<https://oss.oracle.com/licenses/upl/>.
