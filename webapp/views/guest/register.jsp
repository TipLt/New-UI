<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Vaccine For Kids</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg auth-navbar">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-heart-pulse-fill"></i> Vaccine For Kids
            </a>
        </div>
    </nav>

    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-card-body">
                <div class="auth-header">
                    <h3>
                        <i class="bi bi-person-plus"></i>
                        <br>Đăng ký tài khoản
                    </h3>
                    <p class="auth-subtitle">Tạo tài khoản để quản lý tiêm chủng cho bé</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">
                    <div class="mb-3">
                        <label for="fullName" class="form-label">
                            <i class="bi bi-person-fill me-1"></i>Họ và tên *
                        </label>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               placeholder="Nguyễn Văn A" required>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="bi bi-envelope-fill me-1"></i>Email *
                        </label>
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="email@example.com" required>
                    </div>

                    <div class="mb-3">
                        <label for="phoneNumber" class="form-label">
                            <i class="bi bi-telephone-fill me-1"></i>Số điện thoại
                        </label>
                        <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" 
                               placeholder="0901234567">
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="bi bi-lock-fill me-1"></i>Mật khẩu *
                        </label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Tối thiểu 6 ký tự" required>
                        <small class="form-text text-muted">Tối thiểu 6 ký tự</small>
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">
                            <i class="bi bi-lock-fill me-1"></i>Xác nhận mật khẩu *
                        </label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                               placeholder="Nhập lại mật khẩu" required>
                    </div>

                    <button type="submit" class="btn btn-auth">
                        <i class="bi bi-person-plus me-2"></i>Đăng ký
                    </button>
                </form>

                <div class="auth-link">
                    <p class="mb-0">Đã có tài khoản? 
                        <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <footer class="auth-footer">
        © 2024 Vaccine For Kids - Hệ thống quản lý tiêm chủng
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
        });
    </script>
</body>
</html>
