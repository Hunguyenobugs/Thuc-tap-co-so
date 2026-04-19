<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Check-in</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>🔑 <span>Check-in</span></h1></div></div>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/staff/checkin"><input type="hidden" name="action" value="search">
        <input type="text" name="q" class="form-control" placeholder="Nhập mã phiếu hoặc tên khách..." value="${keyword}"><button type="submit" class="btn btn-primary">🔍 Tìm</button></form>
    <c:if test="${results != null}"><c:choose><c:when test="${empty results}"><div class="no-data">Không có phiếu đặt nào cần check-in</div></c:when><c:otherwise>
        <div class="table-container"><table><thead><tr><th>Mã phiếu</th><th>Khách</th><th>Phòng</th><th>Check-in</th><th>Check-out</th><th></th></tr></thead><tbody>
        <c:forEach var="b" items="${results}"><tr><td><strong>${b.code}</strong></td><td>${b.customerName}</td><td>${b.roomTypeName} - ${b.roomNumber}</td><td>${b.checkIn}</td><td>${b.checkOut}</td>
            <td><a href="${pageContext.request.contextPath}/staff/checkin?action=confirm&bookingId=${b.id}" class="btn btn-success btn-sm">🔑 Check-in</a></td></tr></c:forEach>
        </tbody></table></div></c:otherwise></c:choose></c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
