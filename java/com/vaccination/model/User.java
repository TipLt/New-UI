package com.vaccination.model;

import java.time.LocalDateTime;

public class User {
    private int userId;
    private String email;
    private String password;
    private String fullName;
    private String phoneNumber;
    private String role;
    private boolean isActive; // <<<--- GIỮ NGUYÊN TÊN BIẾN
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime lastLogin;
    private String imageUrl; // <<<--- THÊM TRƯỜNG NÀY

    public User() {
    }

    public User(int userId, String email, String fullName, String phoneNumber, String role) {
        this.userId = userId;
        this.email = email;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.isActive = true; // Giữ nguyên
    }

    // --- Getters and Setters cũ (Giữ nguyên) ---
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    // Getter cho boolean nên là "is" + TênBiếnViếtHoaChữĐầu
    public boolean isActive() { return isActive; } // <<<--- GIỮ NGUYÊN PHƯƠNG THỨC GETTER
    // Setter cho boolean nên là "set" + TênBiếnViếtHoaChữĐầu
    public void setActive(boolean active) { isActive = active; } // <<<--- GIỮ NGUYÊN PHƯƠNG THỨC SETTER

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }

    // --- THÊM GETTER VÀ SETTER MỚI CHO imageUrl ---
    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    // --- KẾT THÚC PHẦN THÊM MỚI ---

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", role='" + role + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                '}';
    }
}