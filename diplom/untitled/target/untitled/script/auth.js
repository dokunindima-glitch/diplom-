// auth.js — исправленная версия без ошибок синтаксиса

function setGender(btn) {
    // 1. Убираем класс active у всех кнопок группы
    const buttons = document.querySelectorAll('[name="genderBtn"]');
    buttons.forEach(b => b.classList.remove('active'));

    // 2. Добавляем класс активной нажатой кнопке
    btn.classList.add('active');

    // 3. Записываем значение в скрытое поле формы
    const hiddenGender = document.getElementById('regGender');
    if (hiddenGender) {
        hiddenGender.value = btn.dataset.val; // 'male' или 'female'
    }
}

function checkPasswordMatch() {
    const pass = document.getElementById('regPassword');
    const confirm = document.getElementById('confirmPassword');
    const errorEl = document.getElementById('passwordError');
    const submitBtn = document.getElementById('submitBtn');
    const phoneError = document.getElementById('phoneError');

    // Защита от null, если элементов нет на странице
    if (!pass || !confirm || !errorEl || !submitBtn) return;

    const passValue = pass.value;
    const confirmValue = confirm.value;

    // Логика проверки паролей
    if (confirmValue && passValue !== confirmValue) {
        errorEl.classList.remove('d-none'); // Показываем ошибку
        submitBtn.disabled = true;           // Блокируем кнопку
    } else {
        errorEl.classList.add('d-none');     // Скрываем ошибку

        // Если пароли ок, проверяем, не заблокирована ли кнопка из-за телефона
        if (phoneError && phoneError.classList.contains('d-none')) {
            submitBtn.disabled = false;
        }
    }
}

function formatPhone(input) {
    let value = input.value;

    // 1. Оставляем только цифры, плюс, скобки, тире и пробелы
    value = value.replace(/[^0-9+\-\s]/g, '');

    // 2. Получаем строку только с цифрами
    const digitsOnly = value.replace(/\D/g, '');

    // 3. Если начинается с 8, меняем на 7
    if (digitsOnly.startsWith('8')) {
        value = '7' + digitsOnly.slice(1);
    } else if (digitsOnly.startsWith('+7')) {
        value = digitsOnly;
    }

    const phoneError = document.getElementById('phoneError');
    const submitBtn = document.getElementById('submitBtn');

    // 4. Проверка: ровно 11 цифр?
    const cleanDigits = value.replace(/\D/g, '');

    if (cleanDigits.length === 11) {
        // Форматируем к виду +7XXXXXXXXXX
        const numberWithoutPlus = cleanDigits.replace(/^\+?/, '');
        input.value = '+7' + numberWithoutPlus.substring(1);

        if (phoneError) phoneError.classList.add('d-none');

        // Перепроверяем пароли, чтобы разблокировать кнопку отправки
        checkPasswordMatch();
    } else {
        // Если цифр не 11, оставляем ввод как есть (очищенный от букв)
        input.value = value;

        if (phoneError) {
            phoneError.classList.remove('d-none');
            if (submitBtn) submitBtn.disabled = true;
        }
    }
}