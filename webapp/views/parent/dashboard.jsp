<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Hệ thống Tiêm chủng</title>
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
                        <span>${sessionScope.userName}</span>
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
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="sidebar-menu-link active">
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

            <!-- MAIN CONTENT -->
            <main class="dashboard-main">
                <!-- PAGE HEADER -->
                <div class="page-header fade-in-up">
                    <h1 class="page-title">Dashboard</h1>
                    <p class="page-subtitle">Chào mừng trở lại, ${sessionScope.userName}! Quản lý thông tin tiêm chủng cho con bạn.</p>
                </div>

                <!-- STATISTICS CARDS -->
                <div class="stats-grid fade-in-up">
                    <div class="stat-card primary scale-in">
                        <div class="stat-card-header">
                            <div>
                                <div class="stat-card-title">Số con</div>
                                <div class="stat-card-value">${children.size()}</div>
                                <div class="stat-card-label">Trẻ đang theo dõi</div>
                            </div>
                            <div class="stat-card-icon">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card success scale-in" style="animation-delay: 0.1s;">
                        <div class="stat-card-header">
                            <div>
                                <div class="stat-card-title">Lịch hẹn</div>
                                <div class="stat-card-value">0</div>
                                <div class="stat-card-label">Lịch sắp tới</div>
                            </div>
                            <div class="stat-card-icon">
                                <i class="bi bi-calendar-check-fill"></i>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card info scale-in" style="animation-delay: 0.2s;">
                        <div class="stat-card-header">
                            <div>
                                <div class="stat-card-title">Đã tiêm</div>
                                <div class="stat-card-value">0</div>
                                <div class="stat-card-label">Mũi tiêm đã hoàn thành</div>
                            </div>
                            <div class="stat-card-icon">
                                <i class="bi bi-clipboard-pulse"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- MY CHILDREN SECTION -->
                <div class="content-card fade-in-up">
                    <div class="content-card-header">
                        <h3 class="content-card-title">
                            <i class="bi bi-people-fill"></i>
                            Danh sách con của tôi
                        </h3>
                        <a href="${pageContext.request.contextPath}/parent/children/add" class="btn-modern btn-primary-modern btn-sm-modern">
                            <i class="bi bi-plus-circle"></i>
                            Thêm con
                        </a>
                    </div>
                    <div class="content-card-body">
                        <c:choose>
                            <c:when test="${empty children}">
                                <div class="alert-modern alert-info-modern">
                                    <i class="bi bi-info-circle-fill"></i>
                                    <div>
                                        <strong>Chưa có thông tin trẻ em</strong><br>
                                        Bạn chưa thêm thông tin con của mình. Hãy nhấn nút "Thêm con" để bắt đầu.
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table-modern">
                                        <thead>
                                            <tr>
                                                <th><i class="bi bi-person"></i> Họ và tên</th>
                                                <th><i class="bi bi-calendar"></i> Ngày sinh</th>
                                                <th><i class="bi bi-gender-ambiguous"></i> Giới tính</th>
                                                <th><i class="bi bi-droplet"></i> Nhóm máu</th>
                                                <th><i class="bi bi-gear"></i> Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${children}" var="child">
                                                <tr>
                                                    <td><strong>${child.fullName}</strong></td>
                                                    <td>${child.dateOfBirth}</td>
                                                    <td>${child.gender}</td>
                                                    <td>${child.bloodType != null ? child.bloodType : 'Chưa có'}</td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}" 
                                                               class="btn-modern btn-info-modern btn-sm-modern">
                                                                <i class="bi bi-eye-fill"></i> Xem
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}" 
                                                               class="btn-modern btn-primary-modern btn-sm-modern">
                                                                <i class="bi bi-calendar-plus"></i> Đặt lịch
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/parent/vaccination-history/${child.childId}" 
                                                               class="btn-modern btn-success-modern btn-sm-modern">
                                                                <i class="bi bi-file-medical-fill"></i> Lịch sử
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- UPCOMING APPOINTMENTS SECTION -->
                <div class="content-card fade-in-up">
                    <div class="content-card-header">
                        <h3 class="content-card-title">
                            <i class="bi bi-calendar-event"></i>
                            Lịch hẹn sắp tới
                        </h3>
                        <a href="${pageContext.request.contextPath}/parent/appointments" class="btn-modern btn-outline-modern btn-sm-modern">
                            <i class="bi bi-list-ul"></i>
                            Xem tất cả
                        </a>
                    </div>
                    <div class="content-card-body">
                        <div class="alert-modern alert-secondary-modern">
                            <i class="bi bi-calendar-x"></i>
                            <div>
                                <strong>Không có lịch hẹn</strong><br>
                                Bạn chưa có lịch hẹn tiêm chủng nào sắp tới.
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>