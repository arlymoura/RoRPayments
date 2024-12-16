# RoRPayments - Sistema de Pagamentos com MercadoPago

**RoRPayments** é uma aplicação em Ruby on Rails que integra com o MercadoPago para processar pagamentos. A aplicação utiliza Docker para facilitar o ambiente de desenvolvimento e a configuração de dependências. Além disso, há um processo de verificação periódica do status dos pagamentos.

## Tecnologias Utilizadas

- Ruby on Rails
- MercadoPago API (para processamento de pagamentos)
- Docker (para configurar e isolar o ambiente de desenvolvimento)
- RSpec (para testes)
- FactoryBot (para criação de objetos de teste)

## Pré-requisitos

Para rodar este projeto, você precisa ter as seguintes ferramentas instaladas:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Ruby](https://www.ruby-lang.org/en/)
- [Rails](https://rubyonrails.org/)
- [Bundler](https://bundler.io/)
- [Node.js](https://nodejs.org/) (necessário para o ambiente Rails)

## Configuração do Ambiente

Este projeto utiliza Docker para facilitar a configuração do ambiente de desenvolvimento. Para iniciar a aplicação com Docker, siga os passos abaixo.

### 1. Configuração do Docker

No diretório raiz do projeto, você encontrará um arquivo `Dockerfile` e `docker-compose.yml` configurados para rodar o Rails, o banco de dados PostgreSQL e outros serviços necessários.

#### Build do ambiente com Docker:

```bash
docker-compose build
docker-compose up
```

### Execute o seguinte comando para configurar automaticamente o ambiente
```bash
bin/setup
```

### Você precisa configurar o token de autenticação da API do MercadoPago para que a integração funcione corretamente.

```bash
development:
  mercado_pago_token: "SEU_TOKEN_AQUI"

production:
  mercado_pago_token: "SEU_TOKEN_AQUI"
```

  PS: Você pode colar no .env ou então editar as credenciais com o comando:
  ```rails credentials:edit```


## Melhorias
#### Implementando Work e Schedule para Verificação do Status de Pagamento
Para novas funcionalidades, como a verificação do status dos pagamentos, será necessário criar:

- Work (Background Job)
- O trabalho de verificação do status dos pagamentos pode ser feito através de um Background Job, utilizando gemas como Sidekiq ou ActiveJob.
- O job deve ser acionado periodicamente para verificar os pagamentos que estão com status "processando".
Schedule (Scheduler)
- Utilize uma ferramenta de agendamento, como whenever ou Sidekiq Cron, para agendar a execução do job de verificação do status do pagamento.
