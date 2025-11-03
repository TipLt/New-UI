<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin tài khoản - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <nav class="dashboard-navbar">
        <div class="dashboard-container">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <a href="${pageContext.request.contextPath}/parent/dashboard" class="navbar-brand-custom">
                    <i class="bi bi-heart-pulse-fill"></i>
                    <span>Vaccine For Kids</span>
                </a>
                <div style="display: flex; align-items: center;">
                    <div class="navbar-user-info">
                        <i class="bi bi-person-circle"></i>
                        <span>${sessionScope.user.fullName}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        <i class="bi bi-box-arrow-right"></i>
                        Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="dashboard-row">
            <aside class="sidebar slide-in-left">
                <ul class="sidebar-menu">
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="sidebar-menu-link">
                            <i class="bi bi-speedometer2"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/profile" class="sidebar-menu-link active">
                            <i class="bi bi-person-circle"></i>
                            <span>Hồ sơ cá nhân</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/children" class="sidebar-menu-link">
                            <i class="bi bi-people-fill"></i>
                            <span>Danh sách con</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/booking/step1" class="sidebar-menu-link">
                            <i class="bi bi-calendar-plus"></i>
                            <span>Đặt lịch tiêm</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/appointments" class="sidebar-menu-link">
                            <i class="bi bi-calendar-check"></i>
                            <span>Lịch hẹn của tôi</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/vaccination-history" class="sidebar-menu-link">
                            <i class="bi bi-clipboard-pulse"></i>
                            <span>Lịch sử tiêm chủng</span>
                        </a>
                    </li>
                </ul>
            </aside>

            <main class="dashboard-main">
                <div class="page-header fade-in-up">
                    <div>
                        <h1 class="page-title">Hồ sơ cá nhân</h1>
                        <p class="page-subtitle">Quản lý thông tin tài khoản của bạn</p>
                    </div>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.1) 0%, rgba(92, 200, 190, 0.1) 100%); border-left: 4px solid #48C774;">
                        <i class="bi bi-check-circle-fill" style="color: #48C774; font-size: 1.5rem;"></i>
                        <div>
                            <strong>Thành công!</strong><br>
                            ${success}
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert-modern alert-info-modern fade-in-up" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left-color: #F14668;">
                        <i class="bi bi-exclamation-triangle-fill" style="color: #F14668;"></i>
                        <div>
                            <strong>Lỗi!</strong><br>
                            ${error}
                        </div>
                    </div>
                </c:if>

                <div class="content-card fade-in-up">
                    <div class="content-card-header">
                        <h3 class="content-card-title">
                            <i class="bi bi-camera-fill"></i>
                            Ảnh đại diện
                        </h3>
                    </div>
                    <div class="content-card-body">
                        <c:if test="${not empty successAvatar}">
                            <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.1) 0%, rgba(92, 200, 190, 0.1) 100%); border-left: 4px solid #48C774; margin-bottom: 1.5rem;">
                                <i class="bi bi-check-circle-fill" style="color: #48C774; font-size: 1.5rem;"></i>
                                <div>
                                    <strong>Thành công!</strong><br>
                                    ${successAvatar}
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorAvatar}">
                            <div class="alert-modern alert-info-modern fade-in-up" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left-color: #F14668; margin-bottom: 1.5rem;">
                                <i class="bi bi-exclamation-triangle-fill" style="color: #F14668;"></i>
                                <div>
                                    <strong>Lỗi!</strong><br>
                                    ${errorAvatar}
                                </div>
                            </div>
                        </c:if>

                        <div style="display: flex; align-items: center; gap: 2rem;">
                            <div style="position: relative;">
                                <c:choose>
                                    <c:when test="${not empty user.imageUrl}">
                                        <img id="avatarPreview" src="${user.imageUrl}" alt="Avatar" 
                                             style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 4px solid var(--primary-color); box-shadow: var(--shadow-md);">
                                    </c:when>
                                    <c:otherwise>
                                        <div id="avatarPreview" style="width: 150px; height: 150px; border-radius: 50%; background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); display: flex; align-items: center; justify-content: center; border: 4px solid var(--primary-color); box-shadow: var(--shadow-md);">
                                            <i class="bi bi-person-fill" style="font-size: 4rem; color: white;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div style="flex: 1;">
                                <form method="post" action="${pageContext.request.contextPath}/parent/profile" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="uploadAvatar">
                                    
                                    <div>
                                        <label for="avatar" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-dark);">
                                            <i class="bi bi-upload"></i> Tải lên ảnh mới
                                        </label>
                                        <input type="file" id="avatar" name="avatar" class="form-input-modern" 
                                               accept="image/jpeg,image/jpg,image/png,image/gif" onchange="previewImage(event)">
                                        <small style="color: var(--text-light); font-size: 0.85rem; display: block; margin-top: 0.3rem;">
                                            Chấp nhận: JPG, JPEG, PNG, GIF. Kích thước tối đa: 10MB
                                        </small>
                                    </div>

                                    <div style="padding-top: 1rem;">
                                        <button type="submit" class="btn-modern btn-primary-modern">
                                            <i class="bi bi-upload"></i> Cập nhật ảnh
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="content-card fade-in-up" style="margin-top: 1.5rem;">
                    <div class="content-card-header">
                        <h3 class="content-card-title">
                            <i class="bi bi-person-badge-fill"></i>
                            Thông tin cá nhân
                        </h3>
                    </div>
                    <div class="content-card-body">
                        <form method="post" action="${pageContext.request.contextPath}/parent/profile">
                            <input type="hidden" name="action" value="updateProfile">
                            
                            <div style="display: grid; grid-template-columns: 1fr; gap: 1.5rem; max-width: 600px;">
                                <div>
                                    <label style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-dark);">
                                        <i class="bi bi-envelope"></i> Email
                                    </label>
                                    <input type="email" class="form-input-modern" value="${user.email}" disabled
                                           style="background: var(--bg-section); cursor: not-allowed;">
                                    <small style="color: var(--text-light); font-size: 0.85rem; display: block; margin-top: 0.3rem;">
                                        Email không thể thay đổi
                                    </small>
                                </div>

                                <div>
                                    <label for="fullName" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-dark);">
                                        <i class="bi bi-person"></i> Họ và tên <span style="color: var(--danger-color);">*</span>
                                    </label>
                                    <input type="text" id="fullName" name="fullName" class="form-input-modern" 
                                           value="${user.fullName}" required>
                                </div>

                                <div>
                                    <label for="phoneNumber" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-dark);">
                                        <i class="bi bi-telephone"></i> Số điện thoại
                                    </label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" class="form-input-modern" 
                                           value="${user.phoneNumber}" placeholder="Nhập số điện thoại">
                                </div>

                                <div>
                                    <label style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-dark);">
                                        <i class="bi bi-shield-check"></i> Vai trò
                                    </label>
                                    <input type="text" class="form-input-modern" value="Phụ huynh" disabled
                                           style="background: var(--bg-section); cursor: not-allowed;">
                                </div>

                                <div style="padding-top: 1rem;">
                                    <button type="submit" class="btn-modern btn-primary-modern">
                                        <i class="bi bi-check-circle"></i> Cập nhật thông tin
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="content-card fade-in-up" style="margin-top: 1.5rem;">
                    <div class="content-card-header">
                        <h3 class="content-card-title">
                            <i class="bi bi-shield-lock-fill"></i>
                            Đổi mật khẩu
                        </h3>
                    </div>
                    <div class="content-card-body">
                        <c:if test="${not empty successPassword}">
                            <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.1) 0%, rgba(92, 200, 190, 0.1) 100%); border-left: 4px solid #48C774; margin-bottom: 1.5rem;">
                                <i class="bi bi-check-circle-fill" style="color: #48C774; font-size: 1.5rem;"></i>
                                <div>
                                    <strong>Thành công!</strong><br>
                                    ${successPassword}
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorPassword}">
                            <div class="alert-modern alert-info-modern fade-in-up" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left-color: #F14668; margin-bottom: 1.5rem;">
                                <i class="bi bi-exclamation-triangle-fill" style="color: #F14668;"></i>
                                <div>
                                    <strong>Lỗi!</strong><br>
                                    ${errorPassword}
                                </div>
                            </div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/parent/profile">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div style="display: grid; grid-template-columns: 1fr; gap: 1.5rem; max-width: 600px;">
                                <div>
                                    <label for="currentPassword" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-dark);">
                                        <i class="bi bi-lock"></i> Mật khẩu hiện tại <span style="color: var(--danger-color);">*</span>
                                    </label>
                                    <input type="password" id="currentPassword" name="currentPassword" class="form-input-modern" 
                                           required placeholder="Nhập mật khẩu hiện tại">
                                </div>

                                <div>
                                    <label for="newPassword" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-dark);">
                                        <i class="bi bi-key"></i> Mật khẩu mới <span style="color: var(--danger-color);">*</span>
                                    </label>
                                    <input type="password" id="newPassword" name="newPassword" class="form-input-modern" 
                                           required placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)">
                                </div>

                                <div>
                                    <label for="confirmPassword" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-dark);">
                                        <i class="bi bi-shield-check"></i> Xác nhận mật khẩu <span style="color: var(--danger-color);">*</span>
                                    </label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input-modern" 
                                           required placeholder="Nhập lại mật khẩu mới">
                                </div>

                                <div style="padding-top: 1rem;">
                                    <button type="submit" class="btn-modern btn-primary-modern">
                                        <i class="bi bi-shield-check"></i> Đổi mật khẩu
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        function previewImage(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('avatarPreview');
                    if (preview.tagName === 'IMG') {
                        preview.src = e.target.result;
                    } else {
                        const img = document.createElement('img');
                        img.id = 'avatarPreview';
                        img.src = e.target.result;
                        img.alt = 'Avatar Preview';
                        img.style.cssText = 'width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 4px solid var(--primary-color); box-shadow: var(--shadow-md);';
                        preview.parentNode.replaceChild(img, preview);
                    }
                }
                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>