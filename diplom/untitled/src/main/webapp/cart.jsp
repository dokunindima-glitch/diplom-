<%@ page pageEncoding="UTF-8" %>
<%@ page import="products.ProductService" %>
<%@ page import="products.Product" %>
<%@ page import="java.util.Optional" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Корзина покупок</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .cart-item-row { border-bottom: 1px solid #eee; padding: 15px 0; }
        .cart-total-box { background-color: #f8f9fa; padding: 20px; border-radius: 8px; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-4">
    <h2 class="mb-4 text-primary">Ваша корзина</h2>

    <%

        List<Integer> cartIds = (List<Integer>) session.getAttribute("cart");


        ProductService productService = new ProductService();
        double totalPrice = 0.0;


        if (cartIds == null || cartIds.isEmpty()) {
    %>
        <div class="alert alert-info text-center">
            Корзина пуста. Добавьте товары, чтобы оформить заказ!
        </div>
        <div class="text-center">
            <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-outline-primary btn-lg">
                Перейти в каталог
            </a>
        </div>
    <%
        } else {

            for (Integer id : cartIds) {
                Optional<Product> productOpt = productService.getById(id);

                if (productOpt.isPresent()) {
                    Product p = productOpt.get();

                    String name = p.name();
                    double price = p.price();
                    int quantity = 1;

                    double itemTotal = price * quantity;
                    totalPrice += itemTotal;
    %>
            <div class="row cart-item-row align-items-center" data-product-id="<%= id %>">
                <div class="col-md-4">
                    <h5 class="mb-1"><%= name %></h5>
                    <small class="text-muted">ID: <%= id %></small>
                </div>

                <div class="col-md-3 text-end">
                    <span class="badge bg-secondary">Цена за шт.</span>

                  <h5 class="text-success fw-bold">
                      <span class="unit-price"><%= price %> ₽</span>
                  </h5>
                </div>




            </div>
    <%
                } else {
                    out.println("<div class='row p-3 border-bottom'><div class='col-12 text-danger'>Товар с ID " + id + " не найден.</div></div>");
                }
            }
    %>
        <!-- Блок итоговой суммы -->
        <div class="row mt-4">
            <div class="col-md-8 offset-md-4">
                <div class="card cart-total-box">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="m-0">Общая сумма заказа:</h3>

                            <h3 class="m-0 text-success cart-total-amount"><%= totalPrice %> ₽</h3>
                        </div>
                        <hr>
                        <%

                            boolean isLoggedIn = session.getAttribute("user") != null;
                        %>

                        <% if (isLoggedIn) { %>
                            <!-- КНОПКА ДЛЯ ЗАРЕГИСТРИРОВАННЫХ -->
                            <button type="button" class="btn btn-success btn-lg w-100" id="checkout-btn" onclick="confirmCheckout()">
                                Оформить заказ
                            </button>
                            <p class="text-muted small mt-2 text-center">Переход к оформлению доставки и оплаты.</p>
                        <% } else { %>
                            <!-- КНОПКА ДЛЯ НЕЗАРЕГИСТРИРОВАННЫХ -->
                            <a href="register.jsp" class="btn btn-outline-primary btn-lg w-100">
                                Зарегистрироваться для оформления заказа
                            </a>
                            <p class="text-muted small mt-2 text-center">Нужна учетная запись, чтобы сохранить историю заказов.</p>
                        <% } %>

                        <a href="index.jsp" class="d-block text-center mt-3 text-decoration-none">
                            Продолжить покупки
                        </a>
                    </div>
                </div>
            </div>
        </div>
    <%
        }
    %>
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/script/cart.js"></script>
</body>
</html>