package com.vaccination.controller;

import com.vaccination.dao.UserDAO;
import com.vaccination.model.User;
import com.vaccination.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    System.out.println("\n========================================");
    System.out.println(" LOGIN ATTEMPT - DETAILED DEBUG");
    System.out.println("========================================");
    
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    System.out.println("1. RAW INPUT FROM FORM:");
    System.out.println("   Email: [" + email + "]");
    System.out.println("   Password: [" + password + "]");
    System.out.println("   Email is null? " + (email == null));
    System.out.println("   Password is null? " + (password == null));
    
    if (email != null) {
        System.out.println("   Email length: " + email.length());
        System.out.println("   Email bytes: " + java.util.Arrays.toString(email.getBytes()));
    }
    if (password != null) {
        System.out.println("   Password length: " + password.length());
        System.out.println("   Password bytes: " + java.util.Arrays.toString(password.getBytes()));
    }

    if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
        System.out.println(" VALIDATION FAILED: Empty fields");
        request.setAttribute("error", "Email and password are required");
        request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
        return;
    }

    email = email.trim();
    password = password.trim();
    
    System.out.println("\n2. AFTER TRIM:");
    System.out.println("   Email: [" + email + "]");
    System.out.println("   Password: [" + password + "]");
    System.out.println("   Email length: " + email.length());
    System.out.println("   Password length: " + password.length());
    
    System.out.println("\n3. CALLING UserDAO.findByEmail()...");
    User user = userDAO.findByEmail(email);

    if (user == null) {
        System.out.println(" USER NOT FOUND IN DATABASE");
        System.out.println("   Searched email: [" + email + "]");
        System.out.println("========================================\n");
        request.setAttribute("error", "Invalid email or password");
        request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
        return;
    }
    
    System.out.println(" USER FOUND IN DATABASE");
    System.out.println("   User ID: " + user.getUserId());
    System.out.println("   User Email: [" + user.getEmail() + "]");
    System.out.println("   User Role: " + user.getRole());
    System.out.println("   User Active: " + user.isActive());
    
    System.out.println("\n4. PASSWORD COMPARISON:");
    System.out.println("   Input Password: [" + password + "]");
    System.out.println("   DB Password: [" + user.getPassword() + "]");
    System.out.println("   Input Password Length: " + password.length());
    System.out.println("   DB Password Length: " + user.getPassword().length());
    
    // Character-by-character comparison
    System.out.println("\n5. CHARACTER-BY-CHARACTER COMPARISON:");
    String dbPass = user.getPassword();
    int maxLen = Math.max(password.length(), dbPass.length());
    for (int i = 0; i < maxLen; i++) {
        if (i < password.length() && i < dbPass.length()) {
            char inputChar = password.charAt(i);
            char dbChar = dbPass.charAt(i);
            boolean match = (inputChar == dbChar);
            System.out.println("   Pos " + i + ": Input='" + inputChar + "' (" + (int)inputChar + ") vs DB='" + dbChar + "' (" + (int)dbChar + ") - " + (match ? "✅" : "❌"));
        } else if (i >= password.length()) {
            System.out.println("   Pos " + i + ": Input=(END) vs DB='" + dbPass.charAt(i) + "' (" + (int)dbPass.charAt(i) + ") - ❌ EXTRA CHAR IN DB");
        } else {
            System.out.println("   Pos " + i + ": Input='" + password.charAt(i) + "' (" + (int)password.charAt(i) + ") vs DB=(END) - ❌ EXTRA CHAR IN INPUT");
        }
    }
    
    boolean passwordMatch = password.equals(user.getPassword());
    boolean passwordMatchIgnoreCase = password.equalsIgnoreCase(user.getPassword());
    boolean passwordMatchTrimmed = password.equals(user.getPassword().trim());
    
    System.out.println("\n6. COMPARISON RESULTS:");
    System.out.println("   password.equals(dbPassword): " + passwordMatch);
    System.out.println("   passwordIgnoreCase: " + passwordMatchIgnoreCase);
    System.out.println("   passwordTrimmed: " + passwordMatchTrimmed);
    
    if (passwordMatch) {
        if (!user.isActive()) {
            System.out.println(" LOGIN FAILED: Account deactivated");
            System.out.println("========================================\n");
            request.setAttribute("error", "Your account has been deactivated");
            request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
            return;
        }

        System.out.println(" LOGIN SUCCESS!");
        
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("userName", user.getFullName());

        userDAO.updateLastLogin(user.getUserId());

<<<<<<< Updated upstream
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getFullName());

            userDAO.updateLastLogin(user.getUserId());

            switch (user.getRole()) {
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                case "RECEPTION":
                    response.sendRedirect(request.getContextPath() + "/reception/appointments-list");
                    break;
                case "MEDICAL":
                    response.sendRedirect(request.getContextPath() + "/medical/vaccinations");
                    break;
                case "PARENT":
                    response.sendRedirect(request.getContextPath() + "/parent/dashboard");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/");
                    break;
            }
        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
=======
        String redirectUrl = "";
        switch (user.getRole()) {
            case "ADMIN":
                redirectUrl = request.getContextPath() + "/admin/dashboard";
                break;
            case "RECEPTION":
                redirectUrl = request.getContextPath() + "/reception/appointments-list";
                break;
            case "MEDICAL":
                redirectUrl = request.getContextPath() + "/medical/appointments";
                break;
            case "PARENT":
                redirectUrl = request.getContextPath() + "/parent/dashboard";
                break;
            default:
                redirectUrl = request.getContextPath() + "/";
                break;
>>>>>>> Stashed changes
        }
        System.out.println("   Redirecting to: " + redirectUrl);
        System.out.println("========================================\n");
        response.sendRedirect(redirectUrl);
    } else {
        System.out.println(" LOGIN FAILED: PASSWORD MISMATCH");
        System.out.println("   This is the exact problem!");
        System.out.println("========================================\n");
        request.setAttribute("error", "Invalid email or password");
        request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
    }
    }
}
