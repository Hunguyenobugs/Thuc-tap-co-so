<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="user" value="${sessionScope.currentUser}"/>
<c:set var="role" value="${user.role}"/>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<aside class="sidebar">
    <nav class="sidebar-nav">
        <c:if test="${role == 'ADMIN'}">
            <div class="nav-divider">Quản trị</div>
            <a href="${base}/admin/home">📊 Trang chủ</a>
            <a href="${base}/admin/user?action=manage">👤 Quản lý tài khoản</a>
        </c:if>
        <c:if test="${role == 'MANAGER'}">
            <div class="nav-divider">Quản lý</div>
            <a href="${base}/manager/home">📊 Trang chủ</a>
            <a href="${base}/manager/hotel">🏨 Thông tin KS</a>
            <a href="${base}/manager/roomtype?action=manage">🏷️ Loại phòng</a>
            <a href="${base}/manager/room?action=manage">🚪 Phòng</a>
            <a href="${base}/manager/service?action=manage">🛎️ Dịch vụ</a>
            <a href="${base}/manager/staff?action=manage">👥 Nhân viên</a>
            <a href="${base}/manager/invoice?action=list">💰 Thanh toán</a>
            <a href="${base}/manager/report">📈 Báo cáo</a>
        </c:if>
        <c:if test="${role == 'STAFF'}">
            <div class="nav-divider">Nghiệp vụ</div>
            <a href="${base}/staff/home">📊 Trang chủ</a>
            <a href="${base}/staff/booking?action=searchRoom">📝 Đặt phòng</a>
            <a href="${base}/staff/cancel?action=search">❌ Hủy đặt phòng</a>
            <a href="${base}/staff/manageBooking?action=search">✏️ Sửa phiếu đặt</a>
            <a href="${base}/staff/checkin?action=search">🔑 Check-in</a>
            <a href="${base}/staff/serviceUpdate?action=search">🛎️ Cập nhật DV</a>
            <a href="${base}/staff/checkout?action=search">🚪 Check-out</a>
        </c:if>
    </nav>
</aside>
