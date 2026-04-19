<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Chi tiết Check-out</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>🚪 Check-out <span>${booking.code}</span></h1></div></div>
    <div class="detail-grid">
        <div>
            <div class="card mb-3"><div class="card-header"><h3>🛏️ Thông tin phòng</h3></div>
                <ul class="detail-list">
                    <li><span class="label">Phòng</span><span class="value">${booking.roomTypeName} - ${booking.roomNumber}</span></li>
                    <li><span class="label">Check-in</span><span class="value">${bookedRoom.checkIn}</span></li>
                    <li><span class="label">Check-out</span><span class="value">${bookedRoom.checkOut}</span></li>
                    <li><span class="label">Số đêm</span><span class="value">${nights} đêm</span></li>
                    <li><span class="label">Giá/đêm</span><span class="value"><fmt:formatNumber value="${bookedRoom.actualPrice}" pattern="#,##0"/>₫</span></li>
                    <li><span class="label fw-bold">Tiền phòng</span><span class="value fw-bold text-accent"><fmt:formatNumber value="${roomTotal}" pattern="#,##0"/>₫</span></li>
                </ul></div>
            <c:if test="${not empty usedServices}">
                <div class="card"><div class="card-header"><h3>🛎️ Dịch vụ sử dụng</h3></div>
                    <div class="table-container"><table><thead><tr><th>Tên DV</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th></tr></thead><tbody>
                    <c:forEach var="us" items="${usedServices}"><tr><td>${us.serviceName}</td><td>${us.quantity} ${us.serviceUnit}</td><td><fmt:formatNumber value="${us.unitPrice}" pattern="#,##0"/>₫</td><td class="fw-bold"><fmt:formatNumber value="${us.subtotal}" pattern="#,##0"/>₫</td></tr></c:forEach>
                    </tbody></table></div></div>
            </c:if>
        </div>
        <div><div class="card" style="position:sticky;top:100px;">
            <h3 class="mb-3">💰 Thanh toán</h3>
            <ul class="detail-list">
                <li><span class="label">Tiền phòng</span><span class="value"><fmt:formatNumber value="${roomTotal}" pattern="#,##0"/>₫</span></li>
                <li><span class="label">Tiền DV</span><span class="value"><fmt:formatNumber value="${serviceTotal}" pattern="#,##0"/>₫</span></li>
            </ul>
            <div style="text-align:center;padding:16px;margin:16px 0;border-top:2px solid var(--accent);border-bottom:2px solid var(--accent);">
                <div class="fs-sm text-muted">TỔNG CỘNG</div>
                <div style="font-size:32px;font-weight:700;color:var(--accent);"><fmt:formatNumber value="${grandTotal}" pattern="#,##0"/>₫</div>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/staff/checkout">
                <input type="hidden" name="action" value="execute"><input type="hidden" name="bookingId" value="${booking.id}">
                <input type="hidden" name="roomTotal" value="${roomTotal}"><input type="hidden" name="serviceTotal" value="${serviceTotal}">
                <div class="form-group"><label>Phụ thu</label><input type="number" name="surcharge" class="form-control" value="0" min="0"></div>
                <div class="form-group"><label>Phương thức TT</label><select name="paymentMethod" class="form-control"><option value="Tiền mặt">Tiền mặt</option><option value="Chuyển khoản">Chuyển khoản</option><option value="Thẻ tín dụng">Thẻ tín dụng</option></select></div>
                <div class="form-group"><label>Ghi chú</label><textarea name="note" class="form-control" rows="2"></textarea></div>
                <button type="submit" class="btn btn-success btn-block btn-lg">✅ Hoàn tất Check-out</button>
            </form>
            <a href="${pageContext.request.contextPath}/staff/checkout?action=search" class="btn btn-outline btn-block mt-2">← Quay lại</a>
        </div></div>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
