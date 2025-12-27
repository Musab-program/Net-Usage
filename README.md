# 📱 Net-Usage (مدير الإنترنت)

**Net-Usage** is a robust Flutter application designed to manage internet usage, track user balances, and visualize user consumption data. It serves as a comprehensive tool for administrators to oversee internet subscriptions, monitor weekly usage, and handle payments efficiently.

## ✨ Features

- **User Management**:
  - Add, Update, and Delete users.
  - View user details with custom avatars.
  - Sort users by Name, Balance, or Registration Date.
- **Usage Tracking**:
  - Record weekly internet usage (in GB) for each user.
  - Automatic calculation of amounts due based on configurable gigabyte prices.
- **Financial Management**:
  - Track payments and remaining balances.
  - Reconcile accounts to carry over balances and clear usage records for new cycles.
- **Dashboard & Analytics**:
  - Visual Bar Charts and Pie Charts (using `fl_chart`) to analyze consumption patterns.
  - Summary cards for Total Consumption, Total Payments, and Total Remaining Balance.
  - Top Users leaderboard.
- **Utilities**:
  - **Calculator**: Built-in calculator for quick arithmetic operations within the app.
- **UI/UX**:
  - Modern, responsive design.
  - **Dark & Light Mode** support with persistent theme saving.
  - Interactive Dialogs and Animations.

## 🛠️ Built With

- **[Flutter](https://flutter.dev/)** - The UI toolkit.
- **[GetX](https://pub.dev/packages/get)** - State Management, Dependency Injection, and Routing.
- **[Sqflite](https://pub.dev/packages/sqflite)** - Local SQLite database for persisting users, usage, and settings.
- **[FL Chart](https://pub.dev/packages/fl_chart)** - For rendering beautiful charts.
- **[Shared Preferences](https://pub.dev/packages/shared_preferences)** - For storing simple settings (Theme mode).
- **Google Nav Bar** - For the modern bottom navigation bar.

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- An IDE (VS Code or Android Studio) with Flutter/Dart plugins.

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/your-username/net-usage.git
    ```
2.  **Navigate to the project directory**
    ```bash
    cd net-usage
    ```
3.  **Install dependencies**
    ```bash
    flutter pub get
    ```
4.  **Run the app**
    ```bash
    flutter run
    ```

## 📂 Project Structure

The project follows a modular and clean architecture using GetX pattern:

```
lib/
├── core/                   # Core utilities, widgets, and base controllers
│   ├── base_controllers/   # Global controllers (App, User, Usage, Settings)
│   ├── bindings/           # App-wide dependency injection
│   ├── constants/          # Colors, Strings
│   ├── services/           # Database service (SQLite)
│   ├── utils/              # Themes
│   └── widgets/            # Reusable UI components
├── data/                   # Data layer
│   ├── local_storage/      # DAO implementation for SQLite
│   ├── models/             # Data models (User, Usage, Settings)
│   └── repositories/       # Repositories (Abstraction over data sources)
├── modules/                # Feature modules (Views & Controllers)
│   ├── calculator/
│   ├── dashboard/
│   ├── home/
│   ├── main_screen/
│   ├── splash/
│   └── user_management/
├── routes/                 # App navigation routes
└── main.dart               # Entry point
```

## 📸 Screenshots

|     Home Page      |     Dashboard      |  User Management   |     Dark Mode      |
| :----------------: | :----------------: | :----------------: | :----------------: |
|-![Screenshot_20251227-104850](https://github.com/user-attachments/assets/15452af7-4eec-4626-b1e7-b3d371ccfa4d)-
 |-![Screenshot_20251227-104918](https://github.com/user-attachments/assets/ecee957f-fcea-4d4b-9de6-b2e975d1dd72) -
 |![Screenshot_20251227-104928_One UI Home](https://github.com/user-attachments/assets/2ff364ea-aec3-4519-89eb-d73683782d05)
 | ![Screenshot_20251227-104952](https://github.com/user-attachments/assets/d75d6ac6-61b3-4d33-b633-353d623365fd)
 |
