<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Lịch sử đặt phòng - ${applicationScope.hotelInfo.name}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
/* Modal Styles */
.custom-modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(15, 23, 42, 0.6);
    backdrop-filter: blur(8px);
    align-items: center;
    justify-content: center;
}

.custom-modal.show {
    display: flex;
    animation: fadeIn 0.3s forwards;
}

.custom-modal-content {
    background: var(--bg-secondary);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 28px;
    width: 90%;
    max-width: 600px;
    box-shadow: var(--shadow-lg);
    position: relative;
    color: var(--text-primary);
    transform: scale(0.9);
    transition: transform 0.3s ease;
}

.custom-modal.show .custom-modal-content {
    transform: scale(1);
    animation: zoomIn 0.3s forwards;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes zoomIn {
    from { transform: scale(0.9); }
    to { transform: scale(1); }
}

.custom-modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid var(--border);
    padding-bottom: 14px;
    margin-bottom: 20px;
}

.custom-modal-title {
    margin: 0;
    font-size: 1.3rem;
    font-weight: 700;
    color: var(--accent);
}

.custom-modal-close {
    background: none;
    border: none;
    color: var(--text-secondary);
    font-size: 28px;
    cursor: pointer;
    line-height: 1;
    padding: 0;
    transition: var(--transition);
}

.custom-modal-close:hover {
    color: var(--danger);
    transform: scale(1.1);
}

.detail-section {
    margin-bottom: 20px;
}

.detail-section-title {
    font-weight: 600;
    margin-bottom: 10px;
    font-size: 1rem;
    color: var(--text-primary);
    border-left: 3px solid var(--accent);
    padding-left: 10px;
}

.detail-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
    background: rgba(255, 255, 255, 0.02);
    padding: 16px;
    border-radius: var(--radius-sm);
    border: 1px solid var(--border);
}

.detail-item {
    font-size: 0.95rem;
}

.detail-label {
    color: var(--text-secondary);
    font-size: 0.85rem;
    margin-bottom: 4px;
}

.detail-value {
    font-weight: 600;
}

