<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Vaccine For Kids</title>
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
                        <i class="bi bi-box-arrow-in-right"></i>
                        <br>Đăng nhập
                    </h3>
                    <p class="auth-subtitle">Chào mừng bạn trở lại!</p>
                </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <i class="bi bi-exclamation-circle"></i> ${error}
                            </div>
                        </c:if>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                <i class="bi bi-check-circle"></i> ${success}
                            </div>
                        </c:if>

                <form method="post" action="${pageContext.request.contextPath}/login">
                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="bi bi-envelope-fill me-1"></i>Email
                        </label>
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="your@email.com" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="bi bi-lock-fill me-1"></i>Mật khẩu
                        </label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Nhập mật khẩu" required>
                    </div>
                    
                    <button type="submit" class="btn btn-auth">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập
                    </button>
                </form>

                <div class="auth-link">
                    <p class="mb-0">Chưa có tài khoản? 
                        <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                    </p>
                </div>

                <hr class="auth-divider">
                
            </div>
        </div>
    </div>
    
    <footer class="auth-footer">
        © 2024 Vaccine For Kids - Hệ thống quản lý tiêm chủng
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
