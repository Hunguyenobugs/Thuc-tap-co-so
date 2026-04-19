<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Staff - Grand Lotus Hotel</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar"><div><h1>📊 Trang chủ <span>Nhân viên</span></h1><div class="breadcrumb"><span>Nghiệp vụ lễ tân</span></div></div></div>
        <% String msg = request.getParameter("msg"); %>
        <% if ("booking_success".equals(msg)) { %><div class="alert alert-success">✅ Đặt phòng thành công! Mã phiếu: <strong>${param.code}</strong></div><% } %>
        <% if ("cancel_success".equals(msg)) { %><div class="alert alert-success">✅ Hủy phiếu đặt thành công</div><% } %>
        <% if ("booking_updated".equals(msg)) { %><div class="alert alert-success">✅ Cập nhật phiếu đặt thành công</div><% } %>
        <% if ("checkin_success".equals(msg)) { %><div class="alert alert-success">✅ Check-in thành công</div><% } %>
        <% if ("checkout_success".equals(msg)) { %><div class="alert alert-success">✅ Check-out thành công! Mã hóa đơn: <strong>${param.code}</strong></div><% } %>
        <% if ("password_changed".equals(msg)) { %><div class="alert alert-success">✅ Đổi mật khẩu thành công</div><% } %>
        <div class="stat-grid">
            <div class="stat-card"><div class="stat-label">Vai trò</div><div class="stat-value text-accent">STAFF</div><div class="stat-desc">Nhân viên lễ tân</div></div>
            <div class="stat-card green"><div class="stat-label">Xin chào</div><div class="stat-value">${sessionScope.currentUser.fullName}</div><div class="stat-desc">${sessionScope.currentUser.employeeCode}</div></div>
        </div>
        <h2 class="mb-3">Nghiệp vụ</h2>
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/staff/booking?action=searchRoom" class="menu-item"><div class="icon">📝</div><h3>Đặt phòng</h3><p>Tạo phiếu đặt phòng</p></a>
            <a href="${pageContext.request.contextPath}/staff/cancel?action=search" class="menu-item"><div class="icon">❌</div><h3>Hủy đặt phòng</h3><p>Hủy phiếu đặt</p></a>
            <a href="${pageContext.request.contextPath}/staff/manageBooking?action=search" class="menu-item"><div class="icon">✏️</div><h3>Sửa phiếu đặt</h3><p>Chỉnh sửa phiếu đặt</p></a>
            <a href="${pageContext.request.contextPath}/staff/checkin?action=search" class="menu-item"><div class="icon">🔑</div><h3>Check-in</h3><p>Nhận phòng cho khách</p></a>
            <a href="${pageContext.request.contextPath}/staff/serviceUpdate?action=search" class="menu-item"><div class="icon">🛎️</div><h3>Cập nhật DV</h3><p>Thêm DV phát sinh</p></a>
            <a href="${pageContext.request.contextPath}/staff/checkout?action=search" class="menu-item"><div class="icon">🚪</div><h3>Check-out</h3><p>Trả phòng & thanh toán</p></a>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
