<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pizza Pete's - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home-styles.css">
    
</head>
<body>
    <div class="header">
        <h1>PIZZA PETE'S</h1>
    </div>
    
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="form-section">
                    <h2 class="text-center mb-4">Welcome Back!</h2>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success text-center">${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger text-center">${errorMessage}</div>
                    </c:if>
                    <form:form action="/login" method="post" modelAttribute="newLogin">
                        <div class="form-group">
                            <form:label path="email">Email:</form:label>
                            <form:input path="email" class="form-control" />
                            <form:errors path="email" class="text-danger" />
                        </div>
                        <div class="form-group">
                            <form:label path="password">Password:</form:label>
                            <form:password path="password" class="form-control" />
                            <form:errors path="password" class="text-danger" />
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn btn-primary btn-block">Log In</button>
                        </div>
                    </form:form>
                    <div class="text-center mt-4">
                        <p>Don't have an account? <a href="/register">Register</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>