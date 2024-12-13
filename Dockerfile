# Dockerfile

# Use a imagem oficial do Ruby como base
FROM ruby:3.2.0

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Configure o diretório de trabalho
WORKDIR /app

# Copie o Gemfile e Gemfile.lock para o diretório de trabalho
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Instale as gemas
RUN bundle install

# Copie o restante do código da aplicação
COPY . /app

# Exponha a porta 3000 para acessar a aplicação Rails
EXPOSE 3000

# Comando padrão para rodar o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
