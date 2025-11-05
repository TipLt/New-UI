<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Admin</title>
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
</head>
<body class="bg-gray-100">
    <!-- Sidebar -->
    <aside id="sidebar" class="fixed left-0 top-0 z-40 h-screen w-64 bg-gray-900 transition-transform -translate-x-full lg:translate-x-0">
        <div class="flex h-full flex-col overflow-y-auto px-3 py-4">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="mb-10 flex items-center px-3">
                <i class="bi bi-heart-pulse-fill text-3xl text-primary"></i>
                <span class="ml-3 text-xl font-semibold text-white">Admin Panel</span>
            </a>
            
            <ul class="space-y-2 font-medium">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center rounded-lg px-3 py-2.5 text-gray-300 hover:bg-gray-700">
                        <i class="bi bi-speedometer2"></i>
                        <span class="ml-3">Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center rounded-lg bg-primary px-3 py-2.5 text-white">
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
                    <div class="flex items-center gap-3">
                        <div class="h-10 w-10 rounded-full bg-primary flex items-center justify-center text-white font-semibold">
                            A
                        </div>
                        <div class="hidden sm:block">
                            <p class="text-sm font-medium text-gray-900">Admin User</p>
                            <p class="text-xs text-gray-500">Administrator</p>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Page Content -->
        <main class="p-4 sm:p-6 lg:p-8">
            <div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                <h1 class="text-2xl font-bold text-gray-900">User Management</h1>
                <a href="${pageContext.request.contextPath}/admin/users/create" class="inline-flex items-center gap-2 rounded-lg bg-primary px-6 py-3 text-white font-medium hover:bg-blue-700 transition">
                    <i class="bi bi-person-plus-fill"></i>
                    <span>Create New User</span>
                </a>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty message}">
                <div class="mb-4 rounded-lg bg-green-50 p-4 border border-green-200">
                    <div class="flex items-center gap-2">
                        <i class="bi bi-check-circle-fill text-green-600"></i>
                        <p class="text-sm font-medium text-green-800">${message}</p>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="mb-4 rounded-lg bg-red-50 p-4 border border-red-200">
                    <div class="flex items-center gap-2">
                        <i class="bi bi-exclamation-triangle-fill text-red-600"></i>
                        <p class="text-sm font-medium text-red-800">${error}</p>
                    </div>
                </div>
            </c:if>

            <!-- Filter Section -->
            <div class="mb-6 rounded-lg bg-white p-6 shadow">
                <form action="${pageContext.request.contextPath}/admin/users" method="get" class="flex flex-col gap-4 sm:flex-row sm:items-end">
                    <div class="flex-1">
                        <label class="mb-2 block text-sm font-medium text-gray-700">Filter by Role</label>
                        <select name="role" class="w-full rounded-lg border border-gray-300 px-4 py-2.5 text-gray-900 focus:border-primary focus:ring-2 focus:ring-primary focus:ring-opacity-20">
                            <option value="">All Roles</option>
                            <option value="ADMIN" <c:if test="${roleFilter == 'ADMIN'}">selected</c:if>>ADMIN</option>
                            <option value="RECEPTION" <c:if test="${roleFilter == 'RECEPTION'}">selected</c:if>>RECEPTION</option>
                            <option value="MEDICAL" <c:if test="${roleFilter == 'MEDICAL'}">selected</c:if>>MEDICAL</option>
                            <option value="PARENT" <c:if test="${roleFilter == 'PARENT'}">selected</c:if>>PARENT</option>
                        </select>
                    </div>
                    <button type="submit" class="inline-flex items-center gap-2 rounded-lg bg-gray-700 px-6 py-2.5 text-white font-medium hover:bg-gray-800 transition">
                        <i class="bi bi-funnel-fill"></i>
                        <span>Filter</span>
                    </button>
                </form>
            </div>

            <!-- Users Table -->
            <div class="rounded-lg bg-white shadow overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-gray-50 text-xs uppercase text-gray-700">
                            <tr>
                                <th class="px-6 py-4">ID</th>
                                <th class="px-6 py-4">User</th>
                                <th class="px-6 py-4">Contact</th>
                                <th class="px-6 py-4">Role</th>
                                <th class="px-6 py-4">Status</th>
                                <th class="px-6 py-4">Created At</th>
                                <th class="px-6 py-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <c:forEach var="user" items="${users}">
                                <tr class="hover:bg-gray-50 transition">
                                    <td class="px-6 py-4 font-medium text-gray-900">${user.UserID}</td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <div class="h-10 w-10 rounded-full bg-primary flex items-center justify-center text-white font-semibold">
                                                ${user.FullName.substring(0,1)}
                                            </div>
                                            <span class="font-medium text-gray-900">${user.FullName}</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-gray-900">${user.Email}</div>
                                        <div class="text-gray-500 text-xs">${user.PhoneNumber}</div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex rounded-full px-3 py-1 text-xs font-semibold 
                                            ${user.Role == 'ADMIN' ? 'bg-purple-100 text-purple-700' : 
                                              user.Role == 'MEDICAL' ? 'bg-blue-100 text-blue-700' :
                                              user.Role == 'RECEPTION' ? 'bg-yellow-100 text-yellow-700' :
                                              'bg-green-100 text-green-700'}">
                                            ${user.Role}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center gap-1 rounded-full px-3 py-1 text-xs font-semibold ${user.IsActive ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                                            <i class="bi ${user.IsActive ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                            ${user.IsActive ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-gray-600">${user.CreatedAt}</td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center justify-end gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/users/view?id=${user.UserID}" class="rounded-lg p-2 text-blue-600 hover:bg-blue-50 transition" title="View">
                                                <i class="bi bi-eye-fill"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.UserID}" class="rounded-lg p-2 text-yellow-600 hover:bg-yellow-50 transition" title="Edit">
                                                <i class="bi bi-pencil-fill"></i>
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/users/toggle" method="post" class="inline">
                                                <input type="hidden" name="id" value="${user.UserID}">
                                                <input type="hidden" name="active" value="${!user.IsActive}">
                                                <button type="submit" class="rounded-lg p-2 ${user.IsActive ? 'text-red-600 hover:bg-red-50' : 'text-green-600 hover:bg-green-50'} transition" title="${user.IsActive ? 'Deactivate' : 'Activate'}">
                                                    <i class="bi ${user.IsActive ? 'bi-x-circle-fill' : 'bi-check-circle-fill'}"></i>
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/users/reset" method="post" class="inline">
                                                <input type="hidden" name="id" value="${user.UserID}">
                                                <button type="submit" class="rounded-lg p-2 text-gray-600 hover:bg-gray-50 transition" title="Reset Password">
                                                    <i class="bi bi-key-fill"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="flex items-center justify-between border-t border-gray-200 bg-white px-6 py-4">
                    <div class="text-sm text-gray-700">
                        Showing page <span class="font-medium">${currentPage}</span> of <span class="font-medium">${totalPages}</span>
                    </div>
                    <nav class="flex gap-2">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/admin/users?page=${i}&role=${roleFilter}" 
                               class="rounded-lg px-4 py-2 text-sm font-medium transition ${currentPage == i ? 'bg-primary text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                                ${i}
                            </a>
                        </c:forEach>
                    </nav>
                </div>
            </div>
        </main>
    </div>

    <script>
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        
        sidebarToggle?.addEventListener('click', () => {
            sidebar.classList.toggle('-translate-x-full');
        });
    </script>
</body>
</html>