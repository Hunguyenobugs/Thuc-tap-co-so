<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
            <c:choose>
                <c:when test="${not empty roomType.imageUrl}">
                    <div style="display:flex; flex-direction:column; gap:10px;">
                        <c:forEach var="imgUrl" items="${roomType.imageUrl.split(',')}">
                            <img src="${pageContext.request.contextPath}${imgUrl.trim()}" style="width:100%; height:auto; max-height:400px; object-fit:cover; border-radius:var(--radius);" alt="${roomType.name}">
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="room-card-img" style="height:400px;border-radius:var(--radius);">🛏️</div>
                </c:otherwise>
            </c:choose>
        </div>
        <div>
            <h1 style="font-size:32px;margin-bottom:16px;">${roomType.name}</h1>
            <div class="price mb-3" style="font-size:28px;color:var(--accent);font-weight:700;"><fmt:formatNumber value="${roomType.basePrice}" pattern="#,##0"/>₫ <span style="font-size:14px;color:var(--text-muted);font-weight:400;">/đêm</span></div>
            <div class="card mb-3">
                <ul class="detail-list">
                    <li><span class="label">Sức chứa</span><span class="value">${roomType.capacity} khách</span></li>
                    <li><span class="label">Diện tích</span><span class="value">${roomType.area}</span></li>
                    <li><span class="label">Tiện nghi</span><span class="value">${roomType.amenities}</span></li>
                    <li><span class="label">Mô tả</span><span class="value">${roomType.description}</span></li>
                </ul>
            </div>

            <!-- Nút chọn phòng và đặt ngay -->
            <div style="margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/onlineBooking?action=searchRoom&roomTypeId=${roomType.id}" class="btn btn-primary btn-lg btn-block text-center" style="display: block; text-decoration: none;">🛏️ Chọn phòng và đặt ngay</a>
            </div>
        </div>
    </div>
</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
