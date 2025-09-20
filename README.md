# Jokempo Flutter 🎮

Um jogo simples de **Pedra, Papel e Tesoura (Jokempo)** desenvolvido em **Flutter**, com a funcionalidade extra de **alterar sua jogada ao chacoalhar o celular**.

## 📱 Funcionalidades

- Escolha manual entre **Pedra**, **Papel** e **Tesoura**.
- Oponente (CPU) faz uma jogada aleatória.
- Exibição do resultado da rodada (**Vitória**, **Derrota** ou **Empate**).
- **Placar** atualizado dinamicamente.
- **Reset** de placar.
- **Chacoalhar o dispositivo** altera sua jogada aleatoriamente.
- Feedback tátil (vibração) ao detectar o chacoalhar.

---

## 🚀 Como rodar o projeto

### 1. Pré-requisitos
- [Flutter](https://docs.flutter.dev/get-started/install) instalado.
- SDK configurado no PATH.
- Emulador ou dispositivo físico Android/iOS.

### 2. Clonar o repositório
```bash
git clone https://github.com/seu-usuario/jokempo-flutter.git
cd jokempo-flutter
```

### 3. Instalar dependências
Edite o arquivo `pubspec.yaml` e adicione:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sensors_plus: ^2.0.0
```

Depois rode:
```bash
flutter pub get
```

### 4. Executar o app
Conecte seu dispositivo ou abra um emulador, então rode:
```bash
flutter run
```

---

## 📂 Estrutura do projeto
```
lib/
 └── main.dart   # Arquivo principal com toda a lógica do jogo
```

---

## ⚙️ Configurações adicionais
- **Sensibilidade do chacoalhar**: no código, ajuste as constantes em `_startListeningShake()`:
  - `shakeThreshold` → controla a intensidade necessária para detectar o shake (padrão: `18.0`).
  - `shakeCooldownMs` → tempo mínimo entre shakes consecutivos (padrão: `800 ms`).

- **Feedback tátil**: usa `HapticFeedback.mediumImpact()` ao detectar chacoalhar.

---

## ✨ Melhorias futuras
- Adicionar sons para vitórias/derrotas.
- Interface com imagens ao invés de emojis.
- Modo multiplayer local ou online.
- Histórico de partidas.

---

## 📝 Licença
Este projeto é open-source sob a licença MIT. Fique à vontade para usar e modificar.
