<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Lịch sử đặt phòng - ${applicationScope.hotelInfo.name}</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <h2>Lịch sử đặt phòng</h2>
    <p class="section-desc">Quản lý các phiếu đặt phòng của bạn</p>
    <% if ("booking_success".equals(request.getParameter("msg"))) { %><div class="alert alert-success">Đặt phòng thành công! Mã phiếu: <strong><%= request.getParameter("code") != null ? request.getParameter("code") : "" %></strong></div><% } %>
    <% if ("cancel_success".equals(request.getParameter("msg"))) { %><div class="alert alert-success">Hủy phiếu đặt thành công</div><% } %>
    <% if ("cancel_room_success".equals(request.getParameter("msg"))) { %><div class="alert alert-success">Hủy phòng thành công</div><% } %>
    <% if ("cancel_failed".equals(request.getParameter("error"))) { %><div class="alert alert-danger">Hủy phòng thất bại hoặc phòng đã check-in</div><% } %>
    <c:choose>
        <c:when test="${empty bookings}"><div class="no-data">Bạn chưa có phiếu đặt phòng nào</div></c:when>
        <c:otherwise>
            <c:forEach var="b" items="${bookings}">
                <div class="card mb-3">
                    <div class="card-header">
                        <div>
                            <h3 style="margin:0;">${b.code}</h3>
                            <div class="fs-sm text-muted">
                                Ngày đặt: <fmt:formatDate value="${b.bookingDate}" pattern="HH:mm dd/MM/yyyy"/>
                                • ${b.roomCount} phòng
                            </div>
                        </div>
                        <div style="display:flex;align-items:center;gap:10px;">
                            <c:choose>
                                <c:when test="${b.status=='Chờ xác nhận'}"><span class="badge badge-warning">${b.status}</span></c:when>
                                <c:when test="${b.status=='Chưa nhận phòng'}"><span class="badge badge-info">${b.status}</span></c:when>
                                <c:when test="${b.status=='Lưu trú một phần'}"><span class="badge badge-primary">${b.status}</span></c:when>
                                <c:when test="${b.status=='Đang lưu trú'}"><span class="badge badge-primary">${b.status}</span></c:when>
                                <c:when test="${b.status=='Đã trả phòng'}"><span class="badge badge-success">${b.status}</span></c:when>
                                <c:otherwise><span class="badge badge-danger">${b.status}</span></c:otherwise>
                            </c:choose>
                            <c:if test="${b.status=='Chờ xác nhận' || b.status=='Chưa nhận phòng'}">
                                <a href="${pageContext.request.contextPath}/onlineCancel?bookingId=${b.id}" class="btn btn-danger btn-sm">Hủy cả phiếu</a>
                            </c:if>
                        </div>
                    </div>
                    <c:if test="${not empty b.rooms}">
                        <div class="table-container"><table><thead><tr><th>Phòng</th><th>Loại phòng</th><th>Ngày nhận</th><th>Ngày trả</th><th>Trạng thái phòng</th><th>Thao tác</th></tr></thead><tbody>
                        <c:forEach var="br" items="${b.rooms}">
                            <tr>
                                <td><strong>${br.roomNumber}</strong></td>
                                <td>${br.roomTypeName}</td>
                                <td><fmt:formatDate value="${br.checkIn}" pattern="HH:mm dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${br.checkOut}" pattern="HH:mm dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${br.roomStatus=='Chờ check in'}"><span class="badge badge-warning">${br.roomStatus}</span></c:when>
                                        <c:when test="${br.roomStatus=='Đã check-in'}"><span class="badge badge-primary">${br.roomStatus}</span></c:when>
                                        <c:when test="${br.roomStatus=='Đã check-out'}"><span class="badge badge-success">${br.roomStatus}</span></c:when>
                                        <c:when test="${br.roomStatus=='Đã hủy'}"><span class="badge badge-danger">${br.roomStatus}</span></c:when>
                                        <c:otherwise><span class="badge">${br.roomStatus}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${br.roomStatus=='Chờ check in'}">
                                        <form method="post" action="${pageContext.request.contextPath}/onlineCancel" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn hủy phòng ${br.roomNumber} này?')">
                                            <input type="hidden" name="bookedRoomId" value="${br.id}">
                                            <button type="submit" class="btn btn-danger btn-sm" style="padding: 2px 8px; font-size: 11px;">Hủy phòng</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody></table></div>
                    </c:if>
                    <c:if test="${not empty b.note}">
                        <div style="padding:8px 16px;border-top:1px solid var(--border);">
                            <span class="fs-sm text-muted">Ghi chú: ${b.note}</span>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</section>
<footer class="customer-footer">© 2025 ${applicationScope.hotelInfo.name}</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
