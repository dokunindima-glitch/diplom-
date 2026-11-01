console.log('✅ Скрипт загружен и выполняется!');

document.addEventListener('DOMContentLoaded', () => {
  const grid = document.getElementById('product-grid');
  const cartCountEl = document.getElementById('cart-count');
  const categoryFilter = document.getElementById('categoryFilter');
  const sortSelect = document.getElementById('sortSelect');
  const headerSearchInput = document.getElementById('headerSearchInput');

  // Элементы модального окна
  const modalEl = document.getElementById('productModal');
  const modalName = document.getElementById('modalProductName');
  const modalImage = document.getElementById('modalProductImage');
  const modalCategory = document.getElementById('modalProductCategory');
  const modalPrice = document.getElementById('modalProductPrice');
  const modalQuantity = document.getElementById('modalProductQuantity');
  const modalDescription = document.getElementById('modalProductDescription');
  const addToCartFromModalBtn = document.getElementById('addToCartFromModalBtn');

  if (!grid) {
    console.error('❌ Ошибка: элемент #product-grid не найден. Проверьте HTML/JSP.');
    return;
  }

  let products = [];
  let cart = [];
   let currentProductId = null;
    let bsModalInstance = null;

    if (typeof bootstrap !== 'undefined' && modalEl) {
      bsModalInstance = new bootstrap.Modal(modalEl, { backdrop: 'static', keyboard: true });
      console.log('✅ Bootstrap Modal успешно инициализирован.');
    } else if (modalEl) {
      console.warn('⚠️ Bootstrap не найден. Модалка будет работать на чистом JS.');
    }

  async function loadProductsFromServer() {
    try {
      const response = await fetch('/untitled/api/products');
      if (!response.ok) throw new Error(`HTTP ошибка: ${response.status}`);
      products = await response.json();
      console.log(`✅ Загружено товаров: ${products.length}`);
      renderProducts(products);
    } catch (error) {
      console.error('❌ Ошибка загрузки товаров:', error);
      grid.innerHTML = '<div class="col-12 text-center py-5 alert alert-danger">Не удалось загрузить товары. Проверьте консоль.</div>';
    }
  }

  function searchProducts(items, query) {
    if (!query || !query.trim()) return items;
    const q = query.toLowerCase();
    return items.filter(p => p.name && p.name.toLowerCase().includes(q));
  }

  function filterProducts(items) {
    if (!categoryFilter) return items;
    const category = categoryFilter.value;
    if (category === 'all') return items;
    return items.filter(p => p.category === category);
  }

  function sortProducts(items) {
    if (!sortSelect) return items;
    const sort = sortSelect.value;
    const copy = [...items];
    if (sort === 'default' || !sort) return copy;

    if (sort === 'price-asc') {
      return copy.sort((a, b) => (a.price ?? 0) - (b.price ?? 0));
    } else if (sort === 'price-desc') {
      return copy.sort((b, a) => (b.price ?? 0) - (a.price ?? 0));
    } else if (sort === 'name-asc') {
      return copy.sort((a, b) => (a.name || '').localeCompare(b.name || ''));
    }
    return copy;
  }

  function getFilteredAndSortedProducts() {
    const query = headerSearchInput ? headerSearchInput.value : '';
    let result = searchProducts(products, query);
    result = filterProducts(result);
    result = sortProducts(result);
    return result;
  }

  function renderProducts(items) {
    grid.innerHTML = '';
    if (!items || items.length === 0) {
      grid.innerHTML = '<div class="col-12 text-center py-5 text-muted">Товары не найдены</div>';
      return;
    }

    items.forEach(p => {
      const safeId = p.id ?? 0;
      const safeName = p.name ?? 'Товар без названия';
      const safePrice = (p.price !== undefined && p.price !== null) ? p.price : 0;
      const safeCategory = p.category ?? 'Разное';
      const safeImage = p.image_url ?? p.image ?? 'https://via.placeholder.com/300?text=No+Image';
      const safeQuantity = (p.quantity !== undefined && p.quantity !== null)
        ? parseInt(p.quantity, 10)
        : 0;
      const safeDescription = p.description ?? '';

      let buttonHtml = '';
      let stockStatus = '';

      if (safeQuantity > 0) {
        buttonHtml = `<button class="btn btn-outline-success w-100 mt-2 add-to-cart-btn" data-id="${safeId}">В корзину</button>`;
        stockStatus = `<span class="small text-success fw-bold" style="display:block; margin-top:5px;">✅ Осталось: ${safeQuantity} шт.</span>`;
      } else {
        buttonHtml = `<button class="btn btn-secondary w-100 mt-2" disabled>Нет в наличии</button>`;
        stockStatus = `<span class="small text-danger fw-bold" style="display:block; margin-top:5px;">❌ Нет в наличии</span>`;
      }

      const card = document.createElement('div');
      card.className = 'col-md-4 col-sm-6 mb-4';

      card.innerHTML = `
        <div class="card h-100 product-card" data-id="${safeId}" role="button" tabindex="0" aria-label="${safeName}">
          <img src="${safeImage}" class="card-img-top" alt="${safeName}" style="height: 250px; object-fit: cover;">
          <div class="card-body d-flex flex-column">
            <span class="badge bg-light text-dark badge-price mb-2">${safePrice} ₽</span>
            <h5 class="card-title text-truncate" title="${safeName}">${safeName}</h5>
            <p class="card-text text-muted small mb-2">Категория: ${safeCategory}</p>
            ${stockStatus}
            ${buttonHtml}
          </div>
        </div>`;
      grid.appendChild(card);
    });
  }

  function updateCartUI() {
    if (cartCountEl) {
      cartCountEl.innerText = cart.length;
      console.log(`📦 Корзина обновлена: ${cart.length} товаров`);
    }
  }




 function openProductModal(product) {
     if (!modalEl) return;


     currentProductId = product.id;

     modalName.innerText = product.name;
     modalImage.src = product.image_url ?? product.image ?? 'https://via.placeholder.com/400?text=Нет+фото';
     modalCategory.innerText = product.category ?? '—';
     modalDescription.innerText = product.description ?? 'Описание отсутствует';


     if (typeof bootstrap !== 'undefined' && bsModalInstance) {
       bsModalInstance.show();
     } else if (typeof bootstrap !== 'undefined' && modalEl) {

        const fallbackModal = new bootstrap.Modal(modalEl, { backdrop: 'static', keyboard: true });
        fallbackModal.show();
     } else if (modalEl) {
       modalEl.style.display = 'block';
       document.body.classList.add('modal-open');
     }
   }


  async function addToCart(product) {
      const productId = product.id;


      const url = '/untitled/add-to-cart?id=' + productId;


      cart.push(product);
      updateCartUI();

      try {
        const response = await fetch(url, {
          method: 'GET',
          credentials: 'same-origin'
        });

        if (response.ok) {
          console.log('✅ Товар успешно добавлен на сервере:', product);
        } else {
          console.error('❌ Ошибка сервера при добавлении:', response.status);
        }
      } catch (error) {
        console.error('❌ Ошибка сети:', error);
      }
    }


   grid.addEventListener('click', (e) => {
      const btn = e.target.closest('.add-to-cart-btn');
      if (btn) {
        e.stopPropagation();
        const productId = parseInt(btn.dataset.id, 10);
        if (isNaN(productId)) return;
        const product = products.find(p => p.id === productId);
        if (!product) return;

        addToCart(product);

        btn.innerText = '✅ В корзине';
        btn.classList.remove('btn-outline-success');
        btn.classList.add('btn-success');
        btn.disabled = true;
        return;
      }

      const card = e.target.closest('.product-card');
      if (card) {
        const productId = parseInt(card.dataset.id, 10);
        if (isNaN(productId)) return;
        const product = products.find(p => p.id === productId);
        if (!product) return;
        openProductModal(product);
      }
    });


  if (categoryFilter) {
    categoryFilter.addEventListener('change', () => renderProducts(getFilteredAndSortedProducts()));
  }
  if (sortSelect) {
    sortSelect.addEventListener('change', () => renderProducts(getFilteredAndSortedProducts()));
  }
  if (headerSearchInput) {
    headerSearchInput.addEventListener('input', () => renderProducts(getFilteredAndSortedProducts()));
  }

  loadProductsFromServer();
});


  function updateCartUI() {
    if (cartCountEl) {
      cartCountEl.innerText = cart.length;
      console.log(`📦 Корзина обновлена: ${cart.length} товаров`);
    }
  }


 grid.addEventListener('click', (e) => {
     const btn = e.target.closest('.add-to-cart-btn');
     if (btn) {
       const productId = parseInt(btn.dataset.id, 10);
       if (isNaN(productId)) return;
       const product = products.find(p => p.id === productId);
       if (!product) return;

       addToCart(product);
       btn.innerText = '✅ В корзине';
       btn.classList.remove('btn-outline-success');
       btn.classList.add('btn-success');
       btn.disabled = true;
       return;
     }

     const card = e.target.closest('.product-card');
     if (card) {
       const productId = parseInt(card.dataset.id, 10);
       if (isNaN(productId)) return;
       const product = products.find(p => p.id === productId);
       if (!product) return;
       openProductModal(product);
     }
   });


  if (categoryFilter) {
    categoryFilter.addEventListener('change', () => renderProducts(getFilteredAndSortedProducts()));
  }
  if (sortSelect) {
    sortSelect.addEventListener('change', () => renderProducts(getFilteredAndSortedProducts()));
  }
  if (headerSearchInput) {
    headerSearchInput.addEventListener('input', () => renderProducts(getFilteredAndSortedProducts()));
  }


  loadProductsFromServer();


