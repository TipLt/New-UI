<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử tiêm chủng - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .child-selection-card {
            cursor: pointer;
            transition: var(--transition-smooth);
            border: 2px solid var(--bg-section);
            border-radius: var(--border-radius-lg);
            background: white;
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        .child-selection-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: var(--gradient-hero);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .child-selection-card:hover::before {
            opacity: 0.05;
        }
        .child-selection-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-light);
        }
        .child-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: var(--gradient-hero);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            margin: 0 auto 1.5rem;
            box-shadow: var(--shadow-md);
            position: relative;
            z-index: 1;
        }
        .child-avatar.male {
            background: linear-gradient(135deg, #3498db, #2980b9);
        }
        .child-avatar.female {
            background: linear-gradient(135deg, #e91e63, #c2185b);
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
                        <a href="${pageContext.request.contextPath}/parent/appointments" class="sidebar-menu-link">
                            <i class="bi bi-calendar-check"></i>
                            <span>Lịch hẹn của tôi</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/vaccination-history" class="sidebar-menu-link active">
                            <i class="bi bi-clipboard-pulse"></i>
                            <span>Lịch sử tiêm chủng</span>
                        </a>
                    </li>
                </ul>
            </aside>

            <main class="dashboard-main">
                <div class="page-header fade-in-up">
                    <h1 class="page-title">Lịch sử tiêm chủng</h1>
                    <p class="page-subtitle">Chọn một trẻ để xem lịch sử tiêm chủng của bé</p>
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

                <c:choose>
                    <c:when test="${empty children}">
                        <div class="content-card fade-in-up">
                            <div class="content-card-body">
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <i class="bi bi-person-x"></i>
                                    </div>
                                    <h3 class="empty-state-title">Chưa có thông tin trẻ em</h3>
                                    <p class="empty-state-text">Bạn chưa thêm thông tin con của mình. Hãy thêm trẻ để xem lịch sử tiêm chủng.</p>
                                    <a href="${pageContext.request.contextPath}/parent/children/add" class="btn-modern btn-primary-modern">
                                        <i class="bi bi-plus-circle"></i>
                                        Thêm con
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 2rem;">
                            <c:forEach items="${children}" var="child">
                                <div class="child-selection-card fade-in-up" onclick="location.href='${pageContext.request.contextPath}/parent/vaccination-history/${child.childId}'">
                                    <div style="padding: 2rem; text-align: center; position: relative; z-index: 1;">
                                        <div class="child-avatar ${child.gender != null ? child.gender.toLowerCase() : ''}">
                                            <c:choose>
                                                <c:when test="${child.gender == 'Male'}">
                                                    <i class="bi bi-person"></i>
                                                </c:when>
                                                <c:when test="${child.gender == 'Female'}">
                                                    <i class="bi bi-person-dress"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-person"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <h5 style="font-size: 1.2rem; font-weight: 700; color: var(--text-dark); margin-bottom: 1.5rem;">
                                            ${child.fullName}
                                        </h5>
                                        
                                        <div style="text-align: left; display: flex; flex-direction: column; gap: 0.75rem;">
                                            <div style="display: flex; align-items: center; gap: 0.5rem; color: var(--text-medium);">
                                                <i class="bi bi-calendar3" style="color: var(--primary-color); font-size: 1.1rem;"></i>
                                                <span><strong>Ngày sinh:</strong> ${child.dateOfBirth}</span>
                                            </div>
                                            <div style="display: flex; align-items: center; gap: 0.5rem; color: var(--text-medium);">
                                                <i class="bi bi-gender-ambiguous" style="color: var(--primary-color); font-size: 1.1rem;"></i>
                                                <span><strong>Giới tính:</strong> ${child.gender != null ? child.gender : 'N/A'}</span>
                                            </div>
                                            <div style="display: flex; align-items: center; gap: 0.5rem; color: var(--text-medium);">
                                                <i class="bi bi-droplet-fill" style="color: var(--primary-color); font-size: 1.1rem;"></i>
                                                <span><strong>Nhóm máu:</strong> ${child.bloodType != null ? child.bloodType : 'N/A'}</span>
                                            </div>
                                        </div>
                                        
                                        <div style="margin-top: 1.5rem;">
                                            <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.5rem 1.2rem; background: var(--gradient-info); border-radius: var(--border-radius-xl); color: white; font-weight: 600; font-size: 0.9rem;">
                                                <i class="bi bi-eye-fill"></i> Xem hồ sơ
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>
</body>
</html>