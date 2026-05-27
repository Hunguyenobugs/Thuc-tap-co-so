<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Báo cáo doanh thu</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>`n    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>Báo cáo <span>doanh thu</span></h1></div></div>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/manager/report">
        <label class="fs-sm text-muted" style="white-space:nowrap;padding:10px 0;">Kỳ báo cáo (YYYY-MM)</label>
        <input type="month" name="period" class="form-control" value="${period}" style="max-width:200px;">
        <button type="submit" class="btn btn-primary">Xem báo cáo</button>
    </form>
    <c:if test="${revenue != null}">
        <div class="stat-grid">
            <div class="stat-card"><div class="stat-label">Tổng lượt đặt</div><div class="stat-value">${revenue.totalBookings}</div><div class="stat-desc">phiếu đặt</div></div>
            <div class="stat-card green"><div class="stat-label">Số phòng đã đặt</div><div class="stat-value">${revenue.rentedRoomsCount} / ${revenue.totalRoomsCount}</div><div class="stat-desc">phòng</div></div>
            <div class="stat-card cyan"><div class="stat-label">Doanh thu phòng</div><div class="stat-value"><fmt:formatNumber value="${revenue.roomRevenue}" pattern="#,##0"/>₫</div></div>
            <div class="stat-card orange"><div class="stat-label">Doanh thu DV</div><div class="stat-value"><fmt:formatNumber value="${revenue.serviceRevenue}" pattern="#,##0"/>₫</div></div>
        </div>
        <div class="card mb-3"><div class="card-header"><h3>Tổng doanh thu</h3></div>
            <div style="text-align:center;padding:20px;"><span style="font-size:36px;font-weight:700;color:var(--accent);"><fmt:formatNumber value="${revenue.totalRevenue}" pattern="#,##0"/>₫</span></div>
        </div>
    </c:if>
    <c:if test="${roomStats != null && !roomStats.isEmpty()}">
        <div class="card mb-3"><div class="card-header"><h3>Doanh thu theo phòng</h3></div>
            <div class="table-container"><table><thead><tr><th>Số phòng</th><th>Loại phòng</th><th>Số ngày có khách ở</th><th>Tổng tiền thu được</th></tr></thead><tbody>
            <c:forEach var="rs" items="${roomStats}"><tr><td><strong>${rs.roomNumber}</strong></td><td>${rs.roomTypeName}</td><td>${rs.occupiedDays} ngày</td>
                <td class="fw-bold"><fmt:formatNumber value="${rs.totalRevenue}" pattern="#,##0"/>₫</td></tr></c:forEach>
            </tbody></table></div></div>
    </c:if>
    <c:if test="${serviceStats != null && !serviceStats.isEmpty()}">
        <div class="card"><div class="card-header"><h3>Doanh thu theo dịch vụ</h3></div>
            <div class="table-container"><table><thead><tr><th>Tên dịch vụ</th><th>Danh mục</th><th>Đơn vị</th><th>Số lượt sử dụng</th><th>Số tiền thu được</th></tr></thead><tbody>
            <c:forEach var="ss" items="${serviceStats}"><tr><td><strong>${ss.serviceName}</strong></td><td>${ss.category}</td><td>${ss.unit}</td><td><fmt:formatNumber value="${ss.totalQuantity}" pattern="#,##0.##"/></td>
                <td class="fw-bold"><fmt:formatNumber value="${ss.totalRevenue}" pattern="#,##0"/>₫</td></tr></c:forEach>
            </tbody></table></div></div>
    </c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
