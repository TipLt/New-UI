<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách con - Hệ thống Tiêm chủng</title>
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
                <!-- PAGE HEADER -->
                <div class="page-header fade-in-up">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <h1 class="page-title">Danh sách con</h1>
                            <p class="page-subtitle">Quản lý thông tin và lịch tiêm chủng của các con</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/parent/children/add" class="btn-modern btn-primary-modern">
                            <i class="bi bi-plus-circle"></i>
                            Thêm con
                        </a>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert-modern alert-info-modern fade-in-up" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left-color: #F14668;">
                        <i class="bi bi-exclamation-triangle-fill" style="color: #F14668;"></i>
                        <div>
                            <strong>Lỗi!</strong><br>
                            ${sessionScope.errorMessage}
                        </div>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.1) 0%, rgba(92, 200, 190, 0.1) 100%); border-left: 4px solid #48C774;">
                        <i class="bi bi-check-circle-fill" style="color: #48C774; font-size: 1.5rem;"></i>
                        <div>
                            <strong>Thành công!</strong><br>
                            ${sessionScope.successMessage}
                        </div>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <!-- CHILDREN LIST -->
                <c:choose>
                    <c:when test="${empty children}">
                        <div class="content-card fade-in-up">
                            <div class="content-card-body">
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <i class="bi bi-people"></i>
                                    </div>
                                    <h3 class="empty-state-title">Chưa có thông tin trẻ em</h3>
                                    <p class="empty-state-text">Bạn chưa thêm thông tin con của mình. Hãy bắt đầu bằng cách thêm hồ sơ đầu tiên để quản lý lịch tiêm chủng.</p>
                                    <a href="${pageContext.request.contextPath}/parent/children/add" class="btn-modern btn-primary-modern">
                                        <i class="bi bi-plus-circle"></i>
                                        Thêm con đầu tiên
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="content-card fade-in-up">
                            <div class="content-card-header">
                                <h3 class="content-card-title">
                                    <i class="bi bi-people-fill"></i>
                                    Tổng cộng: ${children.size()} trẻ
                                </h3>
                            </div>
                            <div class="content-card-body">
                                <div class="table-responsive">
                                    <table class="table-modern">
                                        <thead>
                                            <tr>
                                                <th><i class="bi bi-hash"></i> STT</th>
                                                <th><i class="bi bi-person"></i> Họ và tên</th>
                                                <th><i class="bi bi-calendar"></i> Ngày sinh</th>
                                                <th><i class="bi bi-hourglass-split"></i> Tuổi</th>
                                                <th><i class="bi bi-gender-ambiguous"></i> Giới tính</th>
                                                <th><i class="bi bi-droplet"></i> Nhóm máu</th>
                                                <th><i class="bi bi-gear"></i> Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${children}" var="child" varStatus="status">
                                                <tr>
                                                    <td><strong>${status.count}</strong></td>
                                                    <td><strong>${child.fullName}</strong></td>
                                                    <td>${child.dateOfBirth}</td>
                                                    <td>
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
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${child.gender == 'Male'}">
                                                                <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.3rem 0.8rem; background: linear-gradient(135deg, rgba(74, 144, 226, 0.15) 0%, rgba(92, 200, 190, 0.15) 100%); border-radius: 20px; color: var(--primary-color); font-weight: 600; font-size: 0.85rem;">
                                                                    <i class="bi bi-gender-male"></i> Nam
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${child.gender == 'Female'}">
                                                                <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.3rem 0.8rem; background: linear-gradient(135deg, rgba(255, 107, 157, 0.15) 0%, rgba(241, 70, 104, 0.15) 100%); border-radius: 20px; color: #FF6B9D; font-weight: 600; font-size: 0.85rem;">
                                                                    <i class="bi bi-gender-female"></i> Nữ
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="padding: 0.3rem 0.8rem; background: rgba(120, 144, 156, 0.15); border-radius: 20px; color: var(--text-medium); font-weight: 600; font-size: 0.85rem;">
                                                                    ${child.gender}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty child.bloodType}">
                                                                <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.3rem 0.8rem; background: linear-gradient(135deg, rgba(58, 191, 248, 0.15) 0%, rgba(74, 144, 226, 0.15) 100%); border-radius: 20px; color: #3ABFF8; font-weight: 600; font-size: 0.85rem;">
                                                                    <i class="bi bi-droplet-fill"></i> ${child.bloodType}
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: var(--text-light); font-style: italic;">Chưa có</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}" 
                                                               class="btn-modern btn-info-modern btn-sm-modern" title="Xem chi tiết">
                                                                <i class="bi bi-eye-fill"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/parent/children/edit?id=${child.childId}" 
                                                               class="btn-modern btn-outline-modern btn-sm-modern" style="border-color: #FFB84D; color: #FFB84D;" title="Chỉnh sửa">
                                                                <i class="bi bi-pencil-square"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}" 
                                                               class="btn-modern btn-primary-modern btn-sm-modern" title="Đặt lịch">
                                                                <i class="bi bi-calendar-plus"></i>
                                                            </a>
                                                            <button onclick="confirmDelete(${child.childId}, '${child.fullName}')" 
                                                                    class="btn-modern btn-sm-modern" style="background: linear-gradient(135deg, #F14668 0%, #FF6B9D 100%); color: white; border: none;" title="Xóa">
                                                                <i class="bi bi-trash-fill"></i>
                                                            </button>
                                                        </div>
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
        function confirmDelete(childId, childName) {
            if (confirm('Bạn có chắc chắn muốn xóa hồ sơ của "' + childName + '"?\n\nLưu ý: Hành động này sẽ đánh dấu hồ sơ là không hoạt động.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/parent/children/delete';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'childId';
                input.value = childId;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>