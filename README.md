# MedList

Este é um projeto que utiliza o framework Sinatra para criar atualmente uma API web para consultar informações de pacientes armazenadas em um banco de dados PostgreSQL, tudo executado em contêineres Docker.

## Configuração do Ambiente

1. Certifique-se de ter o Docker e o Docker Compose instalados em seu sistema.
2. Clone este repositório em sua máquina local:

    ```bash
    git clone https://github.com/adoniranfranceh/MedList
    ```

## Executando o Projeto

Para iniciar o projeto, execute os seguintes comandos:

1. Navegue até o diretório do projeto:

    ```bash
    cd MedList
    ```

2. Importe dados de pacientes do CSV:

    ```bash
    docker-compose exec app ruby import_from_csv.rb
    ```

3. Construa e inicie os contêineres Docker:

    ```bash
    docker-compose up
    ```

Isso iniciará os contêineres Docker e o servidor estará acessível em http://localhost:4567.

## Rotas da API

- **GET /tests**: Retorna a lista de pacientes em formato JSON.


## Exemplo de Uso

Após iniciar os contêineres, você pode acessar a lista de pacientes em [http://localhost:4567/tests](http://localhost:4567/tests).

```json
{
  "patients": [
    {
      "id": 1,
      "cpf": "123.456.789-10",
      "nome": "João da Silva",
      "email": "joao@example.com",
      "data_nascimento": "1990-05-15",
      "endereco": "Rua A, 123",
      "cidade": "São Paulo",
      "estado": "SP",
      "crm_medico": "CRM12345"
    },
    {
      "id": 2,
      "cpf": "987.654.321-98",
      "nome": "Maria Souza",
      "email": "maria@example.com",
      "data_nascimento": "1985-10-20",
      "endereco": "Avenida B, 456",
      "cidade": "Rio de Janeiro",
      "estado": "RJ",
      "crm_medico": "CRM54321"
    }
  ]
}
```
Esse é um exemplo de como seria o retorno da lista de pacientes em formato JSON após acessar a rota `/tests`.

## Autor

Este projeto foi desenvolvido por [Adoniran França](https://github.com/adoniranfranceh).
