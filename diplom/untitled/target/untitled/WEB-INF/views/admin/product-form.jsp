<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>\${mode == 'edit' ? 'Редактировать товар' : 'Добавить товар'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <h2 class="mb-4">\${mode == 'edit' ? 'Редактирование товара' : 'Новый товар'}</h2>

    <!-- Блок ошибок -->
    <c:if test="\${not empty error}">
        <div class="alert alert-danger">\${error}</div>
    </c:if>

    <form action="\${pageContext.request.contextPath}/admin/products" method="post" class="card p-4 shadow-sm">
        <!-- Скрытое поле для режима и ID -->
        <input type="hidden" name="mode" value="\${mode != null ? mode : 'create'}">
        <c:if test="\${not empty product}">
            <input type="hidden" name="id" value="\${product.id}">
        </c:if>

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Название</label>
                <input type="text" name="name" class="form-control"
                       value="\${not empty product ? product.name : ''}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Цена (₽)</label>
                <input type="number" step="0.01" name="price" class="form-control"
                       value="\${not empty product ? product.price : ''}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Категория</label>
                <select name="category" class="form-select">
                    <option value="гигиена" \${not empty product && product.category == 'гигиена' ? 'selected' : ''}>Гигиена</option>
                    <option value="аксессуары" \${not empty product && product.category == 'аксессуары' ? 'selected' : ''}>Аксессуары</option>
                    <option value="дом" \${not empty product && product.category == 'дом' ? 'selected' : ''}>Дом</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">Количество (шт)</label>
                <input type="number" name="quantity" class="form-control"
                       value="\${not empty product ? product.quantity : ''}" required>
            </div>
            <div class="col-12">
                <label class="form-label">Ссылка на изображение</label>
                <input type="url" name="image" class="form-control"
                       placeholder="https://example.com/image.jpg"
                       value="\${not empty product ? product.image_url : ''}">
                <small class="text-muted">Вставьте прямую ссылку на картинку (не файл)</small>
            </div>
            <div class="col-12">
                <label class="form-label">Описание</label>
                <textarea name="description" class="form-control" rows="4"
                          placeholder="Описание товара...">\${not empty product ? product.description : ''}</textarea>
            </div>
        </div>

        <div class="mt-4 d-flex gap-2">
            <button type="submit" class="btn btn-success">\${mode == 'edit' ? 'Сохранить изменения' : 'Добавить товар'}</button>
            <a href="\${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Отмена</a>
        </div>
    </form>
</div>
</body>
</html>