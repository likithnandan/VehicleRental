package util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static final String DEFAULT_URL =
        "jdbc:mysql://localhost:3306/vehicle_rental?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        String url = DEFAULT_URL;
        String user = DEFAULT_USER;
        String password = "";

        // 1. Try reading from classpath db.properties if present (git-ignored)
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                Properties props = new Properties();
                props.load(in);
                if (props.getProperty("db.url") != null && !props.getProperty("db.url").trim().isEmpty()) {
                    url = props.getProperty("db.url").trim();
                }
                if (props.getProperty("db.user") != null && !props.getProperty("db.user").trim().isEmpty()) {
                    user = props.getProperty("db.user").trim();
                }
                if (props.getProperty("db.password") != null) {
                    password = props.getProperty("db.password").trim();
                }
            }
        } catch (Exception ignored) {
        }

        // 2. Environment variables take precedence (12-factor cloud & CI/CD best practice)
        String envUrl = System.getenv("DB_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            url = envUrl;
        }

        String envUser = System.getenv("DB_USER");
        if (envUser != null && !envUser.trim().isEmpty()) {
            user = envUser;
        }

        String envPassword = System.getenv("DB_PASSWORD");
        if (envPassword != null) {
            password = envPassword;
        }

        // 3. System properties fallback (-Ddb.password=...)
        String propPassword = System.getProperty("db.password");
        if (propPassword != null) {
            password = propPassword;
        }

        return DriverManager.getConnection(url, user, password);
    }
}