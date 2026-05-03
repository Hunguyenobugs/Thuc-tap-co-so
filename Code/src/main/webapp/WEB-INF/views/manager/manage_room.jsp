<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Quản lý phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/manager_header.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>🚪 Quản lý <span>phòng</span></h1></div></div>
    <c:if test="${param.msg != null}"><div class="alert alert-success">✅ Thao tác thành công!</div></c:if>
    <c:if test="${param.error == 'has_booking'}"><div class="alert alert-danger">⚠️ Không thể xóa: phòng đang có phiếu đặt</div></c:if>

    <div style="display: flex; gap: 16px; width: 100%; margin-bottom: 20px;">
        <form method="get" action="${pageContext.request.contextPath}/manager/room" style="display: flex; gap: 16px; flex: 1; margin: 0;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm số phòng..." value="${keyword}" style="flex: 1; max-width: none;">
            <button type="submit" class="btn btn-primary" style="flex-shrink: 0;">🔍 Tìm kiếm</button>
        </form>
        <a href="${pageContext.request.contextPath}/manager/room?action=add" class="btn btn-primary" style="flex-shrink: 0;">➕ Thêm phòng</a>
    </div>

    <c:choose>
        <c:when test="${not empty results}">
            <c:set var="list" value="${results}"/>
        </c:when>
        <c:otherwise>
            <c:set var="list" value="${rooms}"/>
        </c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${empty list}"><div class="no-data">Chưa có phòng nào</div></c:when>
        <c:otherwise>
            <div class="table-container"><table>
                <thead><tr><th>Số phòng</th><th>Tầng</th><th>Loại</th><th>Trạng thái</th><th>Mô tả</th><th></th></tr></thead>
                <tbody>
                <c:forEach var="r" items="${list}">
                    <tr>
                        <td><strong>${r.roomNumber}</strong></td>
                        <td>${r.floor}</td>
                        <td>${r.roomTypeName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${r.status=='Trống'}"><span class="badge badge-success">${r.status}</span></c:when>
                                <c:when test="${r.status=='Đang sử dụng'}"><span class="badge badge-warning">${r.status}</span></c:when>
                                <c:otherwise><span class="badge badge-info">${r.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="fs-sm">${r.description}</td>
                        <td><div class="btn-group">
                            <a href="${pageContext.request.contextPath}/manager/room?action=edit&id=${r.id}" class="btn btn-outline btn-sm">✏️</a>
                            <button onclick="confirmDelete('${pageContext.request.contextPath}/manager/room?action=delete&id=${r.id}','Phòng ${r.roomNumber}')" class="btn btn-danger btn-sm">🗑️</button>
                        </div></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table></div>
        </c:otherwise>
    </c:choose>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
