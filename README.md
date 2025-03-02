# E-commerce
# E-commerce Project

## Project Setup

This project consists of a **backend (Spring Boot)** and a **frontend (Flutter Web)**. Below are the setup instructions for both.

---

## Backend Setup (Spring Boot)


 BackendSetup 
 
    Prerequisites:
    
     - Java 17+
     - Maven 3.8+
     - MySQL Server
     - HeidiSQL or MySQL Workbench (optional for database management)

Follow the steps to set up the backend:

       1. Clone the repository:

        git clone https://github.com/ramihdedeh/E-commerce.git

      2. Navigate to the backend directory:

          cd backend

        3. Configure database connection in application.properties:
           spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce
           spring.datasource.username=root
          spring.datasource.password=yourpassword

4.install dependencies :

    mvn clean package

5. Run the application:

    mvn spring-boot:run

FrontendSetup

  Prerequisites:

  - Flutter SDK installed
  - Dart installed
  - Chrome (for web preview)
  - Android Studio or Visual Studio Code (optional for development)

setup
    Follow the steps to set up the frontend:

    1. Navigate to the frontend directory:

       cd frontend

    2. Install dependencies:

       flutter pub get

    3. Run the application:

       flutter run -d chrome
  


