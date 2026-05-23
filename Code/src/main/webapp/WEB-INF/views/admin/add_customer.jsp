<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Thêm tài khoản khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="layout admin-layout">
        <jsp:include page="../components/sidebar.jsp" />
        <jsp:include page="../components/admin_header.jsp" />
        <main class="main-content fade-in">
            <div class="topbar">
                <div>
                    <h1>Thêm <span>tài khoản khách hàng</span></h1>
                </div>
            </div>

            <c:if test="${error != null}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="card" style="max-width:700px; margin: 0 auto;">
                <form method="post" action="${pageContext.request.contextPath}/admin/customer">
                    <input type="hidden" name="action" value="insert">

                    <div class="form-row">
                        <div class="form-group">
                            <label>Họ tên <span class="required">*</span></label>
                            <input type="text" name="fullName" class="form-control"
                                value="${inputCustomer != null ? inputCustomer.fullName : ''}" required>
                        </div>
                        <div class="form-group">
                            <label>Loại giấy tờ <span class="required">*</span></label>
                            <select name="idType" class="form-control">
                                <option value="CCCD" ${inputCustomer != null && inputCustomer.idType == 'CCCD' ? 'selected' : ''}>CCCD</option>
                                <option value="Hộ chiếu" ${inputCustomer != null && inputCustomer.idType == 'Hộ chiếu' ? 'selected' : ''}>Hộ chiếu</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Số giấy tờ (CCCD/Hộ chiếu) <span class="required">*</span></label>
                            <input type="text" name="idCard" class="form-control"
                                value="${inputCustomer != null ? inputCustomer.idCard : ''}" required>
                        </div>
                        <div class="form-group">
                            <label>Quốc tịch</label>
                            <input type="text" name="nationality" class="form-control"
                                value="${inputCustomer != null ? inputCustomer.nationality : 'Việt Nam'}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Ngày sinh</label>
                            <input type="date" name="birthDate" class="form-control"
                                value="${inputCustomer != null ? inputCustomer.birthDate : ''}">
                        </div>
                        <div class="form-group">
                            <label>Giới tính</label>
                            <select name="gender" class="form-control">
                                <option value="Nam" ${inputCustomer != null && inputCustomer.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${inputCustomer != null && inputCustomer.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                <option value="Khác" ${inputCustomer != null && inputCustomer.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>SĐT <span class="required">*</span></label>
                            <input type="tel" name="phone" class="form-control"
                                value="${inputCustomer != null ? inputCustomer.phone : ''}" required>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control"
                                value="${inputCustomer != null ? inputCustomer.email : ''}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <input type="text" name="address" class="form-control"
                            value="${inputCustomer != null ? inputCustomer.address : ''}">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Mật khẩu đăng nhập <span class="required">*</span></label>
                            <input type="password" name="password" class="form-control" required placeholder="Nhập mật khẩu">
                        </div>
                        <div class="form-group">
                            <label>Xác nhận MK <span class="required">*</span></label>
                            <input type="password" name="confirmPassword" class="form-control" required placeholder="Xác nhận mật khẩu">
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Lưu</button>
                        <a href="${pageContext.request.contextPath}/admin/customer?action=manage"
                            class="btn btn-outline">← Quay lại</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
