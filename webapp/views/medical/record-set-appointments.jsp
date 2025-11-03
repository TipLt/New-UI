<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn lịch hẹn để tiêm - Y Tế</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
<!-- NAVBAR -->
<nav class="dashboard-navbar">
    <div class="dashboard-container">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <a href="${pageContext.request.contextPath}/medical/dashboard" class="navbar-brand-custom">
                <i class="bi bi-heart-pulse-fill"></i>
                <span>Vaccine For Kids - Medical</span>
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
                    <a href="${pageContext.request.contextPath}/medical/dashboard" class="sidebar-menu-link">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/appointments/" class="sidebar-menu-link">
                        <i class="bi bi-calendar-check"></i>
                        <span>Danh sách lịch hẹn</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/vaccination-record/" class="sidebar-menu-link active">
                        <i class="bi bi-syringe"></i>
                        <span>Ghi nhận tiêm chủng</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/vaccinations/" class="sidebar-menu-link">
                        <i class="bi bi-shield-plus"></i>
                        <span>Quản lý Vắc xin</span>
                    </a>
                </li>
            </ul>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="dashboard-main">
            <!-- PAGE HEADER -->
            <div class="page-header fade-in-up">
                <div>
                    <h1 class="page-title">Chọn lịch hẹn để tiêm</h1>
                    <p class="page-subtitle">Chọn lịch hẹn để bắt đầu ghi nhận chi tiết tiêm chủng</p>
                </div>
            </div>

            <!-- APPOINTMENTS LIST -->
            <c:choose>
                <c:when test="${empty appointments}">
                    <div class="content-card fade-in-up">
                        <div class="content-card-body">
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <i class="bi bi-calendar-x"></i>
                                </div>
                                <h3 class="empty-state-title">Chưa có lịch hẹn</h3>
                                <p class="empty-state-text">Hiện tại chưa có lịch hẹn nào cần tiêm.</p>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="content-card fade-in-up">
                        <div class="content-card-body">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th><i class="bi bi-hash"></i> ID</th>
                                        <th><i class="bi bi-person"></i> Trẻ</th>
                                        <th><i class="bi bi-shield-check"></i> Vaccine</th>
                                        <th><i class="bi bi-hospital"></i> Trung tâm</th>
                                        <th><i class="bi bi-calendar"></i> Ngày hẹn</th>
                                        <th><i class="bi bi-clock"></i> Giờ hẹn</th>
                                        <th><i class="bi bi-gear"></i> Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${appointments}" var="appointment">
                                        <tr>
                                            <td><strong>#${appointment.appointmentId}</strong></td>
                                            <td>${appointment.child.fullName}</td>
                                            <td>${appointment.vaccine.vaccineName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty appointment.center}">
                                                        ${appointment.center.centerName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa chọn</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${appointment.appointmentDate}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty appointment.appointmentTime}">
                                                        ${appointment.appointmentTime}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa chọn</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/medical/vaccination-record/datetime?appointmentId=${appointment.appointmentId}"
                                                   class="btn btn-sm btn-success">
                                                    <i class="bi bi-syringe"></i> Bắt đầu tiêm
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
