# 🧭 FiveM Advanced HUD System

A fully configurable **HUD system for FiveM** designed to enhance player experience, featuring a clean modern UI and real-time player data display.

![License](https://img.shields.io/badge/license-GPLv3-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

## ✨ Features

* 🧭 **Real-Time Player HUD** – Displays player ID, cash, bank, and dirty money
* 🔫 **Weapon Display** – Shows current weapon and ammo info
* 🚗 **Vehicle HUD** – Speedometer and fuel indicator when inside vehicles
* 🎨 **Modern UI/UX** – Clean, dark-themed interface designed for readability
* ⚙️ **Highly Configurable** – Easily adjust layout, elements, and behavior
* 🔔 **ox_lib Notifications** – Smooth and modern in-game alerts
* 📊 **Performance Optimized** – Lightweight and efficient for all servers
* 🔄 **Version Checker** – Automatically checks GitHub for updates

## 📦 Dependencies

* [es_extended](https://github.com/esx-framework/esx_core)
* [ox_lib](https://github.com/overextended/ox_lib)
* [oxmysql](https://github.com/overextended/oxmysql)

## 🛠 Installation

1. Download the latest release
2. Extract it into your `resources` folder
3. Rename the folder to your desired resource name
4. Add the resource to your `server.cfg`:

```cfg
ensure your-resource-name
```

5. Configure `config.lua` to fit your server needs
6. Restart your server

> HUD elements automatically sync with player data depending on your framework.

## ⚙️ Configuration

### Basic Setup

Edit `config.lua` to configure core behavior:

```lua
Config.EnableVehicleHUD = true
Config.ShowWeaponInfo = true
Config.UseKMH = true -- Set to false for MPH
```

### HUD Elements

```lua
Config.HUD = {
    showPlayerID = true,
    showCash = true,
    showBank = true,
    showDirtyMoney = true
}
```

## 🧩 Functionality Overview

* Displays essential player information in real-time
* Automatically switches to vehicle HUD when entering a vehicle
* Dynamically updates weapon and ammo data
* Clean and responsive UI for all screen sizes
* Designed to integrate seamlessly with ESX-based servers

## 🗄 Data Handling

This HUD pulls live data directly from your framework.

### How It Works

* Player data is fetched and updated in real-time
* No database edits required
* Fully compatible with standard ESX player data structure

## 🧩 Support

* Open an issue on GitHub for bugs or suggestions
* Please check existing issues before creating a new one

## 📄 License

This project is licensed under the **GPL License**.

## ❤️ Credits

* Built with **ox_lib**
* Data handling via **oxmysql**
* Compatible with **ESX Framework**

## 📷 Screenshots

<img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/01c74d42-215c-4cd0-9992-9cf20232c6ca" />
