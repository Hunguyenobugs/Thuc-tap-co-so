<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Thêm tài khoản</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar">
            <div><h1>➕ Thêm <span>tài khoản</span></h1></div>
        </div>
        
        <c:if test="${error != null}">
            <div class="alert alert-danger">⚠️ ${error}</div>
        </c:if>

        <div class="card" style="max-width:700px;">
            <form method="post" action="${pageContext.request.contextPath}/admin/user">
                <input type="hidden" name="action" value="insert">
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Họ tên <span class="required">*</span></label>
                        <input type="text" name="fullName" class="form-control" value="${inputUser != null ? inputUser.fullName : ''}" required>
                    </div>
                    <div class="form-group">
                        <label>Mã NV</label>
                        <input type="text" name="employeeCode" class="form-control" value="${inputUser != null ? inputUser.employeeCode : ''}">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Username <span class="required">*</span></label>
                        <input type="text" name="username" class="form-control" value="${inputUser != null ? inputUser.username : ''}" required>
                    </div>
                    <div class="form-group">
                        <label>Vai trò</label>
                        <select name="role" class="form-control">
                            <option value="STAFF" ${inputUser != null && inputUser.role == 'STAFF' ? 'selected' : ''}>Nhân viên</option>
                            <option value="MANAGER" ${inputUser != null && inputUser.role == 'MANAGER' ? 'selected' : ''}>Quản lý</option>
                            <option value="ADMIN" ${inputUser != null && inputUser.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu <span class="required">*</span></label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Xác nhận MK <span class="required">*</span></label>
                        <input type="password" name="confirmPassword" class="form-control" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" class="form-control" value="${inputUser != null ? inputUser.email : ''}">
                    </div>
                    <div class="form-group">
                        <label>SĐT</label>
                        <input type="tel" name="phone" class="form-control" value="${inputUser != null ? inputUser.phone : ''}">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Ngày vào làm</label>
                        <input type="date" name="joinDate" class="form-control" value="${inputUser != null ? inputUser.joinDate : ''}">
                    </div>
                    <div class="form-group">
                        <label>Mô tả</label>
                        <input type="text" name="description" class="form-control" value="${inputUser != null ? inputUser.description : ''}">
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">💾 Lưu</button>
                    <a href="${pageContext.request.contextPath}/admin/user?action=manage" class="btn btn-outline">← Quay lại</a>
                </div>
            </form>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
