<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Thêm hóa đơn</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>`n    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>➕ Thêm <span>hóa đơn</span></h1></div></div>
    <c:if test="${error != null}"><div class="alert alert-danger">⚠️ ${error}</div></c:if>
    <div class="card" style="max-width:600px;"><form method="post" action="${pageContext.request.contextPath}/manager/invoice"><input type="hidden" name="action" value="insert">
        <div class="form-group"><label>Mã phiếu đặt <span class="required">*</span></label><input type="text" name="bookingCode" class="form-control" required placeholder="VD: PD2025041901"></div>
        <div class="form-row"><div class="form-group"><label>Tiền phòng</label><input type="number" name="roomTotal" class="form-control" value="0"></div><div class="form-group"><label>Tiền dịch vụ</label><input type="number" name="serviceTotal" class="form-control" value="0"></div></div>
        <div class="form-row"><div class="form-group"><label>Tổng tiền</label><input type="number" name="totalAmount" class="form-control" required></div><div class="form-group"><label>Phương thức TT</label><select name="paymentMethod" class="form-control"><option value="Tiền mặt">Tiền mặt</option><option value="Chuyển khoản">Chuyển khoản</option><option value="Thẻ tín dụng">Thẻ tín dụng</option></select></div></div>
        <div class="form-group"><label>Ghi chú</label><textarea name="note" class="form-control"></textarea></div>
        <div class="form-actions"><button type="submit" class="btn btn-primary">💾 Lưu</button><a href="${pageContext.request.contextPath}/manager/invoice?action=list" class="btn btn-outline">← Quay lại</a></div>
    </form></div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
