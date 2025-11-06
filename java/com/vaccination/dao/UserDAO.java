package com.vaccination.dao;

import com.vaccination.model.User;
import com.vaccination.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class UserDAO {

    // ... (Các hàm findByEmail, findById, createUser, updateUser, updatePassword, updateLastLogin giữ nguyên) ...
    public User findByEmail(String email) {
    String sql = "SELECT * FROM Users WHERE Email = ?";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        // ✅ FIX 1: Log chi tiết
        System.out.println("\n========================================");
        System.out.println("UserDAO.findByEmail() CALLED");
        System.out.println("========================================");
        System.out.println("Input email: [" + email + "]");
        System.out.println("Email length: " + (email != null ? email.length() : "null"));
        
        // ✅ FIX 2: Get connection với error handling
        try {
            conn = DatabaseConnection.getInstance().getConnection();
            System.out.println("✅ Connection obtained: " + (conn != null));
        } catch (Exception e) {
            System.err.println("❌ FAILED to get connection:");
            e.printStackTrace();
            return null;
        }
        
        if (conn == null) {
            System.err.println("❌ Connection is NULL!");
            return null;
        }
        
        if (conn.isClosed()) {
            System.err.println("❌ Connection is CLOSED!");
            return null;
        }
        
        System.out.println("✅ Connection valid and open");
        System.out.println("Database catalog: " + conn.getCatalog());
        
        // ✅ FIX 3: Prepare statement với validation
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, email);
        
        System.out.println("SQL Query: " + sql);
        System.out.println("Parameter [1]: [" + email + "]");
        
        // ✅ FIX 4: Execute query với timeout
        rs = stmt.executeQuery();
        System.out.println("✅ Query executed successfully");
        
        // ✅ FIX 5: Process result
        if (rs.next()) {
            System.out.println("✅ ResultSet has data!");
            
            User user = extractUserFromResultSet(rs);
            
            System.out.println("✅ USER FOUND AND EXTRACTED!");
            System.out.println("   UserID: " + user.getUserId());
            System.out.println("   Email: [" + user.getEmail() + "]");
            System.out.println("   Password: [" + user.getPassword() + "]");
            System.out.println("   Password Length: " + (user.getPassword() != null ? user.getPassword().length() : "null"));
            System.out.println("   FullName: " + user.getFullName());
            System.out.println("   Role: " + user.getRole());
            System.out.println("   IsActive: " + user.isActive());
            System.out.println("========================================\n");
            
            return user;
        } else {
            System.out.println("❌ ResultSet is EMPTY (no data)");
            
            // Debug: Show all emails
            try {
                Statement debugStmt = conn.createStatement();
                ResultSet debugRs = debugStmt.executeQuery("SELECT Email FROM Users");
                System.out.println("Available emails in database:");
                int count = 0;
                while (debugRs.next()) {
                    count++;
                    String dbEmail = debugRs.getString("Email");
                    System.out.println("  " + count + ". [" + dbEmail + "]");
                    
                    // Compare
                    if (email != null && email.equals(dbEmail)) {
                        System.out.println("     ️ MATCH! But query didn't find it?!");
                    }
                }
                System.out.println("Total emails in DB: " + count);
                debugRs.close();
                debugStmt.close();
            } catch (SQLException debugEx) {
                System.err.println("Debug query failed: " + debugEx.getMessage());
            }
            
            System.out.println("========================================\n");
        }
        
    } catch (SQLException e) {
        System.err.println("❌ SQL EXCEPTION in findByEmail()!");
        System.err.println("Message: " + e.getMessage());
        System.err.println("SQL State: " + e.getSQLState());
        System.err.println("Error Code: " + e.getErrorCode());
        System.err.println("Stack trace:");
        e.printStackTrace();
    } catch (Exception e) {
        System.err.println("❌ UNEXPECTED EXCEPTION in findByEmail()!");
        System.err.println("Type: " + e.getClass().getName());
        System.err.println("Message: " + e.getMessage());
        e.printStackTrace();
    } finally {
        // ✅ FIX 6: Properly close resources
        try {
            if (rs != null) {
                rs.close();
                System.out.println("ResultSet closed");
            }
            if (stmt != null) {
                stmt.close();
                System.out.println("Statement closed");
            }
            if (conn != null) {
                conn.close();
                System.out.println("Connection closed");
            }
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage());
        }
    }
    
    System.out.println("❌ Returning NULL (no user found)");
    return null;
    }

    public User findById(int userId) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createUser(User user) {
        // Cần cập nhật câu SQL để thêm cột ImageUrl nếu bạn muốn thêm ảnh ngay khi tạo user
        String sql = "INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive, ImageUrl) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)"; // Thêm ImageUrl vào VALUES
        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPassword()); // Cần hash password ở đây
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhoneNumber());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.isActive());
            stmt.setString(7, user.getImageUrl()); // Thêm ImageUrl

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    user.setUserId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUser(User user) {
        // Cần cập nhật câu SQL để cho phép sửa ImageUrl nếu muốn
        String sql = "UPDATE Users SET FullName = ?, PhoneNumber = ?, ImageUrl = ?, UpdatedAt = GETDATE() WHERE UserID = ?"; // Thêm ImageUrl = ?
        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setString(3, user.getImageUrl()); // Thêm ImageUrl
            stmt.setInt(4, user.getUserId()); // Chỉ số tham số thay đổi

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET Password = ?, UpdatedAt = GETDATE() WHERE UserID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword); // Cần hash password mới
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateLastLogin(int userId) {
        String sql = "UPDATE Users SET LastLogin = GETDATE() WHERE UserID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> findByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role = ? AND IsActive = 1";
        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY CreatedAt DESC";
        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean deactivateUser(int userId) {
        String sql = "UPDATE Users SET IsActive = 0, UpdatedAt = GETDATE() WHERE UserID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getInstance().getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Delete related records first to avoid foreign key constraint violations
            
            // 1. Delete notifications for this user
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM Notifications WHERE UserID = ?")) {
                stmt.setInt(1, userId);
                stmt.executeUpdate();
            }
            
            // 2. Delete staff assignments
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM StaffAssignments WHERE UserID = ?")) {
                stmt.setInt(1, userId);
                stmt.executeUpdate();
            }
            
            // 3. Set ConfirmedBy to NULL in appointments
            try (PreparedStatement stmt = conn.prepareStatement("UPDATE Appointments SET ConfirmedBy = NULL WHERE ConfirmedBy = ?")) {
                stmt.setInt(1, userId);
                stmt.executeUpdate();
            }
            
            // 4. Set AdministeredBy to NULL in vaccination records (if possible) or handle error
            // Note: AdministeredBy is NOT NULL, so we cannot delete users who have administered vaccinations
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM VaccinationRecords WHERE AdministeredBy = ?")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    conn.rollback();
                    throw new SQLException("Cannot delete user: This user has administered vaccinations");
                }
            }
            
            // 5. Handle Children table - ParentID has ON DELETE CASCADE, so it will be handled automatically
            // But we might want to check if this will orphan children
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM Children WHERE ParentID = ?")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    // Children will be deleted due to CASCADE, but we should inform about this
                    int childCount = rs.getInt(1);
                    // Note: In production, use proper logging framework
                    System.err.println("Warning: Deleting user will also delete " + childCount + " child record(s)");
                }
            }
            
            // 6. Finally delete the user
            String sql = "DELETE FROM Users WHERE UserID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                int result = stmt.executeUpdate();
                
                if (result > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    // Log rollback failure
                    System.err.println("Failed to rollback transaction: " + ex.getMessage());
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    // Log connection cleanup failure
                    System.err.println("Failed to close connection: " + e.getMessage());
                }
            }
        }
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserID"));
        String dbEmail = rs.getString("Email");
        user.setEmail(dbEmail != null ? dbEmail.trim() : null); // Trim to handle NVARCHAR padding
        String dbPassword = rs.getString("Password");
        user.setPassword(dbPassword != null ? dbPassword.trim() : null); // Trim password to handle NVARCHAR padding
        user.setFullName(rs.getString("FullName"));
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setRole(rs.getString("Role"));
        user.setActive(rs.getBoolean("IsActive"));

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            user.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        Timestamp lastLogin = rs.getTimestamp("LastLogin");
        if (lastLogin != null) {
            user.setLastLogin(lastLogin.toLocalDateTime());
        }

        // Check if ImageUrl column exists before accessing it
        try {
            rs.findColumn("ImageUrl");
            user.setImageUrl(rs.getString("ImageUrl"));
        } catch (SQLException e) {
            // ImageUrl column doesn't exist in this database schema
            user.setImageUrl(null);
        }

        return user;
    }

    public boolean updateImageUrl(int userId, String imageUrl) {
        String sql = "UPDATE Users SET ImageUrl = ?, UpdatedAt = GETDATE() WHERE UserID = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, imageUrl);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
     //admin merge
    /**
     * Get paginated users with optional role filter
     * @param page page number (1-based)
     * @param size items per page
     * @param roleFilter filter by role (null = all)
     * @return List of users as Map (for JSP compatibility)
     */
    public List<Map<String, Object>> getUsers(int page, int size, String roleFilter) throws SQLException {
        List<Map<String, Object>> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role != 'GUEST'";
        
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql += " AND Role = ?";
        }
        sql += " ORDER BY UserID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(paramIndex++, roleFilter);
            }
            ps.setInt(paramIndex++, (page - 1) * size);
            ps.setInt(paramIndex, size);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("UserID", rs.getInt("UserID"));
                user.put("Email", rs.getString("Email"));
                user.put("FullName", rs.getString("FullName"));
                user.put("PhoneNumber", rs.getString("PhoneNumber"));
                user.put("Role", rs.getString("Role"));
                user.put("IsActive", rs.getBoolean("IsActive"));
                user.put("CreatedAt", rs.getTimestamp("CreatedAt"));
                user.put("LastLogin", rs.getTimestamp("LastLogin"));
                users.add(user);
            }
        }
        return users;
    }

    /**
     * Get total count of users for pagination
     * @param roleFilter filter by role (null = all)
     * @return total count
     */
    public int getTotalUsers(String roleFilter) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE Role != 'GUEST'";
        
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql += " AND Role = ?";
        }
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(1, roleFilter);
            }
            
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
     /**
     * Create user with role validation (Admin function)
     * Uses PLAIN TEXT password
     * @return true if successful
     */
    public boolean createUserWithRole(String email, String password, String fullName, 
                                      String phone, String role) throws SQLException {
        // Validate role
        if (!Arrays.asList("ADMIN", "RECEPTION", "MEDICAL", "PARENT").contains(role)) {
            return false;
        }
        
        // Plain text password (NO BCrypt)
        String sql = "INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, 1)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password); // Plain text
            ps.setString(3, fullName);
            ps.setString(4, phone);
            ps.setString(5, role);
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Get user by ID as Map (for Admin JSP)
     * @param id user ID
     * @return user data as Map
     */
    public Map<String, Object> getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("UserID", rs.getInt("UserID"));
                user.put("Email", rs.getString("Email"));
                user.put("Password", rs.getString("Password")); // Include password for admin view
                user.put("FullName", rs.getString("FullName"));
                user.put("PhoneNumber", rs.getString("PhoneNumber"));
                user.put("Role", rs.getString("Role"));
                user.put("IsActive", rs.getBoolean("IsActive"));
                user.put("CreatedAt", rs.getTimestamp("CreatedAt"));
                user.put("LastLogin", rs.getTimestamp("LastLogin"));
                return user;
            }
        }
        return null;
    }

    /**
     * Update user info (Admin function)
     * @param id user ID
     * @param fullName new full name
     * @param phone new phone
     * @param role new role
     * @return true if successful
     */
    public boolean updateUserByAdmin(int id, String fullName, String phone, String role) throws SQLException {
        String sql = "UPDATE Users SET FullName = ?, PhoneNumber = ?, Role = ? WHERE UserID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, role);
            ps.setInt(4, id);
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Toggle user active/inactive status
     * @param id user ID
     * @param active new status
     * @return true if successful
     */
    public boolean toggleActive(int id, boolean active) throws SQLException {
        String sql = "UPDATE Users SET IsActive = ? WHERE UserID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Reset password to random value
     * Returns the new password (plain text)
     * @param id user ID
     * @return new password or null if failed
     */
    public String resetPassword(int id) throws SQLException {
        String newPass = generateRandomPassword();
        String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newPass); // Plain text
            ps.setInt(2, id);
            
            if (ps.executeUpdate() > 0) {
                return newPass;
            }
        }
        return null;
    }

    /**
     * Generate random password
     * @return random password string
     */
    private String generateRandomPassword() {
        return "Pass" + (int)(Math.random() * 1000000);
    }
}
