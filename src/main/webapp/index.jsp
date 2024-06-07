<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>HOME</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
    </head>
    <body>
        <!-- header section start -->
        <jsp:include page="header.jsp" ></jsp:include>
        <jsp:include page="products.jsp" />
        <jsp:include page="footer.jsp" />
    </body>
</html>