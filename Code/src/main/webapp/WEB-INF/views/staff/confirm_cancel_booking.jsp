<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Xác nhận Hủy phiếu đặt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout staff-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar">
            <div>
                <h1>Xác nhận <span>Hủy phiếu đặt</span></h1>
            </div>
        </div>
        <div class="confirm-box">
            <h2>Xác nhận hủy phiếu đặt</h2>
            <div class="alert alert-warning" style="margin-bottom:16px;">
                Bạn có chắc chắn muốn hủy toàn bộ phiếu đặt <strong>${booking.code}</strong> của khách hàng <strong>${booking.customerName}</strong>? Hành động này không thể hoàn tác.
            </div>
            <div class="card mb-3">
                <ul class="detail-list">
                    <li><span class="label">Mã phiếu đặt</span><span class="value fw-bold">${booking.code}</span></li>
                    <li><span class="label">Khách hàng</span><span class="value">${booking.customerName}</span></li>
                    <li><span class="label">SĐT</span><span class="value">${booking.customerPhone}</span></li>
                    <li><span class="label">Trạng thái</span><span class="value fw-bold">${booking.status}</span></li>
                    <li><span class="label">Ngày đặt</span><span class="value"><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/></span></li>
                </ul>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/staff/cancel">
                <input type="hidden" name="action" value="executeBooking">
                <input type="hidden" name="bookingId" value="${booking.id}">
                <div class="btn-group" style="justify-content:center;">
                    <a href="${pageContext.request.contextPath}/staff/cancel?action=search" class="btn btn-outline">← Quay lại</a>
                    <button type="submit" class="btn btn-danger btn-lg">Xác nhận Hủy phiếu đặt</button>
                </div>
            </form>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
