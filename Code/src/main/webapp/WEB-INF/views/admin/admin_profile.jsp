<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="user" value="${sessionScope.currentUser}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Đổi thông tin cá nhân</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout admin-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/admin_header.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar">
            <div><h1>👤 Thông tin <span>cá nhân</span></h1></div>
        </div>
        
        <c:if test="${param.msg == 'profile_updated'}">
            <div class="alert alert-success">✅ Cập nhật thông tin thành công!</div>
        </c:if>

        <div class="card" style="max-width:600px; margin: 0 auto;">
            <div style="text-align: center; margin-bottom: 24px;">
                <div class="avatar" style="width: 80px; height: 80px; font-size: 32px; margin: 0 auto 16px;">
                    <c:choose>
                        <c:when test="${not empty user.avatarUrl}">
                            <img src="${pageContext.request.contextPath}${user.avatarUrl}" alt="Avatar" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            ${user.fullName.substring(0, 1).toUpperCase()}
                        </c:otherwise>
                    </c:choose>
                </div>
                <h3>${user.username}</h3>
                <p class="text-muted">${user.role} • Mã NV: ${user.employeeCode}</p>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/auth" enctype="multipart/form-data">
                <input type="hidden" name="action" value="updateProfile">
                
                <div class="form-group">
                    <label>Ảnh đại diện (Avatar)</label>
                    <input type="file" name="avatarFile" class="form-control" accept="image/*">
                </div>
                
                <div class="form-group">
                    <label>Họ tên <span class="required">*</span></label>
                    <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" value="${user.email}">
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="tel" name="phone" class="form-control" value="${user.phone}">
                </div>

                <div class="form-group">
                    <label>Mô tả bản thân</label>
                    <textarea name="description" class="form-control" rows="3">${user.description}</textarea>
                </div>

                <div class="btn-group" style="margin-top: 24px; justify-content: center;">
                    <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                    <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-outline">← Hủy</a>
                </div>
            </form>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
