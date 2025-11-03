<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Vắc xin - Y Tế</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            border-radius: 12px;
            border: 2px solid #e2e8f0;
            background: white;
            color: #64748b;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .filter-tab:hover {
            border-color: #3b82f6;
            transform: translateY(-2px);
        }
        .filter-tab.active {
            background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
            border-color: transparent;
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }
        .status-FREE {
            background: linear-gradient(135deg, rgba(72, 199, 116, 0.2) 0%, rgba(92, 200, 190, 0.2) 100%);
            color: #48C774;
        }
        .status-PAID {
            background: linear-gradient(135deg, rgba(58, 191, 248, 0.2) 0%, rgba(74, 144, 226, 0.2) 100%);
            color: #3ABFF8;
        }
        .table tbody tr {
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .table tbody tr:hover {
            background-color: rgba(59, 130, 246, 0.05);
            transform: scale(1.01);
        }
    </style>
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
                    <a href="${pageContext.request.contextPath}/medical/vaccination-record/" class="sidebar-menu-link">
                        <i class="bi bi-syringe"></i>
                        <span>Ghi nhận tiêm chủng</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/vaccinations" class="sidebar-menu-link">
                        <i class="bi bi-syringe"></i>
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
                    <h1 class="page-title">Quản lý Vắc xin</h1>
                    <p class="page-subtitle">Danh sách các loại vắc xin trong hệ thống</p>
                </div>
            </div>

            <!-- SUCCESS/ERROR MESSAGES -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill"></i>
                    <strong>Thành công!</strong>
                    <c:choose>
                        <c:when test="${param.success == 'hidden'}">
                            Vắc xin đã được ẩn thành công!
                        </c:when>
                        <c:when test="${param.success == 'updated'}">
                            Vắc xin đã được cập nhật thành công!
                        </c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <strong>Lỗi!</strong> ${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <strong>Lỗi!</strong> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- FILTER TABS -->
            <div class="filter-tabs fade-in-up">
                <button class="filter-tab active" onclick="filterVaccines('ALL')">
                    <i class="bi bi-list-ul"></i> Tất cả
                </button>
                <button class="filter-tab" onclick="filterVaccines('FREE')">
                    <i class="bi bi-gift"></i> Miễn phí
                </button>
                <button class="filter-tab" onclick="filterVaccines('PAID')">
                    <i class="bi bi-currency-dollar"></i> Có phí
                </button>
            </div>

            <!-- VACCINES LIST -->
            <c:choose>
                <c:when test="${empty vaccines}">
                    <div class="content-card fade-in-up">
                        <div class="content-card-body">
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <i class="bi bi-shield-x"></i>
                                </div>
                                <h3 class="empty-state-title">Chưa có vắc xin</h3>
                                <p class="empty-state-text">Hiện tại chưa có vắc xin nào trong hệ thống.</p>
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
                                        <th style="width: 5%"><i class="bi bi-hash"></i> STT</th>
                                        <th style="width: 25%"><i class="bi bi-shield-check"></i> Tên Vắc xin</th>
                                        <th style="width: 30%"><i class="bi bi-virus"></i> Bệnh Phòng ngừa</th>
                                        <th style="width: 15%"><i class="bi bi-calendar-range"></i> Độ tuổi khuyến cáo</th>
                                        <th style="width: 10%"><i class="bi bi-tag"></i> Loại</th>
                                        <th style="width: 15%"><i class="bi bi-gear"></i> Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="vaccine" items="${vaccines}" varStatus="status">
                                        <tr class="vaccine-row"
                                            data-type="${vaccine.free ? 'FREE' : 'PAID'}"
                                            onclick="showVaccineDetail(${vaccine.vaccineId})"
                                            data-vaccine-id="${vaccine.vaccineId}">
                                            <td><strong>${status.index + 1}</strong></td>
                                            <td>
                                                <div>
                                                    <strong>${vaccine.vaccineName}</strong>
                                                    <c:if test="${not empty vaccine.manufacturer}">
                                                        <br>
                                                        <small class="text-muted">
                                                            <i class="bi bi-building"></i> ${vaccine.manufacturer}
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>${vaccine.diseasesPrevented}</td>
                                            <td>
                                                <i class="bi bi-person-badge"></i> ${vaccine.recommendedAge}
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${vaccine.free}">
                                                        <span class="status-badge status-FREE">
                                                            <i class="bi bi-gift-fill"></i> Miễn phí
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-PAID">
                                                            <i class="bi bi-currency-dollar"></i> Có phí
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button type="button"
                                                        class="btn btn-sm btn-primary me-1"
                                                        onclick="event.stopPropagation(); showVaccineDetail(${vaccine.vaccineId})">
                                                    <i class="bi bi-eye-fill"></i> Xem
                                                </button>
                                                <button type="button"
                                                        class="btn btn-sm btn-info me-1"
                                                        onclick="event.stopPropagation(); editVaccine(${vaccine.vaccineId})">
                                                    <i class="bi bi-pencil-fill"></i> Sửa
                                                </button>
                                                <button type="button"
                                                        class="btn btn-sm btn-warning"
                                                        onclick="event.stopPropagation(); hideVaccine(${vaccine.vaccineId}, '${vaccine.vaccineName}')">
                                                    <i class="bi bi-eye-slash"></i> Ẩn
                                                </button>
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

<!-- Modal for Vaccine Detail -->
<div class="modal fade" id="vaccineDetailModal" tabindex="-1" aria-labelledby="vaccineDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); color: white;">
                <h5 class="modal-title" id="vaccineDetailModalLabel">
                    <i class="bi bi-clipboard-pulse"></i> Chi tiết Vắc xin
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="vaccineDetailContent">
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Đang tải...</span>
                    </div>
                    <p class="mt-3 text-muted">Đang tải thông tin vắc xin...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle"></i> Đóng
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal for Vaccine Edit -->
<div class="modal fade" id="vaccineEditModal" tabindex="-1" aria-labelledby="vaccineEditModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white;">
                <h5 class="modal-title" id="vaccineEditModalLabel">
                    <i class="bi bi-pencil-square"></i> Chỉnh sửa Vắc xin
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="vaccineEditContent">
                <div class="text-center py-5">
                    <div class="spinner-border text-success" role="status">
                        <span class="visually-hidden">Đang tải...</span>
                    </div>
                    <p class="mt-3 text-muted">Đang tải form chỉnh sửa...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle"></i> Hủy
                </button>
                <button type="button" class="btn btn-success" onclick="submitVaccineEdit()">
                    <i class="bi bi-check-circle"></i> Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Filter vaccines by type
    function filterVaccines(type) {
        const tabs = document.querySelectorAll('.filter-tab');
        const rows = document.querySelectorAll('.vaccine-row');

        tabs.forEach(tab => tab.classList.remove('active'));
        event.target.closest('.filter-tab').classList.add('active');

        rows.forEach(row => {
            if (type === 'ALL' || row.dataset.type === type) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Show vaccine detail in modal
    function showVaccineDetail(vaccineId) {
        const modal = new bootstrap.Modal(document.getElementById('vaccineDetailModal'));
        const contentDiv = document.getElementById('vaccineDetailContent');

        // Show loading
        contentDiv.innerHTML = `
            <div class="text-center py-5">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Đang tải...</span>
                </div>
                <p class="mt-3 text-muted">Đang tải thông tin vắc xin...</p>
            </div>
        `;

        modal.show();

        // Fetch vaccine details
        fetch('${pageContext.request.contextPath}/medical/vaccinations/detail/' + vaccineId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Không thể tải thông tin vắc xin');
                }
                return response.text();
            })
            .then(html => {
                contentDiv.innerHTML = html;
            })
            .catch(error => {
                contentDiv.innerHTML = `
                    <div class="alert alert-danger m-4">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <strong>Lỗi!</strong> ${error.message}
                    </div>
                `;
            });
    }

    // Edit vaccine - show edit form in modal
    function editVaccine(vaccineId) {
        const modal = new bootstrap.Modal(document.getElementById('vaccineEditModal'));
        const contentDiv = document.getElementById('vaccineEditContent');

        // Show loading
        contentDiv.innerHTML = `
            <div class="text-center py-5">
                <div class="spinner-border text-success" role="status">
                    <span class="visually-hidden">Đang tải...</span>
                </div>
                <p class="mt-3 text-muted">Đang tải form chỉnh sửa...</p>
            </div>
        `;

        modal.show();

        // Fetch vaccine edit form
        fetch('${pageContext.request.contextPath}/medical/vaccinations/edit/' + vaccineId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Không thể tải form chỉnh sửa');
                }
                return response.text();
            })
            .then(html => {
                contentDiv.innerHTML = html;
            })
            .catch(error => {
                contentDiv.innerHTML = `
                    <div class="alert alert-danger m-4">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <strong>Lỗi!</strong> ${error.message}
                    </div>
                `;
            });
    }

    // Submit vaccine edit form
    function submitVaccineEdit() {
        const form = document.getElementById('vaccineEditForm');
        if (form) {
            if (form.checkValidity()) {
                form.submit();
            } else {
                form.reportValidity();
            }
        }
    }

    // Hide vaccine
    function hideVaccine(vaccineId, vaccineName) {
        if (confirm('Bạn có chắc chắn muốn ẩn vắc xin "' + vaccineName + '" không?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/medical/vaccinations/hide/' + vaccineId;
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
</body>
</html>