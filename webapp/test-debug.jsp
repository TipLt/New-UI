<%@ page import="com.vaccination.dao.UserDAO" %>
<%@ page import="com.vaccination.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Login Issue</title>
    <style>
        body { font-family: monospace; padding: 20px; }
        .debug { background: #f0f0f0; padding: 10px; margin: 10px 0; border-left: 4px solid #007bff; }
        .error { border-left-color: #dc3545; }
        .success { border-left-color: #28a745; }
        pre { background: #2d2d2d; color: #fff; padding: 10px; overflow-x: auto; }
    </style>
</head>
<body>
    <h1> Login Debug Tool</h1>
    
    <%
        UserDAO userDAO = new UserDAO();
        String testEmail = "admin@vaccination.com";
        String testPassword = "Admin@123";
        
        out.println("<div class='debug'>");
        out.println("<h3> TEST INPUT:</h3>");
        out.println("<pre>");
        out.println("Test Email: [" + testEmail + "]");
        out.println("Test Email Length: " + testEmail.length());
        out.println("Test Password: [" + testPassword + "]");
        out.println("Test Password Length: " + testPassword.length());
        
        // Convert to bytes
        byte[] emailBytes = testEmail.getBytes();
        byte[] passBytes = testPassword.getBytes();
        out.println("\nEmail Bytes: " + java.util.Arrays.toString(emailBytes));
        out.println("Password Bytes: " + java.util.Arrays.toString(passBytes));
        out.println("</pre>");
        out.println("</div>");
        
        // Find user
        out.println("<div class='debug'>");
        out.println("<h3> DATABASE LOOKUP:</h3>");
        out.println("<pre>");
        
        User user = userDAO.findByEmail(testEmail);
        
        if (user == null) {
            out.println("❌ USER NOT FOUND!");
            out.println("UserDAO.findByEmail() returned NULL");
            out.println("\n️ PROBLEM: Database connection or query issue");
            out.println("</pre></div>");
        } else {
            out.println("✅ USER FOUND!");
            out.println("\nUser Object Details:");
            out.println("  UserID: " + user.getUserId());
            out.println("  Email: [" + user.getEmail() + "]");
            out.println("  Email Length: " + user.getEmail().length());
            out.println("  FullName: " + user.getFullName());
            out.println("  Role: " + user.getRole());
            out.println("  IsActive: " + user.isActive());
            
            String dbPassword = user.getPassword();
            out.println("\n🔑 PASSWORD DETAILS:");
            out.println("  DB Password: [" + dbPassword + "]");
            out.println("  DB Password Length: " + (dbPassword != null ? dbPassword.length() : "NULL"));
            
            if (dbPassword != null) {
                out.println("  DB Password Bytes: " + java.util.Arrays.toString(dbPassword.getBytes()));
                
                out.println("\n CHARACTER-BY-CHARACTER ANALYSIS:");
                int maxLen = Math.max(testPassword.length(), dbPassword.length());
                for (int i = 0; i < maxLen; i++) {
                    if (i < testPassword.length() && i < dbPassword.length()) {
                        char inputChar = testPassword.charAt(i);
                        char dbChar = dbPassword.charAt(i);
                        int inputASCII = (int) inputChar;
                        int dbASCII = (int) dbChar;
                        boolean match = (inputChar == dbChar);
                        
                        String status = match ? "✅" : "❌";
                        out.println(String.format("  Pos %d: Input='%c'(%d) vs DB='%c'(%d) %s", 
                            i, inputChar, inputASCII, dbChar, dbASCII, status));
                    } else if (i >= testPassword.length()) {
                        char dbChar = dbPassword.charAt(i);
                        out.println(String.format("  Pos %d: Input=(END) vs DB='%c'(%d) ❌ EXTRA IN DB", 
                            i, dbChar, (int)dbChar));
                    } else {
                        char inputChar = testPassword.charAt(i);
                        out.println(String.format("  Pos %d: Input='%c'(%d) vs DB=(END) ❌ EXTRA IN INPUT", 
                            i, inputChar, (int)inputChar));
                    }
                }
                
                out.println("\n COMPARISON RESULTS:");
                boolean exactMatch = testPassword.equals(dbPassword);
                boolean trimMatch = testPassword.equals(dbPassword.trim());
                boolean ignoreCaseMatch = testPassword.equalsIgnoreCase(dbPassword);
                
                out.println("  testPassword.equals(dbPassword): " + exactMatch + (exactMatch ? " ✅" : " ❌"));
                out.println("  testPassword.equals(dbPassword.trim()): " + trimMatch + (trimMatch ? " ✅" : " ❌"));
                out.println("  testPassword.equalsIgnoreCase(dbPassword): " + ignoreCaseMatch + (ignoreCaseMatch ? " ✅" : " ❌"));
                
                out.println("\n RECOMMENDATION:");
                if (exactMatch) {
                    out.println("   Passwords match perfectly!");
                    out.println("  ️ Problem is in LoginServlet logic or session handling");
                } else if (trimMatch) {
                    out.println("  ️ Passwords match after trim!");
                    out.println("  ️ Database has trailing/leading spaces");
                    out.println("  ️ Fix: Use dbPassword.trim() in LoginServlet");
                } else if (ignoreCaseMatch) {
                    out.println("  ️ Passwords match ignoring case!");
                    out.println("   Case sensitivity issue (A vs a)");
                } else {
                    out.println("   Passwords DO NOT MATCH!");
                    out.println("  ️ Check character-by-character comparison above");
                }
            } else {
                out.println("  ❌ DB Password is NULL!");
            }
            out.println("</pre>");
            out.println("</div>");
        }
    %>
    
    <div class="debug">
        <h3>🧪 DIRECT LOGIN TEST:</h3>
        <form method="post" action="<%= request.getContextPath() %>/login">
            <p>Try login with these credentials:</p>
            <input type="text" name="email" value="admin@vaccination.com" style="width:300px;padding:5px;">
            <input type="text" name="password" value="Admin@123" style="width:200px;padding:5px;">
            <button type="submit" style="padding:5px 20px;"> Test Login</button>
        </form>
    </div>
    
    <div class="debug">
        <h3> INSTRUCTIONS:</h3>
        <ol>
            <li>Check the comparison results above</li>
            <li>Look for any  symbols indicating mismatches</li>
            <li>Follow the RECOMMENDATION section</li>
            <li>Take a screenshot and send it to me</li>
        </ol>
    </div>
</body>
</html>