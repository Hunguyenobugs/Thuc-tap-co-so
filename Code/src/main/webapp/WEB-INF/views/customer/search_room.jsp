<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Tìm phòng - Grand Lotus Hotel</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <h2>Tìm phòng trống</h2>
    <p class="section-desc">Chọn ngày và số khách để tìm phòng phù hợp</p>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/search">
        <input type="date" name="checkIn" class="form-control" value="${checkIn}" required>
        <input type="date" name="checkOut" class="form-control" value="${checkOut}" required>
        <select name="guests" class="form-control" style="max-width:150px;">
            <option value="1" ${guests==1?'selected':''}>1 khách</option>
            <option value="2" ${guests==2?'selected':''}>2 khách</option>
            <option value="3" ${guests==3?'selected':''}>3 khách</option>
            <option value="4" ${guests==4?'selected':''}>4 khách</option>
        </select>
        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
    </form>
    <c:if test="${results != null}">
        <c:choose>
            <c:when test="${empty results}">
                <div class="no-data">Không tìm thấy loại phòng phù hợp. Vui lòng thử ngày khác.</div>
            </c:when>
            <c:otherwise>
                <div class="room-grid">
                    <c:forEach var="rt" items="${results}">
                        <div class="room-card">
                            <div class="room-card-img">🛏️</div>
                            <div class="room-card-body">
                                <h3>${rt.name}</h3>
                                <p class="amenities">${rt.amenities}</p>
                                <div class="price"><fmt:formatNumber value="${rt.basePrice}" pattern="#,##0"/>₫ <span>/đêm</span></div>
                            </div>
                            <div class="room-card-footer">
                                <span class="capacity">👥 ${rt.capacity} khách • ${rt.area}</span>
                                <a href="${pageContext.request.contextPath}/onlineBooking?roomTypeId=${rt.id}&checkIn=${checkIn}&checkOut=${checkOut}" class="btn btn-primary btn-sm">Đặt ngay</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>
</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
