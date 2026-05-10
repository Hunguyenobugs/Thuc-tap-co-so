<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Chi tiết phiếu đặt</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>📄 Chi tiết <span>phiếu đặt ${booking.code}</span></h1></div></div>
    <div class="card mb-3"><div class="card-header"><h3>Thông tin chi tiết</h3></div>
        <ul class="detail-list">
            <li><span class="label">Trạng thái</span><span class="value">
                <c:choose>
                    <c:when test="${booking.status=='Chờ xác nhận'}"><span class="badge badge-warning">${booking.status}</span></c:when>
                    <c:when test="${booking.status=='Đã xác nhận'}"><span class="badge badge-info">${booking.status}</span></c:when>
                    <c:when test="${booking.status=='Đang lưu trú'}"><span class="badge badge-primary">${booking.status}</span></c:when>
                    <c:when test="${booking.status=='Đã trả phòng'}"><span class="badge badge-success">${booking.status}</span></c:when>
                    <c:otherwise><span class="badge badge-danger">${booking.status}</span></c:otherwise>
                </c:choose>
            </span></li>
            <li><span class="label">Khách hàng</span><span class="value">${booking.customerName}</span></li>
            <li><span class="label">Số CCCD</span><span class="value">${booking.customerIdCard}</span></li>
            <li><span class="label">Số điện thoại</span><span class="value">${booking.customerPhone}</span></li>
            <li><span class="label">Phòng</span><span class="value">${booking.roomTypeName} - ${booking.roomNumber}</span></li>
            <li><span class="label">Ngày nhận phòng</span><span class="value"><fmt:parseDate value="${booking.checkIn}" pattern="yyyy-MM-dd HH:mm:ss" var="ciDate"/><fmt:formatDate value="${ciDate}" pattern="HH:mm dd/MM/yyyy"/></span></li>
            <li><span class="label">Ngày trả phòng</span><span class="value"><fmt:parseDate value="${booking.checkOut}" pattern="yyyy-MM-dd HH:mm:ss" var="coDate"/><fmt:formatDate value="${coDate}" pattern="HH:mm dd/MM/yyyy"/></span></li>
            <c:set var="room" value="${bookedRooms[0]}" />
            <c:if test="${room.actualCheckin != null}">
                <li><span class="label">Check-in</span><span class="value"><fmt:formatDate value="${room.actualCheckin}" pattern="HH:mm dd/MM/yyyy"/></span></li>
            </c:if>
            <c:if test="${room.actualCheckout != null}">
                <li><span class="label">Check-out</span><span class="value"><fmt:formatDate value="${room.actualCheckout}" pattern="HH:mm dd/MM/yyyy"/></span></li>
            </c:if>
            <li><span class="label">Ngày đặt</span><span class="value"><fmt:formatDate value="${booking.bookingDate}" pattern="HH:mm dd/MM/yyyy"/></span></li>
            <li><span class="label">Tiền cọc</span><span class="value"><fmt:formatNumber value="${booking.depositAmount}" type="currency" currencySymbol="₫"/></span></li>
            <li><span class="label">Ghi chú</span><span class="value">${booking.note != null ? booking.note : 'Không'}</span></li>
            <li><span class="label">Nhân viên</span><span class="value">${booking.staffName != null ? booking.staffName : 'Khách tự đặt'}</span></li>
        </ul>
        <div class="btn-group mt-3" style="justify-content: center;">
            <c:if test="${booking.status == 'Chờ xác nhận'}">
                <form method="post" action="${pageContext.request.contextPath}/staff/manageBooking" style="display:inline;">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận duyệt phiếu này?');">✅ Xác nhận</button>
                </form>
            </c:if>
            <a href="${pageContext.request.contextPath}/staff/manageBooking?action=search" class="btn btn-outline">← Quay lại</a>
        </div>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
