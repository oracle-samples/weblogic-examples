<%-- Copyright (c) 2025, Oracle and/or its affiliates. --%>
<%-- Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. --%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.net.UnknownHostException"%>
<%@page import="java.net.InetAddress"%>
<%@page import="weblogic.management.*"%>

<%
    String hostname, serverAddress;
    hostname = "error";
    serverAddress = "error";
    try {
        InetAddress inetAddress;
        inetAddress = InetAddress.getLocalHost();
        hostname = inetAddress.getHostName();
        serverAddress = inetAddress.toString();
    } catch (UnknownHostException e) {
        e.printStackTrace();
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello WebLogic Server - Request Information</h1>
        <ul>
            <li>getVirtualServerName(): <%= request.getServletContext().getVirtualServerName() %></li>
            <li>InetAddress.hostname: <%=hostname%></li>
            <li>InetAddress.serverAddress: <%=serverAddress%></li>
            <li>getLocalAddr(): <%=request.getLocalAddr()%></li>
            <li>getLocalName(): <%=request.getLocalName()%></li>
            <li>getLocalPort(): <%=request.getLocalPort()%></li>
            <li>getServerName(): <%=request.getServerName()%></li>
            <li>WLS Server Name: <%=System.getProperty("weblogic.Name")%></li>
        </ul>
    </body>
</html>
