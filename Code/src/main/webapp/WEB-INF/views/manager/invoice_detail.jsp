<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Chi tiết hóa đơn</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>`n    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>🧾 Hóa đơn <span>${invoice.code}</span></h1><div class="breadcrumb"><a href="${pageContext.request.contextPath}/manager/invoice?action=list">Hóa đơn</a><span>Chi tiết</span></div></div></div>
    <div class="detail-grid">
        <div><div class="card mb-3"><div class="card-header"><h3>Thông tin hóa đơn</h3></div>
            <ul class="detail-list">
                <li><span class="label">Mã hóa đơn</span><span class="value fw-bold">${invoice.code}</span></li>
                <li><span class="label">Mã phiếu đặt</span><span class="value">${invoice.bookingCode}</span></li>
                <li><span class="label">Khách hàng</span><span class="value">${invoice.customerName}</span></li>
                <li><span class="label">NV lập</span><span class="value">${invoice.staffName}</span></li>
                <li><span class="label">Ngày lập</span><span class="value"><fmt:formatDate value="${invoice.issueDate}" pattern="dd/MM/yyyy HH:mm"/></span></li>
                <li><span class="label">Phương thức</span><span class="value"><span class="badge badge-info">${invoice.paymentMethod}</span></span></li>
            </ul></div>
            <c:if test="${not empty usedServices}"><div class="card"><div class="card-header"><h3>Dịch vụ sử dụng</h3></div>
                <div class="table-container"><table><thead><tr><th>Tên DV</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th></tr></thead><tbody>
                <c:forEach var="us" items="${usedServices}"><tr><td>${us.serviceName}</td><td>${us.quantity} ${us.serviceUnit}</td><td><fmt:formatNumber value="${us.unitPrice}" pattern="#,##0"/>₫</td><td class="fw-bold"><fmt:formatNumber value="${us.subtotal}" pattern="#,##0"/>₫</td></tr></c:forEach>
                </tbody></table></div></div></c:if>
        </div>
        <div><div class="card" style="position:sticky;top:100px;">
            <h3 class="mb-3">💰 Tổng kết</h3>
            <ul class="detail-list">
                <li><span class="label">Tiền phòng</span><span class="value"><fmt:formatNumber value="${invoice.roomTotal}" pattern="#,##0"/>₫</span></li>
                <li><span class="label">Tiền dịch vụ</span><span class="value"><fmt:formatNumber value="${invoice.serviceTotal}" pattern="#,##0"/>₫</span></li>
                <li><span class="label">Phụ thu</span><span class="value"><fmt:formatNumber value="${invoice.surcharge}" pattern="#,##0"/>₫</span></li>
                <li style="padding-top:16px;border-top:2px solid var(--accent);"><span class="label fw-bold" style="font-size:16px;">Tổng cộng</span><span class="value fw-bold text-accent" style="font-size:20px;"><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,##0"/>₫</span></li>
                <li><span class="label">Đã thanh toán</span><span class="value text-success"><fmt:formatNumber value="${invoice.paidAmount}" pattern="#,##0"/>₫</span></li>
            </ul>
            <div class="btn-group mt-3"><a href="${pageContext.request.contextPath}/manager/invoice?action=edit&id=${invoice.id}" class="btn btn-outline">✏️ Sửa</a><a href="${pageContext.request.contextPath}/manager/invoice?action=list" class="btn btn-outline">← Quay lại</a></div>
        </div></div>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
