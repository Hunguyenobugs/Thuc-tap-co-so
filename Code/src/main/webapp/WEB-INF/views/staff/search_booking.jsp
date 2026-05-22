<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Tìm phiếu đặt</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Quản lý <span>phiếu đặt</span></h1></div></div>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/staff/manageBooking"><input type="hidden" name="action" value="search">
        <input type="text" name="q" class="form-control" placeholder="Nhập mã phiếu hoặc tên khách..." value="${keyword}"><button type="submit" class="btn btn-primary">🔍 Tìm</button></form>

    <c:if test="${results != null}"><c:choose><c:when test="${empty results}"><div class="no-data">Không tìm thấy</div></c:when><c:otherwise>
        <div class="table-container"><table><thead><tr>
            <th>Mã phiếu</th><th>Khách hàng</th><th>Số phòng</th><th>Ngày đặt</th><th>Trạng thái</th><th></th>
        </tr></thead><tbody>
        <c:forEach var="b" items="${results}"><tr>
            <td><strong>${b.code}</strong></td>
            <td>${b.customerName}</td>
            <td><span class="badge badge-primary">${b.roomCount} phòng</span></td>
            <td><fmt:formatDate value="${b.bookingDate}" pattern="HH:mm dd/MM/yyyy"/></td>
            <td>
                <c:choose>
                    <c:when test="${b.status=='Chờ xác nhận'}"><span class="badge badge-warning">${b.status}</span></c:when>
                    <c:when test="${b.status=='Chưa nhận phòng'}"><span class="badge badge-info">${b.status}</span></c:when>
                    <c:when test="${b.status=='Lưu trú một phần'}"><span class="badge badge-primary">${b.status}</span></c:when>
                    <c:when test="${b.status=='Đang lưu trú'}"><span class="badge badge-primary">${b.status}</span></c:when>
                    <c:when test="${b.status=='Đã trả phòng'}"><span class="badge badge-success">${b.status}</span></c:when>
                    <c:otherwise><span class="badge badge-danger">${b.status}</span></c:otherwise>
                </c:choose>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/staff/manageBooking?action=view&bookingId=${b.id}" class="btn btn-outline btn-sm">👁️ Xem</a>
                <c:if test="${b.status == 'Chờ xác nhận'}">
                    <form method="post" action="${pageContext.request.contextPath}/staff/manageBooking" style="display:inline;">
                        <input type="hidden" name="action" value="approve">
                        <input type="hidden" name="bookingId" value="${b.id}">
                        <button type="submit" class="btn btn-primary btn-sm" onclick="return confirm('Xác nhận duyệt phiếu này?');">✅ Duyệt</button>
                    </form>
                </c:if>
            </td>
        </tr></c:forEach>
        </tbody></table></div>
    </c:otherwise></c:choose></c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