.text-success {
    color: var(--success) !important;
}
</style>
</head>
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
                        <div class="table-container"><table><thead><tr><th>Phòng</th><th>Loại phòng</th><th>Ngày nhận (Dự kiến)</th><th>Ngày trả (Dự kiến)</th><th>Trạng thái phòng</th><th>Thao tác</th></tr></thead><tbody>
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
                                    <div style="display:flex; gap: 8px; align-items:center;">
                                        <button type="button" class="btn btn-info btn-sm" style="padding: 2px 8px; font-size: 11px;" onclick="showDetailModal(${br.id})">Xem chi tiết</button>
                                        <c:if test="${br.roomStatus=='Chờ check in'}">
                                            <form method="post" action="${pageContext.request.contextPath}/onlineCancel" style="display:inline; margin: 0;" onsubmit="return confirm('Bạn có chắc chắn muốn hủy phòng ${br.roomNumber} này?')">
                                                <input type="hidden" name="bookedRoomId" value="${br.id}">
                                                <button type="submit" class="btn btn-danger btn-sm" style="padding: 2px 8px; font-size: 11px;">Hủy phòng</button>
                                            </form>
                                        </c:if>
                                    </div>
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
<c:forEach var="b" items="${bookings}">
    <c:forEach var="br" items="${b.rooms}">
        <div id="detailModal-${br.id}" class="custom-modal">
            <div class="custom-modal-content">
                <div class="custom-modal-header">
                    <h3 class="custom-modal-title">Chi tiết đặt phòng ${br.roomNumber}</h3>
                    <button class="custom-modal-close" onclick="closeDetailModal(${br.id})">&times;</button>
                </div>
                
                <!-- Thông tin chung -->
                <div class="detail-section">
                    <div class="detail-section-title">Thông tin phòng</div>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <div class="detail-label">Số phòng</div>
                            <div class="detail-value">${br.roomNumber}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Loại phòng</div>
                            <div class="detail-value">${br.roomTypeName}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Nhận phòng dự kiến</div>
                            <div class="detail-value"><fmt:formatDate value="${br.checkIn}" pattern="HH:mm dd/MM/yyyy"/></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Trả phòng dự kiến</div>
                            <div class="detail-value"><fmt:formatDate value="${br.checkOut}" pattern="HH:mm dd/MM/yyyy"/></div>
                        </div>
                        <c:if test="${not empty br.actualCheckin}">
                            <div class="detail-item">
                                <div class="detail-label">Check-in thực tế</div>
                                <div class="detail-value text-success"><fmt:formatDate value="${br.actualCheckin}" pattern="HH:mm dd/MM/yyyy"/></div>
                            </div>
                        </c:if>
                        <c:if test="${not empty br.actualCheckout}">
                            <div class="detail-item">
                                <div class="detail-label">Check-out thực tế</div>
                                <div class="detail-value text-success"><fmt:formatDate value="${br.actualCheckout}" pattern="HH:mm dd/MM/yyyy"/></div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Dịch vụ đã sử dụng -->
                <c:if test="${br.roomStatus == 'Đã check-in' || br.roomStatus == 'Đã check-out'}">
                    <div class="detail-section">
                        <div class="detail-section-title">Dịch vụ đã sử dụng</div>
                        <c:choose>
                            <c:when test="${empty br.services}">
                                <div class="text-muted fs-sm" style="padding: 10px; background: rgba(255,255,255,0.01); border-radius: var(--radius-sm); border: 1px dashed var(--border);">
                                    Không sử dụng dịch vụ nào
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-container" style="margin-top:8px;">
                                    <table style="width:100%; font-size: 0.85rem;">
                                        <thead>
                                            <tr>
                                                <th>Tên dịch vụ</th>
                                                <th>Số lượng</th>
                                                <th>Đơn giá</th>
                                                <th>Thành tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="srv" items="${br.services}">
                                                <tr>
                                                    <td><strong>${srv.serviceName}</strong></td>
                                                    <td>${srv.quantity} ${srv.serviceUnit}</td>
                                                    <td><fmt:formatNumber value="${srv.unitPrice}" pattern="#,##0"/>₫</td>
                                                    <td><strong><fmt:formatNumber value="${srv.quantity * srv.unitPrice}" pattern="#,##0"/>₫</strong></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Hóa đơn thanh toán -->
                <c:if test="${br.roomStatus == 'Đã check-out' && not empty br.invoice}">
                    <div class="detail-section">
                        <div class="detail-section-title">Chi tiết thanh toán</div>
                        <div class="detail-grid" style="grid-template-columns: 1fr; gap: 8px;">
                            <div style="display:flex; justify-content: space-between; font-size: 0.9rem;">
                                <span class="text-secondary">Tiền phòng:</span>
                                <strong><fmt:formatNumber value="${br.invoice.roomTotal}" pattern="#,##0"/>₫</strong>
                            </div>
                            <div style="display:flex; justify-content: space-between; font-size: 0.9rem;">
                                <span class="text-secondary">Tiền dịch vụ:</span>
                                <strong><fmt:formatNumber value="${br.invoice.serviceTotal}" pattern="#,##0"/>₫</strong>
                            </div>
                            <div style="display:flex; justify-content: space-between; font-size: 0.9rem;">
                                <span class="text-secondary">Tiền phụ thu:</span>
                                <strong><fmt:formatNumber value="${br.invoice.surcharge}" pattern="#,##0"/>₫</strong>
                            </div>
                            <div style="display:flex; justify-content: space-between; font-size: 1rem; border-top: 1px solid var(--border); padding-top: 8px; margin-top: 4px;">
                                <span style="font-weight: 600; color: var(--accent);">Tổng đã thanh toán:</span>
                                <strong style="color: var(--success); font-size: 1.1rem;"><fmt:formatNumber value="${br.invoice.totalAmount}" pattern="#,##0"/>₫</strong>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <div style="display:flex; justify-content: flex-end; margin-top: 20px;">
                    <button class="btn btn-outline btn-sm" onclick="closeDetailModal(${br.id})">Đóng</button>
                </div>
            </div>
        </div>
    </c:forEach>
</c:forEach>

<footer class="customer-footer">© 2025 ${applicationScope.hotelInfo.name}</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function showDetailModal(id) {
    var modal = document.getElementById('detailModal-' + id);
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

function closeDetailModal(id) {
    var modal = document.getElementById('detailModal-' + id);
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = '';
    }
}

window.onclick = function(event) {
    if (event.target.classList.contains('custom-modal')) {
        event.target.classList.remove('show');
        document.body.style.overflow = '';
    }
}
</script>
</body></html>
