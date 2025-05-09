<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pizza Pete's - Update Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home-styles.css">
    <style>
        .form-container {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .section-title {
            color: #dc3545;
            font-weight: 700;
            border-bottom: 2px solid #dc3545;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .form-group label {
            font-weight: 500;
        }
        
        .btn-update {
            background-color: #28a745;
            color: white;
        }
        
        .btn-cancel {
            background-color: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>PIZZA PETE'S</h1>
    </div>

    <div class="container">
        <div class="row mb-4">
            <div class="col-12 text-right">
                <nav class="main-nav">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-light">HOME</a>
                    <a href="${pageContext.request.contextPath}/pizzas/new" class="btn btn-light">ORDER (${cartCount})</a>
                    <a href="${pageContext.request.contextPath}/account" class="btn btn-primary active">ACCOUNT</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-light">LOGOUT</a>
                </nav>
            </div>
        </div>

        <div class="form-container">
            <h2 class="section-title">UPDATE PROFILE</h2>
            
            <form:form action="/account/update-profile" method="post" modelAttribute="user">
                <form:hidden path="id" />
                <!-- We don't want to update the password in this form -->
                <form:hidden path="password" />
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <form:label path="firstName">First Name:</form:label>
                            <form:input path="firstName" class="form-control" />
                            <form:errors path="firstName" class="text-danger" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <form:label path="lastName">Last Name:</form:label>
                            <form:input path="lastName" class="form-control" />
                            <form:errors path="lastName" class="text-danger" />
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <form:label path="email">Email:</form:label>
                    <form:input path="email" class="form-control" type="email" />
                    <form:errors path="email" class="text-danger" />
                </div>
                
                <div class="form-group">
                    <form:label path="address">Address:</form:label>
                    <form:input path="address" class="form-control" />
                    <form:errors path="address" class="text-danger" />
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <form:label path="city">City:</form:label>
                            <form:input path="city" class="form-control" />
                            <form:errors path="city" class="text-danger" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <form:label path="state">State:</form:label>
                            <form:input path="state" class="form-control" />
                            <form:errors path="state" class="text-danger" />
                        </div>
                    </div>
                </div>
                
                <div class="form-group text-right">
                    <a href="${pageContext.request.contextPath}/account" class="btn btn-cancel mr-2">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-update">
                        <i class="fas fa-save"></i> Update Profile
                    </button>
                </div>
            </form:form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>