<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Quản lý nhân viên</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/manager_header.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>👥 Quản lý <span>nhân viên</span></h1></div></div>
    <c:if test="${param.msg != null}"><div class="alert alert-success">✅ Thao tác thành công!</div></c:if>
    <c:if test="${param.error == 'has_data'}"><div class="alert alert-danger">⚠️ Không thể xóa: nhân viên có dữ liệu liên quan</div></c:if>

    <div style="display: flex; gap: 16px; width: 100%; margin-bottom: 20px;">
        <form method="get" action="${pageContext.request.contextPath}/manager/staff" style="display: flex; gap: 16px; flex: 1; margin: 0;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm tên, mã NV hoặc username..." value="${keyword}" style="flex: 1; max-width: none;">
            <button type="submit" class="btn btn-primary" style="flex-shrink: 0;">🔍 Tìm kiếm</button>
        </form>
        <a href="${pageContext.request.contextPath}/manager/staff?action=add" class="btn btn-primary" style="flex-shrink: 0;">➕ Thêm nhân viên</a>
    </div>

    <c:choose>
        <c:when test="${not empty results}"><c:set var="list" value="${results}"/></c:when>
        <c:otherwise><c:set var="list" value="${staff}"/></c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${empty list}"><div class="no-data">Chưa có nhân viên nào</div></c:when>
        <c:otherwise>
            <div class="table-container"><table>
                <thead><tr><th>Mã NV</th><th>Họ tên</th><th>Username</th><th>Vai trò</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                <tbody>
                <c:forEach var="u" items="${list}">
                    <tr>
                        <td>${u.employeeCode}</td>
                        <td><strong>${u.fullName}</strong></td>
                        <td>${u.username}</td>
                        <td>
                            <c:choose>
                                <c:when test="${u.role=='ADMIN'}"><span class="badge badge-danger">${u.role}</span></c:when>
                                <c:when test="${u.role=='MANAGER'}"><span class="badge badge-warning">${u.role}</span></c:when>
                                <c:otherwise><span class="badge badge-info">${u.role}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.status=='active'}"><span class="badge badge-success">Hoạt động</span></c:when>
                                <c:otherwise><span class="badge badge-danger">Khóa</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><div class="btn-group">
                            <a href="${pageContext.request.contextPath}/manager/staff?action=detail&id=${u.id}" class="btn btn-outline btn-sm" title="Xem chi tiết">👁️</a>
                            <a href="${pageContext.request.contextPath}/manager/staff?action=edit&id=${u.id}" class="btn btn-outline btn-sm" title="Sửa">✏️</a>
                        </div></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table></div>
        </c:otherwise>
    </c:choose>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
