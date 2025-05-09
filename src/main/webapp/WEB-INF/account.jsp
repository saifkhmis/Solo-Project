<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pizza Pete's - My Account</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home-styles.css">
    <style>
        .account-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
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
        
        .user-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .user-details p {
            margin-bottom: 8px;
            font-size: 1.1rem;
        }
        
        .order-table {
            margin-top: 20px;
        }
        
        .order-table th {
            background-color: #dc3545;
            color: white;
        }
        
        .action-btn {
            margin-right: 5px;
        }
        
        .favorite-star {
            color: gold;
            font-size: 1.2rem;
        }
        
        .btn-update-profile {
            background-color: #28a745;
            color: white;
        }
        
        .toppings-list {
            max-width: 200px;
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

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <!-- User Information Section -->
        <div class="account-section">
            <h2 class="section-title">MY PROFILE</h2>
            <div class="user-info">
                <div class="user-details">
                    <p><strong>Name:</strong> ${user.firstName} ${user.lastName}</p>
                    <p><strong>Email:</strong> ${user.email}</p>
                    <p><strong>Address:</strong> ${user.address}</p>
                    <p><strong>City:</strong> ${user.city}, ${user.state}</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/account/update-profile" class="btn btn-update-profile">
                        <i class="fas fa-user-edit"></i> Update Profile
                    </a>
                </div>
            </div>
        </div>

        <!-- Order History Section -->
        <div class="account-section">
            <h2 class="section-title">MY ORDERS</h2>
            
            <c:choose>
                <c:when test="${empty pizzaOrders}">
                    <p>You haven't placed any orders yet. <a href="${pageContext.request.contextPath}/pizzas/new">Order your first pizza!</a></p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table order-table">
                            <thead>
                                <tr>
                                    <th>Pizza Type</th>
                                    <th>Size</th>
                                    <th>Crust</th>
                                    <th>Toppings</th>
                                    <th>Quantity</th>
                                    <th>Method</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pizzaOrders}" var="pizza">
                                    <tr>
                                        <td>
                                            <c:if test="${pizza.isFavorite}">
                                                <i class="fas fa-star favorite-star" title="Favorite Pizza"></i>
                                            </c:if>
                                            Pizza
                                        </td>
                                        <td>${pizza.size}</td>
                                        <td>${pizza.crust}</td>
                                        <td class="toppings-list">
                                            <c:forEach items="${pizza.toppings}" var="topping" varStatus="status">
                                                ${topping}<c:if test="${!status.last}">, </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>${pizza.quantity}</td>
                                        <td>${pizza.method}</td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <c:if test="${!pizza.isFavorite}">
                                                    <form action="${pageContext.request.contextPath}/pizzas/set-favorite/${pizza.id}" method="post" style="display:inline;">
                                                        <button class="btn btn-warning btn-sm action-btn" title="Mark as Favorite">
                                                            <i class="far fa-star"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <form action="${pageContext.request.contextPath}/pizzas/reorder/${pizza.id}" method="post" style="display:inline;">
                                                    <button class="btn btn-success btn-sm action-btn" title="Reorder this Pizza">
                                                        <i class="fas fa-redo"></i>
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/pizzas/delete/${pizza.id}" method="post" style="display:inline;">
                                                    <button class="btn btn-danger btn-sm action-btn" title="Delete" onclick="return confirm('Are you sure you want to delete this order?');">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>