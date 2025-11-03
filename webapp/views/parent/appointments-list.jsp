<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch hẹn của tôi - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .filter-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        .filter-tab {
            padding: 0.8rem 1.5rem;
            border-radius: var(--border-radius-xl);
            border: 2px solid var(--bg-section);
            background: white;
            color: var(--text-medium);
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-smooth);
        }
        .filter-tab:hover {
            border-color: var(--primary-light);
            transform: translateY(-2px);
        }
        .filter-tab.active {
            background: var(--gradient-hero);
            border-color: transparent;
            color: white;
            box-shadow: var(--shadow-md);
        }
        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: var(--border-radius-xl);
            font-weight: 600;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }
        .status-PENDING { background: linear-gradient(135deg, rgba(255, 184, 77, 0.2) 0%, rgba(255, 107, 157, 0.2) 100%); color: #FFB84D; }
        .status-CONFIRMED { background: linear-gradient(135deg, rgba(72, 199, 116, 0.2) 0%, rgba(92, 200, 190, 0.2) 100%); color: #48C774; }
        .status-COMPLETED { background: linear-gradient(135deg, rgba(58, 191, 248, 0.2) 0%, rgba(74, 144, 226, 0.2) 100%); color: #3ABFF8; }
        .status-CANCELLED { background: linear-gradient(135deg, rgba(241, 70, 104, 0.2) 0%, rgba(255, 107, 157, 0.2) 100%); color: #F14668; }
        .status-REJECTED { background: linear-gradient(135deg, rgba(241, 70, 104, 0.2) 0%, rgba(255, 107, 157, 0.2) 100%); color: #F14668; }
    </style>
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
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="sidebar-menu-link">
                            <i class="bi bi-speedometer2"></i>
                            <span>Dashboard</span>
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
                        <a href="${pageContext.request.contextPath}/parent/appointments" class="sidebar-menu-link active">
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
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <h1 class="page-title">Lịch hẹn của tôi</h1>
                            <p class="page-subtitle">Quản lý và theo dõi các lịch hẹn tiêm chủng</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn-modern btn-primary-modern">
                            <i class="bi bi-calendar-plus"></i>
                            Đặt lịch mới
                        </a>
                    </div>
                </div>

                <!-- SUCCESS/ERROR MESSAGES -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.1) 0%, rgba(92, 200, 190, 0.1) 100%); border-left: 4px solid #48C774;">
                        <i class="bi bi-check-circle-fill" style="color: #48C774; font-size: 1.5rem;"></i>
                        <div>
                            <strong>Thành công!</strong><br>
                            ${sessionScope.success}
                        </div>
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.error}">
                    <div class="alert-modern alert-info-modern fade-in-up" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left-color: #F14668;">
                        <i class="bi bi-exclamation-triangle-fill" style="color: #F14668;"></i>
                        <div>
                            <strong>Lỗi!</strong><br>
                            ${sessionScope.error}
                        </div>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <!-- FILTER TABS -->
                <div class="filter-tabs fade-in-up">
                    <button class="filter-tab active" onclick="filterAppointments('ALL')">
                        <i class="bi bi-list-ul"></i> Tất cả
                    </button>
                    <button class="filter-tab" onclick="filterAppointments('PENDING')">
                        <i class="bi bi-hourglass-split"></i> Chờ xác nhận
                    </button>
                    <button class="filter-tab" onclick="filterAppointments('CONFIRMED')">
                        <i class="bi bi-check-circle"></i> Đã xác nhận
                    </button>
                    <button class="filter-tab" onclick="filterAppointments('COMPLETED')">
                        <i class="bi bi-check-all"></i> Hoàn thành
                    </button>
                    <button class="filter-tab" onclick="filterAppointments('CANCELLED')">
                        <i class="bi bi-x-circle"></i> Đã hủy
                    </button>
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
                                    <p class="empty-state-text">Bạn chưa đặt lịch hẹn nào. Hãy bắt đầu bằng cách đặt lịch tiêm chủng cho con bạn.</p>
                                    <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn-modern btn-primary-modern">
                                        <i class="bi bi-calendar-plus"></i>
                                        Đặt lịch hẹn đầu tiên
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="content-card fade-in-up">
                            <div class="content-card-body">
                                <div class="table-responsive">
                                    <table class="table-modern">
                                        <thead>
                                            <tr>
                                                <th><i class="bi bi-person"></i> Trẻ</th>
                                                <th><i class="bi bi-shield-check"></i> Vaccine</th>
                                                <th><i class="bi bi-hospital"></i> Trung tâm</th>
                                                <th><i class="bi bi-calendar"></i> Ngày</th>
                                                <th><i class="bi bi-clock"></i> Giờ</th>
                                                <th><i class="bi bi-info-circle"></i> Trạng thái</th>
                                                <th><i class="bi bi-credit-card"></i> Thanh toán</th>
                                                <th><i class="bi bi-gear"></i> Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${appointments}" var="appointment">
                                                <tr class="appointment-row" data-status="${appointment.status}">
                                                    <td><strong>${appointment.child.fullName}</strong></td>
                                                    <td>${appointment.vaccine.vaccineName}</td>
                                                    <td>${appointment.center.centerName}</td>
                                                    <td>${appointment.appointmentDate}</td>
                                                    <td>${appointment.appointmentTime}</td>
                                                    <td>
                                                        <span class="status-badge status-${appointment.status}">
                                                            <c:choose>
                                                                <c:when test="${appointment.status == 'PENDING'}">
                                                                    <i class="bi bi-hourglass-split"></i> Chờ
                                                                </c:when>
                                                                <c:when test="${appointment.status == 'CONFIRMED'}">
                                                                    <i class="bi bi-check-circle-fill"></i> Xác nhận
                                                                </c:when>
                                                                <c:when test="${appointment.status == 'COMPLETED'}">
                                                                    <i class="bi bi-check-all"></i> Hoàn thành
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="bi bi-x-circle-fill"></i> Hủy
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${appointment.paymentStatus == 'PAID'}">
                                                                <span style="color: #48C774; font-weight: 600;">
                                                                    <i class="bi bi-check-circle-fill"></i> Đã thanh toán
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${appointment.paymentStatus == 'PENDING'}">
                                                                <span style="color: #FFB84D; font-weight: 600;">
                                                                    <i class="bi bi-clock-fill"></i> Chờ
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #F14668; font-weight: 600;">
                                                                    <i class="bi bi-x-circle-fill"></i> Chưa thanh toán
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/parent/appointments/${appointment.appointmentId}" 
                                                           class="btn-modern btn-info-modern btn-sm-modern">
                                                            <i class="bi bi-eye-fill"></i> Xem
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

    <script>
        function filterAppointments(status) {
            const tabs = document.querySelectorAll('.filter-tab');
            const rows = document.querySelectorAll('.appointment-row');
            
            tabs.forEach(tab => tab.classList.remove('active'));
            event.target.closest('.filter-tab').classList.add('active');
            
            rows.forEach(row => {
                if (status === 'ALL' || row.dataset.status === status) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>