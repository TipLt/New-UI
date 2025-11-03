<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Appointment - Vaccination System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .confirm-icon {
            font-size: 4rem;
            color: #4A90E2;
            animation: scaleIn 0.5s ease;
        }
        .summary-section {
            background: linear-gradient(135deg, rgba(74, 144, 226, 0.05), rgba(92, 200, 190, 0.05));
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid #4A90E2;
        }
        .summary-section h6 {
            color: #4A90E2;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .info-grid {
            display: grid;
            gap: 1rem;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid rgba(74, 144, 226, 0.1);
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #546E7A;
            font-weight: 500;
        }
        .info-value {
            color: #2C3E50;
            font-weight: 600;
        }
        .total-cost {
            background: linear-gradient(135deg, #5CC8BE, #4A90E2);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 8px 20px rgba(74, 144, 226, 0.3);
        }
        .total-cost h4 {
            margin-bottom: 0;
            font-size: 2rem;
            font-weight: 800;
        }
        .card-hover {
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }
        .card-hover:hover {
            box-shadow: 0 4px 20px rgba(74, 144, 226, 0.15);
        }
        .btn-gradient {
            background: linear-gradient(135deg, #4A90E2, #5CC8BE);
            border: none;
            transition: all 0.3s ease;
        }
        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(74, 144, 226, 0.3);
        }
        .navbar-custom {
            background: linear-gradient(135deg, #4A90E2, #5CC8BE);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .dashboard-layout {
            display: flex;
            min-height: calc(100vh - 80px);
        }
        .sidebar {
            width: 250px;
            background: white;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
            padding: 2rem 0;
        }
        .sidebar-nav {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.5rem;
            color: #546E7A;
            text-decoration: none;
            transition: all 0.3s ease;
            margin: 0.25rem 1rem;
            border-radius: 10px;
        }
        .sidebar-item:hover {
            background: rgba(74, 144, 226, 0.08);
            color: #4A90E2;
        }
        .sidebar-item.active {
            background: linear-gradient(135deg, #4A90E2, #5CC8BE);
            color: white;
        }
        .sidebar-item i {
            font-size: 1.2rem;
        }
        .main-content {
            flex: 1;
            padding: 2rem;
            background: #F8F9FA;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/parent/dashboard">
                <i class="bi bi-heart-pulse"></i> Vaccination System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <span class="navbar-text text-white me-3">
                            <i class="bi bi-person-circle"></i> ${sessionScope.userName}
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn-logout" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="dashboard-layout">
        <aside class="sidebar">
            <nav class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/parent/dashboard" class="sidebar-item">
                    <i class="bi bi-speedometer2"></i>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/parent/children" class="sidebar-item">
                    <i class="bi bi-people"></i>
                    <span>My Children</span>
                </a>
                <a href="${pageContext.request.contextPath}/parent/booking/step1" class="sidebar-item active">
                    <i class="bi bi-calendar-plus"></i>
                    <span>Book Appointment</span>
                </a>
                <a href="${pageContext.request.contextPath}/parent/appointments" class="sidebar-item">
                    <i class="bi bi-calendar-check"></i>
                    <span>My Appointments</span>
                </a>
                <a href="${pageContext.request.contextPath}/parent/vaccination-history" class="sidebar-item">
                    <i class="bi bi-clipboard-pulse"></i>
                    <span>Vaccination History</span>
                </a>
            </nav>
        </aside>

        <main class="main-content">
            <div class="container-fluid">
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/booking/step1">Step 1</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/booking/step2?childId=${child.childId}&vaccineId=${vaccine.vaccineId}">Step 2</a></li>
                        <li class="breadcrumb-item active">Confirm Appointment</li>
                    </ol>
                </nav>

                <div class="page-header text-center">
                    <i class="bi bi-clipboard-check confirm-icon"></i>
                    <h2 class="mt-3"><i class="bi bi-check-circle"></i> Confirm Appointment Details</h2>
                    <p class="text-muted">Please review your appointment information carefully</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="row g-4 mb-4">
                    <div class="col-md-6">
                        <div class="summary-section">
                            <h6><i class="bi bi-person-fill"></i> Child Information</h6>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Full Name:</span>
                                    <span class="info-value">${child.fullName}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Date of Birth:</span>
                                    <span class="info-value">${child.dateOfBirth}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Gender:</span>
                                    <span class="info-value">${child.gender}</span>
                                </div>
                                <c:if test="${not empty child.bloodType}">
                                    <div class="info-item">
                                        <span class="info-label">Blood Type:</span>
                                        <span class="info-value">${child.bloodType}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="summary-section">
                            <h6><i class="bi bi-shield-fill-check"></i> Vaccine Information</h6>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Vaccine Name:</span>
                                    <span class="info-value fw-bold text-primary">${vaccine.vaccineName}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Manufacturer:</span>
                                    <span class="info-value">${vaccine.manufacturer}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Diseases Prevented:</span>
                                    <span class="info-value">${vaccine.diseasesPrevented}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="summary-section">
                            <h6><i class="bi bi-hospital"></i> Vaccination Center</h6>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Center Name:</span>
                                    <span class="info-value">${center.centerName}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Address:</span>
                                    <span class="info-value">${center.address}</span>
                                </div>
                                <c:if test="${not empty center.phoneNumber}">
                                    <div class="info-item">
                                        <span class="info-label">Phone:</span>
                                        <span class="info-value">${center.phoneNumber}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="summary-section">
                            <h6><i class="bi bi-calendar-event"></i> Appointment Details</h6>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Date:</span>
                                    <span class="info-value">${appointmentDate}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Time:</span>
                                    <span class="info-value">${appointmentTime}</span>
                                </div>
                            </div>
                        </div>

                        <div class="total-cost">
                            <p class="mb-2 opacity-75">Total Cost</p>
                            <h4><fmt:formatNumber value="${vaccine.price}" type="currency" currencySymbol="$"/></h4>
                        </div>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/parent/booking/create">
                    <input type="hidden" name="childId" value="${child.childId}">
                    <input type="hidden" name="vaccineId" value="${vaccine.vaccineId}">
                    <input type="hidden" name="centerId" value="${center.centerId}">
                    <input type="hidden" name="date" value="${appointmentDate}">
                    <input type="hidden" name="time" value="${appointmentTime}">

                    <div class="card card-hover mb-4">
                        <div class="card-body">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="confirmTerms" required>
                                <label class="form-check-label" for="confirmTerms">
                                    I confirm that all the information above is correct and agree to the terms and conditions
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/parent/booking/step2?childId=${child.childId}&vaccineId=${vaccine.vaccineId}" 
                           class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Previous Step
                        </a>
                        <button type="submit" class="btn btn-primary btn-gradient">
                            <i class="bi bi-check-circle"></i> Confirm & Book
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
