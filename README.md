# Calorie Tracker

A privacy-focused calorie tracking app built with Flutter that puts you in control of your data.

## Overview

This calorie tracking app prioritizes **privacy**, **speed**, and **customization** over data harvesting and subscription models. Your nutrition data stays on your device with optional personal cloud sync - no company servers involved.

### Key Principles
- 🔒 **Privacy First**: Your data never leaves your control
- 💰 **Pay Once, Own Forever**: No subscriptions or recurring fees  
- 📱 **Mobile-Only**: Optimized for iOS and Android
- ⚡ **Fast & Minimal**: Lightweight design focused on core functionality

## Features

### Core Functionality
- **Custom Food Database**: 100% user-created food library with flexible unit support (100g, per item, per serving)
- **Meal Builder**: Create custom meals from your food library with live macro calculations
- **Daily Tracking**: Manual food/meal logging with calorie targets
- **Weight Tracking**: Optional weight logging with progress visualization
- **Quick Stats**: Weekly/monthly trends and averages

### Privacy & Data
- **Local-First Storage**: All data stored locally using Hive database
- **Optional Cloud Sync**: Use your personal iCloud/Google Drive (not our servers)
- **No Data Harvesting**: Zero telemetry or analytics collection
- **Complete Ownership**: Export/import your data anytime

## Technical Stack

- **Framework**: Flutter (cross-platform iOS/Android)
- **Local Database**: Hive (fast, lightweight NoSQL)
- **Key Dependencies**:
  - `hive_flutter` - Local data storage
  - `path_provider` - File system access
  - `image_picker` - Photo functionality
  - `fl_chart` - Statistics visualization

## Development Status

### ✅ Completed
- Core app structure with bottom navigation
- Food library management (CRUD operations)
- Food creation with custom units and macros
- Local database with Hive
- Image support for foods
- Basic UI components and screens

### 🚧 In Progress
- Daily calorie logging functionality
- Meal library implementation
- Statistics and trends

### 📋 Planned
- Weight tracking
- BMI calculator and tools
- Data export/import
- Cloud sync functionality
- Advanced analytics (Pro version)

## Monetization Model

- **Free Trial**: 2 weeks full access
- **Basic Version**: $9.99 one-time purchase (core features)
- **Pro Version**: $24.99 one-time purchase (advanced analytics, meal planning, enhanced tools)

**No subscriptions. No recurring fees. Pay once, track forever.**

## Privacy Commitment

This app is designed with privacy as a core principle:
- No user accounts or sign-ups required
- No data transmission to company servers
- No advertising or user tracking
- Optional cloud sync uses YOUR personal cloud storage
- Complete data portability and ownership

---

*Built for people who want simple, private calorie tracking without the complexity of modern "connected" apps.*
