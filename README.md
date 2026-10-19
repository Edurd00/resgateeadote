# Resgate & Adote

Plataforma de adoção inspirada no site Adote um Gatinho, criada para aproximar animais resgatados de pessoas interessadas em adotá-los. O contato de interesse é iniciado diretamente pelo WhatsApp do voluntário responsável pelo pet.

## Tecnologias

- Ruby 3.2.3
- Ruby on Rails 7.1.6
- PostgreSQL em produção
- Tailwind CSS 4
- Active Storage com Cloudinary em produção
- Docker
- Render

> Ruby 3.2.3 é a versão da linguagem usada pelo projeto. A versão Rails registrada no `Gemfile.lock` é 7.1.6.

## Contato para adoção

Cada animal pode estar associado ao usuário que o cadastrou. Na página do pet, o botão **Quero Adotar** usa o telefone de WhatsApp desse usuário (`User#phone`), removendo caracteres não numéricos e adicionando o código do Brasil quando o telefone contém apenas DDD e número. A mensagem de interesse é preenchida automaticamente.

Se o responsável não tiver telefone configurado, a aplicação usa `DEFAULT_WHATSAPP`. Configure esse valor com o número internacional, apenas com dígitos, por exemplo `5511999999999`.

## Perfis e permissões

- **Superadmin:** administra os voluntários e tem acesso às funções administrativas de gestão.
- **Admin / Voluntário:** cadastra e gerencia os pets atribuídos ao seu usuário e pode atualizar o próprio perfil e WhatsApp.

O primeiro Superadmin pode ser criado pelo seed. Configure `SUPERADMIN_EMAIL` e `SUPERADMIN_PASSWORD` antes de executá-lo. O seed usa `admin@resgateeadote.com.br` e `Mudar123!` como valores padrão; defina uma senha própria e segura no Render antes do primeiro deploy.

## Executar localmente

1. Instale Ruby 3.2.3, PostgreSQL e as dependências do projeto.
2. Configure `DATABASE_URL` se quiser usar PostgreSQL localmente. Em desenvolvimento, a configuração padrão usa SQLite.
3. Instale as gems e prepare o banco:

   ```sh
   bundle install
   bin/rails db:prepare
   ```

4. Inicie o servidor:

   ```sh
   bin/rails server
   ```

## Deploy no Render

### Serviço Ruby

1. Crie um banco PostgreSQL no Render e um Web Service Ruby ligado ao repositório.
2. Configure o comando de build como `./bin/render-build.sh` e o comando de início como `./bin/rails server -b 0.0.0.0`.
3. Defina no ambiente do Web Service as variáveis abaixo:

   | Variável | Uso |
   | --- | --- |
   | `DATABASE_URL` | URL interna do banco PostgreSQL do Render |
   | `SECRET_KEY_BASE` | Segredo da aplicação Rails |
   | `CLOUDINARY_URL` | Credenciais do Cloudinary para o Active Storage |
   | `SUPERADMIN_EMAIL` | E-mail da conta Superadmin inicial |
   | `SUPERADMIN_PASSWORD` | Senha inicial segura do Superadmin |
   | `DEFAULT_WHATSAPP` | Número internacional padrão para contato, se o pet não tiver responsável com telefone |

   `HOST_URL` é opcional e só é usado pelo ping interno de produção. `INSTAGRAM_URL` e `FACEBOOK_URL` são opcionais e ativam os links sociais no rodapé.

4. Faça o deploy. O `bin/render-build.sh` executa `bundle install`, precompila os assets, limpa assets antigos, aplica `bundle exec rails db:migrate` e termina com `bundle exec rails db:seed` para criar ou promover o Superadmin.

### Serviço Docker

O Dockerfile prepara a imagem e o Render inicia o container pelo `CMD` do Dockerfile. Serviços Docker não usam o comando de build Ruby `./bin/render-build.sh` automaticamente. Configure as mesmas variáveis de ambiente. Em planos com comando de pré-deploy, use `bundle exec rails db:migrate` nesse campo; para inicializar o Superadmin, execute uma vez `bundle exec rails db:seed` no shell do serviço. Em um serviço Ruby, o script de build já executa o seed.

Para planos pagos, o Render recomenda executar migrações como comando de pré-deploy, separado do build. O comando de pré-deploy roda em uma instância separada e não altera o filesystem da imagem já compilada. Consulte a [documentação de deploy do Render](https://render.com/docs/deploy-rails-6-7) e a [documentação de comandos de deploy](https://render.com/docs/deploys) antes de escolher a configuração do serviço.

## Upload de imagens

Em produção, o Active Storage usa o serviço Cloudinary configurado em `config/storage.yml`. As credenciais devem ser fornecidas pela variável `CLOUDINARY_URL`; não grave segredos no repositório.

## Licença e contribuições

Consulte o responsável pelo projeto para informações sobre licença. Para contribuir, crie uma branch, faça as alterações e abra um pull request com um resumo do que foi feito.
