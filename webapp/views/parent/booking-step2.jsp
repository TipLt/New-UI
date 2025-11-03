<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Step 2 - Vaccination System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .summary-banner {
            background: linear-gradient(135deg, #4A90E2, #5CC8BE);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 20px rgba(74, 144, 226, 0.3);
        }
        .selection-card {
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid rgba(74, 144, 226, 0.1);
        }
        .selection-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border-color: rgba(74, 144, 226, 0.4);
        }
        .selection-card.selected {
            border-color: #4A90E2;
            background: linear-gradient(135deg, rgba(74, 144, 226, 0.1), rgba(92, 200, 190, 0.1));
            box-shadow: 0 8px 25px rgba(74, 144, 226, 0.3);
        }
        .time-slot {
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            text-align: center;
            background: white;
        }
        .time-slot:hover {
            transform: scale(1.05);
            border-color: #4A90E2;
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.2);
        }
        .time-slot.selected {
            background: linear-gradient(135deg, #4A90E2, #5CC8BE);
            color: white;
            border-color: #4A90E2;
            font-weight: 600;
        }
        .navbar-custom {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.05);
        }
        .dashboard-layout {
            display: flex;
            min-height: 100vh;
            padding-top: 70px;
        }
        .sidebar {
            width: 280px;
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            position: fixed;
            top: 70px;
            bottom: 0;
            left: 0;
            overflow-y: auto;
        }
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2rem;
            background: #F5F8FB;
        }
        .sidebar-nav {
            padding: 1.5rem 0;
        }
        .sidebar-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.5rem;
            color: #546E7A;
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }
        .sidebar-item:hover {
            background: rgba(74, 144, 226, 0.08);
            color: #4A90E2;
            border-left-color: #4A90E2;
        }
        .sidebar-item.active {
            background: linear-gradient(135deg, #4A90E2, #5CC8BE);
            color: white;
            border-left-color: #FF6B9D;
        }
        .sidebar-item i {
            font-size: 1.3rem;
        }
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background: linear-gradient(135deg, #4A90E2, #5CC8BE);
            border: none;
        }
        .btn-gradient {
            box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
        }
        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(74, 144, 226, 0.4);
        }
        .page-header h2 {
            color: #2C3E50;
            font-weight: 700;
        }
        .page-header p {
            color: #78909C;
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
                        <li class="breadcrumb-item active">Book Appointment - Step 2</li>
                    </ol>
                </nav>

                <div class="page-header">
                    <h2><i class="bi bi-calendar-check"></i> Book Appointment - Step 2</h2>
                    <p class="text-muted">Select vaccination center, date and time</p>
                </div>

                <div class="summary-banner">
                    <h5 class="mb-3"><i class="bi bi-info-circle"></i> Booking Summary</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <p class="mb-1"><strong><i class="bi bi-person-fill"></i> Child:</strong> ${child.fullName}</p>
                            <p class="mb-0 small opacity-75">DOB: ${child.dateOfBirth} | ${child.gender}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-1"><strong><i class="bi bi-shield-fill-check"></i> Vaccine:</strong> ${vaccine.vaccineName}</p>
                            <p class="mb-0 small opacity-75">
                                Price: <strong><fmt:formatNumber value="${vaccine.price}" type="currency" currencySymbol="$"/></strong>
                            </p>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form method="get" action="${pageContext.request.contextPath}/parent/booking/step2" id="autoReloadForm">
                    <input type="hidden" name="childId" value="${child.childId}">
                    <input type="hidden" name="vaccineId" value="${vaccine.vaccineId}">
                    
                    <div class="card card-hover mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="bi bi-building"></i> Select Vaccination Center</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty centers}">
                                    <div class="alert alert-warning">
                                        <i class="bi bi-info-circle"></i> No vaccination centers available.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row g-3">
                                        <c:forEach items="${centers}" var="center">
                                            <div class="col-md-6">
                                                <div class="card selection-card h-100 ${selectedCenterId == center.centerId ? 'selected' : ''}" 
                                                     onclick="selectCenter(${center.centerId})">
                                                    <div class="card-body">
                                                        <div class="form-check mb-2">
                                                            <input class="form-check-input center-radio" type="radio" 
                                                                   name="centerId" value="${center.centerId}" 
                                                                   id="center${center.centerId}" 
                                                                   ${selectedCenterId == center.centerId ? 'checked' : ''} 
                                                                   onchange="autoReload()" required>
                                                            <label class="form-check-label fw-bold" for="center${center.centerId}">
                                                                <i class="bi bi-hospital text-primary"></i> ${center.centerName}
                                                            </label>
                                                        </div>
                                                        <div class="text-muted small">
                                                            <p class="mb-1">
                                                                <i class="bi bi-geo-alt"></i> ${center.address}
                                                            </p>
                                                            <c:if test="${not empty center.phoneNumber}">
                                                                <p class="mb-0">
                                                                    <i class="bi bi-telephone"></i> ${center.phoneNumber}
                                                                </p>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="card card-hover mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="bi bi-calendar3"></i> Select Date</h5>
                        </div>
                        <div class="card-body">
                            <input type="date" class="form-control form-control-lg" name="date" 
                                   id="dateInput"
                                   value="${selectedDate}" 
                                   min="${minDate}" 
                                   onchange="autoReload()" required>
                        </div>
                    </div>
                </form>

                <form method="get" action="${pageContext.request.contextPath}/parent/booking/confirm" id="step2Form">
                    <input type="hidden" name="childId" value="${child.childId}">
                    <input type="hidden" name="vaccineId" value="${vaccine.vaccineId}">
                    <input type="hidden" name="centerId" value="${selectedCenterId}">
                    <input type="hidden" name="date" value="${selectedDate}">

                    <div class="card card-hover mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="bi bi-clock"></i> Select Time Slot</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty availableSlots}">
                                    <div class="alert alert-info">
                                        <i class="bi bi-info-circle"></i> Please select a vaccination center and date first to see available time slots.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row g-3">
                                        <c:forEach items="${availableSlots}" var="slot">
                                            <div class="col-md-3 col-sm-4 col-6">
                                                <div class="time-slot ${selectedTimeSlot == slot ? 'selected' : ''}" 
                                                     onclick="selectTimeSlot(event, '${slot}')">
                                                    <input type="radio" name="time" value="${slot}" 
                                                           id="slot${slot}" class="d-none" 
                                                           ${selectedTimeSlot == slot ? 'checked' : ''} required>
                                                    <label for="slot${slot}" class="mb-0 w-100" style="cursor: pointer;">
                                                        <i class="bi bi-clock"></i> ${slot}
                                                    </label>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Previous Step
                        </a>
                        <button type="submit" class="btn btn-primary btn-gradient" ${empty availableSlots ? 'disabled' : ''}>
                            <i class="bi bi-arrow-right"></i> Review & Confirm
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectCenter(centerId) {
            document.querySelectorAll('.center-radio').forEach(radio => {
                radio.checked = false;
                radio.closest('.selection-card').classList.remove('selected');
            });
            const radio = document.getElementById('center' + centerId);
            radio.checked = true;
            radio.closest('.selection-card').classList.add('selected');
        }

        function selectTimeSlot(event, slot) {
            document.querySelectorAll('.time-slot').forEach(el => {
                el.classList.remove('selected');
            });
            event.currentTarget.classList.add('selected');
            document.getElementById('slot' + slot).checked = true;
        }

        function autoReload() {
            const centerRadio = document.querySelector('input[name="centerId"]:checked');
            const dateInput = document.getElementById('dateInput');
            
            if (centerRadio && dateInput.value) {
                document.getElementById('autoReloadForm').submit();
            }
        }
    </script>
</body>
</html>
