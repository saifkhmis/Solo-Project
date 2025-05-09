<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pizza Pete's - Register</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home-styles.css">
</head>
<body>
    <div class="header">
        <h1>PIZZA PETE'S</h1>
    </div>
    
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-md-10 col-lg-8">
                <div class="form-section">
                    <h2 class="text-center mb-4">Create Your Account</h2>
                    
                    <!-- Display any error messages -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger text-center">${errorMessage}</div>
                    </c:if>
                    
                    <form:form action="/register" method="post" modelAttribute="newUser">
                        <div class="form-group row">
                            <div class="col-md-6">
                                <form:label path="firstName">First Name:</form:label>
                                <form:input path="firstName" class="form-control" />
                                <form:errors path="firstName" class="text-danger" />
                            </div>
                            <div class="col-md-6">
                                <form:label path="lastName">Last Name:</form:label>
                                <form:input path="lastName" class="form-control" />
                                <form:errors path="lastName" class="text-danger" />
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <form:label path="email">Email:</form:label>
                            <form:input path="email" class="form-control" />
                            <form:errors path="email" class="text-danger" />
                        </div>
                        
                        <div class="form-group">
                            <form:label path="address">Address:</form:label>
                            <form:input path="address" id="address-input" class="form-control" />
                            <form:errors path="address" class="text-danger" />
                        </div>
                        
                        <div class="form-group row">
                            <div class="col-md-6">
                                <form:label path="city">City:</form:label>
                                <form:input path="city" id="city-input" class="form-control" />
                                <form:errors path="city" class="text-danger" />
                            </div>
                            <div class="col-md-6">
                                <form:label path="state">State:</form:label>
                                <form:input path="state" id="state-input" class="form-control" />
                                <form:errors path="state" class="text-danger" />
                            </div>
                        </div>
                        
                        <!-- Hidden fields for latitude and longitude -->
                        <form:input type="hidden" path="latitude" id="latitude-input" />
                        <form:input type="hidden" path="longitude" id="longitude-input" />
                        
                        <!-- Map container -->
                        <div id="map" style="height: 300px; margin-bottom: 20px;"></div>
                        
                        <div class="form-group row">
                            <div class="col-md-6">
                                <form:label path="password">Password:</form:label>
                                <form:password path="password" class="form-control" />
                                <form:errors path="password" class="text-danger" />
                            </div>
                            <div class="col-md-6">
                                <form:label path="confirm">Confirm Password:</form:label>
                                <form:password path="confirm" class="form-control" />
                                <form:errors path="confirm" class="text-danger" />
                            </div>
                        </div>
                        
                        <div class="text-center">
                            <button type="submit" class="btn btn-primary btn-block">Create Account</button>
                        </div>
                    </form:form>
                    
                    <div class="text-center mt-4">
                        <p>Already have an account? <a href="/login">Login</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    
    <!-- jQuery for animations -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/register.js"></script>
</body>
</html>