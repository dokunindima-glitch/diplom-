<%@ page pageEncoding="UTF-8" %>
<%@ page import="Users.User" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Пополнение баланса — GreenShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>


    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="profile-card">
                    <h3 class="mb-4">Пополнение баланса</h3>
                    <p class="text-muted">Текущий баланс: <b><%= String.format("%.2f ₽", currentUser.balance()) %></b></p>

                    <!-- Форма пополнения -->
                    <form action="${pageContext.request.contextPath}/topup" method="post">
                        <div class="mb-3">
                            <label class="form-label">Сумма пополнения (₽)</label>
                            <input type="number" name="amount" class="form-control" step="0.01" min="1" required
                                   placeholder="Например, 500">
                        </div>
                        <button type="submit" class="btn btn-success w-100">Зачислить средства</button>
                    </form>

                    <hr class="my-4">
                    <a href="profile.jsp" class="btn btn-outline-secondary w-100">Назад в профиль</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>