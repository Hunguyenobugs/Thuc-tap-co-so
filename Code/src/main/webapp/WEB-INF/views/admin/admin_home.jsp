<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Admin - Grand Lotus Hotel</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar"><div><h1>📊 Trang chủ <span>Admin</span></h1><div class="breadcrumb"><span>Quản trị hệ thống</span></div></div></div>
        <% if ("password_changed".equals(request.getParameter("msg"))) { %><div class="alert alert-success">✅ Đổi mật khẩu thành công</div><% } %>
        <div class="stat-grid">
            <div class="stat-card"><div class="stat-label">Vai trò</div><div class="stat-value text-accent">ADMIN</div><div class="stat-desc">Quản trị viên hệ thống</div></div>
            <div class="stat-card green"><div class="stat-label">Xin chào</div><div class="stat-value">${sessionScope.currentUser.fullName}</div><div class="stat-desc">${sessionScope.currentUser.employeeCode}</div></div>
        </div>
        <h2 class="mb-3">Chức năng quản trị</h2>
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/admin/user?action=manage" class="menu-item"><div class="icon">👤</div><h3>Quản lý tài khoản</h3><p>Thêm, sửa, xóa tài khoản</p></a>
            <a href="${pageContext.request.contextPath}/auth?action=changePasswordPage" class="menu-item"><div class="icon">🔒</div><h3>Đổi mật khẩu</h3><p>Thay đổi mật khẩu cá nhân</p></a>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
