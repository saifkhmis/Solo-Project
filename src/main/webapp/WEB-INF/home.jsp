<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pizza Pete's - Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pizza-styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home-styles.css">
</head>
<body>
    <div class="header">
        <h1>PIZZA PETE'S</h1>
    </div>
    <div class="container">
        <div class="row mb-4">
            <div class="col-12 text-right">
                <nav class="main-nav">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary active">HOME</a>
                    <a href="${pageContext.request.contextPath}/pizzas/new" class="btn btn-light">ORDER (${cartCount})</a>
                    <a href="${pageContext.request.contextPath}/account" class="btn btn-light">ACCOUNT</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-light">LOGOUT</a>
                </nav>
            </div>
        </div>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <h2 class="text-center mb-5">QUICK OPTIONS</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="option-box">
                    <p class="option-description">
                        Start a completely new pizza order with your choice of toppings, crust styles, and sizes.
                    </p>
                    <a href="${pageContext.request.contextPath}/pizzas/new" class="btn btn-dark">Build Your Pizza</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="option-box">
                    <c:choose>
                        <c:when test="${not empty favoritePizza}">
                            <p class="option-description">
                                Re-order your favorite pizza: 
                                ${favoritePizza.size} ${favoritePizza.crust} with 
                                <c:forEach items="${favoritePizza.toppings}" var="topping" varStatus="status">
                                    ${topping}<c:if test="${!status.last}">, </c:if>
                                </c:forEach>
                            </p>
                            <a href="${pageContext.request.contextPath}/reorder-favorite" class="btn btn-dark">Re-Order My Fave</a>
                        </c:when>
                        <c:otherwise>
                            <p class="option-description">
                                Create a favorite pizza by checking "Mark as Favorite" when ordering. It will appear here for quick re-ordering.
                            </p>
                            <a href="${pageContext.request.contextPath}/pizzas/new" class="btn btn-dark">Create a Favorite</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-md-4">
                <div class="option-box">
                    <p class="option-description">
                        Let us surprise you with a randomly selected pizza combination.
                    </p>
                    <a href="${pageContext.request.contextPath}/surprise-pizza" class="btn btn-dark">SURPRISE ME</a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>