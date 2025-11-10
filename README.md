# ⛽ SafeGas Monitor - Aplicativo de Monitoramento de Gás

![SafeGas Monitor App Screenshot](c:\Users\berna\OneDrive\Imagens\Screenshots\app.png) Um aplicativo Flutter robusto para monitoramento inteligente de botijões de gás, oferecendo controle em tempo real do nível de gás e alertas de segurança para vazamentos. Desenvolvido para proporcionar tranquilidade e eficiência no consumo de gás doméstico ou comercial.

---

## ✨ Features Principais

* **Autenticação Segura:** Login/Registro via e-mail e senha com Firebase Authentication.
* **Monitoramento em Tempo Real:** Visualização instantânea do nível do botijão de gás (integração com Realtime Database).
* **Alerta de Vazamento:** Notificações instantâneas (futuro) em caso de detecção de vazamento.
* **Histórico de Consumo:** Gráficos intuitivos mostrando o padrão de uso do gás ao longo do tempo (futuro).
* **Perfil do Usuário:** Gerenciamento do perfil e opção de logout.
* **Design Intuitivo:** Interface de usuário limpa e moderna, com navegação por abas.

---

## 🛠️ Tecnologias Utilizadas

* **Framework:** [Flutter](https://flutter.dev/) (para desenvolvimento mobile cross-platform)
* **Backend as a Service (BaaS):** [Google Firebase](https://firebase.google.com/)
    * **Authentication:** Gerenciamento de usuários.
    * **Realtime Database:** Armazenamento e sincronização de dados em tempo real (nível do gás, status de vazamento).
    * **Cloud Messaging (FCM):** Para notificações push (futuro).
    * **Cloud Functions:** Para lógica de backend acionada por eventos (futuro).
* **Hardware (IoT):** [ESP32](https://www.espressif.com/en/products/socs/esp32) com sensor de gás (integração via Firebase RTDB).
* **Gráficos:** [fl_chart](https://pub.dev/packages/fl_chart) (para visualização do histórico de consumo).

---

## 🚀 Como Rodar o Projeto (Desenvolvimento)

Siga estas instruções para configurar e rodar o projeto localmente para desenvolvimento e testes.

### Pré-requisitos

* [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão `3.x.x` ou superior)
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [VS Code](https://code.visualstudio.com/) (recomendado) com as extensões Flutter e Dart.
* Uma conta e um projeto configurado no [Google Firebase](https://console.firebase.google.com/).
    * **Importante:** Adicione as impressões digitais SHA-1 de Debug e Release do seu ambiente no Firebase para que a autenticação e o Firebase Realtime Database funcionem corretamente.

### Configuração

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/bernardondff/monitoramento_gas.git](https://github.com/bernardondff/monitoramento_gas.git)
    cd monitoramento_gas
    ```

2.  **Instale as dependências do Flutter:**
    ```bash
    flutter pub get
    ```

3.  **Configure o Firebase:**
    * Siga as instruções oficiais do Flutter para [adicionar o Firebase ao seu projeto Flutter](https://firebase.google.com/docs/flutter/setup).
    * **Baixe o arquivo `google-services.json`** do seu projeto Firebase e coloque-o na pasta `android/app/`.
    * Certifique-se de que as configurações do Gradle (arquivos `android/build.gradle` e `android/app/build.gradle`) estejam corretas conforme a documentação do Firebase.

4.  **Crie a estrutura do Realtime Database:**
    * No seu Firebase Realtime Database, crie a seguinte estrutura para testes (os dados serão preenchidos pelo hardware):
        ```json
        {
          "botijoes": {
            "botijao_01": {
              "nivel": 75,
              "status": "Normal",
              "vazamento": false
            }
          },
          "logs_botijao_01": {
            "-N_log1": { "nivel": 95, "timestamp": 1 },
            "-N_log2": { "nivel": 80, "timestamp": 2 },
            // ... adicione mais logs para testes do gráfico
          }
        }
        ```

### Rodando o App

1.  Certifique-se de que um emulador Android esteja rodando ou um dispositivo físico esteja conectado.
2.  Execute o aplicativo:
    ```bash
    flutter run
    ```

---

## 📦 Como Publicar (Release)

Para publicar o aplicativo na Google Play Store, siga os passos abaixo:

1.  **Gere a Chave de Assinatura (Keystore):** Crie e configure sua `upload-keystore.jks`. **Guarde esta chave em segurança.**
2.  **Configure o Firebase:** Adicione a impressão digital SHA-1 da sua chave de **Release** no console do Firebase e baixe um novo `google-services.json`.
3.  **Gere o App Bundle:**
    ```bash
    flutter build appbundle --release
    ```
4.  **Upload para Google Play Console:** Suba o arquivo `.aab` gerado (`build/app/outputs/bundle/release/app-release.aab`) para sua conta de desenvolvedor no [Google Play Console](https://play.google.com/console).
5.  **Preencha as informações:** Ícone, screenshots, descrição, política de privacidade, etc.

---

## 🤝 Contribuição

Contribuições são bem-vindas! Se você tiver sugestões, melhorias ou encontrar bugs, por favor, abra uma issue ou envie um Pull Request.

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT.

---

## 📧 Contato

Para dúvidas ou suporte, entre em contato com Bernardo Nunes de F. - bernardondf@gmail.com

---
