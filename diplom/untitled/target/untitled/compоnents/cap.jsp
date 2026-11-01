<%@ page pageEncoding="UTF-8" %>
<%@ page import="Users.User" %>
<%
    // 1. Проверяем, есть ли пользователь в сессии
    Object userObj = session.getAttribute("user");
    boolean isLoggedIn = (userObj != null);

    String firstName = "";
    String lastName = "";

    if (isLoggedIn) {
        // 2. Приводим к типу User (твой record класс)
        // Важно: имя класса User должно совпадать с тем, что ты создал
        User currentUser = (User) userObj;

        // 3. Получаем данные.
        // Если User - это record с полями name/surname:
        firstName = currentUser.name();
        lastName = currentUser.surname();

        // Если вдруг ты переименовал поля в firstName/lastName, используй currentUser.firstName()
    }
%>

<header class="bg-white shadow-sm sticky-top py-3">
  <div class="container">
    <div class="d-flex align-items-center justify-content-between">
      <a href="index.jsp" class="fw-bold fs-4 text-success text-decoration-none">
        GreenShop
      </a>

      <form class="d-flex w-50 me-3" onsubmit="event.preventDefault()">
        <input id="headerSearchInput" class="form-control me-2" type="search" placeholder="Поиск товаров..." aria-label="Поиск">

      </form>

      <div class="d-flex align-items-center gap-3">
        <% if (isLoggedIn) { %>
    <a href="profile.jsp" class="text-decoration-none d-flex align-items-center gap-2">
    <i class="bi bi-person-circle fs-4"></i>
    <span class="fw-semibold"><%= firstName %> <%= lastName %></span>
    </a>
    <a href="logout" class="text-decoration-none text-danger d-flex align-items-center gap-1">
    <i class="bi bi-box-arrow-right fs-4"></i>
    <span class="small">Выйти</span>
    </a>
        <% } else { %>
          <!-- КНОПКА ВХОДА (если НЕ вошел) -->
          <a href="#" class="text-decoration-none" data-bs-toggle="modal" data-bs-target="#loginModal">
            <i class="bi bi-person-circle fs-4 text-primary"></i>
            <span class="ms-1 fw-semibold">Войти</span>
          </a>
        <% } %>

        <a href="#" class="text-decoration-none position-relative">
          <i class="bi bi-cart-fill fs-4"></i>
          <span id="cart-count" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">0</span>
        </a>
      </div>
    </div>
  </div>
</header>

<!-- Начало модального окна -->
<div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="loginModalLabel">Авторизация</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <ul class="nav nav-tabs mb-3" id="authTabs" role="tablist">
          <li class="nav-item">
            <button class="nav-link active" id="login-tab" data-bs-toggle="tab" data-bs-target="#tab-login" type="button">Вход</button>
          </li>
        </ul>
        <div class="tab-content" id="authTabsContent">
          <div class="tab-pane fade show active" id="tab-login">
            <!-- ИСПРАВЛЕНО: action="login" вместо сложного выражения -->
            <form id="loginForm" action="login" method="post">
              <div class="mb-3">
                <label for="loginPhone" class="form-label">Телефон</label>
                <input type="text" class="form-control" id="loginPhone" name="phone" placeholder="+7999..." required>
              </div>
              <div class="mb-3">
                <label for="loginPassword" class="form-label">Пароль</label>
                <input type="password" class="form-control" id="loginPassword" name="password" required>
              </div>
              <div id="loginError" class="text-danger small mb-3 d-none"></div>
              <button type="submit" class="btn btn-primary w-100">Войти</button>
              <p class="small text-center mt-3">
                Нет аккаунта?
                <a href="register.jsp" class="text-primary text-decoration-none fw-bold">Зарегистрироваться</a>
              </p>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="script/script.js"></script>

<script>
  function handleHeaderSearch() {
    const query = document.getElementById('headerSearchInput').value.trim();
    if (!query) return;
    window.location.href = 'search?q=' + encodeURIComponent(query);
  }
</script>