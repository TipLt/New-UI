<%@ page import="com.vaccination.util.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
    <style>
        body { font-family: monospace; padding: 20px; }
        .success { background: #d4edda; border: 2px solid #28a745; padding: 15px; margin: 10px 0; }
        .error { background: #f8d7da; border: 2px solid #dc3545; padding: 15px; margin: 10px 0; }
        pre { background: #2d2d2d; color: #fff; padding: 10px; overflow-x: auto; }
    </style>
</head>
<body>
    <h1> Database Connection Test</h1>
    
    <%
        Connection conn = null;
        try {
            out.println("<div class='success'>");
            out.println("<h3>✅ STEP 1: Get DatabaseConnection Instance</h3>");
            DatabaseConnection dbInstance = DatabaseConnection.getInstance();
            out.println("<p>✅ DatabaseConnection instance created</p>");
            
            out.println("<h3>✅ STEP 2: Get Connection</h3>");
            conn = dbInstance.getConnection();
            out.println("<p>✅ Connection object obtained</p>");
            
            if (conn != null && !conn.isClosed()) {
                out.println("<h3>✅ STEP 3: Connection Details</h3>");
                out.println("<pre>");
                out.println("Connection Status: CONNECTED");
                out.println("Connection Class: " + conn.getClass().getName());
                out.println("Database Product: " + conn.getMetaData().getDatabaseProductName());
                out.println("Database Version: " + conn.getMetaData().getDatabaseProductVersion());
                out.println("Driver Name: " + conn.getMetaData().getDriverName());
                out.println("Driver Version: " + conn.getMetaData().getDriverVersion());
                out.println("Catalog: " + conn.getCatalog());
                out.println("URL: " + conn.getMetaData().getURL());
                out.println("</pre>");
                
                out.println("<h3>✅ STEP 4: Test Query - Find Admin User</h3>");
                String sql = "SELECT * FROM Users WHERE Email = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, "admin@vaccination.com");
                
                out.println("<pre>");
                out.println("SQL: " + sql);
                out.println("Parameter: admin@vaccination.com");
                out.println("</pre>");
                
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    out.println("<div class='success'>");
                    out.println("<h3>✅ USER FOUND!</h3>");
                    out.println("<pre>");
                    out.println("UserID: " + rs.getInt("UserID"));
                    out.println("Email: " + rs.getString("Email"));
                    out.println("Password: [" + rs.getString("Password") + "]");
                    out.println("FullName: " + rs.getString("FullName"));
                    out.println("Role: " + rs.getString("Role"));
                    out.println("IsActive: " + rs.getBoolean("IsActive"));
                    out.println("</pre>");
                    out.println("</div>");
                } else {
                    out.println("<div class='error'>");
                    out.println("<h3>❌ USER NOT FOUND IN QUERY!</h3>");
                    out.println("<p>Connection works but query returns no results</p>");
                    out.println("</div>");
                }
                
                rs.close();
                stmt.close();
                
                out.println("<h3>✅ STEP 5: List All Users</h3>");
                Statement listStmt = conn.createStatement();
                ResultSet allUsers = listStmt.executeQuery("SELECT UserID, Email, Role FROM Users");
                
                out.println("<pre>");
                int count = 0;
                while (allUsers.next()) {
                    count++;
                    out.println(count + ". UserID=" + allUsers.getInt("UserID") + 
                              ", Email=[" + allUsers.getString("Email") + "]" +
                              ", Role=" + allUsers.getString("Role"));
                }
                out.println("\nTotal users: " + count);
                out.println("</pre>");
                
                allUsers.close();
                listStmt.close();
                
            } else {
                out.println("<div class='error'>");
                out.println("<h3>❌ CONNECTION FAILED</h3>");
                out.println("<p>Connection is null or closed</p>");
                out.println("</div>");
            }
            out.println("</div>");
            
        } catch (Exception e) {
            out.println("<div class='error'>");
            out.println("<h3>❌ ERROR OCCURRED</h3>");
            out.println("<pre>");
            out.println("Exception Type: " + e.getClass().getName());
            out.println("Message: " + e.getMessage());
            out.println("\nStack Trace:");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
            out.println("</div>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    out.println("<p>✅ Connection closed</p>");
                } catch (SQLException e) {
                    out.println("<p>️ Error closing connection: " + e.getMessage() + "</p>");
                }
            }
        }
    %>
    
    <hr>
    <h3> Database Configuration Check</h3>
    <pre><%= 
        "Looking for: resources/database.properties\n" +
        "Expected content:\n" +
        "  db.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver\n" +
        "  db.url=jdbc:sqlserver://localhost:1433;databaseName=VaccinationDB;encrypt=true;trustServerCertificate=true\n" +
        "  db.username=sa\n" +
        "  db.password=123456"
    %></pre>
</body>
</html>