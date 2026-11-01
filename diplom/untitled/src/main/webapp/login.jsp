<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Вход</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container d-flex justify-content-center align-items-center min-vh-100">
    <div class="card shadow col-md-4 col-12">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">Вход в аккаунт</h4>
        </div>
        <div class="card-body p-4">

            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="alert alert-danger small"><%= error %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label for="loginPhone" class="form-label">Телефон</label>
                    <input type="tel" class="form-control" id="loginPhone" name="phone" required>
                </div>
                <div class="mb-3">
                    <label for="loginPassword" class="form-label">Пароль</label>
                    <input type="password" class="form-control" id="loginPassword" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Войти</button>
            </form>

            <hr class="my-4">
            <p class="text-center small">
                Нет аккаунта? <a href="${pageContext.request.contextPath}/register.jsp">Зарегистрироваться</a>
            </p>
        </div>
    </div>
</div>
</body>
</html>