# III BANK — Personal Finance Manager

A full-stack JEE (Java Servlets + JSP) banking/personal finance management system built with a Maven-based project structure, MySQL persistence, and a modern dark-themed UI.

## Overview

III BANK lets users register an account, securely log in, track income and expenses, and view an analytics dashboard with spending breakdowns and an AI financial advisor panel.

## Features

- **Secure authentication** — registration and login with hashed passwords (jbcrypt), backed by a servlet `AuthFilter` that protects all routes except public auth pages
- **Dashboard / Analytics** — real-time balance, total income, and total expenses at a glance, plus a weekly income vs. expenses trend chart
- **Spending Categories** — donut chart breakdown of expenses by category (e.g. Food, Rent, Car)
- **Transactions** — full transaction history with search, filter by type, and sort, showing running balance impact per entry
- **Add Transaction** — quick-entry form for income/expense with type, amount, category, date, and optional note
- **AI Financial Advisor** — in-dashboard panel offering a summary of spending behavior and a prompt box to ask financial questions

## Tech Stack

| Layer          | Technology                              |
|----------------|------------------------------------------|
| Language       | Java 17                                   |
| Web layer      | Java Servlets + JSP (`javax.servlet` 4.0.1) |
| Server         | Apache Tomcat 9.x                         |
| Build          | Maven                                     |
| Database       | MySQL 8                                   |
| Security       | jBCrypt (password hashing)                |
| IDE            | Eclipse (Dynamic Web Project / WTP)       |

## Screens

- **Login** — email + password sign-in with a "Secure Login" indicator
- <img width="1521" height="865" alt="image" src="https://github.com/user-attachments/assets/5ac8d4a6-779a-40b0-9a2a-f4ab2606eae6" />

- **Register** — first name, last name, email, and password sign-up
- <img width="1447" height="888" alt="image" src="https://github.com/user-attachments/assets/f44aa2a9-0acd-4817-93ca-21c4b41cc19e" />

- **Dashboard** — total balance, income, expenses, financial analytics chart, spending categories donut chart, recent transactions, AI advisor panel, and quick add-transaction form
- <img width="1897" height="911" alt="image" src="https://github.com/user-attachments/assets/02827265-dc32-45da-bb62-403444a84621" />

- **Transactions** — full searchable/sortable transaction history
<img width="1920" height="917" alt="image" src="https://github.com/user-attachments/assets/ae80b2c0-1259-4e89-b0e5-db2eafca6986" />

## Getting Started

### Prerequisites

- JDK 17
- Apache Maven
- Apache Tomcat 9.x (must be 9.x — the project uses the `javax.servlet` namespace, which is incompatible with Tomcat 10+)
- MySQL Server 8.x

### Database Setup

```sql
CREATE DATABASE bank_app;
USE bank_app;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100),
  prenom VARCHAR(100),
  email VARCHAR(150) UNIQUE,
  password VARCHAR(255)
);

CREATE TABLE transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_email VARCHAR(150),
  type VARCHAR(20),
  category VARCHAR(100),
  amount DECIMAL(12,2),
  description VARCHAR(255),
  transaction_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Update the credentials in `src/main/java/DBConnection.java` to match your local MySQL setup if they differ from the defaults (`root` / no password).

### Build & Run

```bash
git clone https://github.com/CondoRHxH/AI-Powered_Banking_Management_System.git
cd AI-Powered_Banking_Management_System
mvn clean package
```

Deploy the generated WAR from `target/` to your Tomcat 9 `webapps/` folder, then start Tomcat.

Alternatively, import the project into Eclipse (it's pre-configured as an Eclipse Dynamic Web Project) and run it via **Run As → Run on Server** against a Tomcat 9 server.

### Access

Once deployed, go to:

```
http://localhost:8080/<context-path>/Register.jsp
```

to create an account, then log in from `Login.jsp`.

## Project Structure

```
├── pom.xml
├── src/
│   └── main/
│       ├── java/              # Servlets & DB connection logic
│       │   ├── AuthFilter.java
│       │   ├── DBConnection.java
│       │   ├── Login_Servlet.java
│       │   ├── Register_Servlet.java
│       │   ├── Transaction_Servlet.java
│       │   ├── Transactions_Servlet.java
│       │   ├── Dashboard_Servlet.java
│       │   └── Logout_Servlet.java
│       └── webapp/            # JSP pages & web assets
│           ├── Login.jsp
│           ├── Register.jsp
│           ├── Dashboard.jsp
│           ├── Transactions.jsp
│           └── WEB-INF/
│               ├── web.xml
│               └── lib/
```

## Notes

- All routes except `Login.jsp`, `Register.jsp`, and their corresponding servlets are protected by `AuthFilter`, which redirects unauthenticated users back to login.
- Passwords are hashed with jBCrypt before storage — plaintext passwords are never persisted.

## License

This project is for educational purposes as part of a school coursework assignment.
