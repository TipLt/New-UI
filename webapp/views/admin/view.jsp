<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details - Admin</title>
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

            <div class="grid gap-6 lg:grid-cols-3">
                <!-- User Profile Card -->
                <div class="lg:col-span-1">
                    <div class="rounded-lg bg-white p-6 shadow">
                        <div class="flex flex-col items-center">
                            <div class="h-24 w-24 rounded-full bg-primary flex items-center justify-center text-white text-3xl font-bold mb-4">
                                ${user.FullName.substring(0,1)}
                            </div>
                            <h2 class="text-xl font-bold text-gray-900">${user.FullName}</h2>
                            <span class="mt-2 inline-flex rounded-full px-4 py-1.5 text-sm font-semibold 
                                ${user.Role == 'ADMIN' ? 'bg-purple-100 text-purple-700' : 
                                  user.Role == 'MEDICAL' ? 'bg-blue-100 text-blue-700' :
                                  user.Role == 'RECEPTION' ? 'bg-yellow-100 text-yellow-700' :
                                  'bg-green-100 text-green-700'}">
                                ${user.Role}
                            </span>
                            <div class="mt-4 w-full">
                                <span class="flex items-center justify-center gap-2 rounded-lg px-4 py-2 text-sm font-semibold ${user.IsActive ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-700'}">
                                    <i class="bi ${user.IsActive ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                    ${user.IsActive ? 'Active Account' : 'Inactive Account'}
                                </span>
                            </div>
                        </div>

                        <div class="mt-6 space-y-3">
                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.UserID}" class="flex items-center justify-center gap-2 rounded-lg bg-primary px-4 py-2.5 text-white font-medium hover:bg-blue-700 transition">
                                <i class="bi bi-pencil-fill"></i>
                                <span>Edit User</span>
                            </a>
                            <form action="${pageContext.request.contextPath}/admin/users/toggle" method="post">
                                <input type="hidden" name="id" value="${user.UserID}">
                                <input type="hidden" name="active" value="${!user.IsActive}">
                                <button type="submit" class="w-full flex items-center justify-center gap-2 rounded-lg ${user.IsActive ? 'bg-red-600 hover:bg-red-700' : 'bg-green-600 hover:bg-green-700'} px-4 py-2.5 text-white font-medium transition">
                                    <i class="bi ${user.IsActive ? 'bi-x-circle-fill' : 'bi-check-circle-fill'}"></i>
                                    <span>${user.IsActive ? 'Deactivate' : 'Activate'}</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- User Information -->
                <div class="lg:col-span-2">
                    <div class="rounded-lg bg-white p-6 shadow">
                        <h3 class="mb-6 text-lg font-semibold text-gray-900">User Information</h3>
                        
                        <div class="grid gap-6 sm:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-gray-500">User ID</label>
                                <p class="text-base font-semibold text-gray-900">${user.UserID}</p>
                            </div>
                            
                            <div>
                                <label class="mb-2 block text-sm font-medium text-gray-500">Full Name</label>
                                <p class="text-base font-semibold text-gray-900">${user.FullName}</p>
                            </div>
                            
                            <div>
                                <label class="mb-2 block text-sm font-medium text-gray-500">Email Address</label>
                                <div class="flex items-center gap-2">
                                    <i class="bi bi-envelope-fill text-gray-400"></i>
                                    <p class="text-base font-semibold text-gray-900">${user.Email}</p>
                                </div>
                            </div>
                            
                            <div>
                                <label class="mb-2 block text-sm font-medium text-gray-500">Phone Number</label>
                                <div class="flex items-center gap-2">
                                    <i class="bi bi-telephone-fill text-gray-400"></i>
                                    <p class="text-base font-semibold text-gray-900">${user.PhoneNumber}</p>
                                </div>
                            </div>
                            
                            <div>
                                <label class="mb-2 block text-sm font-medium text-gray-500">Role</label>
                                <p class="text-base font-semibold text-gray-900">${user.Role}</p>
                            </div>
                            
                            <div>
                                <label class="mb-2 block text-sm font-medium text-gray-500">Account Status</label>
                                <p class="text-base font-semibold ${user.IsActive ? 'text-green-600' : 'text-red-600'}">
                                    ${user.IsActive ? 'Active' : 'Inactive'}
                                </p>
                            </div>
                            
                            <div>
                                <label class="mb-2 block text-sm font-medium text-gray-500">Created At</label>
                                <div class="flex items-center gap-2">
                                    <i class="bi bi-calendar-event text-gray-400"></i>
                                    <p class="text-base font-semibold text-gray-900">${user.CreatedAt}</p>
                                </div>
                            </div>
                            
                            <div>
                                <label class="mb-2 block text-sm font-medium text-gray-500">Last Login</label>
                                <div class="flex items-center gap-2">
                                    <i class="bi bi-clock-history text-gray-400"></i>
                                    <p class="text-base font-semibold text-gray-900">${user.LastLogin}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Actions -->
                    <div class="mt-6 rounded-lg bg-white p-6 shadow">
                        <h3 class="mb-4 text-lg font-semibold text-gray-900">Additional Actions</h3>
                        <div class="flex flex-wrap gap-3">
                            <form action="${pageContext.request.contextPath}/admin/users/reset" method="post" class="inline">
                                <input type="hidden" name="id" value="${user.UserID}">
                                <button type="submit" class="inline-flex items-center gap-2 rounded-lg bg-yellow-600 px-4 py-2.5 text-white font-medium hover:bg-yellow-700 transition">
                                    <i class="bi bi-key-fill"></i>
                                    <span>Reset Password</span>
                                </button>
                            </form>
                            
                            <button onclick="if(confirm('Are you sure you want to delete this user?')) { /* Add delete logic */ }" class="inline-flex items-center gap-2 rounded-lg bg-red-600 px-4 py-2.5 text-white font-medium hover:bg-red-700 transition">
                                <i class="bi bi-trash-fill"></i>
                                <span>Delete User</span>
                            </button>
                        </div>
                    </div>
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