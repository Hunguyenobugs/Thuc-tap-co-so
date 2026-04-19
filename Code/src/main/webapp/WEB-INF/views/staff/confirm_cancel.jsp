<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Xác nhận hủy</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>⚠️ Xác nhận <span>hủy phiếu</span></h1></div></div>
    <div class="confirm-box">
        <div class="alert alert-warning">Bạn có chắc chắn muốn hủy phiếu đặt <strong>${booking.code}</strong>?</div>
        <div class="card mb-3"><ul class="detail-list">
            <li><span class="label">Mã phiếu</span><span class="value fw-bold">${booking.code}</span></li>
            <li><span class="label">Khách hàng</span><span class="value">${booking.customerName}</span></li>
            <li><span class="label">Phòng</span><span class="value">${booking.roomTypeName} - ${booking.roomNumber}</span></li>
            <li><span class="label">Trạng thái</span><span class="value"><span class="badge badge-info">${booking.status}</span></span></li>
        </ul></div>
        <form method="post" action="${pageContext.request.contextPath}/staff/cancel"><input type="hidden" name="action" value="execute"><input type="hidden" name="bookingId" value="${booking.id}">
            <div class="btn-group" style="justify-content:center;"><a href="${pageContext.request.contextPath}/staff/cancel?action=search" class="btn btn-outline">← Quay lại</a><button type="submit" class="btn btn-danger btn-lg">Xác nhận hủy</button></div></form>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
