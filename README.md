# ⚽ FutVision Mobile

Aplicação mobile desenvolvida em **Flutter** para explorar o universo do futebol mundial. Consome dados em tempo real da **TheSportsDB API** e possui integração com **Firebase** (autenticação e favoritos).

---

## 📱 Prints da Aplicação

| Login | Home | Classificação |
|-------|------|---------------|
| ![login](prints/login.png) | ![home](prints/home.png) | ![standings](prints/standings.png) |

| Jogadores | Detalhes do Time | Favoritos |
|-----------|-----------------|-----------|
| ![players](prints/players.png) | ![team](prints/team.png) | ![favorites](prints/favorites.png) |

---

## 🏗️ Arquitetura da Aplicação

```
futvision_mobile/
├── lib/
│   ├── main.dart                        # Entrada do app, tema, rotas (go_router)
│   ├── services/
│   │   ├── football_api.dart            # Chamadas à TheSportsDB API (http)
│   │   ├── auth_service.dart            # Firebase Authentication
│   │   └── favorites_service.dart       # Cloud Firestore (favoritos)
│   ├── screens/
│   │   ├── login_screen.dart            # Tela de login/cadastro
│   │   ├── home_screen.dart             # Home com busca de times e ligas
│   │   ├── standings_screen.dart        # Classificação por liga/temporada
│   │   ├── matches_screen.dart          # Próximos jogos
│   │   ├── players_screen.dart          # Busca de jogadores
│   │   ├── compare_screen.dart          # Comparar dois times
│   │   ├── favorites_screen.dart        # Favoritos salvos no Firestore
│   │   ├── team_details_screen.dart     # Detalhes do time + elenco + galeria
│   │   ├── player_details_screen.dart   # Detalhes do jogador + galeria
│   │   └── about_screen.dart            # Sobre o projeto
│   ├── widgets/
│   │   ├── league_card.dart             # Card de liga reutilizável
│   │   ├── team_card.dart               # Card de time reutilizável
│   │   └── favorite_button.dart         # Botão de favorito reutilizável
│   └── utils/
│       └── translations.dart            # Traduções (ligas, posições, países)
└── android/
    └── app/
        └── google-services.json         # Configuração Firebase Android
```

### Fluxo de dados

```
Usuário
  │
  ├── [Não autenticado] ──► LoginScreen ──► Firebase Auth
  │
  └── [Autenticado]
        │
        ├── TheSportsDB API ──► football_api.dart ──► Screens
        │
        └── Cloud Firestore ──► favorites_service.dart ──► FavoritesScreen
```

---

## 🚀 Tecnologias Utilizadas

| Tecnologia | Versão | Uso |
|------------|--------|-----|
| Flutter | 3.x | Framework mobile |
| Dart | 3.x | Linguagem de programação |
| go_router | ^14.6.3 | Navegação e rotas |
| http | ^1.2.2 | Requisições à API |
| cached_network_image | ^3.4.1 | Cache de imagens |
| firebase_core | ^3.13.1 | Inicialização Firebase |
| firebase_auth | ^5.5.2 | Autenticação |
| cloud_firestore | ^5.6.6 | Banco de dados |
| google_sign_in | ^6.2.2 | Login com Google |

---

## ⚙️ Como Instalar e Rodar

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado
- Android Studio ou VS Code com extensão Flutter
- Dispositivo Android ou emulador

### Passo a passo

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/futvision_mobile.git

# 2. Entre na pasta do projeto
cd futvision_mobile

# 3. Instale as dependências
flutter pub get

# 4. Rode o app
flutter run
```

### Gerar APK

```bash
flutter build apk --release
# APK gerado em: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔥 Integração com Firebase

O app utiliza dois serviços do Firebase:

- **Authentication** — cadastro e login com email/senha e Google
- **Cloud Firestore** — armazenamento dos times e jogadores favoritos do usuário

Estrutura do Firestore:
```
users/
  {uid}/
    favorites/
      team_{id}   → { type, id, name, badge, subtitle, addedAt }
      player_{id} → { type, id, name, badge, subtitle, addedAt }
```

---

## 🌐 API Utilizada

**TheSportsDB** — [thesportsdb.com](https://www.thesportsdb.com)

| Endpoint | Uso |
|----------|-----|
| `all_leagues.php` | Listar todas as ligas de futebol |
| `searchteams.php` | Buscar times por nome |
| `lookupteam.php` | Detalhes de um time |
| `searchplayers.php` | Buscar jogadores por nome ou time |
| `lookupplayer.php` | Detalhes de um jogador |
| `eventsnextleague.php` | Próximos jogos de uma liga |
| `lookuptable.php` | Classificação de uma liga por temporada |

---

## 📦 Download do APK

> [Clique aqui para baixar o APK](https://github.com/seu-usuario/futvision_mobile/releases/latest)

---

## 👨‍💻 Autor

**Eduardo Colombari Elias**  
Estudante de Engenharia de Software — Uni-FACEF  

