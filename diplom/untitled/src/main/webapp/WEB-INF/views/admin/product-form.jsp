<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, products.Product" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <!-- Объявляем переменные ОДИН РАЗ здесь, чтобы они были видны во всем файле -->
    <%
        String mode = (String) request.getAttribute("mode");
        Product product = (Product) request.getAttribute("product");

        String pageTitle = "edit".equals(mode) ? "Редактирование товара" : "Новый товар";
    %>
    <title><%= pageTitle %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-4">
    <!-- Заголовок (используем уже объявленную переменную mode) -->
    <h2 class="mb-4"><%= pageTitle %></h2>

    <!-- Форма -->
    <form action="<%= request.getContextPath() %>/admin/products" method="post">

        <!-- Скрытое поле для режима -->
        <input type="hidden" name="mode" value="<%= mode != null ? mode : "new" %>">

        <!-- Если режим edit, передаем ID товара -->
        <%
            if (product != null) {
        %>
            <input type="hidden" name="id" value="<%= product.id() %>">
        <%
            }
        %>

        <div class="row">
            <!-- Название -->
            <div class="col-md-6 mb-3">
                <label class="form-label">Название</label>
                <input type="text" name="name" class="form-control"
                       value="<%= product != null ? product.name() : "" %>" required>
            </div>

            <!-- Цена -->
            <div class="col-md-6 mb-3">
                <label class="form-label">Цена (₽)</label>
                <input type="number" step="0.01" name="price" class="form-control"
                       value="<%= product != null ? product.price() : "" %>" required>
            </div>
        </div>

        <div class="row">
            <!-- Категория -->
            <div class="col-md-6 mb-3">
                <label class="form-label">Категория</label>
                <select name="category" class="form-select" required>
                    <option value="" disabled selected>Выберите категорию</option>
                    <option value="all">Все категории</option>
                    <option value="Гигиена" <%= product != null && "Гигиена".equals(product.category()) ? "selected" : "" %>>Гигиена</option>
                    <option value="Дом" <%= product != null && "Дом".equals(product.category()) ? "selected" : "" %>>Дом</option>
                    <option value="Спорт" <%= product != null && "Спорт".equals(product.category()) ? "selected" : "" %>>Спорт</option>
                    <option value="Аксессуары" <%= product != null && "Аксессуары".equals(product.category()) ? "selected" : "" %>>Аксессуары</option>
                    <option value="Хранение" <%= product != null && "Хранение".equals(product.category()) ? "selected" : "" %>>Хранение</option>
                </select>
            </div>

            <!-- Количество -->
            <div class="col-md-6 mb-3">
                <label class="form-label">Количество (шт)</label>
                <input type="number" name="quantity" class="form-control"
                       value="<%= product != null ? product.quantity() : "" %>" required>
            </div>
        </div>

        <!-- Ссылка на изображение -->
        <div class="mb-3">
            <label class="form-label">Ссылка на изображение</label>
            <input type="url" name="image_url" class="form-control"
                   placeholder="Вставьте прямую ссылку на картинку"
                   value="<%= product != null ? product.image_url() : "" %>">
            <div class="form-text">Вставьте прямую ссылку на картинку (не файл)</div>
        </div>

        <!-- Описание -->
        <div class="mb-3">
            <label class="form-label">Описание</label>
            <textarea name="description" class="form-control" rows="4"
                      placeholder="Описание товара"><%= product != null ? product.description() : "" %></textarea>
        </div>

        <!-- Кнопки -->
        <div class="d-flex justify-content-between align-items-center mt-4">

            <!-- Основное действие: Сохранить / Добавить -->
            <div>
                <button type="submit" class="btn btn-success">
                    <%
                        if ("edit".equals(mode)) {
                    %>
                        Сохранить изменения
                    <%
                        } else {
                    %>
                        Добавить товар
                    <%
                        }
                    %>
                </button>
            </div>

            <!-- Навигация и Отмена (все кнопки одинакового размера за счёт btn-sm) -->
            <div class="d-flex gap-2 align-items-center">
                <a href="<%= request.getContextPath() %>/admin/products?view=list"
                   class="btn btn-sm btn-outline-secondary">
                   📋 Список товаров
                </a>
                <a href="<%= request.getContextPath() %>/" class="btn btn-sm btn-outline-primary">
                    🏠 На главную
                </a>
                <a href="<%= request.getContextPath() %>/admin/products" class="btn btn-sm btn-secondary">
                    Отмена
                </a>
            </div>
        </div>
    </form>
</div>

</body>
</html>