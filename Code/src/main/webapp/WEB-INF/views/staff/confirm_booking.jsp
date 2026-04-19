<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Xác nhận đặt phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>📝 Đặt phòng - <span>Xác nhận</span></h1><div class="breadcrumb"><span>Bước 3: Xác nhận thông tin</span></div></div></div>
    <div class="detail-grid">
        <div>
            <div class="card mb-3"><div class="card-header"><h3>👤 Thông tin khách hàng</h3></div>
                <ul class="detail-list">
                    <li><span class="label">Họ tên</span><span class="value">${customer.fullName}</span></li>
                    <li><span class="label">CCCD</span><span class="value">${customer.idCard}</span></li>
                    <li><span class="label">SĐT</span><span class="value">${customer.phone}</span></li>
                    <li><span class="label">Email</span><span class="value">${customer.email}</span></li>
                </ul></div>
            <div class="card"><div class="card-header"><h3>🛏️ Thông tin phòng</h3></div>
                <ul class="detail-list">
                    <li><span class="label">Phòng</span><span class="value">${room.roomNumber} - ${roomType.name}</span></li>
                    <li><span class="label">Nhận phòng</span><span class="value">${checkIn}</span></li>
                    <li><span class="label">Trả phòng</span><span class="value">${checkOut}</span></li>
                    <li><span class="label">Số đêm</span><span class="value">${nights} đêm</span></li>
                    <li><span class="label">Giá/đêm</span><span class="value"><fmt:formatNumber value="${roomType.basePrice}" pattern="#,##0"/>₫</span></li>
                </ul></div>
        </div>
        <div><div class="card" style="position:sticky;top:100px;">
            <h3 class="mb-3">💰 Ước tính chi phí</h3>
            <div style="text-align:center;padding:20px;"><span style="font-size:32px;font-weight:700;color:var(--accent);"><fmt:formatNumber value="${totalEstimate}" pattern="#,##0"/>₫</span></div>
            <form method="post" action="${pageContext.request.contextPath}/staff/booking">
                <input type="hidden" name="action" value="insert"><input type="hidden" name="customerId" value="${customer.id}">
                <div class="form-group"><label>Yêu cầu đặc biệt</label><textarea name="specialRequests" class="form-control" rows="3"></textarea></div>
                <button type="submit" class="btn btn-primary btn-block btn-lg">✅ Xác nhận đặt phòng</button>
            </form>
            <a href="${pageContext.request.contextPath}/staff/booking?action=searchRoom" class="btn btn-outline btn-block mt-2">← Đặt lại từ đầu</a>
        </div></div>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
