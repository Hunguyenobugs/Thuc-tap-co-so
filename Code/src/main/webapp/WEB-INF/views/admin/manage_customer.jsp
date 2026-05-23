<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Quản lý tài khoản khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout admin-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/admin_header.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar">
            <div><h1>Quản lý <span>tài khoản khách hàng</span></h1></div>
        </div>

        <c:if test="${param.msg == 'add_success'}">
            <div class="alert alert-success">Thêm tài khoản khách hàng thành công!</div>
        </c:if>
        <c:if test="${param.msg == 'update_success'}">
            <div class="alert alert-success">Cập nhật tài khoản khách hàng thành công!</div>
        </c:if>
        <c:if test="${param.msg == 'delete_success'}">
            <div class="alert alert-success">Khóa tài khoản khách hàng thành công!</div>
        </c:if>
        <c:if test="${param.msg == 'restore_success'}">
            <div class="alert alert-success">Mở khóa tài khoản khách hàng thành công!</div>
        </c:if>

        <div style="display: flex; gap: 16px; width: 100%; margin-bottom: 20px;">
            <form method="get" action="${pageContext.request.contextPath}/admin/customer" style="display: flex; gap: 16px; flex: 1; margin: 0;">
                <input type="hidden" name="action" value="manage">
                <input type="text" name="keyword" class="form-control" placeholder="Nhập tên, số điện thoại hoặc CCCD..." value="${keyword}" style="flex: 1; max-width: none;">
                <button type="submit" class="btn btn-primary" style="flex-shrink: 0;">Tìm kiếm</button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/customer?action=add" class="btn btn-primary" style="flex-shrink: 0;">Thêm tài khoản khách hàng</a>
        </div>

        <c:if test="${results != null}">
            <c:choose>
                <c:when test="${empty results}">
                    <div class="no-data">Không tìm thấy khách hàng nào</div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table>
                            <thead>
                            <tr>
                                <th>Loại giấy tờ</th>
                                <th>Số giấy tờ (CCCD)</th>
                                <th>Họ tên</th>
                                <th>Quốc tịch</th>
                                <th>SĐT</th>
                                <th>Email</th>
                                <th>Giới tính</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="c" items="${results}">
                                <tr>
                                    <td><span class="badge badge-info">${c.idType}</span></td>
                                    <td>${c.idCard}</td>
                                    <td><strong>${c.fullName}</strong></td>
                                    <td>${c.nationality}</td>
                                    <td>${c.phone}</td>
                                    <td>${c.email}</td>
                                    <td>${c.gender}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${c.status == 'active'}"><span class="badge badge-success">Hoạt động</span></c:when>
                                            <c:otherwise><span class="badge badge-danger">Khóa</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="${pageContext.request.contextPath}/admin/customer?action=edit&id=${c.id}" class="btn btn-outline btn-sm" title="Sửa">Sửa</a>
                                            <c:choose>
                                                <c:when test="${c.status == 'active'}">
                                                    <button onclick="confirmDelete('${pageContext.request.contextPath}/admin/customer?action=delete&id=${c.id}','${c.fullName}')" class="btn btn-danger btn-sm" title="Khóa tài khoản">Khóa</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/customer?action=restore&id=${c.id}" class="btn btn-success btn-sm" title="Mở khóa tài khoản" onclick="return confirm('Bạn có chắc chắn muốn mở khóa tài khoản này không?');">Mở khóa</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
