<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Pizza Order</title>
    <link rel="stylesheet" href="/webjars/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/main.css">
    <script src="/webjars/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Your Pizza Order</h1>
            <div>
                <a href="/home" class="btn btn-secondary">Home</a>
                <a href="/logout" class="btn btn-danger">Logout</a>
            </div>
        </div>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h3>Your Pizzas</h3>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty pizzas}">
                        <p>Your order is currently empty. Add some pizzas!</p>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Size</th>
                                    <th>Crust</th>
                                    <th>Toppings</th>
                                    <th>Quantity</th>
                                    <th>Method</th>
                                    <th>Price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pizza" items="${pizzas}">
                                    <tr>
                                        <td>${pizza.size}</td>
                                        <td>${pizza.crust}</td>
                                        <td>
                                            <c:forEach var="topping" items="${pizza.toppings}" varStatus="status">
                                                ${topping}<c:if test="${!status.last}">, </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>${pizza.quantity}</td>
                                        <td>${pizza.method}</td>
                                        <td>$${pizza.price}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <div class="d-flex justify-content-end">
                            <h4>Total: $${totalPrice}</h4>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-footer">
                <div class="d-flex justify-content-between">
                    <a href="/orders/add-pizza" class="btn btn-success">Add Another Pizza</a>
                    
                    <c:if test="${not empty pizzas}">
                        <form action="/orders/purchase" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-primary">Complete Purchase</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</body>
</html>