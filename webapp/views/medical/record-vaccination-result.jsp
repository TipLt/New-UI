<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ghi nhận kết quả tiêm - Y Tế</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .summary-box {
            background: #f8f9fa;
            border-left: 4px solid #3b82f6;
            padding: 1rem;
            margin-bottom: 2rem;
            border-radius: 8px;
        }
        .outcome-option {
            padding: 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .outcome-option:hover {
            border-color: #3b82f6;
            background: rgba(59, 130, 246, 0.05);
        }
        .outcome-option input[type="radio"]:checked + label {
            font-weight: bold;
            color: #3b82f6;
        }
        #reasonGroup {
            display: none;
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

<!-- MAIN CONTENT -->
<div class="dashboard-container">
    <div class="dashboard-row">
        <!-- SIDEBAR -->
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
                    <a href="${pageContext.request.contextPath}/medical/vaccinations" class="sidebar-menu-link">
                        <i class="bi bi-syringe"></i>
                        <span>Quản lý Vắc xin</span>
                    </a>
                </li>
            </ul>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="dashboard-main">
            <div class="page-header fade-in-up">
                <div>
                    <h1 class="page-title">
                        <i class="bi bi-2-circle-fill"></i> Bước 2: Ghi nhận kết quả tiêm
                    </h1>
                    <p class="page-subtitle">Xác nhận kết quả của việc tiêm chủng</p>
                </div>
            </div>

            <!-- SUMMARY BOX -->
            <div class="summary-box fade-in-up">
                <h5><i class="bi bi-clipboard-check"></i> Tóm tắt thông tin tiêm</h5>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Trẻ:</strong> ${child.fullName}</p>
                        <p><strong>Vắc xin:</strong> ${vaccine.vaccineName}</p>
                        <p><strong>Người tiêm:</strong> ${administrator.fullName}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Thời điểm:</strong>
                            ${vaccinationData.vaccinationDateTime}
                        </p>
                        <c:if test="${not empty vaccinationData.batchNumber}">
                            <p><strong>Số lô:</strong> ${vaccinationData.batchNumber}</p>
                        </c:if>
                        <c:if test="${not empty vaccinationData.doseNumber}">
                            <p><strong>Liều thứ:</strong> ${vaccinationData.doseNumber}</p>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- FORM -->
            <div class="content-card fade-in-up">
                <div class="content-card-body">
                    <form method="POST" action="${pageContext.request.contextPath}/medical/vaccination-record/save-result" id="resultForm">

                        <!-- Outcome Selection -->
                        <div class="mb-4">
                            <label class="form-label">
                                <i class="bi bi-check2-circle"></i> Kết quả tiêm <span class="text-danger">*</span>
                            </label>

                            <div class="outcome-option">
                                <input type="radio" name="outcome" value="Administered" id="outcome1" required>
                                <label for="outcome1" class="ms-2">
                                    <i class="bi bi-check-circle-fill text-success"></i> Đã tiêm (Administered)
                                </label>
                            </div>

                            <div class="outcome-option">
                                <input type="radio" name="outcome" value="Deferred" id="outcome2">
                                <label for="outcome2" class="ms-2">
                                    <i class="bi bi-clock-fill text-warning"></i> Hoãn (Deferred)
                                </label>
                            </div>

                            <div class="outcome-option">
                                <input type="radio" name="outcome" value="Contraindicated" id="outcome3">
                                <label for="outcome3" class="ms-2">
                                    <i class="bi bi-x-circle-fill text-danger"></i> Chống chỉ định (Contraindicated)
                                </label>
                            </div>

                            <div class="outcome-option">
                                <input type="radio" name="outcome" value="Refused" id="outcome4">
                                <label for="outcome4" class="ms-2">
                                    <i class="bi bi-hand-thumbs-down-fill text-secondary"></i> Từ chối (Refused)
                                </label>
                            </div>

                            <div class="outcome-option">
                                <input type="radio" name="outcome" value="Error" id="outcome5">
                                <label for="outcome5" class="ms-2">
                                    <i class="bi bi-exclamation-triangle-fill text-warning"></i> Sai sót (Error)
                                </label>
                            </div>

                            <div class="outcome-option">
                                <input type="radio" name="outcome" value="Not eligible" id="outcome6">
                                <label for="outcome6" class="ms-2">
                                    <i class="bi bi-slash-circle-fill text-muted"></i> Không đủ điều kiện (Not eligible)
                                </label>
                            </div>
                        </div>

                        <!-- Reason (required if not Administered) -->
                        <div class="mb-4" id="reasonGroup">
                            <label for="reason" class="form-label">
                                <i class="bi bi-chat-left-text"></i> Lý do <span class="text-danger">*</span>
                            </label>
                            <textarea class="form-control"
                                      id="reason"
                                      name="reason"
                                      rows="3"
                                      placeholder="Nhập lý do chi tiết..."></textarea>
                        </div>

                        <!-- Stock Confirmation (only if Administered) -->
                        <div class="mb-4" id="stockGroup">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="stockConfirmed" name="stockConfirmed">
                                <label class="form-check-label" for="stockConfirmed">
                                    <i class="bi bi-box-seam"></i> Xác nhận đã kiểm tra và ghi nhận tồn kho
                                </label>
                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/medical/vaccination-record/datetime?appointmentId=${vaccinationData.appointmentId}"
                               class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle"></i> Xác nhận
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const outcomeRadios = document.querySelectorAll('input[name="outcome"]');
        const reasonGroup = document.getElementById('reasonGroup');
        const reasonField = document.getElementById('reason');
        const stockGroup = document.getElementById('stockGroup');

        outcomeRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                if (this.value === 'Administered') {
                    reasonGroup.style.display = 'none';
                    reasonField.removeAttribute('required');
                    stockGroup.style.display = 'block';
                } else {
                    reasonGroup.style.display = 'block';
                    reasonField.setAttribute('required', 'required');
                    stockGroup.style.display = 'none';
                }
            });
        });

        // Set default to Administered
        document.getElementById('outcome1').checked = true;
        stockGroup.style.display = 'block';
    });
</script>
</body>
</html>
