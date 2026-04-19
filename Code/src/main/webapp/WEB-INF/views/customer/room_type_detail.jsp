<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>${roomType.name} - Grand Lotus Hotel</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <div class="breadcrumb mb-3"><a href="${pageContext.request.contextPath}/home">Trang chủ</a><span>${roomType.name}</span></div>
    <div class="detail-grid">
        <div>
            <div class="room-card-img" style="height:400px;border-radius:var(--radius);">🛏️</div>
        </div>
        <div>
            <h1 style="font-size:32px;margin-bottom:16px;">${roomType.name}</h1>
            <div class="price mb-3" style="font-size:28px;color:var(--accent);font-weight:700;"><fmt:formatNumber value="${roomType.basePrice}" pattern="#,##0"/>₫ <span style="font-size:14px;color:var(--text-muted);font-weight:400;">/đêm</span></div>
            <div class="card">
                <ul class="detail-list">
                    <li><span class="label">Sức chứa</span><span class="value">${roomType.capacity} khách</span></li>
                    <li><span class="label">Diện tích</span><span class="value">${roomType.area}</span></li>
                    <li><span class="label">Tiện nghi</span><span class="value">${roomType.amenities}</span></li>
                    <li><span class="label">Mô tả</span><span class="value">${roomType.description}</span></li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/search" class="btn btn-primary btn-lg mt-3">Đặt phòng ngay</a>
        </div>
    </div>
</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
