
window.addEventListener("message", ({ data }) => {
    const card = document.querySelector('.card');
    const checkout = document.querySelector('.checkout');
    const titlePlayer = document.getElementById('title-player');

    if (data.action === "open") {
        card.style.animation = 'fadeContent ease 2s'
        card.style.display = 'flex';
    } else if (data.action === "close") {
        card.style.animation = 'fadeContentOut ease 0.4s'
        setTimeout(() => {
            checkout.style.display = 'none';
            card.style.display = 'none';
        }, 300);
        return;
    }

    if (titlePlayer && data.name) {
        const name = data.name.toUpperCase();
        titlePlayer.innerHTML = `OLÁ ${name}, SEJA BEM-VINDO(A) A <br>TRINITY ROLEPLAY.`;
    }
});

function popupDescriptionOn(type) {
    const descriptions = {
        vip: 'description-vip',
        car: 'description-car',
        camaro: 'title-camaro',
        lancerx: 'title-lancerx',
        bmwm2: 'title-bmwm2'
    };

    const elementId = descriptions[type];
    if (elementId) {
        const element = document.getElementById(elementId);
        element.style.display = 'block';
        element.style.animation = 'fadeContent ease 0.3s';
    }
}

function popupDescriptionOut(type) {
    const descriptions = {
        vip: 'description-vip',
        car: 'description-car',
        camaro: 'title-camaro',
        lancerx: 'title-lancerx',
        bmwm2: 'title-bmwm2'
    };

    const elementId = descriptions[type];
    if (elementId) {
        const element = document.getElementById(elementId);

        if (type === 'vip' || type === 'car') {
            element.style.animation = 'fadeContentOut ease 0.3s';
            setTimeout(() => (element.style.display = 'none'), 200);
        } else if (!clickButton) {
            element.style.display = 'none';
        }
    }
}

function resgatar() {
    const elementsToHide = [
        'title-player',
        'description-player',
        '.beneficios',
        'resgatar'
    ];

    elementsToHide.forEach(selector => {
        const element = document.querySelector(selector) || document.getElementById(selector);
        if (element) {
            element.style.animation = 'fadeContentOut ease 0.6s';
            setTimeout(() => (element.style.display = 'none'), 500);
        }
    });

    setTimeout(carSelect, 300);
}

function carSelect() {
    const titleCar = document.getElementById('title-car');
    if (titleCar) {
        titleCar.style.animation = 'fadeContent ease 0.4s';
        setTimeout(() => (titleCar.style.display = 'flex'), 300);
    }

    document.querySelectorAll('.car').forEach(car => {
        car.style.animation = 'fadeContent ease 0.4s';
        setTimeout(() => (car.style.display = 'flex'), 300);
    });
}

let clickButton = false
let vehicle = '';
let modelConfirm = {
    'camaro': false,
    'lancerx': false,
    'bmwm2': false
}

function camaro() {
    if (!clickButton) {
        clickButton = true;
        modelConfirm.camaro = true;

        const camaroElement = document.getElementById('camaro');

        camaroElement.style.transform = 'scale(1.05)';
        setTimeout(() => {
            disableCars();
            updateCheckout('CAMARO');
            highlightCar(camaroElement);
            document.getElementById('title-camaro').style.display = 'block';
        }, 100);
    }
}

function lancerx() {
    if (!clickButton) {
        clickButton = true;
        modelConfirm.lancerx = true;

        const lancerxElement = document.getElementById('lancerx');

        lancerxElement.style.transform = 'scale(1.05)';
        setTimeout(() => {
            disableCars();
            updateCheckout('LANCER X');
            highlightCar(lancerxElement);
        }, 100);
    }
}

function bmwm2() {
    if (!clickButton) {
        clickButton = true;
        modelConfirm.bmwm2 = true;

        const bmwm2Element = document.getElementById('bmwm2');

        bmwm2Element.style.transform = 'scale(1.05)';
        setTimeout(() => {
            disableCars();
            updateCheckout('BMW M2');
            highlightCar(bmwm2Element);
        }, 100);
    }
}

function disableCars() {
    document.querySelectorAll('.car').forEach(car => {
        car.style.pointerEvents = 'none';
    });
}

function updateCheckout(vehicleName) {
    const checkout = document.querySelector('.checkout');
    checkout.style.display = 'flex';
    checkout.style.animation = 'fadeContent ease 0.5s';
    document.getElementById('checkout-confirm').innerHTML = `ADICIONAR ${vehicleName} A <br>SUA GARAGEM ?`;
}

function highlightCar(carElement) {
    carElement.style.transform = 'scale(1.1)';
    carElement.style.boxShadow = '0 0 1vw rgba(0, 0, 0, 0.5)';
    carElement.style.backgroundColor = 'rgb(34, 34, 34)';
    carElement.style.border = 'solid 0.14vw #ffd900';
}

function cancel() {
    Object.keys(modelConfirm).forEach(key => (modelConfirm[key] = false));

    const checkout = document.querySelector('.checkout');
    checkout.style.animation = 'fadeContentOut ease 0.5s';

    ['camaro', 'lancerx', 'bmwm2'].forEach(title => {
        const titleElement = document.getElementById(`title-${title}`);
        if (titleElement) titleElement.style.display = 'none';
    });

    setTimeout(() => {
        checkout.style.display = 'none';
        document.querySelectorAll('.car').forEach(car => {
            car.style.transform = '';
            car.style.boxShadow = '';
            car.style.backgroundColor = '';
            car.style.border = '';
            car.style.pointerEvents = 'auto';
        });

        clickButton = false;
    }, 400);
}

function confirm() {
    const selectedModel = Object.keys(modelConfirm).find(model => modelConfirm[model]);
    
    let modelo = selectedModel === 'lancerx' ? 2 : selectedModel;

    if (modelo == 'camaro'){
        modelo = 1;
    }

    if (modelo === 'bmwm2') {
        modelo = 3;
    }
    
    fetch('https://rewardTrinity/reward', {
        method: 'POST',
        body: JSON.stringify({ model: modelo }),
        headers: { 'Content-Type': 'application/json' }
    });
}

document.addEventListener('keydown', function(event) {
    if (clickButton){
        cancel()
        return
    }

    if (event.key === "Escape") { 
        fetch('https://rewardTrinity/close', {
            method: 'POST',
        });
    }
});

