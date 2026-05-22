<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Thông tin cá nhân - ${applicationScope.hotelInfo.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <div class="topbar" style="margin-bottom: 24px;">
        <div><h1>👤 Thông tin <span>cá nhân</span></h1></div>
    </div>
    
    <div style="max-width:600px; margin: 0 auto;">
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success">✅ Cập nhật thông tin cá nhân thành công!</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">⚠️ ${error}</div>
        </c:if>
 
        <div class="card">
            <div style="text-align: center; margin-bottom: 24px;">
                <div class="avatar" style="width: 80px; height: 80px; font-size: 32px; margin: 0 auto 16px;">
                    ${customer.fullName != null ? customer.fullName.substring(0, 1).toUpperCase() : '👤'}
                </div>
                <h3>${customer.fullName}</h3>
                <p class="text-muted">Khách hàng • CCCD: ${not empty customer.idCard ? customer.idCard : 'Chưa cập nhật'}</p>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/customerAuth">
                <input type="hidden" name="action" value="editProfile">
                
                <div class="form-group">
                    <label>Họ và tên <span class="required">*</span></label>
                    <input type="text" name="fullName" class="form-control" value="${customer.fullName}" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Số CCCD / Hộ chiếu</label>
                        <input type="text" name="idCard" class="form-control" value="${customer.idCard}">
                    </div>
                    <div class="form-group">
                        <label>Giới tính</label>
                        <select name="gender" class="form-control">
                            <option value="">--Chọn--</option>
                            <option value="Nam" ${customer.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${customer.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${customer.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Email <span class="required">*</span></label>
                        <input type="email" name="email" class="form-control" value="${customer.email}" required>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại <span class="required">*</span></label>
                        <input type="tel" name="phone" class="form-control" value="${customer.phone}" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Ngày sinh</label>
                        <input type="date" name="birthDate" class="form-control" value="${customer.birthDate}">
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <input type="text" name="address" class="form-control" value="${customer.address}">
                    </div>
                </div>
                
                <div class="btn-group" style="margin-top: 24px; justify-content: center;">
                    <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline">← Hủy</a>
                </div>
            </form>
        </div>
    </div>
</section>
<footer class="customer-footer">© 2025 ${applicationScope.hotelInfo.name}</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
