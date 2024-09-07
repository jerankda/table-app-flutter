

# TableApp

**TableApp** is a Flutter application that allows users to manage a table with editable and selectable rows. The app utilizes `SharedPreferences` for local data storage, enabling persistent data across app sessions.

## Features

- **Add Row**: Add a new row to the table with default data.
- **Edit Row**: Edit the data of a single selected row.
- **Delete Rows**: Delete multiple selected rows at once.
- **Persistent Storage**: The table data is saved locally using `SharedPreferences` and restored on app launch.

## Flowchart

![Table App](https://github.com/jerankda/table-app-flutter/blob/main/7gjeUhiCHXkSwub1Cwb67j.png?raw=true)

## Getting Started

To run this app locally, follow these steps:

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
- An IDE with Flutter support, such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/jerankda/table-app-flutter
    ```

2. Navigate to the project directory:

    ```bash
    cd tabellenapp
    ```

3. Install the required dependencies:

    ```bash
    flutter pub get
    ```

### Running the App

To run the app on an emulator or physical device, use:

```bash
flutter run
