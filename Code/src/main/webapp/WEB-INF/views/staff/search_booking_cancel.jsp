<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Hủy đặt phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>❌ Hủy <span>đặt phòng</span></h1></div></div>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/staff/cancel"><input type="hidden" name="action" value="search">
        <input type="text" name="q" class="form-control" placeholder="Nhập mã phiếu hoặc tên khách..." value="${keyword}"><button type="submit" class="btn btn-primary">🔍 Tìm</button></form>
    <c:if test="${results != null}"><c:choose><c:when test="${empty results}"><div class="no-data">Không tìm thấy phiếu đặt</div></c:when><c:otherwise>
        <div class="table-container"><table><thead><tr><th>Mã phiếu</th><th>Khách</th><th>Phòng</th><th>Ngày nhận phòng</th><th>Trạng thái</th><th></th></tr></thead><tbody>
        <c:forEach var="b" items="${results}"><tr><td><strong>${b.code}</strong></td><td>${b.customerName}</td><td>${b.roomNumber}</td>
            <td><fmt:parseDate value="${b.checkIn}" pattern="yyyy-MM-dd HH:mm:ss" var="pCI"/><fmt:formatDate value="${pCI}" pattern="HH:mm dd/MM/yyyy"/></td>
            <td>
                <c:choose>
                    <c:when test="${b.status=='Chờ xác nhận'}"><span class="badge badge-warning">${b.status}</span></c:when>
                    <c:when test="${b.status=='Đã xác nhận'}"><span class="badge badge-info">${b.status}</span></c:when>
                    <c:when test="${b.status=='Đang lưu trú'}"><span class="badge badge-primary">${b.status}</span></c:when>
                    <c:when test="${b.status=='Đã trả phòng'}"><span class="badge badge-success">${b.status}</span></c:when>
                    <c:otherwise><span class="badge badge-danger">${b.status}</span></c:otherwise>
                </c:choose>
            </td>
            <td><a href="${pageContext.request.contextPath}/staff/cancel?action=confirm&bookingId=${b.id}" class="btn btn-danger btn-sm">Hủy phiếu</a></td></tr></c:forEach>
        </tbody></table></div></c:otherwise></c:choose></c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
