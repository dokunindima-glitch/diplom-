<%@ page pageEncoding="UTF-8" %>
<%@ page import="users.User" %>

<%
    User currentUser = (User) session.getAttribute("user");

    if (currentUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }


    String avatarUrl;
    if ("male".equalsIgnoreCase(currentUser.gender())) {
        avatarUrl = "https://avatars.mds.yandex.net/i?id=152bcc46b8648b19510ae343e86ca657e618e709-10250781-images-thumbs&n=13";
    } else if ("female".equalsIgnoreCase(currentUser.gender())) {
        avatarUrl = "https://avatars.mds.yandex.net/i?id=cd564e00fcdf71c718657c8886418abb_l-5877669-images-thumbs&n=13";
    } else {

        avatarUrl = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"; // это не картинка, поэтому ниже запасной вариант
        avatarUrl = "https://ui-avatars.com/api/?name=User&background=e9ecef&color=495057";
    }
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Профиль — GreenShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/avatar.css">
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
            <%
                String success = request.getParameter("success");
                if ("true".equals(success)) {
            %>
            <div class="alert alert-success text-center mt-3">Баланс успешно пополнен!</div>
            <%
                }
            %>
                <div class="profile-card">
                    <div class="d-flex align-items-start gap-4">

                        <div class="avatar">
                            <img src="<%= avatarUrl %>" alt="Аватар пользователя" />
                        </div>

                        <div>
                            <h2 class="mb-1"><%= currentUser.name() %> <%= currentUser.surname() %></h2>
                            <p class="text-muted mb-0">Клиент GreenShop</p>
                            <p class="text-secondary small"><%= currentUser.role() %></p>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Блок 1: Телефон и Пол -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label text-muted small">Телефон</label>
                                <div class="fw-bold"><%= currentUser.phone() != null ? currentUser.phone() : "Не указан" %></div>
                            </div>
                        </div>
                    </div>

                    <!-- Блок 2: Баланс -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label text-muted small">Баланс</label>
                                <div class="fw-bold text-success">
                                    <%= String.format("%.2f ₽", currentUser.balance()) %>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6"></div>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex gap-3">
                        <a href="index.jsp" class="btn btn-outline-secondary">Вернуться в магазин</a>
                        <a href="${pageContext.request.contextPath}/topup.jsp"
                               class="btn btn-success">
                                <i class="bi bi-wallet-fill me-2"></i>Пополнить баланс
                            </a>
                        <a href="logout" class="btn btn-danger text-white">Выйти из профиля</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>