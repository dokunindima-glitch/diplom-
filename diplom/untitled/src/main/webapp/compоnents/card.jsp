<%@ page pageEncoding="UTF-8" %>
<%@ page import="users.User" %>
<%
    User currentUser = (User) session.getAttribute("user");

    boolean isAdmin = false;
    if (currentUser != null) {

        isAdmin = "ADMIN".equals(currentUser.role().toUpperCase());
    }
%>

<% if (isAdmin) { %>
    <div class="text-center mt-5">
        <a href="<%= request.getContextPath() %>/admin/products"
           class="btn btn-lg btn-warning text-dark">
           🛠 Панель администратора: Редактор товаров
        </a>
    </div>
<% } %>


<div id="product-grid" class="row g-4">
</div>
<div id="productModal" class="modal fade" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">

                <h5 class="modal-title" id="modalProductName">Название товара</h5>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">

                        <img id="modalProductImage" src="" class="img-fluid rounded" alt="Товар">
                    </div>
                    <div class="col-md-6">
                        <p class="text-muted small mb-2">Категория: <span id="modalProductCategory">—</span></p>
                        <hr>
                        <p id="modalProductDescription" class="text-muted">Описание товара...</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" id="addToCartFromModalBtn">Для выхода нажмите esc </button>
            </div>
        </div>
    </div>
</div>
