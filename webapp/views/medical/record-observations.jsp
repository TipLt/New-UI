<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theo dõi sau tiêm - Y Tế</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .timer-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 2rem;
        }
        .timer-display {
            font-size: 3rem;
            font-weight: bold;
            font-family: 'Courier New', monospace;
        }
        .record-info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        .save-indicator {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 1rem;
            background: #10b981;
            color: white;
            border-radius: 10px;
            display: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
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
                        <i class="bi bi-3-circle-fill"></i> Bước 3: Theo dõi sau tiêm
                    </h1>
                    <p class="page-subtitle">Theo dõi tình trạng sức khỏe sau khi tiêm chủng</p>
                </div>
            </div>

            <!-- TIMER BOX -->
            <div class="timer-box fade-in-up">
                <h4><i class="bi bi-stopwatch"></i> Thời gian theo dõi</h4>
                <div class="timer-display" id="timer">30:00</div>
                <div class="mt-3">
                    <button class="btn btn-light btn-sm me-2" onclick="setTimer(30)">30 phút</button>
                    <button class="btn btn-light btn-sm" onclick="setTimer(60)">60 phút</button>
                    <button class="btn btn-warning btn-sm ms-3" onclick="pauseTimer()">
                        <i class="bi bi-pause-fill"></i> Tạm dừng
                    </button>
                    <button class="btn btn-success btn-sm" onclick="startTimer()">
                        <i class="bi bi-play-fill"></i> Tiếp tục
                    </button>
                </div>
            </div>

            <!-- RECORD INFO -->
            <div class="record-info fade-in-up">
                <h5><i class="bi bi-clipboard-data"></i> Thông tin đã tiêm</h5>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Trẻ:</strong> ${record.child.fullName}</p>
                        <p><strong>Vắc xin:</strong> ${record.vaccine.vaccineName}</p>
                        <p><strong>Người tiêm:</strong> ${record.staff.fullName}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Thời điểm tiêm:</strong>
                            ${record.vaccinationDate}
                        </p>
                        <c:if test="${not empty record.batchNumber}">
                            <p><strong>Số lô:</strong> ${record.batchNumber}</p>
                        </c:if>
                        <c:if test="${not empty record.doseNumber}">
                            <p><strong>Liều thứ:</strong> ${record.doseNumber}</p>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- OBSERVATION FORM -->
            <div class="content-card fade-in-up">
                <div class="content-card-body">
                    <form id="observationForm">
                        <input type="hidden" name="recordId" value="${record.recordId}">

                        <!-- Symptoms/Side Effects -->
                        <div class="mb-4">
                            <label for="sideEffects" class="form-label">
                                <i class="bi bi-exclamation-triangle"></i> Triệu chứng/Tác dụng phụ
                            </label>
                            <textarea class="form-control"
                                      id="sideEffects"
                                      name="sideEffects"
                                      rows="4"
                                      placeholder="Ghi nhận các triệu chứng, phản ứng sau tiêm...">${record.sideEffectsReported}</textarea>
                            <small class="form-text text-muted">
                                VD: Sốt nhẹ, đau tại chỗ tiêm, quấy khóc, không có phản ứng bất thường...
                            </small>
                        </div>

                        <!-- Health Check Notes -->
                        <div class="mb-4">
                            <label for="healthNotes" class="form-label">
                                <i class="bi bi-heart-pulse"></i> Ghi chú khám sức khỏe
                            </label>
                            <textarea class="form-control"
                                      id="healthNotes"
                                      name="healthNotes"
                                      rows="3"
                                      placeholder="Sinh hiệu, can thiệp y khoa (nếu có)...">${record.healthCheckNotes}</textarea>
                            <small class="form-text text-muted">
                                VD: Nhiệt độ: 37.2°C, mạch: 100, huyết áp: bình thường...
                            </small>
                        </div>

                        <!-- Observation Note -->
                        <div class="mb-4">
                            <label for="obsNote" class="form-label">
                                <i class="bi bi-chat-left-text"></i> Ghi chú theo dõi
                            </label>
                            <textarea class="form-control"
                                      id="obsNote"
                                      name="obsNote"
                                      rows="2"
                                      placeholder="Ghi chú bổ sung trong quá trình theo dõi..."></textarea>
                        </div>

                        <!-- Next Dose Date -->
                        <div class="mb-4">
                            <label for="nextDoseDate" class="form-label">
                                <i class="bi bi-calendar-plus"></i> Ngày hẹn tiêm liều tiếp theo
                            </label>
                            <input type="date"
                                   class="form-control"
                                   id="nextDoseDate"
                                   name="nextDoseDate"
                                   value="${record.nextDoseDate}">
                        </div>

                        <!-- AEFI Warning -->
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <strong>Lưu ý:</strong> Nếu có phản ứng nặng hoặc bất thường, vui lòng ghi rõ vào phần "Triệu chứng/Tác dụng phụ"
                            và cân nhắc báo cáo AEFI (Adverse Event Following Immunization).
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-between">
                            <button type="button" class="btn btn-primary" onclick="saveObservation()">
                                <i class="bi bi-floppy"></i> Lưu tạm
                            </button>
                            <button type="button" class="btn btn-success" onclick="finishObservation()">
                                <i class="bi bi-check-circle"></i> Hoàn tất quan sát
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Save Indicator -->
<div class="save-indicator" id="saveIndicator">
    <i class="bi bi-check-circle-fill"></i> Đã lưu tự động
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let timerInterval;
    let timeLeft = 1800; // 30 minutes in seconds
    let isPaused = false;

    function updateTimerDisplay() {
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;
        document.getElementById('timer').textContent =
            `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
    }

    function startTimer() {
        isPaused = false;
        if (timerInterval) return;

        timerInterval = setInterval(() => {
            if (!isPaused && timeLeft > 0) {
                timeLeft--;
                updateTimerDisplay();

                // Auto-save every 2 minutes
                if (timeLeft % 120 === 0) {
                    autoSaveObservation();
                }

                // Alert when time is up
                if (timeLeft === 0) {
                    alert('Đã hết thời gian theo dõi 30 phút!');
                    pauseTimer();
                }
            }
        }, 1000);
    }

    function pauseTimer() {
        isPaused = true;
    }

    function setTimer(minutes) {
        timeLeft = minutes * 60;
        updateTimerDisplay();
        if (!timerInterval) {
            startTimer();
        }
    }

    function autoSaveObservation() {
        const form = document.getElementById('observationForm');
        const formData = new FormData(form);

        fetch('${pageContext.request.contextPath}/medical/vaccination-record/update-observation/${record.recordId}', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSaveIndicator();
                }
            })
            .catch(error => console.error('Auto-save error:', error));
    }

    function saveObservation() {
        const form = document.getElementById('observationForm');
        const formData = new FormData(form);

        fetch('${pageContext.request.contextPath}/medical/vaccination-record/update-observation/${record.recordId}', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Đã lưu thành công!');
                    showSaveIndicator();
                } else {
                    alert('Lỗi: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Không thể lưu dữ liệu!');
            });
    }

    function finishObservation() {
        if (confirm('Bạn có chắc chắn muốn hoàn tất quan sát? Sau khi hoàn tất, bạn sẽ không thể chỉnh sửa.')) {
            saveObservation();
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/medical/appointments/?success=observation_completed';
            }, 1000);
        }
    }

    function showSaveIndicator() {
        const indicator = document.getElementById('saveIndicator');
        indicator.style.display = 'block';
        setTimeout(() => {
            indicator.style.display = 'none';
        }, 2000);
    }

    // Start timer on page load
    document.addEventListener('DOMContentLoaded', function() {
        startTimer();
    });
</script>
</body>
</html>
