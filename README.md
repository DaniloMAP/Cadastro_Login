# Flutter Login e Cadastro com Firebase

Este projeto Flutter é um aplicativo de autenticação que permite aos usuários se cadastrarem e fazerem login usando o Firebase Authentication. Ele também inclui funcionalidades para escolha e edição de imagem, e upload de imagem para o Firebase Storage.

## Funcionalidades

- **Login:** Usuários podem fazer login usando email e senha.
- **Cadastro:** Novos usuários podem se cadastrar fornecendo email e senha.
- **Escolha e Edição de Imagem:** Durante o cadastro, os usuários podem escolher uma foto de perfil e editar usando ferramentas de corte.
- **Upload de Imagem:** A foto de perfil escolhida é carregada para o Firebase Storage.

## Tecnologias Utilizadas

- Flutter
- Firebase Authentication
- Firebase Storage
- Image Picker
- Image Cropper

## Estrutura do Projeto

- `main.dart`: Ponto de entrada do aplicativo. Inicializa o Firebase e define a tela inicial.
- `login_screen.dart`: Tela de login que permite aos usuários fazerem login ou navegarem para a tela de cadastro.
- `signup_screen.dart`: Tela de cadastro que permite aos novos usuários se cadastrarem e escolherem uma foto de perfil.
- `auth_service.dart`: Serviço que encapsula a lógica de autenticação com o Firebase.

## Como Executar

1. Clone o repositório para sua máquina local.
2. Abra o projeto no seu ambiente de desenvolvimento Flutter.
3. Certifique-se de que todas as dependências estão instaladas executando `flutter pub get`.
4. Configure o Firebase adicionando os arquivos de configuração `google-services.json` (para Android) e `GoogleService-Info.plist` (para iOS) ao projeto.
5. Execute o aplicativo em um dispositivo ou emulador.
