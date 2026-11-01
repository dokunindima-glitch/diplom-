<%@ page pageEncoding="UTF-8" %>
<section id="products" class="py-4">
    <div class="container">
      <!-- Панель фильтров -->
      <div class="row mb-4 align-items-center">
        <div class="col-auto ms-md-auto">
          <label class="form-label fw-bold me-2">Сортировка:</label>
          <select id="sortSelect" class="form-select d-inline-block w-auto ms-2">
            <option value="default">По умолчанию</option>
            <option value="price-asc">Цена: от низкой</option>
            <option value="price-desc">Цена: от высокой</option>
          </select>
        </div>
      </div>
 <!-- Сетка товаров -->
      <div id="product-grid" class="row g-4"></div>
    </div>
  </section>