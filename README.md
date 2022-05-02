# HanriOTP
> HanriOTP is an OTP generator for 2FA synchronized with Google's serivces.

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Plugins Used](#plugin-used)
* [Features](#features)
* [Screenshots](#screenshots)
* [Project Status](#project-status)
* [Acknowledgements](#acknowledgements)
* [Contact](#contact)
* [License](#license)


## General Information
- HanriOTP is a One Time Password (OTP) generator application for 2 Factor Authentication (2FA) that I made as one of my main Portfolio app with Flutter, it was made to replace any OTP application such as Google's with a light weight, optimized app and that doesn't need to connect to the internet. In sum it is a very simple OTP generator app, it doesn't do anything superficial, just straight to the point.
- You can simply add your seeds manually or using a QR Code
- Export your backup wether it is a clear json file or an encrypted json file to the directory /storage/emulated/0/HanriOTP/
- Import your backup from wherever it is in your phone

## Technologies Used
- Flutter 2.10

## Plugins Used
- 'otp' to generate OTP codes
- 'flutter_riverpod' to manage the state of the app
- 'shared_preferences' to store user's data locally
- 'permission_handler' to request storage permission
- 'intl' to format timestamp strings
- 'file_picker' to import files from local storage into the app
- 'qr_flutter' to generate QR Codes for seeds
- 'encrypt' to encrypt the app's pin code
- 'aes_crypt_null_safe' to encrypt backup files
- 'flutter_speed_dial' for easy multi floating action button
- 'qr_code_scanner' to scan QR Codes

## Features
- Add and edit seeds
- Add manually
- Add from QR Code
- 3 encryption methods (SHA1, SHA128, SHA256)
- Pin Code App Locker
- Import and Export Clear Backup
- Import and Export Encrypted Backup

## Screenshots
[<img width=200 alt="Main Activity" src="https://github.com/Hhanri/otp_generator/blob/main/assets/screenshots/home_screen.png">](https://github.com/Hhanri/otp_generator/blob/main/assets/screenshots/home_screen.png)
[<img width=200 alt="Pin Code Activity" src="https://github.com/Hhanri/otp_generator/blob/main/assets/screenshots/pin_code_screen.png">](https://github.com/Hhanri/otp_generator/blob/main/assets/screenshots/pin_code_screen.png)
[<img width=200 alt="Backup Activity" src="https://github.com/Hhanri/otp_generator/blob/main/assets/screenshots/backup_settings_screen.png">](https://github.com/Hhanri/otp_generator/blob/main/assets/screenshots/backup_settings_screen.png)


## Project Status
Project is: complete
The project is still maintained to fix any bug that can occur in the future

## Acknowledgements
- This project was inspired by https://github.com/andOTP/andOTP

## Contact
Created by [@Hhanri] - feel free to contact me!
- Twitter: @__Hanri__
- Discord: @ハンリ#3182

## License
This project is open source and available under the [GNU AGPLv3 License](https://github.com/Hhanri/otp_generator/blob/main/LICENSE.txt).