document.addEventListener('DOMContentLoaded', () => {
  const authLink = document.getElementById('auth-link');
  const loginModalEl = document.querySelector('#loginModal');

  if (!authLink || !loginModalEl) return;


  authLink.addEventListener('click', (e) => {
    e.preventDefault();
    const bsModal = new bootstrap.Modal(loginModalEl);
    bsModal.show();
  });


  const loginForm = document.getElementById('loginForm');
  if (loginForm) {
    loginForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      const phone = loginForm.phone.value.trim();
      const password = loginForm.password.value;
      const errorEl = document.getElementById('loginError');
      errorEl.textContent = '';
      errorEl.classList.remove('d-none');

      try {
        const res = await fetch('/untitled/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: new URLSearchParams({ phone, password })
        });

        const data = await res.json();
        if (res.ok) {
          location.reload();
        } else {
          errorEl.textContent = data.error || 'Ошибка входа';
        }
      } catch (err) {
        console.error(err);
        errorEl.textContent = 'Ошибка соединения с сервером';
      }
    });
  }


  const registerForm = document.getElementById('registerForm');
  if (registerForm) {
    registerForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      const name = registerForm.name.value.trim();
      const phone = registerForm.phone.value.trim();
      const password = registerForm.password.value;
      const errorEl = document.getElementById('registerError');
      errorEl.textContent = '';
      errorEl.classList.remove('d-none');

      try {
        const res = await fetch('/untitled/register', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: new URLSearchParams({ name, phone, password })
        });

        const data = await res.json();
        if (res.ok) {

          errorEl.textContent = 'Регистрация успешна! Теперь войдите.';
          errorEl.classList.add('text-success');

          const loginTabBtn = document.querySelector('#login-tab');
          if (loginTabBtn) loginTabBtn.click();
        } else {
          errorEl.textContent = data.error || 'Ошибка регистрации';
          errorEl.classList.remove('text-success');
        }
      } catch (err) {
        console.error(err);
        errorEl.textContent = 'Ошибка соединения с сервером';
        errorEl.classList.remove('text-success');
      }
    });
  }


  const switchToRegister = document.getElementById('switchToRegister');
  const switchToLogin = document.getElementById('switchToLogin');

  if (switchToRegister) {
    switchToRegister.addEventListener('click', (e) => {
      e.preventDefault();
      const registerTabBtn = document.querySelector('#register-tab');
      if (registerTabBtn) registerTabBtn.click();
    });
  }

  if (switchToLogin) {
    switchToLogin.addEventListener('click', (e) => {
      e.preventDefault();
      const loginTabBtn = document.querySelector('#login-tab');
      if (loginTabBtn) loginTabBtn.click();
    });
  }
});