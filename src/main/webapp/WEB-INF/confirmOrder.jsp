<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Confirm Your Order - Pizza Pete's</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Keep your existing styles.css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <!-- Add the enhanced pizza-specific styles -->
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
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-light">HOME</a>
                    <a href="${pageContext.request.contextPath}/pizzas/new" class="btn btn-primary active">ORDER (${cartCount})</a>
                    <a href="${pageContext.request.contextPath}/account" class="btn btn-light">ACCOUNT</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-light">LOGOUT</a>
                </nav>
            </div>
        </div>

        <h1><i class="fas fa-pizza-slice pizza-icon"></i> Your Order</h1>

        <div class="order-summary">
            <h2 class="order-header">ORDER DETAILS</h2>
            
            <div class="order-detail">
                <span class="detail-label"><i class="fas fa-shopping-bag pizza-icon"></i> METHOD:</span>
                <span class="detail-value">${pizza.method}</span>
            </div>
            
            <!-- Show delivery details only if delivery method is selected -->
            <c:if test="${pizza.method == 'Delivery'}">
                <div class="delivery-details-section">
                    <h3 class="delivery-header">DELIVERY INFORMATION</h3>
                    
                    <div class="order-detail">
                        <span class="detail-label"><i class="fas fa-user pizza-icon"></i> NAME:</span>
                        <span class="detail-value">${pizza.user.firstName} ${pizza.user.lastName}</span>
                    </div>
                    
                    <div class="order-detail">
                        <span class="detail-label"><i class="fas fa-map-marker-alt pizza-icon"></i> ADDRESS:</span>
                        <span class="detail-value">${pizza.user.address}, ${pizza.user.city}, ${pizza.user.state}</span>
                    </div>
                </div>
            </c:if>
            
            <div class="order-detail">
                <span class="detail-label"><i class="fas fa-sort-numeric-up pizza-icon"></i> QTY:</span>
                <span class="detail-value">${pizza.quantity}</span>
            </div>
            
            <div class="order-detail">
                <span class="detail-label"><i class="fas fa-ruler pizza-icon"></i> SIZE:</span>
                <span class="detail-value">${pizza.size}</span>
            </div>
            
            <div class="order-detail">
                <span class="detail-label"><i class="fas fa-bread-slice pizza-icon"></i> CRUST:</span>
                <span class="detail-value">${pizza.crust}</span>
            </div>
            
            <div class="order-detail">
                <span class="detail-label"><i class="fas fa-cheese pizza-icon"></i> TOPPINGS:</span>
                <span class="detail-value">
                    <c:forEach items="${pizza.toppings}" var="topping" varStatus="status">
                        ${topping}<c:if test="${!status.last}">, </c:if>
                    </c:forEach>
                </span>
            </div>
            
            <div class="price-row">
                <span class="detail-label">PRICE:</span>
                <span class="detail-value">$<fmt:formatNumber value="${price}" pattern="#,##0.00" /></span>
            </div>
            
            <div class="total-row">
                <span class="detail-label">TOTAL:</span>
                <span class="detail-value">$<fmt:formatNumber value="${price}" pattern="#,##0.00" /></span>
            </div>
        </div>
        
        <div class="buttons-container">
            <form action="/pizzas/purchase" method="post">
                <button type="submit" class="btn-purchase">
                    <i class="fas fa-check-circle"></i> PURCHASE
                </button>
            </form>
            <a href="/pizzas/new" class="btn-cancel">
                <i class="fas fa-times-circle"></i> START OVER
            </a>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
    $(document).ready(function() {
        // Add 3D hover effects to the order summary box
        $('.order-summary').on('mousemove', function(e) {
            const $this = $(this);
            const boundingRect = this.getBoundingClientRect();
            const mouseX = e.clientX - boundingRect.left;
            const mouseY = e.clientY - boundingRect.top;
            
            const centerX = boundingRect.width / 2;
            const centerY = boundingRect.height / 2;
            
            const moveX = (mouseX - centerX) / 40;
            const moveY = (mouseY - centerY) / 40;
            
            $this.css('transform', `perspective(1000px) rotateX(${-moveY}deg) rotateY(${moveX}deg) translateZ(5px)`);
        });
        
        $('.order-summary').on('mouseleave', function() {
            $(this).css('transform', 'perspective(1000px) rotateX(0) rotateY(0) translateZ(0)');
        });
        
        // Button animations
        $('.btn-purchase').on('mouseenter', function() {
            $(this).find('i').css('transform', 'rotate(10deg) scale(1.2)');
        });
        
        $('.btn-purchase').on('mouseleave', function() {
            $(this).find('i').css('transform', 'rotate(0) scale(1)');
        });
        
        $('.btn-cancel').on('mouseenter', function() {
            $(this).find('i').css('transform', 'rotate(-10deg) scale(1.2)');
        });
        
        $('.btn-cancel').on('mouseleave', function() {
            $(this).find('i').css('transform', 'rotate(0) scale(1)');
        });
    });
    </script>
</body>
</html>