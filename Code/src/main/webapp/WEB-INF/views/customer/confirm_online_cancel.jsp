<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Xác nhận hủy đặt phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <div class="confirm-box">
        <h2>⚠️ Xác nhận hủy phiếu đặt</h2>
        <div class="alert alert-warning">Bạn có chắc chắn muốn hủy phiếu đặt <strong>${booking.code}</strong>?</div>
        <div class="confirm-detail">
            <div class="card mb-3">
                <ul class="detail-list">
                    <li><span class="label">Mã phiếu</span><span class="value">${booking.code}</span></li>
                    <li><span class="label">Phòng</span><span class="value">${booking.roomTypeName} - ${booking.roomNumber}</span></li>
                    <li><span class="label">Trạng thái</span><span class="value">${booking.status}</span></li>
                </ul>
            </div>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/onlineCancel">
            <input type="hidden" name="bookingId" value="${booking.id}">
            <div class="btn-group" style="justify-content:center;">
                <a href="${pageContext.request.contextPath}/bookingHistory" class="btn btn-outline">← Quay lại</a>
                <button type="submit" class="btn btn-danger btn-lg">Xác nhận hủy</button>
            </div>
        </form>
    </div>
</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
</body></html>
