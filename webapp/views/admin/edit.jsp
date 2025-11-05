<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User - Admin</title>
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
            <div class="mb-6">
                <a href="${pageContext.request.contextPath}/admin/users" class="inline-flex items-center gap-2 text-gray-600 hover:text-gray-900">
                    <i class="bi bi-arrow-left"></i>
                    <span>Back to User List</span>
                </a>
            </div>

            <div class="mx-auto max-w-3xl">
                <div class="rounded-lg bg-white p-6 shadow sm:p-8">
                    <div class="mb-6 flex items-center gap-4">
                        <div class="h-16 w-16 rounded-full bg-primary flex items-center justify-center text-white text-2xl font-bold">
                            ${user.FullName.substring(0,1)}
                        </div>
                        <div>
                            <h1 class="text-2xl font-bold text-gray-900">Edit User</h1>
                            <p class="mt-1 text-sm text-gray-600">Update user information for ${user.FullName}</p>
                        </div>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="mb-6 rounded-lg bg-red-50 p-4 border border-red-200">
                            <div class="flex items-center gap-2">
                                <i class="bi bi-exclamation-triangle-fill text-red-600"></i>
                                <p class="text-sm font-medium text-red-800">${error}</p>
                            </div>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/users/edit" method="post" class="space-y-6">
                        <input type="hidden" name="id" value="${user.UserID}">

                        <!-- Full Name -->
                        <div>
                            <label for="name" class="mb-2 block text-sm font-medium text-gray-700">
                                Full Name <span class="text-red-500">*</span>
                            </label>
                            <input type="text" id="fullName" name="fullName" required value="${user.FullName}"
                                   class="w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-900 focus:border-primary focus:ring-2 focus:ring-primary focus:ring-opacity-20 transition"
                                   placeholder="Enter full name">
                        </div>

                        <!-- Email -->
                        <div>
                            <label for="email" class="mb-2 block text-sm font-medium text-gray-700">
                                Email Address <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                                    <i class="bi bi-envelope-fill text-gray-400"></i>
                                </div>
                                <input type="email" id="email" name="email" required value="${user.Email}"
                                       class="w-full rounded-lg border border-gray-300 pl-11 pr-4 py-3 text-gray-900 focus:border-primary focus:ring-2 focus:ring-primary focus:ring-opacity-20 transition"
                                       placeholder="user@example.com">
                            </div>
                        </div>

                        <!-- Phone -->
                        <div>
                            <label for="phone" class="mb-2 block text-sm font-medium text-gray-700">
                                Phone Number <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                                    <i class="bi bi-telephone-fill text-gray-400"></i>
                                </div>
                                <input type="tel" id="phoneNumber" name="phoneNumber" required value="${user.PhoneNumber}"
                                       class="w-full rounded-lg border border-gray-300 pl-11 pr-4 py-3 text-gray-900 focus:border-primary focus:ring-2 focus:ring-primary focus:ring-opacity-20 transition"
                                       placeholder="0123456789">
                            </div>
                        </div>

                        <!-- Role -->
                        <div>
                            <label for="role" class="mb-2 block text-sm font-medium text-gray-700">
                                Role <span class="text-red-500">*</span>
                            </label>
                            <select id="role" name="role" required 
                                    class="w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-900 focus:border-primary focus:ring-2 focus:ring-primary focus:ring-opacity-20 transition">
                                <option value="ADMIN" <c:if test="${user.Role == 'ADMIN'}">selected</c:if>>ADMIN</option>
                                <option value="RECEPTION" <c:if test="${user.Role == 'RECEPTION'}">selected</c:if>>RECEPTION</option>
                                <option value="MEDICAL" <c:if test="${user.Role == 'MEDICAL'}">selected</c:if>>MEDICAL</option>
                                <option value="PARENT" <c:if test="${user.Role == 'PARENT'}">selected</c:if>>PARENT</option>
                            </select>
                        </div>

                        <!-- Active Status -->
                        <div class="rounded-lg bg-gray-50 p-4">
                            <div class="flex items-center justify-between">
                                <div>
                                    <label for="active" class="text-sm font-medium text-gray-700">Account Status</label>
                                    <p class="text-xs text-gray-500">Enable or disable this user account</p>
                                </div>
                                <input type="checkbox" id="active" name="active" value="true" ${user.IsActive ? 'checked' : ''}
                                       class="h-4 w-4 rounded border-gray-300 text-primary focus:ring-2 focus:ring-primary focus:ring-opacity-20">
                            </div>
                        </div>

                        <!-- Password Change Section -->
                        <div class="rounded-lg border-2 border-dashed border-gray-300 p-4">
                            <h3 class="mb-2 text-sm font-semibold text-gray-700">Change Password (Optional)</h3>
                            <p class="mb-4 text-xs text-gray-500">Leave blank to keep the current password</p>
                            <div class="relative">
                                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                                    <i class="bi bi-lock-fill text-gray-400"></i>
                                </div>
                                <input type="password" id="password" name="password" 
                                       class="w-full rounded-lg border border-gray-300 pl-11 pr-4 py-3 text-gray-900 focus:border-primary focus:ring-2 focus:ring-primary focus:ring-opacity-20 transition"
                                       placeholder="Enter new password">
                            </div>
                        </div>

                        <!-- Additional Info -->
                        <div class="grid grid-cols-2 gap-4 rounded-lg bg-gray-50 p-4">
                            <div>
                                <p class="text-xs text-gray-500">User ID</p>
                                <p class="text-sm font-semibold text-gray-900">${user.UserID}</p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500">Created At</p>
                                <p class="text-sm font-semibold text-gray-900">${user.CreatedAt}</p>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="flex gap-4 pt-4">
                            <button type="submit" class="flex-1 inline-flex items-center justify-center gap-2 rounded-lg bg-primary px-6 py-3 text-white font-medium hover:bg-blue-700 transition">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>Update User</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/users" class="flex-1 inline-flex items-center justify-center gap-2 rounded-lg bg-gray-200 px-6 py-3 text-gray-700 font-medium hover:bg-gray-300 transition">
                                <i class="bi bi-x-circle-fill"></i>
                                <span>Cancel</span>
                            </a>
                        </div>
                    </form>
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