
const rates = {};
const elementUSD = document.querySelector('[data-value="USD"]');
const elementCNY = document.querySelector('[data-value="CNY"]');
const elementEUR = document.querySelector('[data-value="EUR"]');
const elementGBP = document.querySelector('[data-value="GBP"]');
const elementJPY = document.querySelector('[data-value="JPY"]');

const input = document.querySelector('#input');
const result = document.querySelector('#result');
const select = document.querySelector('#select');

const dailyOperations = {};

const convertButton = document.querySelector('#convert-button')

const currentDate = new Date();
const currentDay = `${currentDate.getDate()}-${(currentDate.getMonth() + 1)}-${currentDate.getFullYear()}`;

getCurrencies();

setInterval(getCurrencies, 5000);

async function getCurrencies () {
    const response = await fetch('https://www.cbr-xml-daily.ru/daily_json.js');
    const data = await response.json();
    const result = await data;
  

    rates.USD = result.Valute.USD;
    rates.CNY = result.Valute.CNY;
    rates.EUR = result.Valute.EUR;
    rates.GBP = result.Valute.GBP;
    rates.JPY = result.Valute.JPY;

    console.log(rates);

    elementUSD.textContent = rates.USD.Value.toFixed(2);
    elementCNY.textContent = rates.CNY.Value.toFixed(2);
    elementEUR.textContent = rates.EUR.Value.toFixed(2);
    elementGBP.textContent = rates.GBP.Value.toFixed(2);
    elementJPY.textContent = rates.JPY.Value.toFixed(2);

    //цветокор в зависимости от курса
    if (rates.USD.Value > rates.USD.Previous) {
        elementUSD.classList.add('top');
    } else {
        elementUSD.classList.add('bottom');
    }

    if (rates.CNY.Value > rates.CNY.Previous) {
        elementCNY.classList.add('top');
    } else {
        elementCNY.classList.add('bottom');
    }

    if (rates.EUR.Value > rates.EUR.Previous) {
        elementEUR.classList.add('top');
    } else {
        elementEUR.classList.add('bottom');
    }

    if (rates.GBP.Value > rates.GBP.Previous) {
        elementGBP.classList.add('top');
    } else {
        elementGBP.classList.add('bottom');
    }

    if (rates.JPY.Value > rates.JPY.Previous) {
        elementJPY.classList.add('top');
    } else {
        elementJPY.classList.add('bottom');
    }

}

input.oninput = convertValue;
select.oninput = convertValue;

function convertValue(){
    result.value = (parseFloat(input.value) / rates[select.value].Value).toFixed(2);

}