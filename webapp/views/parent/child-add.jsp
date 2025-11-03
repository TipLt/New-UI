<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm con - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .form-modern {
            display: grid;
            gap: 1.5rem;
        }
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .form-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .form-label .required {
            color: var(--danger-color);
        }
        .form-input, .form-select, .form-textarea {
            padding: 0.9rem 1.2rem;
            border: 2px solid var(--bg-section);
            border-radius: var(--border-radius-md);
            font-size: 1rem;
            color: var(--text-dark);
            background: white;
            transition: var(--transition-fast);
            font-family: inherit;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-help {
            font-size: 0.85rem;
            color: var(--text-light);
        }
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

    <!-- MAIN CONTENT -->
    <div class="dashboard-container">
        <div style="max-width: 900px; margin: 0 auto; padding: 2.5rem 1.5rem;">
            <!-- PAGE HEADER -->
            <div class="page-header fade-in-up">
                <h1 class="page-title">Thêm con mới</h1>
                <p class="page-subtitle">Điền đầy đủ thông tin để tạo hồ sơ tiêm chủng cho con bạn</p>
            </div>

            <!-- FORM CARD -->
            <div class="content-card fade-in-up">
                <div class="content-card-header">
                    <h3 class="content-card-title">
                        <i class="bi bi-person-plus-fill"></i>
                        Thông tin trẻ em
                    </h3>
                </div>
                <div class="content-card-body">
                    <c:if test="${not empty error}">
                        <div class="alert-modern" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left: 4px solid var(--danger-color); margin-bottom: 2rem;">
                            <i class="bi bi-exclamation-circle-fill" style="color: var(--danger-color); font-size: 1.5rem;"></i>
                            <div>
                                <strong>Lỗi!</strong><br>
                                ${error}
                            </div>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/parent/children/add" class="form-modern">
                        <!-- Full Name -->
                        <div class="form-group">
                            <label for="fullName" class="form-label">
                                <i class="bi bi-person"></i> Họ và tên <span class="required">*</span>
                            </label>
                            <input type="text" class="form-input" id="fullName" name="fullName" 
                                   placeholder="Nhập họ và tên đầy đủ" required>
                        </div>

                        <!-- Date of Birth & Gender -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="dateOfBirth" class="form-label">
                                    <i class="bi bi-calendar"></i> Ngày sinh <span class="required">*</span>
                                </label>
                                <input type="date" class="form-input" id="dateOfBirth" name="dateOfBirth" required>
                            </div>

                            <div class="form-group">
                                <label for="gender" class="form-label">
                                    <i class="bi bi-gender-ambiguous"></i> Giới tính <span class="required">*</span>
                                </label>
                                <select class="form-select" id="gender" name="gender" required>
                                    <option value="">-- Chọn giới tính --</option>
                                    <option value="Male">Nam</option>
                                    <option value="Female">Nữ</option>
                                    <option value="Other">Khác</option>
                                </select>
                            </div>
                        </div>

                        <!-- Blood Type, Weight & Height -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="bloodType" class="form-label">
                                    <i class="bi bi-droplet-fill"></i> Nhóm máu
                                </label>
                                <select class="form-select" id="bloodType" name="bloodType">
                                    <option value="">-- Chọn nhóm máu --</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="weight" class="form-label">
                                    <i class="bi bi-bar-chart"></i> Cân nặng (kg)
                                </label>
                                <input type="number" step="0.1" class="form-input" id="weight" name="weight" 
                                       placeholder="VD: 12.5">
                            </div>

                            <div class="form-group">
                                <label for="height" class="form-label">
                                    <i class="bi bi-rulers"></i> Chiều cao (cm)
                                </label>
                                <input type="number" step="0.1" class="form-input" id="height" name="height" 
                                       placeholder="VD: 85">
                            </div>
                        </div>

                        <!-- Allergies -->
                        <div class="form-group">
                            <label for="allergies" class="form-label">
                                <i class="bi bi-exclamation-triangle"></i> Dị ứng
                            </label>
                            <textarea class="form-textarea" id="allergies" name="allergies" 
                                      placeholder="Liệt kê các loại dị ứng đã biết (nếu có)"></textarea>
                            <span class="form-help">Ví dụ: Dị ứng đạm trứng, dị ứng kháng sinh Penicillin...</span>
                        </div>

                        <!-- Medical History -->
                        <div class="form-group">
                            <label for="medicalHistory" class="form-label">
                                <i class="bi bi-file-medical"></i> Tiền sử bệnh
                            </label>
                            <textarea class="form-textarea" id="medicalHistory" name="medicalHistory" 
                                      placeholder="Ghi chú các bệnh lý hoặc tình trạng sức khỏe liên quan"></textarea>
                            <span class="form-help">Ví dụ: Hen suyễn, bệnh tim bẩm sinh, suy dinh dưỡng...</span>
                        </div>

                        <!-- Action Buttons -->
                        <div style="display: flex; justify-content: space-between; gap: 1rem; margin-top: 1rem;">
                            <a href="${pageContext.request.contextPath}/parent/dashboard" class="btn-modern btn-outline-modern">
                                <i class="bi bi-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn-modern btn-primary-modern">
                                <i class="bi bi-save"></i> Lưu thông tin
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>