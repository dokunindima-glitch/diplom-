<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, products.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Управление товарами</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Товары магазина</h2>
        <!-- Кнопка "Добавить новый" -->
        <a href="<%= request.getContextPath() %>/admin/products" class="btn btn-primary">
            + Добавить новый
        </a>
    </div>

    <!-- Блок вывода ошибки -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null && !error.isEmpty()) {
    %>
        <div class="alert alert-danger"><%= error %></div>
    <%
        }
    %>

    <table class="table table-white table-hover align-middle">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Название</th>
                <th>Категория</th>
                <th>Цена</th>
                <th>Кол-во</th>
                <th>Действия</th>
            </tr>
        </thead>
        <tbody>
            <%
                @SuppressWarnings("unchecked")
                List<Product> products = (List<Product>) request.getAttribute("products");

                if (products == null || products.isEmpty()) {
            %>
                <tr>
                    <td colspan="6" class="text-center py-4">Товаров нет</td>
                </tr>
            <%
                } else {
                    for (Product p : products) {
            %>
                <tr>
                    <!-- ДЛЯ RECORD: используем p.id(), p.name(), а не p.getId() -->
                    <td><%= p.id() %></td>
                    <td><%= p.name() %></td>
                    <td><span class="badge bg-info text-dark"><%= p.category() %></span></td>
                    <td><%= p.price() %> ₽</td>
                    <td><%= p.quantity() %></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/admin/products?action=edit&id=<%= p.id() %>"
                           class="btn btn-sm btn-warning me-1">
                            ✏️ Редактировать
                        </a>
                        <button type="button" class="btn btn-sm btn-danger"
                                onclick="if(confirm('Удалить товар?')) window.location.href='<%= request.getContextPath() %>/admin/products?action=delete&id=<%= p.id() %>'">
                            🗑️ Удалить
                        </button>
                    </td>
                </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
</div>
</body>
</html>