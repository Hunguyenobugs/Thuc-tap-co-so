<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Xác nhận Hủy phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>⚠️ Xác nhận <span>Hủy phòng</span></h1></div></div>
    <div class="confirm-box">
        <h2>Xác nhận hủy phòng</h2>
        <div class="alert alert-warning" style="margin-bottom:16px;">
            ⚠️ Bạn có chắc chắn muốn hủy phòng <strong>${bookedRoom.roomNumber}</strong> trong phiếu đặt <strong>${booking.code}</strong>? Hành động này không thể hoàn tác.
        </div>
        <div class="card mb-3"><ul class="detail-list">
            <li><span class="label">Mã phiếu đặt</span><span class="value fw-bold">${booking.code}</span></li>
            <li><span class="label">Khách hàng</span><span class="value">${booking.customerName}</span></li>
            <li><span class="label">SĐT</span><span class="value">${booking.customerPhone}</span></li>
            <li><span class="label">Phòng</span><span class="value fw-bold">${bookedRoom.roomNumber} - ${bookedRoom.roomTypeName}</span></li>
            <li><span class="label">Ngày nhận phòng (dự kiến)</span><span class="value"><fmt:formatDate value="${bookedRoom.checkIn}" pattern="HH:mm dd/MM/yyyy"/></span></li>
            <li><span class="label">Ngày trả phòng (dự kiến)</span><span class="value"><fmt:formatDate value="${bookedRoom.checkOut}" pattern="HH:mm dd/MM/yyyy"/></span></li>
        </ul></div>
        <form method="post" action="${pageContext.request.contextPath}/staff/cancel">
            <input type="hidden" name="action" value="execute">
            <input type="hidden" name="bookedRoomId" value="${bookedRoom.id}">
            <div class="btn-group" style="justify-content:center;">
                <a href="${pageContext.request.contextPath}/staff/cancel?action=search" class="btn btn-outline">← Quay lại</a>
                <button type="submit" class="btn btn-danger btn-lg">🗑️ Xác nhận Hủy phòng</button>
            </div>
        </form>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
