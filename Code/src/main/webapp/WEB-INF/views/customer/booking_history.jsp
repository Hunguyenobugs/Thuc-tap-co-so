<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Lịch sử đặt phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <h2>Lịch sử đặt phòng</h2>
    <p class="section-desc">Quản lý các phiếu đặt phòng của bạn</p>
    <% if ("booking_success".equals(request.getParameter("msg"))) { %><div class="alert alert-success">✅ Đặt phòng thành công! Chúng tôi sẽ xác nhận sớm.</div><% } %>
    <% if ("cancel_success".equals(request.getParameter("msg"))) { %><div class="alert alert-success">✅ Hủy phiếu đặt thành công</div><% } %>
    <c:choose>
        <c:when test="${empty bookings}"><div class="no-data">Bạn chưa có phiếu đặt phòng nào</div></c:when>
        <c:otherwise>
            <div class="table-container">
                <table>
                    <thead><tr><th>Mã phiếu</th><th>Phòng</th><th>Nhận phòng</th><th>Trả phòng</th><th>Trạng thái</th><th></th></tr></thead>
                    <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td><strong>${b.code}</strong></td>
                            <td>${b.roomTypeName} - ${b.roomNumber}</td>
                            <td>${b.checkIn}</td>
                            <td>${b.checkOut}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.status=='Chờ xác nhận'}"><span class="badge badge-warning">${b.status}</span></c:when>
                                    <c:when test="${b.status=='Đã xác nhận'}"><span class="badge badge-info">${b.status}</span></c:when>
                                    <c:when test="${b.status=='Đang lưu trú'}"><span class="badge badge-primary">${b.status}</span></c:when>
                                    <c:when test="${b.status=='Đã trả phòng'}"><span class="badge badge-success">${b.status}</span></c:when>
                                    <c:when test="${b.status=='Đã hủy'}"><span class="badge badge-danger">${b.status}</span></c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${b.status=='Chờ xác nhận' || b.status=='Đã xác nhận'}">
                                    <a href="${pageContext.request.contextPath}/onlineCancel?bookingId=${b.id}" class="btn btn-danger btn-sm">Hủy</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
