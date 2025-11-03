package com.vaccination.controller.parent;

import com.vaccination.dao.UserDAO;
import com.vaccination.model.User;
import com.vaccination.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/parent/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class ParentProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PARENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        User freshUserData = userDAO.findById(user.getUserId());
        if (freshUserData != null) {
            request.setAttribute("user", freshUserData);
        }

        request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PARENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            handleUpdateProfile(request, response, user);
        } else if ("changePassword".equals(action)) {
            handleChangePassword(request, response, user);
        } else if ("uploadAvatar".equals(action)) {
            handleUploadAvatar(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent/profile");
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Họ và tên không được để trống");
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
            return;
        }

        User updatedUser = userDAO.findById(user.getUserId());
        updatedUser.setFullName(fullName.trim());
        updatedUser.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : "");

        if (userDAO.updateUser(updatedUser)) {
            HttpSession session = request.getSession();
            session.setAttribute("user", updatedUser);
            
            request.setAttribute("success", "Cập nhật thông tin thành công!");
            request.setAttribute("user", updatedUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        User dbUser = userDAO.findById(user.getUserId());

        if (currentPassword == null || newPassword == null || confirmPassword == null) {
            request.setAttribute("errorPassword", "Vui lòng điền đầy đủ thông tin");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
            return;
        }

        if (!PasswordUtil.verifyPassword(currentPassword, dbUser.getPassword())) {
            request.setAttribute("errorPassword", "Mật khẩu hiện tại không đúng");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("errorPassword", "Mật khẩu mới phải có ít nhất 6 ký tự");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorPassword", "Mật khẩu mới và xác nhận mật khẩu không khớp");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        if (userDAO.updatePassword(user.getUserId(), hashedPassword)) {
            request.setAttribute("successPassword", "Đổi mật khẩu thành công!");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
        } else {
            request.setAttribute("errorPassword", "Đổi mật khẩu thất bại. Vui lòng thử lại!");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
        }
    }

    private void handleUploadAvatar(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        Part filePart = request.getPart("avatar");
        
        if (filePart == null || filePart.getSize() == 0) {
            User dbUser = userDAO.findById(user.getUserId());
            request.setAttribute("errorAvatar", "Vui lòng chọn file ảnh");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
            return;
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        int lastDotIndex = fileName.lastIndexOf(".");
        
        if (lastDotIndex < 0 || lastDotIndex == fileName.length() - 1) {
            User dbUser = userDAO.findById(user.getUserId());
            request.setAttribute("errorAvatar", "File không hợp lệ. Vui lòng chọn file ảnh có đuôi JPG, JPEG, PNG hoặc GIF");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
            return;
        }
        
        String fileExtension = fileName.substring(lastDotIndex).toLowerCase();
        
        if (!fileExtension.matches("\\.(jpg|jpeg|png|gif)")) {
            User dbUser = userDAO.findById(user.getUserId());
            request.setAttribute("errorAvatar", "Chỉ chấp nhận file ảnh (JPG, JPEG, PNG, GIF)");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
            return;
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "avatars";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String uniqueFileName = "avatar_" + user.getUserId() + "_" + UUID.randomUUID().toString() + fileExtension;
        Path filePath = Paths.get(uploadPath, uniqueFileName);
        
        Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        String imageUrl = request.getContextPath() + "/uploads/avatars/" + uniqueFileName;

        if (userDAO.updateImageUrl(user.getUserId(), imageUrl)) {
            User updatedUser = userDAO.findById(user.getUserId());
            HttpSession session = request.getSession();
            session.setAttribute("user", updatedUser);
            
            request.setAttribute("successAvatar", "Cập nhật ảnh đại diện thành công!");
            request.setAttribute("user", updatedUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
        } else {
            User dbUser = userDAO.findById(user.getUserId());
            request.setAttribute("errorAvatar", "Cập nhật ảnh thất bại. Vui lòng thử lại!");
            request.setAttribute("user", dbUser);
            request.getRequestDispatcher("/views/parent/parent-profile.jsp").forward(request, response);
        }
    }
}