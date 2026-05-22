<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Cập nhật dịch vụ</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.service-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 12px; }
.service-card { border: 1px solid var(--border); border-radius: 10px; padding: 14px; background: var(--bg-primary); transition: box-shadow 0.2s; }
.service-card:hover { box-shadow: var(--shadow-md); }
.service-name { font-weight: 700; font-size: 15px; color: var(--text-primary); }
.service-meta { font-size: 12px; color: var(--text-muted); margin: 4px 0 10px; }
.service-price { font-weight: 700; color: var(--accent); font-size: 14px; }
.qty-row { display: flex; gap: 8px; align-items: center; margin-top: 10px; }
.qty-row input { flex: 1; padding: 5px 8px; border-radius: 6px; border: 1px solid var(--border); background: var(--bg-secondary); color: var(--text-primary); }
.category-title { font-size: 13px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; margin: 16px 0 8px; padding-bottom: 4px; border-bottom: 1px solid var(--border); }
</style>
</head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div>
        <h1>🛎️ Dịch vụ - <span>${booking.code}</span></h1>
        <div class="breadcrumb">
            ${booking.customerName}
            <c:if test="${bookedRoom != null}"> • Phòng <strong>${bookedRoom.roomNumber}</strong> (${bookedRoom.roomTypeName})</c:if>
        </div>
    </div></div>

    <% if ("updated".equals(request.getParameter("msg"))) { %><div class="alert alert-success">✅ Cập nhật dịch vụ thành công</div><% } %>

    <div class="detail-grid">
        <!-- Cột trái: Dịch vụ đã sử dụng -->
        <div>
            <div class="card mb-3"><div class="card-header"><h3>📋 Dịch vụ đã sử dụng</h3><span class="badge badge-info">Tổng: <fmt:formatNumber value="${serviceTotal}" pattern="#,##0"/>₫</span></div>
                <c:choose><c:when test="${empty usedServices}"><div class="no-data">Chưa có dịch vụ nào</div></c:when>
                <c:otherwise>
                    <div class="table-container"><table><thead><tr><th>Tên DV</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th><th>Ngày</th><th></th></tr></thead><tbody>
                    <c:forEach var="us" items="${usedServices}"><tr>
                        <td>${us.serviceName}</td>
                        <td>${us.quantity} ${us.serviceUnit}</td>
                        <td><fmt:formatNumber value="${us.unitPrice}" pattern="#,##0"/>₫</td>
                        <td class="fw-bold"><fmt:formatNumber value="${us.subtotal}" pattern="#,##0"/>₫</td>
                        <td class="fs-sm"><fmt:formatDate value="${us.usedDate}" pattern="HH:mm dd/MM"/></td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/staff/serviceUpdate" style="display:inline;">
                                <input type="hidden" name="action" value="deleteService">
                                <input type="hidden" name="bookingId" value="${booking.id}">
                                <c:if test="${bookedRoomId != null}"><input type="hidden" name="bookedRoomId" value="${bookedRoomId}"></c:if>
                                <input type="hidden" name="usedServiceId" value="${us.id}">
                                <button type="submit" class="btn btn-danger btn-sm"
                                        onclick="return confirm('Bỏ dịch vụ ${us.serviceName}?')">🗑️</button>
                            </form>
                        </td>
                    </tr></c:forEach>
                    </tbody></table></div>
                </c:otherwise></c:choose>
            </div>
        </div>

        <!-- Cột phải: Tất cả dịch vụ -->
        <div><div class="card" style="position:sticky;top:100px;max-height:80vh;overflow-y:auto;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                <h3 class="m-0">➕ Thêm dịch vụ</h3>
            </div>
            
            <input type="text" id="serviceSearch" class="form-control" placeholder="🔍 Tìm nhanh dịch vụ..." style="margin-bottom:16px;" onkeyup="filterServices()">

            <div id="serviceList">
            <c:if test="${not empty allServices}">
                <%-- Nhóm theo category --%>
                <c:set var="currentCategory" value=""/>
                <c:forEach var="s" items="${allServices}">
                    <c:if test="${s.category != currentCategory}">
                        <div class="category-title">${empty s.category ? 'Khác' : s.category}</div>
                        <c:set var="currentCategory" value="${s.category}"/>
                    </c:if>
                    <div class="service-card">
                        <div class="service-name">${s.name}</div>
                        <div class="service-meta">${s.category} • ${s.unit}</div>
                        <div class="service-price"><fmt:formatNumber value="${s.price}" pattern="#,##0"/>₫/${s.unit}</div>
                        <form method="post" action="${pageContext.request.contextPath}/staff/serviceUpdate">
                            <input type="hidden" name="action" value="addService">
                            <input type="hidden" name="bookingId" value="${booking.id}">
                            <c:if test="${bookedRoomId != null}"><input type="hidden" name="bookedRoomId" value="${bookedRoomId}"></c:if>
                            <input type="hidden" name="serviceId" value="${s.id}">
                            <div class="qty-row">
                                <label class="fs-sm" style="white-space:nowrap;">Số lượng</label>
                                <input type="number" name="quantity" value="1" min="1" step="0.5">
                                <button type="submit" class="btn btn-success btn-sm">➕</button>
                            </div>
                        </form>
                    </div>
                </c:forEach>
            </c:if>
            </div>

            <a href="${pageContext.request.contextPath}/staff/serviceUpdate?action=search" class="btn btn-outline btn-block mt-3">← Quay lại</a>
        </div></div>
    </div>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function filterServices() {
    const query = document.getElementById('serviceSearch').value.toLowerCase();
    const cards = document.querySelectorAll('.service-card');
    const categories = document.querySelectorAll('.category-title');
    
    // Hide or show cards
    cards.forEach(card => {
        const name = card.querySelector('.service-name').textContent.toLowerCase();
        if (name.includes(query)) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });

    // Hide or show category titles
    categories.forEach(cat => {
        let hasVisibleCard = false;
        let nextSibling = cat.nextElementSibling;
        while (nextSibling && !nextSibling.classList.contains('category-title')) {
            if (nextSibling.classList.contains('service-card') && nextSibling.style.display !== 'none') {
                hasVisibleCard = true;
                break;
            }
            nextSibling = nextSibling.nextElementSibling;
        }
        cat.style.display = hasVisibleCard ? 'block' : 'none';
    });
}
</script>
</body></html>
