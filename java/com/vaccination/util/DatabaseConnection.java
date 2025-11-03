package com.vaccination.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {
    private static DatabaseConnection instance;
    private String url;
    private String username;
    private String password;
    private String driver;

    private DatabaseConnection() {
        try {
            Properties props = new Properties();
            InputStream input = getClass().getClassLoader().getResourceAsStream("database.properties");
            
            if (input == null) {
                System.out.println("Unable to find database.properties, using defaults");
                this.driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
                this.url = "jdbc:sqlserver://localhost:1433;databaseName=VaccinationDB";
                this.username = "dodt";
                this.password = "123456789";
            } else {
                props.load(input);
                this.driver = props.getProperty("db.driver");
                this.url = props.getProperty("db.url");
                this.username = props.getProperty("db.username");
                this.password = props.getProperty("db.password");
                input.close();
            }

            Class.forName(driver);
            System.out.println("MSSQL JDBC Driver Registered!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MSSQL JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (IOException e) {
            System.err.println("Error loading database properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    public void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
}
