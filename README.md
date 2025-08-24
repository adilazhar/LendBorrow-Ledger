# Lend Borrow Ledger

## Overview

An offline-first Flutter application designed to help users easily track interpersonal debts and loans. It provides a simple ledger to manage transactions between contacts, with all data stored locally on the device for privacy and offline accessibility.

## Features

- **Offline-First**: The app is fully functional without an internet connection.
- **Track Transactions**: Easily add new entries for money lent or borrowed.
- **Contact Management**: Add and manage a list of contacts you transact with.
- **Real-time Balances**: Automatically calculates and displays the net balance for each contact.
- **Transaction History**: View a complete history of all transactions for a specific person.
- **Local Storage**: All data is securely stored on your device using a local SQLite database.

## Tech Stack

- **Framework**: Flutter, Dart
- **State Management**: Riverpod
- **Database**: Drift (ORM over SQLite)
- **Reactive Programming**: RxDart
