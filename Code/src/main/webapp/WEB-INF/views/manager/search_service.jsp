<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Tìm dịch vụ</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>🔍 Tìm <span>dịch vụ</span></h1></div></div>
    <% if ("in_use".equals(request.getParameter("error"))) { %><div class="alert alert-danger">⚠️ Không thể xóa: dịch vụ đã được sử dụng trong phiếu đặt</div><% } %>
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/manager/service"><input type="hidden" name="action" value="search">
        <input type="text" name="keyword" class="form-control" placeholder="Nhập tên dịch vụ..." value="${keyword}"><button type="submit" class="btn btn-primary">🔍 Tìm</button></form>
    <c:if test="${results != null}"><c:choose><c:when test="${empty results}"><div class="no-data">Không tìm thấy</div></c:when><c:otherwise>
        <div class="table-container"><table><thead><tr><th>Tên</th><th>Danh mục</th><th>Đơn vị</th><th>Đơn giá</th><th></th></tr></thead><tbody>
        <c:forEach var="s" items="${results}"><tr><td><strong>${s.name}</strong></td><td><span class="badge badge-info">${s.category}</span></td><td>${s.unit}</td><td class="text-accent fw-bold"><fmt:formatNumber value="${s.price}" pattern="#,##0"/>₫</td>
            <td><div class="btn-group"><a href="${pageContext.request.contextPath}/manager/service?action=edit&id=${s.id}" class="btn btn-outline btn-sm">✏️</a>
                <button onclick="confirmDelete('${pageContext.request.contextPath}/manager/service?action=delete&id=${s.id}','${s.name}')" class="btn btn-danger btn-sm">🗑️</button></div></td></tr></c:forEach>
        </tbody></table></div></c:otherwise></c:choose></c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
