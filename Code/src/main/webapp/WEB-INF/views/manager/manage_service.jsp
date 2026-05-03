<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Quản lý dịch vụ</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/manager_header.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>🛎️ Quản lý <span>dịch vụ</span></h1></div></div>
    <c:if test="${param.msg != null}"><div class="alert alert-success">✅ Thao tác thành công!</div></c:if>
    <c:if test="${param.error == 'in_use'}"><div class="alert alert-danger">⚠️ Không thể xóa: dịch vụ đã được sử dụng trong phiếu đặt</div></c:if>

    <div style="display: flex; gap: 16px; width: 100%; margin-bottom: 20px;">
        <form method="get" action="${pageContext.request.contextPath}/manager/service" style="display: flex; gap: 16px; flex: 1; margin: 0;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm tên dịch vụ..." value="${keyword}" style="flex: 1; max-width: none;">
            <button type="submit" class="btn btn-primary" style="flex-shrink: 0;">🔍 Tìm kiếm</button>
        </form>
        <a href="${pageContext.request.contextPath}/manager/service?action=add" class="btn btn-primary" style="flex-shrink: 0;">➕ Thêm dịch vụ</a>
    </div>

    <c:choose>
        <c:when test="${not empty results}"><c:set var="list" value="${results}"/></c:when>
        <c:otherwise><c:set var="list" value="${services}"/></c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${empty list}"><div class="no-data">Chưa có dịch vụ nào</div></c:when>
        <c:otherwise>
            <div class="table-container"><table>
                <thead><tr><th>Tên</th><th>Danh mục</th><th>Đơn vị</th><th>Đơn giá</th><th></th></tr></thead>
                <tbody>
                <c:forEach var="s" items="${list}">
                    <tr>
                        <td><strong>${s.name}</strong></td>
                        <td><span class="badge badge-info">${s.category}</span></td>
                        <td>${s.unit}</td>
                        <td class="text-accent fw-bold"><fmt:formatNumber value="${s.price}" pattern="#,##0"/>₫</td>
                        <td><div class="btn-group">
                            <a href="${pageContext.request.contextPath}/manager/service?action=edit&id=${s.id}" class="btn btn-outline btn-sm">✏️</a>
                            <button onclick="confirmDelete('${pageContext.request.contextPath}/manager/service?action=delete&id=${s.id}','${s.name}')" class="btn btn-danger btn-sm">🗑️</button>
                        </div></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table></div>
        </c:otherwise>
    </c:choose>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
