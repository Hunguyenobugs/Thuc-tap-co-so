<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Sửa phiếu đặt</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Sửa phiếu <span>${booking.code}</span></h1></div></div>
    <div class="card mb-3"><div class="card-header"><h3>Thông tin hiện tại</h3></div>
        <ul class="detail-list">
            <li><span class="label">Khách hàng</span><span class="value">${booking.customerName}</span></li>
            <li><span class="label">Phòng hiện tại</span><span class="value">${booking.roomTypeName} - ${booking.roomNumber}</span></li>
            <li><span class="label">Check-in</span><span class="value">${booking.checkIn}</span></li>
            <li><span class="label">Check-out</span><span class="value">${booking.checkOut}</span></li>
        </ul></div>
    <c:if test="${freeRooms != null && !freeRooms.isEmpty()}">
        <div class="card"><div class="card-header"><h3>Chọn phòng mới</h3></div>
            <form method="post" action="${pageContext.request.contextPath}/staff/manageBooking"><input type="hidden" name="action" value="update"><input type="hidden" name="bookingId" value="${booking.id}">
                <div class="form-group"><label>Phòng mới</label><select name="roomId" class="form-control">
                    <c:forEach var="r" items="${freeRooms}"><option value="${r.id}">${r.roomNumber} - ${r.roomTypeName}</option></c:forEach>
                </select></div>
                <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Cập nhật</button><a href="${pageContext.request.contextPath}/staff/manageBooking?action=search" class="btn btn-outline">← Quay lại</a></div>
            </form></div>
    </c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
