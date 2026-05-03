<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Sửa tài khoản</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout admin-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/admin_header.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar">
            <div><h1>✏️ Sửa <span>tài khoản</span></h1></div>
        </div>
        
        <c:if test="${error != null}">
            <div class="alert alert-danger">⚠️ ${error}</div>
        </c:if>

        <div class="card" style="max-width:700px; margin: 0 auto;">
            <form method="post" action="${pageContext.request.contextPath}/admin/user">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${editUser.id}">
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Họ tên <span class="required">*</span></label>
                        <input type="text" name="fullName" class="form-control" value="${editUser.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label>Mã NV <span class="required">*</span></label>
                        <input type="text" name="employeeCode" class="form-control" value="${editUser.employeeCode}" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Username <span class="required">*</span></label>
                        <input type="text" name="username" class="form-control" value="${editUser.username}" required>
                    </div>
                    <div class="form-group">
                        <label>Vai trò</label>
                        <select name="role" class="form-control">
                            <option value="STAFF" ${editUser.role == 'STAFF' ? 'selected' : ''}>Nhân viên</option>
                            <option value="MANAGER" ${editUser.role == 'MANAGER' ? 'selected' : ''}>Quản lý</option>
                            <option value="ADMIN" ${editUser.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu (Để trống nếu không đổi)</label>
                        <input type="password" name="password" class="form-control" placeholder="Mật khẩu mới">
                    </div>
                    <div class="form-group">
                        <label>Xác nhận MK</label>
                        <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Email <span class="required">*</span></label>
                        <input type="email" name="email" class="form-control" value="${editUser.email}" required>
                    </div>
                    <div class="form-group">
                        <label>SĐT <span class="required">*</span></label>
                        <input type="tel" name="phone" class="form-control" value="${editUser.phone}" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Ngày vào làm <span class="required">*</span></label>
                        <input type="date" name="joinDate" class="form-control" value="${editUser.joinDate}" required>
                    </div>
                    <div class="form-group">
                        <label>Mô tả</label>
                        <input type="text" name="description" class="form-control" value="${editUser.description}">
                    </div>
                </div>

                <input type="hidden" name="status" value="${editUser.status}">

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">💾 Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/admin/user?action=manage" class="btn btn-outline">← Quay lại</a>
                </div>
            </form>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>