<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>${applicationScope.hotelInfo.name}</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
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
                <c:choose>
                    <c:when test="${not empty rt.imageUrl}">
                        <div class="room-gallery" style="display:flex; overflow:hidden; gap:5px; padding:5px; scroll-snap-type: x mandatory;">
                            <c:forEach var="imgUrl" items="${rt.imageUrl.split(',')}">
                                <img src="${pageContext.request.contextPath}${imgUrl.trim()}" style="height:150px; min-width:100%; object-fit:cover; border-radius:8px; scroll-snap-align: start;" alt="${rt.name}">
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="room-card-img">Phòng</div>
                    </c:otherwise>
                </c:choose>
                <div class="room-card-body">
                    <h3>${rt.name}</h3>
                    <p class="amenities">${rt.amenities}</p>
                    <div class="price"><fmt:formatNumber value="${rt.basePrice}" pattern="#,##0"/>₫ <span>/đêm</span></div>
                </div>
                <div class="room-card-footer">
                    <span class="capacity">${rt.capacity} khách • ${rt.area}</span>
                    <a href="${pageContext.request.contextPath}/home?action=roomTypeDetail&id=${rt.id}" class="btn btn-outline btn-sm">Chi tiết</a>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<c:if test="${not empty hotel.imageUrl}">
<section class="section" style="padding-top:0;">
    <h2>Không gian khách sạn</h2>
    <p class="section-desc">Hình ảnh thực tế về không gian và dịch vụ tại ${hotel.name}</p>
    <div class="hotel-gallery" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px; margin-top: 20px;">
        <c:forEach var="imgUrl" items="${hotel.imageUrl.split(',')}">
            <div class="gallery-item" style="border-radius: var(--radius); overflow: hidden; height: 200px; box-shadow: var(--shadow); transition: var(--transition);">
                <img src="${pageContext.request.contextPath}${imgUrl.trim()}" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s;" alt="${hotel.name}" onmouseover="this.style.transform='scale(1.08)'" onmouseout="this.style.transform='scale(1)'">
            </div>
        </c:forEach>
    </div>
</section>
</c:if>

<section class="section" style="padding-top:0;">
    <h2>Thông tin liên hệ</h2>
    <div class="card mt-2" style="max-width:600px;">
        <ul class="detail-list">
            <li><span class="label">Địa chỉ</span><span class="value">${hotel.address}</span></li>
            <li><span class="label">Điện thoại</span><span class="value">${hotel.phone}</span></li>
            <li><span class="label">Email</span><span class="value">${hotel.email}</span></li>
            <li><span class="label">Xếp hạng</span><span class="value">${hotel.starRating} sao</span></li>
        </ul>
    </div>
</section>
<footer class="customer-footer">© 2025 ${hotel.name}. All rights reserved.</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const today = new Date().toISOString().split('T')[0];
        const checkIn = document.querySelector('input[name="checkIn"]');
        const checkOut = document.querySelector('input[name="checkOut"]');
        if(checkIn) checkIn.min = today;
        if(checkOut) checkOut.min = today;
        
        if(checkIn && checkOut) {
            checkIn.addEventListener('change', function() {
                if (checkIn.value) {
                    const next = new Date(checkIn.value);
                    next.setDate(next.getDate() + 1);
                    const minOut = next.toISOString().split('T')[0];
                    checkOut.min = minOut;
                    if (checkOut.value && checkOut.value <= checkIn.value) checkOut.value = minOut;
                }
            });
        }
    });

</script>
</body></html>
