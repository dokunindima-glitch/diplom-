<script>
    function removeItem(productId, rowElement) {
        if (!confirm('Вы уверены, что хотите удалить этот товар?')) {
            return;
        }

        fetch('<%= request.getContextPath() %>/remove-from-cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'id=' + encodeURIComponent(productId)
        })
        .then(response => {
            if (response.ok) {
                console.log('Сервер ответил OK, скрываем строку...');
                rowElement.style.display = 'none';


                setTimeout(() => {
                    recalculateTotal();
                }, 50);

                const visibleRows = document.querySelectorAll('.cart-item-row:not([style*="display:none"])');
                if (visibleRows.length === 0) {
                    setTimeout(() => location.reload(), 300);
                }
            } else {
                alert('Ошибка сервера при удалении товара.');
            }
        })
        .catch(error => {
            console.error('Ошибка сети:', error);
            alert('Ошибка соединения с сервером.');
        });
    }

    function recalculateTotal() {
        let total = 0;
        const rows = document.querySelectorAll('.cart-item-row:not([style*="display:none"])');

        console.log('Найдено видимых строк товаров:', rows.length);

        rows.forEach((row, index) => {
            const unitPriceEl = row.querySelector('.unit-price');

            if (!unitPriceEl) {
                console.warn(`Строка \${index}: не найден элемент .unit-price`);
                return;
            }


            const rawText = unitPriceEl.innerText;
            const cleanPriceText = rawText.replace(/[^\d.]/g, '');

            console.log(`Строка ${index}: сырой текст "${rawText}", очищенный "\${cleanPriceText}"`);

            const price = parseFloat(cleanPriceText);

            if (isNaN(price) || price < 0) {
                console.warn(`Строка \${index}: не удалось распарсить цену. Пропускаем.`);
                return;
            }


            const quantity = 1;

            total += price * quantity;
            console.log(`Строка ${index}: цена ${price}, кол-во ${quantity}, итог строки ${price * quantity}`);
        });

        const totalElement = document.querySelector('.cart-total-amount');
        if (totalElement) {
            console.log('Новая общая сумма:', total);
            totalElement.textContent = total.toLocaleString('ru-RU') + ' ₽';
        } else {
            console.error('Не найден элемент .cart-total-amount!');
        }
    }
    function confirmCheckout() {

        const totalElement = document.getElementById('cart-total-amount');
        if (!totalElement) {
            alert('Ошибка: не найдена сумма заказа.');
            return;
        }


        const rawText = totalElement.innerText;
        const cleanAmount = parseFloat(rawText.replace(/[^0-9.-]+/g,""));

        if (isNaN(cleanAmount) || cleanAmount <= 0) {
            alert('Некорректная сумма заказа.');
            return;
        }


        if (confirm(`Вы уверены, что хотите оформить заказ на сумму \${cleanAmount.toLocaleString('ru-RU')} ₽?\n\nСредства будут списаны с вашего баланса.`)) {

            placeOrder(cleanAmount);
        }
    }

    function placeOrder(amount) {

        fetch('\${pageContext.request.contextPath}/checkout', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ totalAmount: amount })
        })
        .then(response => {
            if (response.ok) {
                alert('Заказ успешно оформлен! Остатки товаров на складе обновлены.');

                window.location.href = '\${pageContext.request.contextPath}/orders.jsp';
            } else {

                return response.json();
            }
        })
        .catch(error => {
            console.error('Ошибка сети:', error);
            alert('Произошла ошибка соединения с сервером.');
        });
    }
</script>