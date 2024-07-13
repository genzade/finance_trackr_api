# Finance Trackr API

This a simple API that allows you to track and manage your finances. The app currently
has a few endpoints that allow a user to:

- Register
- Authenticate
- Create income and expenditures
- View statements

#### Table of contents

- [Approach](#approach)
  - [Application flow](#application-flow)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [With Docker](#with-docker)
  - [Without Docker](#without-docker)
  - [Database creation](#database-creation)
  - [Run Test Suite](#run-test-suite)
- [Documentation](#documentation)
  - [endpoints](#endpoints)
    - [`POST /api/v1/customer/registration`](#post-apiv1customerregistration)
    - [`POST /api/v1/customer/authenticate`](#post-apiv1customerauthenticate)
    - [`POST /api/v1/customers/:customer_id/income`](#post-apiv1customerscustomer_idincome)
    - [`POST /api/v1/customers/:customer_id/expenditures`](#post-apiv1customerscustomer_idexpenditures)
    - [`GET /api/v1/customers/:customer_id/statement`](#get-apiv1customerscustomer_idstatement)
- [A few things to consider](#a-few-things-to-consider)

## Approach

The data model I settled on was the following:

- `Customer`
  - has many incomes
  - has many expenditures
  - has one statement
- `Income`
  - belongs to customer
- `Expenditure`
  - belongs to customer

![app entity relationship diagram](erd.jpg)

### Application flow

Service and form objects are used to handle business logic and keep the models skinny.
Business logic that can easily be unit tested.

When a customer first registers successfully a statement record is automatically
created for them asynchronously.

Customer can authenticate themselves and retrieve their token and id in order to
make authorized requests.

Customer should be able to add their own income and expenditure records respectively.
This will update their statement record with an asynchronous rating and disposable
income calculations.

Customer can view their statements where they will obtain some useful information
such as their income/expenditure lists and rating, as well as their disposable income.

Check out the Docs for more details on usage.

## Prerequisites

This project requires:

- Ruby `3.2.2`, use your favourite version manager to install this.
  I use [asdf](https://asdf-vm.com/)
- Rails `7.1.3`
- [Docker](https://www.docker.com/) (Optional, see alternative below)

Alternatively, if you do not have docker on your machine, you will need the following:

- PostgreSQL must be installed and accepting connections
- Redis must be installed

## Installation

Clone this repo

```sh
$ git clone git@github.com:genzade/finance_trackr_api.git
$ cd finance_trackr_api
$ bundle
```

### With Docker

Run the servers with:

```sh
$ bin/dev
```

### Without Docker

Start redis server

```sh
$ redis-server
```

Start sidekiq server

```sh
$ bundle exec sidekiq
```

Start application server

```sh
$ bin/rails server
```

### Database creation

```sh
$ bin/rails db:drop db:create db:migrate
```

### Run Test Suite

```sh
$ bundle exec rspec
```

## Documentation

### endpoints

#### `POST /api/v1/customer/registration`

Example usage

```sh
$ curl localhost:3000/api/v1/customer/registration \
    --request POST \
    --header "Content-Type: application/json"
    -d '{"email":"hello@mail","password":"123456","password_confirmation":"123456"}' \

=> {
      "message" : "Customer registered successfully"
   }
```

#### `POST /api/v1/customer/authenticate`

Example usage

```sh
$ curl localhost:3000/api/v1/customer/authenticate \
    --request POST \
    --header "Content-Type: application/json" \
    -d '{"customer":{"email":"hello@mail","password":"123456"}}'

=> {
      "data" : {
         "customer_id" : 1,
         "token" : "y0uR-j50n.w36.t0k3N-"
      },
      "message" : "Customer authenticated successfully"
   }
```

Example usage

#### `POST /api/v1/customers/:customer_id/income`

```sh
$ curl localhost:3000/api/v1/customers/1/income \
    --request POST \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer y0uR-j50n.w36.t0k3N-" \
    -d '{"income":{"source":"salary","amount":2800.0}}'

=> {
      "message" : "Income created successfully"
   }

```

Example usage

#### `POST /api/v1/customers/:customer_id/expenditures`

```sh
$ curl localhost:3000/api/v1/customers/1/expenditure \
    --request POST \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer y0uR-j50n.w36.t0k3N-" \
    -d '{"expenditure":{"category":"mortgage","amount":500.0}}'

=> {
      "message" : "Expenditure created successfully"
   }
```

#### `GET /api/v1/customers/:customer_id/statement`

Example usage

When there are no customer income or expenditure records created, the default
statement will be returned

```sh
$ curl localhost:3000/api/v1/customer/1/statement \
    --request GET \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer y0uR-j50n.w36.t0k3N-"

=> {
      "data" : {
         "disposable_income_amount" : null,
         "expenditure" : [],
         "ie_rating" : "Not Calculated",
         "income" : []
      },
      "message" : "Statement fetched successfully"
   }
```

Below is an example response from the customer statement endpoint when the customer
already has a few income and expenditure records.

```json
{
  "data": {
    "disposable_income_amount": "850.0",
    "expenditure": [
      {
        "amount": "500.0",
        "category": "mortgage"
      },
      {
        "amount": "100.0",
        "category": "utilities"
      },
      {
        "amount": "150.0",
        "category": "travel"
      },
      {
        "amount": "500.0",
        "category": "food"
      },
      {
        "amount": "1000.0",
        "category": "loan_repayment"
      }
    ],
    "ie_rating": "Rated D",
    "income": [
      {
        "amount": "2800.0",
        "source": "salary"
      },
      {
        "amount": "300.0",
        "source": "other"
      }
    ]
  },
  "message": "Statement fetched successfully"
}
```

This json was based on the customer having the following income and expenditures.

| Income | Amount | Expenditure     | Amount |
| ------ | ------ | --------------- | ------ |
| Salary | 2800   | Mortgage        | 500    |
| Other  | 300    | Utilities       | 100    |
|        |        | Travel          | 150    |
|        |        | Food            | 500    |
|        |        | Loans Repayment | 1000   |

## A few things to consider

This was an enjoyable exercise but I should mention a few things the app is missing
or could and/or should be done differently.

- Serialization. An improvement would have been to serialize the models. At the moment
  simple data is returned but in the future as the app grows and more sophisticated
  data is required; we could do with some serialization solution. This way instead
  of specifying which model attrs to return as json in the controllers (see the statement
  controller for and example).
- Handle logging out. Refresh token flow? The requirement mentioned authentication
  but I have not yet handled the scenario when the Customer logs out. At the moment
  the moment a customer can authenticate and they will get a jwt issued and it will
  expire in 2 hours.
- Another way to handle the statements would probably be to have a separate table
  (perhaps called `financial_health` or something) that would have the `ie_rating`
  and `disposable_income_amount` columns and just have the statement endpoint return
  these and the other customer data
- At the moment a `customer` only has one `statement` which would be constantly updated.
  This could be a has_many with a new one being created every month for the customer
  to reflect their income/expenditures. This could also not even be a table at all
  and just have the endpoint return the calculations based on the income/expenditures.
