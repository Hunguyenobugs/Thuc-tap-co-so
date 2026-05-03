<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Quản lý loại phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/manager_header.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>🏷️ Quản lý <span>loại phòng</span></h1></div></div>
    <c:if test="${param.msg != null}"><div class="alert alert-success">✅ Thao tác thành công!</div></c:if>
    <c:if test="${param.error == 'has_rooms'}"><div class="alert alert-danger">⚠️ Không thể xóa: loại phòng này đang có phòng liên kết</div></c:if>

    <div style="display: flex; gap: 16px; width: 100%; margin-bottom: 20px;">
        <form method="get" action="${pageContext.request.contextPath}/manager/roomtype" style="display: flex; gap: 16px; flex: 1; margin: 0;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm tên loại phòng..." value="${keyword}" style="flex: 1; max-width: none;">
            <button type="submit" class="btn btn-primary" style="flex-shrink: 0;">🔍 Tìm kiếm</button>
        </form>
        <a href="${pageContext.request.contextPath}/manager/roomtype?action=add" class="btn btn-primary" style="flex-shrink: 0;">➕ Thêm loại phòng</a>
    </div>

    <c:choose>
        <c:when test="${not empty results}"><c:set var="list" value="${results}"/></c:when>
        <c:otherwise><c:set var="list" value="${roomTypes}"/></c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${empty list}"><div class="no-data">Chưa có loại phòng nào</div></c:when>
        <c:otherwise>
            <div class="table-container"><table>
                <thead><tr><th>ID</th><th>Tên</th><th>Sức chứa</th><th>Diện tích</th><th>Giá/đêm</th><th>Tiện nghi</th><th></th></tr></thead>
                <tbody>
                <c:forEach var="rt" items="${list}">
                    <tr>
                        <td>${rt.id}</td>
                        <td><strong>${rt.name}</strong></td>
                        <td>${rt.capacity}</td>
                        <td>${rt.area}</td>
                        <td class="text-accent fw-bold"><fmt:formatNumber value="${rt.basePrice}" pattern="#,##0"/>₫</td>
                        <td class="fs-sm">${rt.amenities}</td>
                        <td><div class="btn-group">
                            <a href="${pageContext.request.contextPath}/manager/roomtype?action=edit&id=${rt.id}" class="btn btn-outline btn-sm">✏️ Sửa</a>
                            <button onclick="confirmDelete('${pageContext.request.contextPath}/manager/roomtype?action=delete&id=${rt.id}','${rt.name}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                        </div></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table></div>
        </c:otherwise>
    </c:choose>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
