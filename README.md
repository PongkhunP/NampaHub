# NampaHub

## About the Project

NampaHub is a mobile application that connects investors with sustainable development projects. The platform enables donors to contribute funds to SDGS (Sustainable Development Goals) projects and track the impact of their investments.

## Features

- **Project Browsing**: Users can discover and view available SDGS projects
- **Donation Management**: Secure donation system with multiple payment options
- **Investor Dashboard**: Track donation history and project contributions
- **Project Details**: Comprehensive information about each SDGS initiative
- **Payment Integration**: Stripe integration for secure transactions
- **User Authentication**: Secure login and account management with JWT
- **Investor Profiles**: Manage profile information and donation preferences

## Tech Stack

### Frontend
- **Framework**: Flutter 3.3.1+
- **Language**: Dart
- **UI**: Material Design
- **Package**: cupertino_icons for iOS styling

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js 4.19.2
- **Database**: MariaDB 3.3.1
- **Authentication**: 
  - JSON Web Tokens (JWT) 9.0.2
  - Bcrypt 5.1.1 for password hashing
- **Payment Processing**: Stripe integration
- **Middleware**:
  - CORS for cross-origin requests
  - Body Parser for request parsing
  - Dotenv for environment variables

### Development Tools
- **Backend Dev Server**: Nodemon 3.1.3

## Getting Started

### Prerequisites
- Flutter SDK 3.3.1 or higher
- Node.js and npm
- MariaDB database

### Installation

**Backend Setup**:
```bash
npm install
npm run dev
