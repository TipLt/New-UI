<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết lịch hẹn - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .info-section {
            background: linear-gradient(135deg, rgba(74, 144, 226, 0.05) 0%, rgba(92, 200, 190, 0.05) 100%);
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--primary-color);
        }
        .info-section h6 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }
        .info-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-dark);
        }
        .status-badge-large {
            padding: 0.8rem 1.5rem;
            border-radius: var(--border-radius-xl);
            font-weight: 700;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
    </style>
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

            <main class="dashboard-main">
                <div style="margin-bottom: 1.5rem;">
                    <nav aria-label="breadcrumb">
                        <ol style="display: flex; list-style: none; padding: 0; margin: 0; gap: 0.5rem; font-size: 0.9rem;">
                            <li><a href="${pageContext.request.contextPath}/parent/dashboard" style="color: var(--primary-color);">Dashboard</a></li>
                            <li style="color: var(--text-light);">/</li>
                            <li><a href="${pageContext.request.contextPath}/parent/appointments" style="color: var(--primary-color);">Lịch hẹn</a></li>
                            <li style="color: var(--text-light);">/</li>
                            <li style="color: var(--text-medium);">Chi tiết</li>
                        </ol>
                    </nav>
                </div>

                <div class="page-header fade-in-up">
                    <h1 class="page-title">Chi tiết lịch hẹn</h1>
                    <p class="page-subtitle">Thông tin đầy đủ về lịch hẹn tiêm chủng</p>
                </div>

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
                    <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left: 4px solid var(--danger-color);">
                        <i class="bi bi-exclamation-circle-fill" style="color: var(--danger-color); font-size: 1.5rem;"></i>
                        <div>
                            <strong>Lỗi!</strong><br>
                            ${sessionScope.error}
                        </div>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <div style="display: grid; grid-template-columns: 1fr auto; gap: 2rem; margin-bottom: 2rem;">
                    <div class="content-card fade-in-up">
                        <div class="content-card-header">
                            <h3 class="content-card-title">
                                <i class="bi bi-info-circle-fill"></i>
                                Thông tin lịch hẹn
                            </h3>
                        </div>
                        <div class="content-card-body">
                            <div class="info-grid" style="margin-bottom: 1.5rem;">
                                <div class="info-item">
                                    <span class="info-label"><i class="bi bi-hash"></i> Mã lịch hẹn</span>
                                    <span class="info-value">#${appointment.appointmentId}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label"><i class="bi bi-calendar3"></i> Ngày hẹn</span>
                                    <span class="info-value">
                                        <${appointment.appointmentDate}
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label"><i class="bi bi-clock"></i> Giờ hẹn</span>
                                    <span class="info-value">
                                        ${appointment.appointmentTime}
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label"><i class="bi bi-flag-fill"></i> Trạng thái</span>
                                    <c:choose>
                                        <c:when test="${appointment.status == 'PENDING'}">
                                            <span class="status-badge-large" style="background: linear-gradient(135deg, rgba(255, 184, 77, 0.2) 0%, rgba(255, 107, 157, 0.2) 100%); color: #FFB84D;">
                                                <i class="bi bi-hourglass-split"></i> Chờ xác nhận
                                            </span>
                                        </c:when>
                                        <c:when test="${appointment.status == 'CONFIRMED'}">
                                            <span class="status-badge-large" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.2) 0%, rgba(92, 200, 190, 0.2) 100%); color: #48C774;">
                                                <i class="bi bi-check-circle-fill"></i> Đã xác nhận
                                            </span>
                                        </c:when>
                                        <c:when test="${appointment.status == 'COMPLETED'}">
                                            <span class="status-badge-large" style="background: linear-gradient(135deg, rgba(58, 191, 248, 0.2) 0%, rgba(74, 144, 226, 0.2) 100%); color: #3ABFF8;">
                                                <i class="bi bi-check-all"></i> Hoàn thành
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge-large" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.2) 0%, rgba(255, 107, 157, 0.2) 100%); color: #F14668;">
                                                <i class="bi bi-x-circle-fill"></i> Đã hủy
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="info-section">
                                <h6><i class="bi bi-person-fill"></i> Thông tin trẻ em</h6>
                                <div class="info-grid">
                                    <div class="info-item">
                                        <span class="info-label">Họ và tên</span>
                                        <span class="info-value">${appointment.child.fullName}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Ngày sinh</span>
                                        <span class="info-value">${appointment.child.dateOfBirth}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Giới tính</span>
                                        <span class="info-value">${appointment.child.gender != null ? appointment.child.gender : 'N/A'}</span>
                                    </div>
                                    <c:if test="${not empty appointment.child.bloodType}">
                                        <div class="info-item">
                                            <span class="info-label">Nhóm máu</span>
                                            <span class="info-value">${appointment.child.bloodType}</span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="info-section">
                                <h6><i class="bi bi-shield-fill-check"></i> Thông tin vaccine</h6>
                                <div class="info-grid">
                                    <div class="info-item">
                                        <span class="info-label">Tên vaccine</span>
                                        <span class="info-value" style="color: var(--primary-color);">${appointment.vaccine.vaccineName}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Nhà sản xuất</span>
                                        <span class="info-value">${appointment.vaccine.manufacturer}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Phòng bệnh</span>
                                        <span class="info-value">${appointment.vaccine.diseasesPrevented}</span>
                                    </div>
                                    <c:if test="${appointment.vaccine.free}">
                                        <div class="info-item">
                                            <span class="info-label">Phân loại</span>
                                            <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.4rem 1rem; background: linear-gradient(135deg, rgba(72, 199, 116, 0.2) 0%, rgba(92, 200, 190, 0.2) 100%); border-radius: 20px; color: #48C774; font-weight: 600;">
                                                <i class="bi bi-gift-fill"></i> Miễn phí
                                            </span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <c:if test="${not empty appointment.notes}">
                                <div class="info-section">
                                    <h6><i class="bi bi-sticky-fill"></i> Ghi chú</h6>
                                    <div style="background: white; padding: 1rem; border-radius: var(--border-radius-md); border: 1px solid var(--bg-section);">
                                        ${appointment.notes}
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div style="width: 350px;">
                        <div class="content-card fade-in-up">
                            <div class="content-card-header">
                                <h3 class="content-card-title">
                                    <i class="bi bi-gear-fill"></i>
                                    Thao tác
                                </h3>
                            </div>
                            <div class="content-card-body">
                                <c:choose>
                                    <c:when test="${appointment.status == 'PENDING' || appointment.status == 'CONFIRMED'}">
                                        <button type="button" class="btn-modern btn-danger w-100" style="width: 100%; margin-bottom: 1rem;" onclick="document.getElementById('cancelModal').style.display='flex'">
                                            <i class="bi bi-x-circle"></i> Hủy lịch hẹn
                                        </button>
                                        <div class="alert-modern alert-info-modern" style="margin: 0;">
                                            <i class="bi bi-info-circle-fill"></i>
                                            <div>
                                                <strong>Lưu ý</strong><br>
                                                Vui lòng đến trước 15 phút so với giờ hẹn.
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${appointment.status == 'COMPLETED'}">
                                        <div class="alert-modern" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.1) 0%, rgba(92, 200, 190, 0.1) 100%); border-left: 4px solid #48C774; margin: 0;">
                                            <i class="bi bi-check-circle-fill" style="color: #48C774; font-size: 1.5rem;"></i>
                                            <div>
                                                <strong>Hoàn thành</strong><br>
                                                Lịch hẹn này đã được hoàn thành.
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${appointment.status == 'CANCELLED'}">
                                        <div class="alert-modern" style="background: linear-gradient(135deg, rgba(120, 144, 156, 0.1) 0%, rgba(120, 144, 156, 0.1) 100%); border-left: 4px solid var(--text-medium); margin: 0;">
                                            <i class="bi bi-info-circle-fill" style="color: var(--text-medium); font-size: 1.5rem;"></i>
                                            <div>
                                                <strong>Đã hủy</strong><br>
                                                Lịch hẹn này đã được hủy.
                                            </div>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <div class="content-card fade-in-up" style="margin-top: 1.5rem;">
                            <div class="content-card-header">
                                <h3 class="content-card-title">
                                    <i class="bi bi-link-45deg"></i>
                                    Liên kết nhanh
                                </h3>
                            </div>
                            <div class="content-card-body" style="display: flex; flex-direction: column; gap: 0.75rem;">
                                <a href="${pageContext.request.contextPath}/parent/appointments" class="btn-modern btn-outline-modern" style="width: 100%;">
                                    <i class="bi bi-calendar-check"></i> Tất cả lịch hẹn
                                </a>
                                <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn-modern btn-primary-modern" style="width: 100%;">
                                    <i class="bi bi-calendar-plus"></i> Đặt lịch mới
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <div id="cancelModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); align-items: center; justify-content: center; z-index: 9999;">
        <div style="background: white; border-radius: var(--border-radius-lg); max-width: 500px; width: 90%; padding: 2rem; box-shadow: var(--shadow-xl);">
            <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem;">
                <i class="bi bi-exclamation-triangle" style="font-size: 3rem; color: var(--warning-color);"></i>
                <h5 style="margin: 0; color: var(--text-dark);">Hủy lịch hẹn</h5>
            </div>
            <p style="color: var(--text-medium); margin-bottom: 1rem;">Bạn có chắc chắn muốn hủy lịch hẹn này không?</p>
            <p style="color: var(--text-light); font-size: 0.9rem; margin-bottom: 1.5rem;">Hành động này không thể hoàn tác. Bạn sẽ cần đặt lịch mới nếu muốn tiêm chủng.</p>
            <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                <button type="button" class="btn-modern btn-outline-modern" onclick="document.getElementById('cancelModal').style.display='none'">
                    <i class="bi bi-x"></i> Không, giữ lại
                </button>
                <form method="post" action="${pageContext.request.contextPath}/parent/appointments/${appointment.appointmentId}/cancel" style="display: inline;">
                    <button type="submit" class="btn-modern" style="background: var(--danger-color); color: white;">
                        <i class="bi bi-check"></i> Có, hủy lịch
                    </button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>