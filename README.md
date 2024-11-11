# Vitawallet API

Este proyecto es una API que permite consultar el precio de Bitcoin y realizar transacciones. Todas las interacciones se hacen a través de peticiones HTTP, por lo que puedes utilizar Postman (o cualquier cliente API) para probar sus endpoints.

## Requisitos

- **Postman**: Puedes descargarlo desde [https://www.postman.com/downloads/](https://www.postman.com/downloads/).
- **URL base**: Asegúrate de utilizar la URL de despliegue de tu API o `http://localhost:3000` si estás ejecutando la API en tu máquina local.

## Endpoints Disponibles

### 1. Consultar el Precio de Bitcoin

**Método**: `GET`  
**URL**: `/prices/show`

**Descripción**: Obtiene el precio actual del Bitcoin en USD.

**Ejemplo de respuesta exitosa:**

```
json
{
  "currency": "BTC",
  "price_in_usd": 76351.1576
}
```

** Para crear una transaccion de Compra de Bitcoin debera hacerlo de la siguiente manera **
<b>Siendo un POST a la url: </b>

``` {url}/api/users/:user_id/transactions/buy ```


deberan poner en el body de la misma, en formato RAW como JSON de la siguiente manera
```
{
  "amount_to_send": 10000,
  "currency_to_send": "USD",
  "currency_to_receive": "BTC"
}
```

** Para crear una transaccion de Venta de USD para comprar BTC debera hacerlo de la siguiente manera **
<b>Siendo un POST a la url: </b>

``` {url}/api/users/:user_id/transactions/sell ```


deberan poner en el body de la misma, en formato RAW como JSON de la siguiente manera

```
{
  "amount_to_send": 10000,
  "currency_to_send": "BTC",
  "currency_to_receive": "USD"
}
```

** Para conocer las transacciones de un usuario en especifico debera hacerlo de la siguente manera**
<b>Siendo un GET a la url: </b>
` /api/users/:user_id/transactions ` 

y les devolvera algo como esto 

```
"user_id": 1,
    "balance_usd": "9178.47",
    "balance_btc": "0.01860147",
    "transactions": [
        {
            "id": 1,
            "user_id": 1,
            "transaction_type": "buy",
            "amount_usd": "100.0",
            "amount_btc": "0.00130536466486485",
            "balance_usd_at_transaction": "9385.0",
            "balance_btc_at_transaction": "0.02",
            "created_at": "2024-11-07T20:16:52.227Z",
            "updated_at": "2024-11-07T20:16:52.227Z"
        },
        {
            "id": 2,
            "user_id": 1,
            "transaction_type": "buy",
            "amount_usd": "200.0",
            "amount_btc": "0.0026171061472043",
            "balance_usd_at_transaction": "9285.0",
            "balance_btc_at_transaction": "0.02",
            "created_at": "2024-11-09T15:42:22.302Z",
            "updated_at": "2024-11-09T15:42:22.302Z"
        }
    ],
```
