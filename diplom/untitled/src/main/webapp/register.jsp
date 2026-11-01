<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Регистрация</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container d-flex justify-content-center align-items-center min-vh-100">
    <div class="card shadow col-md-5 col-12">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">Регистрация</h4>
        </div>
        <div class="card-body p-4">

            <!-- Блок вывода ошибок -->
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="alert alert-danger small"><%= error %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="regName" class="form-label">Имя</label>
                        <input type="text" class="form-control" id="regName" name="name" required placeholder="Иван">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="regSurname" class="form-label">Фамилия</label>
                        <input type="text" class="form-control" id="regSurname" name="surname" required placeholder="Иванов">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Пол</label>
                    <div class="btn-group w-100" role="group">
                        <button type="button" class="btn btn-outline-primary w-50 active"
                                data-val="male" name="genderBtn" onclick="setGender(this)">Мужской</button>
                        <button type="button" class="btn btn-outline-primary w-50"
                                data-val="female" name="genderBtn" onclick="setGender(this)">Женский</button>
                    </div>
                    <!-- Скрытое поле для отправки значения на сервер -->
                    <input type="hidden" id="regGender" name="gender" value="male">
                </div>

                <div class="mb-3">
                    <label for="regPhone" class="form-label">Телефон</label>

                    <input type="tel"
                           class="form-control"
                           id="regPhone"
                           name="phone"
                           required
                           placeholder="+7 (999) 000-00-00"
                           oninput="formatPhone(this)">

                    <div id="phoneError" class="text-danger small mt-1 d-none">Номер должен содержать 11 цифр</div>
                </div>

                <div class="mb-3">
                    <label for="regPassword" class="form-label">Пароль (4–8 символов)</label>
                    <input type="password" class="form-control" id="regPassword" name="password"
                           required minlength="4" maxlength="8"
                           placeholder="от 4 до 8 символов">
                </div>

                <div class="mb-4">
                    <label for="confirmPassword" class="form-label">Повтор пароля</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                           required minlength="4" maxlength="8"
                           oninput="checkPasswordMatch()">
                    <div id="passwordError" class="text-danger small mt-1 d-none">Пароли не совпадают</div>
                </div>

                <button type="submit" class="btn btn-success w-100" id="submitBtn">Зарегистрироваться</button>
            </form>

            <hr class="my-4">
            <p class="text-center small">
                Уже есть аккаунт? <a href="${pageContext.request.contextPath}/login.jsp" class="text-primary fw-bold">Войти</a>
            </p>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/script/auth.js"></script>
</body>
</html>