<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Chi tiết phiếu đặt</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/><main class="main-content fade-in">
    <div class="topbar">
        <div><h1>📄 Chi tiết <span>phiếu đặt ${booking.code}</span></h1></div>
        <div>
            <c:choose>
                <c:when test="${booking.status=='Chờ xác nhận'}"><span class="badge badge-warning" style="font-size:14px;padding:8px 16px;">${booking.status}</span></c:when>
                <c:when test="${booking.status=='Đã xác nhận'}"><span class="badge badge-info" style="font-size:14px;padding:8px 16px;">${booking.status}</span></c:when>
                <c:when test="${booking.status=='Đang lưu trú'}"><span class="badge badge-primary" style="font-size:14px;padding:8px 16px;">${booking.status}</span></c:when>
                <c:when test="${booking.status=='Đã trả phòng'}"><span class="badge badge-success" style="font-size:14px;padding:8px 16px;">${booking.status}</span></c:when>
                <c:otherwise><span class="badge badge-danger" style="font-size:14px;padding:8px 16px;">${booking.status}</span></c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="detail-grid">
        <div>
            <!-- Thông tin khách hàng -->
            <div class="card mb-3"><div class="card-header"><h3>👤 Thông tin khách hàng</h3></div>
                <ul class="detail-list">
                    <li><span class="label">Họ tên</span><span class="value fw-bold">${booking.customerName}</span></li>
                    <li><span class="label">Số CCCD</span><span class="value">${booking.customerIdCard}</span></li>
                    <li><span class="label">SĐT</span><span class="value">${booking.customerPhone}</span></li>
                </ul>
            </div>

            <!-- Danh sách phòng -->
            <div class="card"><div class="card-header">
                <h3>🛏️ Danh sách phòng</h3>
                <span class="badge badge-primary">${bookedRooms.size()} phòng</span>
            </div>
            <div class="table-container"><table><thead><tr>
                <th>Phòng</th><th>Loại phòng</th><th>Ngày nhận phòng</th><th>Ngày trả phòng</th>
                <th>Check-in TT</th><th>Check-out TT</th><th>Giá/đêm</th><th>TT phòng</th>
            </tr></thead><tbody>
            <c:forEach var="br" items="${bookedRooms}"><tr>
                <td><strong>${br.roomNumber}</strong></td>
                <td>${br.roomTypeName}</td>
                <td><fmt:formatDate value="${br.checkIn}" pattern="HH:mm dd/MM/yyyy"/></td>
                <td><fmt:formatDate value="${br.checkOut}" pattern="HH:mm dd/MM/yyyy"/></td>
                <td class="fs-sm">
                    <c:if test="${br.actualCheckin != null}"><fmt:formatDate value="${br.actualCheckin}" pattern="HH:mm dd/MM/yyyy"/></c:if>
                    <c:if test="${br.actualCheckin == null}"><span class="text-muted">—</span></c:if>
                </td>
                <td class="fs-sm">
                    <c:if test="${br.actualCheckout != null}"><fmt:formatDate value="${br.actualCheckout}" pattern="HH:mm dd/MM/yyyy"/></c:if>
                    <c:if test="${br.actualCheckout == null}"><span class="text-muted">—</span></c:if>
                </td>
                <td><fmt:formatNumber value="${br.actualPrice}" pattern="#,##0"/>₫</td>
                <td>
                    <c:choose>
                        <c:when test="${br.roomStatus=='Chờ'}"><span class="badge badge-warning">${br.roomStatus}</span></c:when>
                        <c:when test="${br.roomStatus=='Đã check-in'}"><span class="badge badge-primary">${br.roomStatus}</span></c:when>
                        <c:when test="${br.roomStatus=='Đã check-out'}"><span class="badge badge-success">${br.roomStatus}</span></c:when>
                        <c:otherwise><span class="badge badge-danger">${br.roomStatus}</span></c:otherwise>
                    </c:choose>
                </td>
            </tr></c:forEach>
            </tbody></table></div>
            </div>
        </div>

        <!-- Cột phải: Thông tin booking -->
        <div><div class="card" style="position:sticky;top:100px;">
            <h3 class="mb-3">📋 Thông tin phiếu</h3>
            <ul class="detail-list">
                <li><span class="label">Mã phiếu</span><span class="value fw-bold">${booking.code}</span></li>
                <li><span class="label">Ngày đặt</span><span class="value"><fmt:formatDate value="${booking.bookingDate}" pattern="HH:mm dd/MM/yyyy"/></span></li>
                <li><span class="label">Tiền cọc</span><span class="value text-accent fw-bold"><fmt:formatNumber value="${booking.depositAmount}" pattern="#,##0"/>₫</span></li>
                <li><span class="label">Ghi chú</span><span class="value">${not empty booking.note ? booking.note : '—'}</span></li>
                <li><span class="label">Nhân viên</span><span class="value">${not empty booking.staffName ? booking.staffName : 'Khách tự đặt'}</span></li>
            </ul>
            <div class="btn-group mt-3" style="flex-direction:column;gap:8px;">
                <c:if test="${booking.status == 'Chờ xác nhận'}">
                    <form method="post" action="${pageContext.request.contextPath}/staff/manageBooking">
                        <input type="hidden" name="action" value="approve">
                        <input type="hidden" name="bookingId" value="${booking.id}">
                        <button type="submit" class="btn btn-primary btn-block" onclick="return confirm('Xác nhận duyệt phiếu này?');">✅ Duyệt phiếu</button>
                    </form>
                </c:if>
                <a href="${pageContext.request.contextPath}/staff/manageBooking?action=search" class="btn btn-outline btn-block">← Quay lại</a>
            </div>
        </div></div>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
