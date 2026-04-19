<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Grand Lotus Hotel</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="hero">
    <h1>Chào mừng đến <span>${hotel.name}</span></h1>
    <p>${hotel.description}</p>
    <form class="search-hero" action="${pageContext.request.contextPath}/search" method="get">
        <input type="date" name="checkIn" placeholder="Ngày nhận" required>
        <input type="date" name="checkOut" placeholder="Ngày trả" required>
        <select name="guests"><option value="1">1 khách</option><option value="2" selected>2 khách</option><option value="3">3 khách</option><option value="4">4 khách</option></select>
        <button type="submit" class="btn btn-primary">Tìm phòng</button>
    </form>
</section>
<section class="section">
    <h2>Loại phòng</h2>
    <p class="section-desc">Trải nghiệm các hạng phòng sang trọng của chúng tôi</p>
    <div class="room-grid">
        <c:forEach var="rt" items="${roomTypes}">
            <div class="room-card">
                <div class="room-card-img">🛏️</div>
                <div class="room-card-body">
                    <h3>${rt.name}</h3>
                    <p class="amenities">${rt.amenities}</p>
                    <div class="price"><fmt:formatNumber value="${rt.basePrice}" pattern="#,##0"/>₫ <span>/đêm</span></div>
                </div>
                <div class="room-card-footer">
                    <span class="capacity">👥 ${rt.capacity} khách • ${rt.area}</span>
                    <a href="${pageContext.request.contextPath}/home?action=roomTypeDetail&id=${rt.id}" class="btn btn-outline btn-sm">Chi tiết</a>
                </div>
            </div>
        </c:forEach>
    </div>
</section>
<section class="section" style="padding-top:0;">
    <h2>Thông tin liên hệ</h2>
    <div class="card mt-2" style="max-width:600px;">
        <ul class="detail-list">
            <li><span class="label">Địa chỉ</span><span class="value">${hotel.address}</span></li>
            <li><span class="label">Điện thoại</span><span class="value">${hotel.phone}</span></li>
            <li><span class="label">Email</span><span class="value">${hotel.email}</span></li>
            <li><span class="label">Xếp hạng</span><span class="value">${hotel.starRating} ⭐</span></li>
        </ul>
    </div>
</section>
<footer class="customer-footer">© 2025 ${hotel.name}. All rights reserved.</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
