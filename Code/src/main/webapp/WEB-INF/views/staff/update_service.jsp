<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Thêm dịch vụ phát sinh</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>🛎️ Dịch vụ - <span>${booking.code}</span></h1><div class="breadcrumb"><span>Phòng ${booking.roomNumber} • ${booking.customerName}</span></div></div></div>
    <% if ("service_added".equals(request.getParameter("msg"))) { %><div class="alert alert-success">✅ Thêm dịch vụ thành công</div><% } %>
    <div class="detail-grid">
        <div>
            <div class="card mb-3"><div class="card-header"><h3>Dịch vụ đã sử dụng</h3><span class="badge badge-info">Tổng: <fmt:formatNumber value="${serviceTotal}" pattern="#,##0"/>₫</span></div>
                <c:choose><c:when test="${empty usedServices}"><div class="no-data">Chưa có dịch vụ nào</div></c:when><c:otherwise>
                    <div class="table-container"><table><thead><tr><th>Tên DV</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th><th>Ngày</th></tr></thead><tbody>
                    <c:forEach var="us" items="${usedServices}"><tr><td>${us.serviceName}</td><td>${us.quantity} ${us.serviceUnit}</td><td><fmt:formatNumber value="${us.unitPrice}" pattern="#,##0"/>₫</td><td class="fw-bold"><fmt:formatNumber value="${us.subtotal}" pattern="#,##0"/>₫</td><td class="fs-sm"><fmt:formatDate value="${us.usedDate}" pattern="dd/MM HH:mm"/></td></tr></c:forEach>
                    </tbody></table></div></c:otherwise></c:choose>
            </div>
        </div>
        <div><div class="card" style="position:sticky;top:100px;">
            <h3 class="mb-3">➕ Thêm dịch vụ</h3>
            <form method="get" action="${pageContext.request.contextPath}/staff/serviceUpdate" class="mb-3">
                <input type="hidden" name="action" value="load"><input type="hidden" name="bookingId" value="${booking.id}">
                <div class="form-group"><label>Tìm dịch vụ</label><div style="display:flex;gap:8px;"><input type="text" name="keyword" class="form-control" placeholder="Tên dịch vụ..." value="${keyword}"><button type="submit" class="btn btn-outline btn-sm">🔍</button></div></div>
            </form>
            <c:if test="${searchServices != null}">
                <c:forEach var="s" items="${searchServices}">
                    <div class="card mb-2" style="padding:12px;">
                        <div class="flex-between"><div><strong>${s.name}</strong><br><span class="fs-sm text-muted">${s.category} • <fmt:formatNumber value="${s.price}" pattern="#,##0"/>₫/${s.unit}</span></div></div>
                        <form method="post" action="${pageContext.request.contextPath}/staff/serviceUpdate" class="mt-1" style="display:flex;gap:8px;align-items:end;">
                            <input type="hidden" name="action" value="addService"><input type="hidden" name="bookingId" value="${booking.id}"><input type="hidden" name="serviceId" value="${s.id}">
                            <div style="flex:1;"><label class="fs-sm">Số lượng</label><input type="number" name="quantity" class="form-control" value="1" min="1" step="0.5" style="padding:6px 10px;"></div>
                            <button type="submit" class="btn btn-success btn-sm">➕ Thêm</button>
                        </form>
                    </div>
                </c:forEach>
            </c:if>
            <a href="${pageContext.request.contextPath}/staff/serviceUpdate?action=search" class="btn btn-outline btn-block mt-3">← Quay lại</a>
        </div></div>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
