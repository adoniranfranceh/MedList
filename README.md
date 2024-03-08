# MedList

### Um projeto do Rebase Labs.

Este projeto utiliza o framework Sinatra para criar uma API web que consulta informações de pacientes armazenadas em um banco de dados PostgreSQL, tudo executado em contêineres Docker.

## Configuração do Ambiente

1. Certifique-se de ter o Docker e o Docker Compose instalados em seu sistema.
2. Clone este repositório em sua máquina local:

    ```bash
    git clone https://github.com/adoniranfranceh/MedList
    ```

## Executando o Projeto

Para iniciar o projeto, siga estes passos:

1. Navegue até o diretório do projeto:

    ```bash
    cd MedList
    ```

2. Construa e inicie os contêineres Docker:

    ```bash
    docker-compose up
    ```

    Isso iniciará os contêineres Docker e o servidor estará acessível em http://localhost:4567.

3. Execute o arquivo `import_data.rb` para importar dados de pacientes do CSV localizado em `data/data.csv`:

    ```bash
    docker-compose exec app ruby import_data.rb
    ```

4. Delete todos os dados de pacientes

    ```bash
    docker-compose exec app ruby app/back/truncate.rb
    ```

   

## Executando Testes

Você pode executar os testes da aplicação utilizando o comando abaixo:

```bash
docker-compose exec app_front rspec
```

## Utilizando a Interface Gráfica

Além da API, agora há uma interface gráfica disponível em `localhost:3000/home` que consome a API. A interface foi projetada como uma única página (single page), proporcionando uma experiência de usuário fluida e intuitiva.

### Listagem
![Lista de Pacientes](https://github.com/adoniranfranceh/MedList/assets/116985618/7d86a484-ee1d-469c-92af-26d61c9f6012)

### Detalhes
![Detalhes do Paciente](https://github.com/adoniranfranceh/MedList/assets/116985618/e50ba6eb-5b3e-48f5-a13f-e388d7b224cd)


## Rotas da API

- **GET /tests**: Retorna a lista de pacientes em formato JSON, incluindo os resultados dos testes.
- **GET /tests?search=Nome**: Retorna os pacientes cujos nomes correspondem à pesquisa.

## Exemplo de Uso

Após iniciar os contêineres, você pode acessar a lista de pacientes em [http://localhost:4567/tests](http://localhost:4567/tests).

```json
{
  "patients": [
    {
      "result_token": "IQCZ17",
      "result_date": "2021-08-05",
      "cpf": "048.973.170-88",
      "name": "Emilly Batista Neto",
      "email": "gerald.crona@ebert-quigley.com",
      "address": "165 Rua Rafaela",
      "city": "Ituverava",
      "state": "Alagoas",
      "birthday": "2001-03-11",
      "doctor": {
        "crm": "B000BJ20J4",
        "crm_state": "PI",
        "name": "Maria Luiza Pires"
      },
      "tests": [
        {
          "type": "hemácias",
          "limits": "45-52",
          "result": "97"
        },
        {
          "type": "leucócitos",
          "limits": "9-61",
          "result": "89"
        }
      ]
    },
    {
      "result_token": "0W9I67",
      "result_date": "2021-07-09",
      "cpf": "048.108.026-04",
      "name": "Juliana dos Reis Filho",
      "email": "mariana_crist@kutch-torp.com",
      "address": "527 Rodovia Júlio",
      "city": "Lagoa da Canoa",
      "state": "Paraíba",
      "birthday": "1995-07-03",
      "doctor": {
        "crm": "B0002IQM66"
      },
      "tests": [
        {
          "type": "hemácias",
          "limits": "40-52",
          "result": "99"
        },
        {
          "type": "leucócitos",
          "limits": "10-61",
          "result": "90"
        },
        {
          "type": "plaquetas",
          "limits": "12-93",
          "result": "98"
        }
      ]
    }
  ]
}
