<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Pizza</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Fonts and CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pizza-styles.css">
</head>
<body>
    <div class="header">
        <h1>PIZZA PETE'S</h1>
    </div>

    <div class="container pizza-container">
        <div class="pizza-header">
            <h1><i class="fas fa-edit pizza-icon"></i> Edit Your Pizza</h1>
        </div>

        <div class="pizza-row justify-content-center">
            <div class="pizza-col" style="max-width: 800px; margin: 0 auto;">
                <div class="pizza-form-container">
                    <form:form action="/pizzas/update/${pizza.id}" method="post" modelAttribute="pizza">
                        <div class="pizza-row">
                            <!-- Method -->
                            <div class="pizza-col-6">
                                <div class="pizza-form-group">
                                    <form:label path="method">
                                        <i class="fas fa-shopping-bag pizza-icon"></i> Order Method
                                    </form:label>
                                    <form:select path="method" class="pizza-form-control pizza-select">
                                        <form:option value="CarryOut">Carry Out</form:option>
                                        <form:option value="Delivery">Delivery</form:option>
                                    </form:select>
                                    <form:errors path="method" class="pizza-error" />
                                </div>
                            </div>
                            <!-- Size -->
                            <div class="pizza-col-6">
                                <div class="pizza-form-group">
                                    <form:label path="size">
                                        <i class="fas fa-ruler pizza-icon"></i> Size
                                    </form:label>
                                    <form:select path="size" class="pizza-form-control pizza-select">
                                        <form:option value="Small">Small</form:option>
                                        <form:option value="Medium">Medium</form:option>
                                        <form:option value="Large">Large</form:option>
                                    </form:select>
                                    <form:errors path="size" class="pizza-error" />
                                </div>
                            </div>
                        </div>

                        <!-- Crust & Quantity -->
                        <div class="pizza-row">
                            <div class="pizza-col-6">
                                <div class="pizza-form-group">
                                    <form:label path="crust">
                                        <i class="fas fa-bread-slice pizza-icon"></i> Crust
                                    </form:label>
                                    <form:select path="crust" class="pizza-form-control pizza-select">
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
                                    <form:input path="quantity" type="number" min="1" class="pizza-form-control" />
                                    <form:errors path="quantity" class="pizza-error" />
                                </div>
                            </div>
                        </div>

                        <!-- Toppings -->
                        <div class="pizza-divider"></div>
                        <div class="pizza-form-group">
                            <form:label path="toppings">
                                <i class="fas fa-cheese pizza-icon"></i> Toppings
                            </form:label>
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
                            <div class="pizza-toppings-hint">Hold Ctrl/Cmd to select multiple</div>
                            <form:errors path="toppings" class="pizza-error" />
                        </div>

                        <!-- Favorite -->
                        <div class="pizza-form-group">
                            <label class="pizza-checkbox-container">
                                <i class="far fa-heart pizza-icon"></i> Mark as Favorite
                                <form:checkbox path="isFavorite" />
                                <span class="pizza-checkbox"></span>
                            </label>
                        </div>

                        <!-- Submit -->
                        <div style="text-align: center; margin-top: 30px;">
                            <button type="submit" class="pizza-submit-btn">
                                <i class="fas fa-save pizza-icon"></i> Save Changes
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>

    <!-- JS (same as createPizza.jsp) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Same animation logic from createPizza.jsp
    </script>
</body>
</html>
