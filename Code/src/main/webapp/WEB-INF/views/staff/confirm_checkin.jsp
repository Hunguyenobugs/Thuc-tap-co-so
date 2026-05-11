<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Xác nhận Check-in</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>🔑 Xác nhận <span>Check-in</span></h1></div></div>
    <div class="confirm-box">
        <h2>Xác nhận nhận phòng</h2>
        <div class="card mb-3"><ul class="detail-list">
            <li><span class="label">Mã phiếu đặt</span><span class="value fw-bold">${booking.code}</span></li>
            <li><span class="label">Khách hàng</span><span class="value">${booking.customerName}</span></li>
            <li><span class="label">Phòng</span><span class="value fw-bold">${bookedRoom.roomNumber} - ${bookedRoom.roomTypeName}</span></li>
            <li><span class="label">Ngày nhận phòng (dự kiến)</span><span class="value"><fmt:formatDate value="${bookedRoom.checkIn}" pattern="HH:mm dd/MM/yyyy"/></span></li>
            <li><span class="label">Ngày trả phòng (dự kiến)</span><span class="value"><fmt:formatDate value="${bookedRoom.checkOut}" pattern="HH:mm dd/MM/yyyy"/></span></li>
            <li><span class="label">Check-in thực tế</span><span class="value text-accent fw-bold">Ngay bây giờ (${pageContext.response.characterEncoding})</span></li>
        </ul></div>
        <div class="alert alert-info">⏰ Thời gian check-in sẽ được ghi nhận tại thời điểm bấm xác nhận.</div>
        <form method="post" action="${pageContext.request.contextPath}/staff/checkin">
            <input type="hidden" name="action" value="execute">
            <input type="hidden" name="bookedRoomId" value="${bookedRoom.id}">
            <div class="btn-group" style="justify-content:center;">
                <a href="${pageContext.request.contextPath}/staff/checkin?action=search" class="btn btn-outline">← Quay lại</a>
                <button type="submit" class="btn btn-success btn-lg">✅ Xác nhận Check-in</button>
            </div>
        </form>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
