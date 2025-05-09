<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Your Perfect Pizza</title>
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
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-light">HOME</a>
                    <a href="${pageContext.request.contextPath}/pizzas/new" class="btn btn-primary active">ORDER (${cartCount})</a>
                    <a href="${pageContext.request.contextPath}/account" class="btn btn-light">ACCOUNT</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-light">LOGOUT</a>
                </nav>
            </div>
        </div>

        <div class="pizza-header">
            <div class="container">
                <h1><i class="fas fa-pizza-slice pizza-icon"></i> Create Your Perfect Pizza</h1>
            </div>
        </div>

        <div class="pizza-row justify-content-center">
            <div class="pizza-col" style="max-width: 800px; margin: 0 auto;">
                <div class="pizza-form-container">
                    <form:form action="/pizzas/new" method="post" modelAttribute="pizza">
                        <div class="pizza-row">
                            <div class="pizza-col-6">
                                <div class="pizza-form-group">
                                    <form:label path="method">
                                        <i class="fas fa-shopping-bag pizza-icon"></i> Order Method
                                    </form:label>
                                    <form:select path="method" class="pizza-form-control pizza-select">
                                        <form:option value="" label="-- Select Method --" />
                                        <form:option value="CarryOut">Carry Out</form:option>
                                        <form:option value="Delivery">Delivery</form:option>
                                    </form:select>
                                    <form:errors path="method" class="pizza-error" />
                                </div>
                            </div>
                            <div class="pizza-col-6">
                                <div class="pizza-form-group">
                                    <form:label path="size">
                                        <i class="fas fa-ruler pizza-icon"></i> Size
                                    </form:label>
                                    <form:select path="size" class="pizza-form-control pizza-select">
                                        <form:option value="" label="-- Select Size --" />
                                        <form:option value="Small">Small</form:option>
                                        <form:option value="Medium">Medium</form:option>
                                        <form:option value="Large">Large</form:option>
                                    </form:select>
                                    <form:errors path="size" class="pizza-error" />
                                </div>
                            </div>
                        </div>

                        <div class="pizza-row">
                            <div class="pizza-col-6">
                                <div class="pizza-form-group">
                                    <form:label path="crust">
                                        <i class="fas fa-bread-slice pizza-icon"></i> Crust
                                    </form:label>
                                    <form:select path="crust" class="pizza-form-control pizza-select">
                                        <form:option value="" label="-- Select Crust --" />
                                        <form:option value="Thin Crust">Thin Crust</form:option>
                                        <form:option value="Regular">Regular</form:option>
                                        <form:option value="Thick">Thick</form:option>
                                    </form:select>
                                    <form:errors path="crust" class="pizza-error" />
                                </div>
                            </div>
                            <div class="pizza-col-6">
                                <div class="pizza-form-group">
                                    <form:label path="quantity">
                                        <i class="fas fa-sort-numeric-up pizza-icon"></i> Quantity
                                    </form:label>
                                    <form:input path="quantity" type="number" min="1" class="pizza-form-control" placeholder="How many pizzas?" />
                                    <form:errors path="quantity" class="pizza-error" />
                                </div>
                            </div>
                        </div>

                        <div class="pizza-divider"></div>

                        <div class="pizza-form-group">
                            <form:label path="toppings">
                                <i class="fas fa-cheese pizza-icon"></i> Toppings
                            </form:label>
                            <div class="pizza-toppings-container">
                                <form:select path="toppings" multiple="true" class="pizza-form-control pizza-select">
                                    <form:option value="Cheese">Cheese</form:option>
                                    <form:option value="Pepperoni">Pepperoni</form:option>
                                    <form:option value="Mushrooms">Mushrooms</form:option>
                                    <form:option value="Onions">Onions</form:option>
                                    <form:option value="Sausage">Sausage</form:option>
                                    <form:option value="Bacon">Bacon</form:option>
                                    <form:option value="Olives">Olives</form:option>
                                    <form:option value="Green Peppers">Green Peppers</form:option>
                                </form:select>
                                <div class="pizza-toppings-hint">Hold Ctrl/Cmd to select multiple toppings</div>
                                <form:errors path="toppings" class="pizza-error" />
                            </div>
                        </div>

                        <div class="pizza-divider"></div>

                        <div class="pizza-form-group">
                            <label class="pizza-checkbox-container">
                                <i class="far fa-heart pizza-icon"></i> Mark as Favorite
                                <form:checkbox path="isFavorite" />
                                <span class="pizza-checkbox"></span>
                            </label>
                        </div>

                        <div style="text-align: center; margin-top: 30px;">
                            <button type="submit" class="pizza-submit-btn">
                                <i class="fas fa-check-circle pizza-icon"></i> Create Pizza
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
    $(document).ready(function() {
        // Add 3D hover effects
        $('.pizza-form-container').on('mousemove', function(e) {
            const $this = $(this);
            const boundingRect = this.getBoundingClientRect();
            const mouseX = e.clientX - boundingRect.left;
            const mouseY = e.clientY - boundingRect.top;
            
            const centerX = boundingRect.width / 2;
            const centerY = boundingRect.height / 2;
            
            const moveX = (mouseX - centerX) / 30;
            const moveY = (mouseY - centerY) / 30;
            
            $this.css('transform', `perspective(1000px) rotateX(${-moveY}deg) rotateY(${moveX}deg) translateZ(10px)`);
        });
        
        $('.pizza-form-container').on('mouseleave', function() {
            $(this).css('transform', 'perspective(1000px) rotateX(0) rotateY(0) translateZ(0)');
        });
        
        // Enhanced select animations
        $('.pizza-select').on('focus', function() {
            $(this).parent().siblings('label').find('.pizza-icon').css({
                'transform': 'perspective(500px) rotateY(30deg) translateZ(20px) scale(1.2)',
                'filter': 'drop-shadow(4px 4px 4px rgba(0,0,0,0.25))'
            });
        });
        
        $('.pizza-select').on('blur', function() {
            $(this).parent().siblings('label').find('.pizza-icon').css({
                'transform': 'perspective(500px) rotateY(5deg)',
                'filter': 'drop-shadow(2px 2px 2px rgba(0,0,0,0.15))'
            });
        });
        
        // Submit button effect
        $('.pizza-submit-btn').on('mouseenter', function() {
            $(this).find('.pizza-icon').css('transform', 'rotate(10deg) scale(1.2) translateZ(15px)');
        });
        
        $('.pizza-submit-btn').on('mouseleave', function() {
            $(this).find('.pizza-icon').css('transform', 'translateZ(5px)');
        });
    });
    </script>
</body>
</html>