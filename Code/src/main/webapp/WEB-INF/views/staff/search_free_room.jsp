<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Tìm phòng trống</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>📝 Đặt phòng - <span>Tìm phòng trống</span></h1><div class="breadcrumb"><span>Bước 1: Chọn phòng</span></div></div></div>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/staff/booking">
        <input type="hidden" name="action" value="searchRoom">
        <input type="date" name="checkIn" class="form-control" value="${checkIn}" required placeholder="Ngày nhận">
        <input type="date" name="checkOut" class="form-control" value="${checkOut}" required placeholder="Ngày trả">
        <select name="roomTypeId" class="form-control" required>
            <option value="">-- Chọn loại phòng --</option>
            <c:forEach var="rt" items="${roomTypes}"><option value="${rt.id}" ${selectedType==rt.id.toString()?'selected':''}>${rt.name} - <fmt:formatNumber value="${rt.basePrice}" pattern="#,##0"/>₫/đêm</option></c:forEach>
        </select>
        <button type="submit" class="btn btn-primary">🔍 Tìm</button>
    </form>
    <c:if test="${rooms != null}">
        <c:choose><c:when test="${empty rooms}"><div class="no-data">Không có phòng trống trong khoảng thời gian này</div></c:when>
            <c:otherwise>
                <div class="table-container"><table><thead><tr><th>Số phòng</th><th>Tầng</th><th>Loại phòng</th><th>Giá/đêm</th><th></th></tr></thead><tbody>
                <c:forEach var="r" items="${rooms}"><tr><td><strong>${r.roomNumber}</strong></td><td>Tầng ${r.floor}</td><td>${r.roomTypeName}</td><td class="text-accent fw-bold">${r.basePrice != null ? r.basePrice : ''}₫</td>
                    <td><form method="post" action="${pageContext.request.contextPath}/staff/booking" style="display:inline;">
                        <input type="hidden" name="action" value="saveCheckIn"><input type="hidden" name="roomId" value="${r.id}"><input type="hidden" name="checkIn" value="${checkIn}"><input type="hidden" name="checkOut" value="${checkOut}">
                        <button type="submit" class="btn btn-primary btn-sm">Chọn phòng →</button></form></td></tr></c:forEach>
                </tbody></table></div>
            </c:otherwise>
        </c:choose>
    </c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
