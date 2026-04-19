<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Tìm khách hàng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>📝 Đặt phòng - <span>Tìm khách hàng</span></h1><div class="breadcrumb"><span>Bước 2: Chọn khách hàng</span></div></div></div>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/staff/booking">
        <input type="hidden" name="action" value="searchCustomer">
        <input type="text" name="q" class="form-control" placeholder="Nhập số CCCD khách hàng..." value="${keyword}">
        <button type="submit" class="btn btn-primary">🔍 Tìm</button>
        <a href="${pageContext.request.contextPath}/staff/booking?action=addCustomer" class="btn btn-success">➕ Khách mới</a>
    </form>
    <c:if test="${customers != null}">
        <c:choose><c:when test="${empty customers}"><div class="no-data">Không tìm thấy khách hàng. <a href="${pageContext.request.contextPath}/staff/booking?action=addCustomer">Thêm khách mới</a></div></c:when>
            <c:otherwise><div class="table-container"><table><thead><tr><th>CCCD</th><th>Họ tên</th><th>SĐT</th><th>Email</th><th></th></tr></thead><tbody>
                <c:forEach var="c" items="${customers}"><tr><td>${c.idCard}</td><td><strong>${c.fullName}</strong></td><td>${c.phone}</td><td>${c.email}</td>
                    <td><a href="${pageContext.request.contextPath}/staff/booking?action=confirm&customerId=${c.id}" class="btn btn-primary btn-sm">Chọn →</a></td></tr></c:forEach>
            </tbody></table></div></c:otherwise>
        </c:choose>
    </c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
