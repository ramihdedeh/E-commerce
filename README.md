# E-commerce
# E-commerce Project

## Project Setup

This project consists of a **backend (Spring Boot)** and a **frontend (Flutter Web)**. Below are the setup instructions for both.

---

## Backend Setup (Spring Boot)

```java
class BackendSetup {
    // Prerequisites:
    // - Java 17+
    // - Maven 3.8+
    // - MySQL Server
    // - HeidiSQL or MySQL Workbench (optional for database management)

    public static void main(String[] args) {
        System.out.println("Follow the steps to set up the backend:");
        System.out.println("1. Clone the repository:");
        System.out.println("   git clone https://github.com/ramihdedeh/E-commerce.git");
        System.out.println("2. Navigate to the backend directory:");
        System.out.println("   cd backend");
        System.out.println("3. Configure database connection in application.properties:");
        System.out.println("   spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce");
        System.out.println("   spring.datasource.username=root");
        System.out.println("   spring.datasource.password=yourpassword");
        System.out.println("4. Run the application:");
        System.out.println("   mvn spring-boot:run");
    }
}
