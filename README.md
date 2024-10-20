
# Erebrus VPN App

Erebrus is a decentralized VPN application that allows users to connect to secure networks using dVPN technology. This project is built using Flutter and supports web3 integration for decentralized functionality.

## Features

- **VPN Services**: Secure and decentralized VPN service.
- **dWiFi Support**: Connect to decentralized Wi-Fi networks.
- **Web3 Integration**: Allows users to use decentralized web services.
- **Speed Check**: Test internet connection speeds.
- **Subscription Plans**: Manage VPN subscription packages.
- **Profile Management**: Customize user profiles.
- **Onboarding**: Seamless onboarding for new users.

## File Structure

```
lib/
│
├── api/
│   └── api.dart                     # API calls and endpoints management
│
├── components/
│   └── widgets.dart                 # Reusable UI components
│
├── config/
│   ├── api_const.dart               # API constants
│   ├── assets.dart                  # Asset paths
│   ├── colors.dart                  # App color palette
│   ├── common.dart                  # Common utility functions
│   ├── secure_storage.dart          # Secure storage configuration
│   └── strings.dart                 # Strings and localization
│   └── theme.dart                   # Application theme and styles
│
├── controller/
│   └── auth_controller.dart         # Authentication management
│
├── model/
│   └── erebrus/                     # Erebrus-specific models
│       ├── AllNodeModel.dart        # Node list model
│       ├── CheckSubModel.dart       # Subscription check model
│       ├── DWifiModel.dart          # dWiFi model
│       └── RegisterClientModel.dart # Client registration model
│
├── view/
│   ├── bottombar/                   # Bottom navigation bar UI
│   ├── dwifi/                       # Decentralized Wi-Fi views
│   ├── home/                        # Home screen views
│   ├── Onboarding/                  # User onboarding UI
│   ├── profile/                     # User profile views
│   ├── setting/                     # Settings views
│   ├── speedCheck/                  # Speed test UI
│   ├── subscription/                # Subscription views
│   └── vpn/                         # VPN connection views
│
├── web3dart/
│   └── models/                      # Web3dart models
│       ├── marketplace.dart         # Marketplace-related models
│       └── web3dart.dart            # Web3dart integration
│
├── main.dart                        # Application entry point
│
│
└── release/                         # Release apk files
```

## Getting Started

### Prerequisites

- **Flutter SDK**: Make sure Flutter is installed on your machine. [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Erebrus is built using Dart, which comes with Flutter.

### Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/your-repo/erebrus-vpn.git
    cd erebrus-vpn
    ```

2. **Install dependencies**:
    ```bash
    flutter pub get
    ```

3. **Configure environment variables**:
   - Set up the necessary environment variables in the `.env` file under the `web/` directory.

4. **Run the app**:
    ```bash
    flutter run
    ```

## Key Libraries Used

- **GetX**: For state management and routing.
- **Hive**: Local storage solution.
- **Flutter Secure Storage**: Secure storage for sensitive data.
- **Web3dart**: Integration with decentralized networks.
- **Dio**: For handling API requests.
  
## Contributing

Feel free to open issues or submit pull requests if you'd like to contribute to this project.

## License

This project is licensed under the GNU License - see the [LICENSE](LICENSE) file for details.
