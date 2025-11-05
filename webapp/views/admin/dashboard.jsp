<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Vaccination System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#3C50E0',
                        secondary: '#80CAEE',
                    }
                }
            }
        }
    </script>
    <style>
        .stat-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-gray-100">
    <!-- Sidebar -->
    <aside id="sidebar" class="fixed left-0 top-0 z-40 h-screen w-64 bg-gray-900 transition-transform -translate-x-full lg:translate-x-0">
        <div class="flex h-full flex-col overflow-y-auto px-3 py-4">
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="mb-10 flex items-center px-3">
                <i class="bi bi-heart-pulse-fill text-3xl text-primary"></i>
                <span class="ml-3 text-xl font-semibold text-white">Admin Panel</span>
            </a>
            
            <!-- Navigation -->
            <ul class="space-y-2 font-medium">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center rounded-lg bg-primary px-3 py-2.5 text-white">
                        <i class="bi bi-speedometer2"></i>
                        <span class="ml-3">Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center rounded-lg px-3 py-2.5 text-gray-300 hover:bg-gray-700">
                        <i class="bi bi-people-fill"></i>
                        <span class="ml-3">User Management</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="flex items-center rounded-lg px-3 py-2.5 text-gray-300 hover:bg-gray-700">
                        <i class="bi bi-calendar-check"></i>
                        <span class="ml-3">Appointments</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/vaccinations" class="flex items-center rounded-lg px-3 py-2.5 text-gray-300 hover:bg-gray-700">
                        <i class="bi bi-heart-pulse"></i>
                        <span class="ml-3">Vaccinations</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/settings" class="flex items-center rounded-lg px-3 py-2.5 text-gray-300 hover:bg-gray-700">
                        <i class="bi bi-gear-fill"></i>
                        <span class="ml-3">Settings</span>
                    </a>
                </li>
            </ul>

            <!-- Logout Button at Bottom of Sidebar -->
            <div class="mt-auto pt-4 border-t border-gray-700">
                <a href="${pageContext.request.contextPath}/logout" class="flex items-center rounded-lg px-3 py-2.5 text-red-400 hover:bg-gray-700 hover:text-red-300 transition">
                    <i class="bi bi-box-arrow-right"></i>
                    <span class="ml-3">Logout</span>
                </a>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="lg:pl-64">
        <!-- Top Header -->
        <header class="sticky top-0 z-30 bg-white shadow">
            <div class="flex h-16 items-center justify-between px-4 sm:px-6 lg:px-8">
                <button id="sidebarToggle" class="rounded-lg p-2 text-gray-600 hover:bg-gray-100 lg:hidden">
                    <i class="bi bi-list text-2xl"></i>
                </button>
                
                <div class="flex items-center gap-4">
                    <button class="rounded-lg p-2 text-gray-600 hover:bg-gray-100">
                        <i class="bi bi-bell text-xl"></i>
                    </button>
                    
                    <!-- User Info with Logout in Header -->
                    <div class="relative group">
                        <button class="flex items-center gap-3 rounded-lg px-3 py-2 hover:bg-gray-100 transition">
                            <div class="h-10 w-10 rounded-full bg-primary flex items-center justify-center text-white font-semibold">
                                ${sessionScope.userName != null ? sessionScope.userName.substring(0,1) : 'A'}
                            </div>
                            <div class="hidden sm:block text-left">
                                <p class="text-sm font-medium text-gray-900">${sessionScope.userName != null ? sessionScope.userName : 'Admin'}</p>
                                <p class="text-xs text-gray-500">${sessionScope.userRole != null ? sessionScope.userRole : 'Administrator'}</p>
                            </div>
                            <i class="bi bi-chevron-down text-gray-400"></i>
                        </button>
                        
                        <!-- Dropdown Menu -->
                        <div class="absolute right-0 mt-2 w-48 rounded-lg bg-white shadow-lg border border-gray-200 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all">
                            <div class="p-2">
                                <a href="${pageContext.request.contextPath}/admin/profile" class="flex items-center gap-2 rounded-lg px-3 py-2 text-gray-700 hover:bg-gray-100 transition">
                                    <i class="bi bi-person-circle"></i>
                                    <span>My Profile</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/settings" class="flex items-center gap-2 rounded-lg px-3 py-2 text-gray-700 hover:bg-gray-100 transition">
                                    <i class="bi bi-gear-fill"></i>
                                    <span>Settings</span>
                                </a>
                                <hr class="my-2 border-gray-200">
                                <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2 rounded-lg px-3 py-2 text-red-600 hover:bg-red-50 transition">
                                    <i class="bi bi-box-arrow-right"></i>
                                    <span>Logout</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Dashboard Content -->
        <main class="p-4 sm:p-6 lg:p-8">
            <h1 class="mb-6 text-2xl font-bold text-gray-900">Dashboard Overview</h1>
            
            <!-- Stats Cards -->
            <div class="mb-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <!-- Total Users -->
                <div class="stat-card rounded-lg bg-white p-6 shadow">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Total Users</p>
                            <h3 class="mt-2 text-3xl font-bold text-gray-900">
                                <c:set var="totalUsers" value="0"/>
                                <c:forEach var="entry" items="${usersByRole}">
                                    <c:set var="totalUsers" value="${totalUsers + entry.value}"/>
                                </c:forEach>
                                ${totalUsers}
                            </h3>
                        </div>
                        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-blue-100">
                            <i class="bi bi-people-fill text-2xl text-blue-600"></i>
                        </div>
                    </div>
                </div>

                <!-- New Users This Month -->
                <div class="stat-card rounded-lg bg-white p-6 shadow">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">New Users</p>
                            <h3 class="mt-2 text-3xl font-bold text-gray-900">${newUsers}</h3>
                        </div>
                        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
                            <i class="bi bi-person-plus-fill text-2xl text-green-600"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Children -->
                <div class="stat-card rounded-lg bg-white p-6 shadow">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Total Children</p>
                            <h3 class="mt-2 text-3xl font-bold text-gray-900">${totalChildren}</h3>
                        </div>
                        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-purple-100">
                            <i class="bi bi-heart-fill text-2xl text-purple-600"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Appointments -->
                <div class="stat-card rounded-lg bg-white p-6 shadow">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Appointments</p>
                            <h3 class="mt-2 text-3xl font-bold text-gray-900">${totalAppointments}</h3>
                        </div>
                        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-yellow-100">
                            <i class="bi bi-calendar-check-fill text-2xl text-yellow-600"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts and Tables Section -->
            <div class="grid gap-6 lg:grid-cols-2">
                <!-- Users by Role -->
                <div class="rounded-lg bg-white p-6 shadow">
                    <h3 class="mb-4 text-lg font-semibold text-gray-900">Users by Role</h3>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm">
                            <thead class="bg-gray-50 text-xs uppercase text-gray-700">
                                <tr>
                                    <th class="px-6 py-3">Role</th>
                                    <th class="px-6 py-3 text-right">Count</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="entry" items="${usersByRole}">
                                    <tr class="border-b hover:bg-gray-50">
                                        <td class="px-6 py-4 font-medium text-gray-900">${entry.key}</td>
                                        <td class="px-6 py-4 text-right">
                                            <span class="rounded-full bg-primary px-3 py-1 text-xs font-semibold text-white">
                                                ${entry.value}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Active/Inactive Users -->
                <div class="rounded-lg bg-white p-6 shadow">
                    <h3 class="mb-4 text-lg font-semibold text-gray-900">User Status</h3>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm">
                            <thead class="bg-gray-50 text-xs uppercase text-gray-700">
                                <tr>
                                    <th class="px-6 py-3">Status</th>
                                    <th class="px-6 py-3 text-right">Count</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="entry" items="${activeInactive}">
                                    <tr class="border-b hover:bg-gray-50">
                                        <td class="px-6 py-4 font-medium text-gray-900">${entry.key}</td>
                                        <td class="px-6 py-4 text-right">
                                            <span class="rounded-full ${entry.key == 'Active' ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-600'} px-3 py-1 text-xs font-semibold">
                                                ${entry.value}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Recent Logins -->
            <div class="mt-6 rounded-lg bg-white p-6 shadow">
                <h3 class="mb-4 text-lg font-semibold text-gray-900">Recent Logins</h3>
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-gray-50 text-xs uppercase text-gray-700">
                            <tr>
                                <th class="px-6 py-3">User ID</th>
                                <th class="px-6 py-3">Name</th>
                                <th class="px-6 py-3">Last Login</th>
                                <th class="px-6 py-3 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="login" items="${recentLogins}">
                                <tr class="border-b hover:bg-gray-50">
                                    <td class="px-6 py-4 font-medium text-gray-900">${login.UserID}</td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <div class="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 text-xs font-semibold">
                                                ${login.FullName.substring(0,1)}
                                            </div>
                                            <span>${login.FullName}</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 text-gray-600">${login.LastLogin}</td>
                                    <td class="px-6 py-4 text-right">
                                        <a href="${pageContext.request.contextPath}/admin/users/view?id=${login.UserID}" class="font-medium text-primary hover:underline">
                                            View Details
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="mt-6">
                <a href="${pageContext.request.contextPath}/admin/users" class="inline-flex items-center gap-2 rounded-lg bg-primary px-6 py-3 text-white font-medium hover:bg-blue-700 transition">
                    <i class="bi bi-people-fill"></i>
                    <span>Manage Users</span>
                </a>
            </div>
        </main>
    </div>

    <script>
        // Sidebar toggle for mobile
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        
        sidebarToggle?.addEventListener('click', () => {
            sidebar.classList.toggle('-translate-x-full');
        });
    </script>
</body>
</html>