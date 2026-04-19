<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Tìm tài khoản</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>🔍 Tìm <span>tài khoản</span></h1></div></div>
    <% if ("has_data".equals(request.getParameter("error"))) { %><div class="alert alert-danger">⚠️ Không thể xóa: tài khoản có dữ liệu liên quan</div><% } %>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/admin/user"><input type="hidden" name="action" value="search">
        <input type="text" name="keyword" class="form-control" placeholder="Nhập tên, mã NV hoặc username..." value="${keyword}"><button type="submit" class="btn btn-primary">🔍 Tìm</button></form>
    <c:if test="${results != null}"><c:choose><c:when test="${empty results}"><div class="no-data">Không tìm thấy</div></c:when><c:otherwise>
        <div class="table-container"><table><thead><tr><th>Mã NV</th><th>Họ tên</th><th>Username</th><th>Vai trò</th><th>Trạng thái</th><th></th></tr></thead><tbody>
        <c:forEach var="u" items="${results}"><tr><td>${u.employeeCode}</td><td><strong>${u.fullName}</strong></td><td>${u.username}</td>
            <td><c:choose><c:when test="${u.role=='ADMIN'}"><span class="badge badge-danger">${u.role}</span></c:when><c:when test="${u.role=='MANAGER'}"><span class="badge badge-warning">${u.role}</span></c:when><c:otherwise><span class="badge badge-info">${u.role}</span></c:otherwise></c:choose></td>
            <td><c:choose><c:when test="${u.status=='active'}"><span class="badge badge-success">Hoạt động</span></c:when><c:otherwise><span class="badge badge-danger">Khóa</span></c:otherwise></c:choose></td>
            <td><div class="btn-group"><a href="${pageContext.request.contextPath}/admin/user?action=edit&id=${u.id}" class="btn btn-outline btn-sm">✏️</a>
                <button onclick="confirmDelete('${pageContext.request.contextPath}/admin/user?action=delete&id=${u.id}','${u.fullName}')" class="btn btn-danger btn-sm">🗑️</button></div></td></tr></c:forEach>
        </tbody></table></div></c:otherwise></c:choose></c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
