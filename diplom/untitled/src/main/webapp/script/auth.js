

function setGender(btn) {

    const buttons = document.querySelectorAll('[name="genderBtn"]');
    buttons.forEach(b => b.classList.remove('active'));


    btn.classList.add('active');


    const hiddenGender = document.getElementById('regGender');
    if (hiddenGender) {
        hiddenGender.value = btn.dataset.val;
    }
}

function checkPasswordMatch() {
    const pass = document.getElementById('regPassword');
    const confirm = document.getElementById('confirmPassword');
    const errorEl = document.getElementById('passwordError');
    const submitBtn = document.getElementById('submitBtn');
    const phoneError = document.getElementById('phoneError');


    if (!pass || !confirm || !errorEl || !submitBtn) return;

    const passValue = pass.value;
    const confirmValue = confirm.value;


    if (confirmValue && passValue !== confirmValue) {
        errorEl.classList.remove('d-none');
        submitBtn.disabled = true;
    } else {
        errorEl.classList.add('d-none');


        if (phoneError && phoneError.classList.contains('d-none')) {
            submitBtn.disabled = false;
        }
    }
}

function formatPhone(input) {
    let value = input.value;


    value = value.replace(/[^0-9+\-\s]/g, '');


    const digitsOnly = value.replace(/\D/g, '');


    if (digitsOnly.startsWith('8')) {
        value = '7' + digitsOnly.slice(1);
    } else if (digitsOnly.startsWith('+7')) {
        value = digitsOnly;
    }

    const phoneError = document.getElementById('phoneError');
    const submitBtn = document.getElementById('submitBtn');


    const cleanDigits = value.replace(/\D/g, '');

    if (cleanDigits.length === 11) {

        const numberWithoutPlus = cleanDigits.replace(/^\+?/, '');
        input.value = '+7' + numberWithoutPlus.substring(1);

        if (phoneError) phoneError.classList.add('d-none');


        checkPasswordMatch();
    } else {

        input.value = value;

        if (phoneError) {
            phoneError.classList.remove('d-none');
            if (submitBtn) submitBtn.disabled = true;
        }
    }
}