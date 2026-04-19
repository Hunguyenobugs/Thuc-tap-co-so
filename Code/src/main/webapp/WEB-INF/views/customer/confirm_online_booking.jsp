<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Xác nhận đặt phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <div class="confirm-box">
        <h2>📋 Xác nhận đặt phòng</h2>
        <div class="confirm-detail">
            <div class="card mb-3">
                <ul class="detail-list">
                    <li><span class="label">Loại phòng</span><span class="value">${roomType.name}</span></li>
                    <li><span class="label">Ngày nhận</span><span class="value">${checkIn}</span></li>
                    <li><span class="label">Ngày trả</span><span class="value">${checkOut}</span></li>
                    <li><span class="label">Số đêm</span><span class="value">${nights} đêm</span></li>
                    <li><span class="label">Giá/đêm</span><span class="value"><fmt:formatNumber value="${roomType.basePrice}" pattern="#,##0"/>₫</span></li>
                    <li><span class="label fw-bold">Tổng ước tính</span><span class="value fw-bold text-accent"><fmt:formatNumber value="${totalEstimate}" pattern="#,##0"/>₫</span></li>
                </ul>
            </div>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/onlineBooking">
            <input type="hidden" name="roomTypeId" value="${roomType.id}">
            <input type="hidden" name="checkIn" value="${checkIn}">
            <input type="hidden" name="checkOut" value="${checkOut}">
            <div class="form-group"><label>Yêu cầu đặc biệt</label><textarea name="specialRequests" class="form-control" rows="3" placeholder="VD: Cần thêm gối, phòng tầng cao..."></textarea></div>
            <div class="btn-group" style="justify-content:center;">
                <a href="${pageContext.request.contextPath}/search" class="btn btn-outline">← Quay lại</a>
                <button type="submit" class="btn btn-primary btn-lg">Xác nhận đặt phòng</button>
            </div>
        </form>
    </div>
</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
