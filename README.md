# MedList

## Um projeto do Rebase Labs.

Este projeto utiliza o framework Sinatra para criar uma API web que consulta informações de pacientes armazenadas em um banco de dados PostgreSQL, tudo executado em contêineres Docker.

## Arquitetura do Projeto
O MedList adota uma arquitetura simples e eficaz, dividindo claramente o back-end do front-end:

### Back-end (app/back/):

Gerencia a lógica do servidor, endpoints da API e as operações no banco de dados. Inclui arquivos para importação de dados e configuração de conexão.

### Front-end (app/front/):

Fornece a interface do usuário, comunicando-se com o back-end por meio de chamadas de API para recuperar e exibir dados.

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
    docker-compose exec app ruby app/back/import_data.rb
    ```

4. Delete todos os dados de pacientes

    ```bash
    docker-compose exec app ruby app/back/truncate.rb
    ```

## Executando Testes

#### Para executar os testes da aplicação, siga estas etapas:
Garanta que os os containers estejam levantados:
```bash
docker-compose up -d
```
Execute os testes:
```bash
docker-compose exec app_back rspec
```

**OBS:** Os testes de sistema utilizam o banco de dados do ambiente de desenvolvimento. Certifique-se de que os dados no arquivo `data/data.csv` sigam o padrão esperado.

```bash
  docker-compose exec app ruby app/back/import_data.rb
```

### Especificações dos Testes
Antes de cada teste, o banco de dados é configurado com dados de teste para a tabela 'patients' a partir de um arquivo JSON em `spec/json/patients.json`, possibilitando chamadas ao model Patient nos cenários de teste de unidade e integração. Após cada teste, o banco de dados é redefinido para garantir um ambiente limpo.

## Utilizando a Interface Gráfica

Além da API, há uma interface gráfica disponível em `localhost:3000/home` que consome as API's. A interface foi projetada como uma única página (single page), proporcionando uma experiência de usuário fluida e intuitiva.

### Listagem
![Lista de Pacientes](https://github.com/adoniranfranceh/MedList/assets/116985618/ea731d70-dbc1-4084-a801-84aec3e51701)

### Detalhes
![Detalhes do Paciente](https://github.com/adoniranfranceh/MedList/assets/116985618/7e58d865-d085-48cb-a3cf-851ae05443a2)

## Utilizando a API

### Importando Dados via CSV

Você também pode importar dados via CSV enviado pela requisição ao endpoint `/import`. Para fazer isso, siga estas etapas:

1. Na interface [http://localhost:3000/home](http://localhost:3000/home).
2. Selecione o arquivo CSV com os dados a serem importados em "Escolher arquivo CSV".
3. Clique no botão "Importar CSV".

### Rotas da API

- **GET http://localhost:4567/tests**: Retorna a lista de pacientes em formato JSON, incluindo os resultados dos testes.
- **GET http://localhost:4567/tests?search=Nome**: Retorna os pacientes cujos nomes correspondem à pesquisa.
- **GET http://localhost:4567/tests/:token**: Retorna os pacientes cujos tokens correspondem à pesquisa.
- **POST http://localhost:4567/import**: Aceita envio de arquivo CSV com a implentação de backgroundjob.

### Exemplo de Uso

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
```
