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
    <!-- Gallery CSS Style -->
    <style>
    .gallery-container {
        display: flex;
        flex-direction: column;
        gap: 16px;
        width: 100%;
    }
    .gallery-main {
        width: 100%;
        height: 420px;
        border-radius: var(--radius);
        overflow: hidden;
        box-shadow: var(--shadow);
        position: relative;
        background: rgba(0, 0, 0, 0.2);
    }
    .gallery-main img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: opacity 0.25s ease, transform 0.5s ease;
    }
    .gallery-main:hover img {
        transform: scale(1.03);
    }
    .gallery-nav {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        background: rgba(15, 23, 42, 0.6);
        color: #fff;
        border: none;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        font-size: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 10;
        transition: var(--transition);
        backdrop-filter: blur(4px);
    }
    .gallery-nav:hover {
        background: var(--accent);
        transform: translateY(-50%) scale(1.1);
        box-shadow: 0 0 15px var(--accent-glow);
    }
    .gallery-prev {
        left: 16px;
    }
    .gallery-next {
        right: 16px;
    }
    .gallery-thumbnails {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        width: 100%;
    }
    .thumbnail-item {
        width: 80px;
        height: 60px;
        border-radius: var(--radius-sm);
        overflow: hidden;
        cursor: pointer;
        border: 2px solid transparent;
        transition: var(--transition);
        opacity: 0.6;
        box-shadow: var(--shadow);
    }
    .thumbnail-item img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
    }
    .thumbnail-item:hover {
        opacity: 1;
        transform: translateY(-2px);
    }
    .thumbnail-item.active {
        opacity: 1;
        border-color: var(--accent);
        box-shadow: 0 0 10px var(--accent-glow);
        transform: scale(1.05);
    }
    </style>

    <div class="detail-grid">
        <div>
            <c:choose>
                <c:when test="${not empty roomType.imageUrl}">
                    <c:set var="imgList" value="${roomType.imageUrl.split(',')}"/>
                    <div class="gallery-container">
                        <!-- Ảnh lớn hiển thị chính -->
                        <div class="gallery-main">
                            <c:if test="${fn:length(imgList) > 1}">
                                <button type="button" class="gallery-nav gallery-prev" onclick="navigateGallery(-1)">&#10094;</button>
                                <button type="button" class="gallery-nav gallery-next" onclick="navigateGallery(1)">&#10095;</button>
                            </c:if>
                            <img id="mainGalleryImg" src="${pageContext.request.contextPath}${imgList[0].trim()}" alt="${roomType.name}">
                        </div>
                        
                        <!-- Danh sách ảnh nhỏ ở dưới -->
                        <c:if test="${fn:length(imgList) > 1}">
                            <div class="gallery-thumbnails">
                                <c:forEach var="imgUrl" items="${imgList}" varStatus="status">
                                    <div class="thumbnail-item ${status.index == 0 ? 'active' : ''}" onclick="changeMainImage('${pageContext.request.contextPath}${imgUrl.trim()}', this)">
                                        <img src="${pageContext.request.contextPath}${imgUrl.trim()}" alt="${roomType.name} - Thumbnail ${status.index + 1}">
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="room-card-img" style="height:400px;border-radius:var(--radius); display:flex; align-items:center; justify-content:center; background:var(--bg-secondary); color:var(--text-muted); font-size:18px;">Chưa có hình ảnh</div>
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
                <a href="${pageContext.request.contextPath}/onlineBooking?action=searchRoom&roomTypeId=${roomType.id}" class="btn btn-primary btn-lg btn-block text-center" style="display: block; text-decoration: none;">Chọn phòng và đặt ngay</a>
            </div>
        </div>
    </div>
</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
const images = [
    <c:forEach var="imgUrl" items="${imgList}" varStatus="status">
        '${pageContext.request.contextPath}${imgUrl.trim()}'${not status.last ? ',' : ''}
    </c:forEach>
];
let currentIndex = 0;

function changeMainImage(src, element) {
    const mainImg = document.getElementById('mainGalleryImg');
    if (mainImg.src === src) return;
    
    mainImg.style.opacity = '0';
    setTimeout(() => {
        mainImg.src = src;
        mainImg.style.opacity = '1';
    }, 200);
    
    currentIndex = images.indexOf(src);
    
    document.querySelectorAll('.thumbnail-item').forEach(item => {
        item.classList.remove('active');
    });
    
    if (element) {
        element.classList.add('active');
    } else {
        const thumbnails = document.querySelectorAll('.thumbnail-item');
        if (thumbnails[currentIndex]) {
            thumbnails[currentIndex].classList.add('active');
        }
    }
}

function navigateGallery(direction) {
    if (images.length <= 1) return;
    currentIndex += direction;
    if (currentIndex < 0) {
        currentIndex = images.length - 1;
    } else if (currentIndex >= images.length) {
        currentIndex = 0;
    }
    
    const nextSrc = images[currentIndex];
    changeMainImage(nextSrc, null);
}
</script>
</body></html>
