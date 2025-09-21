<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css"> <!-- your CSS file -->
</head>
<body>
    <div class="cart-container">
        <h1>Your Shopping Cart</h1>

        
            <p>Your cart is empty. <a href="<%=request.getContextPath() %>">Go Shopping</a></p>
                <div class="product-card-horizontal">
                    <img src="" alt="">
                    <div class="product-info">
                        <h3></h3>
                        <p>Price: </p>
                        <p>Quantity:</p>
                        <p>Subtotal:</p>
                    </div>
                    <form action="updateCart" method="post" style="margin-left:auto;">
                        <input type="hidden" name="productId" value="">
                        <input type="number" name="quantity" min="1" value="">
                        <button type="submit">Update</button>
                    </form>
                    <form action="removeFromCart" method="post">
                        <input type="hidden" name="productId" value="">
                        <button type="submit">Remove</button>
                    </form>
                </div>

            <div class="cart-total">
                <h2>Total:</h2>
                <form action="checkout.jsp" method="get">
                    <button type="submit">Proceed to Checkout</button>
                </form>
            </div>
    </div>
</body>
</html>
