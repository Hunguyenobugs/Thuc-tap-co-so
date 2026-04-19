<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Manager - Grand Lotus Hotel</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar"><div><h1>📊 Trang chủ <span>Quản lý</span></h1><div class="breadcrumb"><span>Quản lý khách sạn</span></div></div></div>
        <% if ("password_changed".equals(request.getParameter("msg"))) { %><div class="alert alert-success">✅ Đổi mật khẩu thành công</div><% } %>
        <div class="stat-grid">
            <div class="stat-card"><div class="stat-label">Vai trò</div><div class="stat-value text-accent">MANAGER</div><div class="stat-desc">Quản lý khách sạn</div></div>
            <div class="stat-card green"><div class="stat-label">Xin chào</div><div class="stat-value">${sessionScope.currentUser.fullName}</div><div class="stat-desc">${sessionScope.currentUser.employeeCode}</div></div>
        </div>
        <h2 class="mb-3">Chức năng quản lý</h2>
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/manager/hotel" class="menu-item"><div class="icon">🏨</div><h3>Thông tin KS</h3><p>Cập nhật thông tin</p></a>
            <a href="${pageContext.request.contextPath}/manager/roomtype?action=manage" class="menu-item"><div class="icon">🏷️</div><h3>Loại phòng</h3><p>Quản lý loại phòng</p></a>
            <a href="${pageContext.request.contextPath}/manager/room?action=manage" class="menu-item"><div class="icon">🚪</div><h3>Phòng</h3><p>Quản lý phòng cụ thể</p></a>
            <a href="${pageContext.request.contextPath}/manager/service?action=manage" class="menu-item"><div class="icon">🛎️</div><h3>Dịch vụ</h3><p>Quản lý dịch vụ</p></a>
            <a href="${pageContext.request.contextPath}/manager/staff?action=manage" class="menu-item"><div class="icon">👥</div><h3>Nhân viên</h3><p>Quản lý nhân sự</p></a>
            <a href="${pageContext.request.contextPath}/manager/invoice?action=list" class="menu-item"><div class="icon">💰</div><h3>Thanh toán</h3><p>Quản lý hóa đơn</p></a>
            <a href="${pageContext.request.contextPath}/manager/report" class="menu-item"><div class="icon">📈</div><h3>Báo cáo</h3><p>Doanh thu & công suất</p></a>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
