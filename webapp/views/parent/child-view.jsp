<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin chi tiết - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <!-- NAVBAR -->
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

    <!-- MAIN DASHBOARD LAYOUT -->
    <div class="dashboard-container">
        <div class="dashboard-row">
            <!-- SIDEBAR MENU -->
            <aside class="sidebar slide-in-left">
                <ul class="sidebar-menu">
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="sidebar-menu-link">
                            <i class="bi bi-speedometer2"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/profile" class="sidebar-menu-link">
                            <i class="bi bi-person-circle"></i>
                            <span>Hồ sơ cá nhân</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/children" class="sidebar-menu-link active">
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

            <!-- MAIN CONTENT -->
            <main class="dashboard-main">
                <!-- BREADCRUMB -->
                <div style="margin-bottom: 1.5rem;">
                    <nav aria-label="breadcrumb">
                        <ol style="display: flex; list-style: none; padding: 0; margin: 0; gap: 0.5rem; font-size: 0.9rem;">
                            <li><a href="${pageContext.request.contextPath}/parent/children" style="color: var(--primary-color);">Danh sách con</a></li>
                            <li style="color: var(--text-light);">/</li>
                            <li style="color: var(--text-medium);">${child.fullName}</li>
                        </ol>
                    </nav>
                </div>

                <!-- PAGE HEADER -->
                <div class="page-header fade-in-up">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <h1 class="page-title">Hồ sơ trẻ em</h1>
                            <p class="page-subtitle">Thông tin chi tiết về ${child.fullName}</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}" 
                           class="btn-modern btn-primary-modern">
                            <i class="bi bi-calendar-plus"></i>
                            Đặt lịch tiêm
                        </a>
                    </div>
                </div>

                <!-- CHILD PROFILE CARD -->
                <div class="content-card fade-in-up">
                    <div class="content-card-header">
                        <h3 class="content-card-title">
                            <i class="bi bi-person-badge-fill"></i>
                            Thông tin cá nhân
                        </h3>
                    </div>
                    <div class="content-card-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">
                            <!-- Full Name -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem;">
                                    <i class="bi bi-person"></i> Họ và tên
                                </label>
                                <h4 style="font-size: 1.3rem; color: var(--text-dark); font-weight: 700;">${child.fullName}</h4>
                            </div>

                            <!-- Date of Birth -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem;">
                                    <i class="bi bi-calendar"></i> Ngày sinh
                                </label>
                                <h4 style="font-size: 1.3rem; color: var(--text-dark); font-weight: 700;">${child.dateOfBirth}</h4>
                            </div>

                            <!-- Age -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem;">
                                    <i class="bi bi-hourglass-split"></i> Tuổi
                                </label>
                                <h4 style="font-size: 1.3rem; color: var(--text-dark); font-weight: 700;">
                                    <c:set var="years" value="${child.ageYears}" />
                                    <c:set var="months" value="${child.ageRemainingMonths}" />
                                    <c:choose>
                                        <c:when test="${child.ageInMonths < 12}">
                                            ${child.ageInMonths} tháng
                                        </c:when>
                                        <c:when test="${months == 0}">
                                            ${years} tuổi
                                        </c:when>
                                        <c:otherwise>
                                            ${years} tuổi ${months} tháng
                                        </c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>

                            <!-- Gender -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem;">
                                    <i class="bi bi-gender-ambiguous"></i> Giới tính
                                </label>
                                <h4 style="font-size: 1.3rem; font-weight: 700;">
                                    <c:choose>
                                        <c:when test="${child.gender == 'Male'}">
                                            <span style="color: var(--primary-color);"><i class="bi bi-gender-male"></i> Nam</span>
                                        </c:when>
                                        <c:when test="${child.gender == 'Female'}">
                                            <span style="color: #FF6B9D;"><i class="bi bi-gender-female"></i> Nữ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--text-medium);">${child.gender}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>

                            <!-- Blood Type -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem;">
                                    <i class="bi bi-droplet-fill"></i> Nhóm máu
                                </label>
                                <h4 style="font-size: 1.3rem; color: var(--danger-color); font-weight: 700;">
                                    ${not empty child.bloodType ? child.bloodType : 'Chưa có'}
                                </h4>
                            </div>

                            <!-- Weight -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem;">
                                    <i class="bi bi-bar-chart"></i> Cân nặng
                                </label>
                                <h4 style="font-size: 1.3rem; color: var(--text-dark); font-weight: 700;">
                                    ${not empty child.weight ? child.weight : 'Chưa ghi'}${not empty child.weight ? ' kg' : ''}
                                </h4>
                            </div>

                            <!-- Height -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem;">
                                    <i class="bi bi-rulers"></i> Chiều cao
                                </label>
                                <h4 style="font-size: 1.3rem; color: var(--text-dark); font-weight: 700;">
                                    ${not empty child.height ? child.height : 'Chưa ghi'}${not empty child.height ? ' cm' : ''}
                                </h4>
                            </div>
                        </div>

                        <hr style="margin: 2rem 0; border: none; border-top: 2px solid var(--bg-section);">

                        <!-- Medical Information -->
                        <div style="display: grid; grid-template-columns: 1fr; gap: 1.5rem;">
                            <!-- Medical History -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.8rem;">
                                    <i class="bi bi-file-medical"></i> Tiền sử bệnh
                                </label>
                                <div class="alert-modern alert-info-modern">
                                    <i class="bi bi-file-medical-fill"></i>
                                    <div>${not empty child.medicalHistory ? child.medicalHistory : 'Không có tiền sử bệnh ghi nhận'}</div>
                                </div>
                            </div>

                            <!-- Allergies -->
                            <div>
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.8rem;">
                                    <i class="bi bi-exclamation-triangle"></i> Dị ứng
                                </label>
                                <div style="padding: 1.5rem 2rem; border-radius: var(--border-radius-md); background: linear-gradient(135deg, rgba(255, 184, 77, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left: 4px solid var(--warning-color); display: flex; align-items: center; gap: 1rem;">
                                    <i class="bi bi-exclamation-triangle-fill" style="font-size: 1.5rem; color: var(--warning-color);"></i>
                                    <div style="font-weight: 500; color: var(--text-dark);">${not empty child.allergies ? child.allergies : 'Không có dị ứng ghi nhận'}</div>
                                </div>
                            </div>
                        </div>

                        <hr style="margin: 2rem 0; border: none; border-top: 2px solid var(--bg-section);">

                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.1) 0%, rgba(92, 200, 190, 0.1) 100%); border-left: 4px solid #48C774; margin-bottom: 1.5rem;">
                                <i class="bi bi-check-circle-fill" style="color: #48C774; font-size: 1.5rem;"></i>
                                <div>
                                    <strong>Thành công!</strong><br>
                                    ${sessionScope.successMessage}
                                </div>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>

                        <!-- Action Buttons -->
                        <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/parent/children" class="btn-modern btn-outline-modern">
                                <i class="bi bi-arrow-left"></i> Quay lại
                            </a>
                            <a href="${pageContext.request.contextPath}/parent/children/edit?id=${child.childId}" 
                               class="btn-modern" style="background: linear-gradient(135deg, #FFB84D 0%, #FF8C42 100%); color: white;">
                                <i class="bi bi-pencil-square"></i> Chỉnh sửa
                            </a>
                            <a href="${pageContext.request.contextPath}/parent/recommended-vaccines?childId=${child.childId}" 
                               class="btn-modern btn-info-modern">
                                <i class="bi bi-clipboard2-pulse-fill"></i> Vaccine đề xuất
                            </a>
                            <a href="${pageContext.request.contextPath}/parent/vaccination-history/${child.childId}" 
                               class="btn-modern btn-success-modern">
                                <i class="bi bi-clipboard-pulse"></i> Lịch sử tiêm
                            </a>
                            <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}" 
                               class="btn-modern btn-primary-modern">
                                <i class="bi bi-calendar-plus"></i> Đặt lịch mới
                            </a>
                        </div>

                        <!-- Footer Info -->
                        <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--bg-section); color: var(--text-light); font-size: 0.85rem;">
                            <i class="bi bi-clock"></i> Tạo lúc: ${child.createdAt}
                            <c:if test="${not empty child.updatedAt}">
                                | Cập nhật: ${child.updatedAt}
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>