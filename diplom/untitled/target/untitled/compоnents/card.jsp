<%@ page pageEncoding="UTF-8" %>
<div id="product-grid" class="row g-4">
    <!-- Сюда JS будет вставлять карточки -->
</div>

<!-- 2. Модальное окно (ИСПРАВЛЯЕТ ОШИБКУ "Cannot set properties of null") -->
<!-- Убедись, что все id внутри совпадают с теми, что в JS -->
<div id="productModal" class="modal fade" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <!-- ВАЖНО: id должен быть точно modalProductName -->
                <h5 class="modal-title" id="modalProductName">Название товара</h5>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <!-- ВАЖНО: id должен быть точно modalProductImage -->
                        <img id="modalProductImage" src="" class="img-fluid rounded" alt="Товар">
                    </div>
                    <div class="col-md-6">
                        <h4 class="text-success mb-3" id="modalProductPrice">0 ₽</h4>
                        <p class="text-muted small mb-2">Категория: <span id="modalProductCategory">—</span></p>
                        <p class="fw-bold mb-2">Наличие: <span id="modalProductQuantity">0 шт.</span></p>
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
