<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Sửa hóa đơn</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Sửa <span>hóa đơn ${invoice.code}</span></h1></div></div>
    <div class="card" style="max-width:500px;"><form method="post" action="${pageContext.request.contextPath}/manager/invoice"><input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${invoice.id}">
        <div class="form-group"><label>Số tiền thanh toán</label><input type="number" name="paidAmount" class="form-control" value="${invoice.paidAmount}"></div>
        <div class="form-group"><label>Phương thức TT</label><select name="paymentMethod" class="form-control"><option value="Tiền mặt" ${invoice.paymentMethod=='Tiền mặt'?'selected':''}>Tiền mặt</option><option value="Chuyển khoản" ${invoice.paymentMethod=='Chuyển khoản'?'selected':''}>Chuyển khoản</option><option value="Thẻ tín dụng" ${invoice.paymentMethod=='Thẻ tín dụng'?'selected':''}>Thẻ tín dụng</option></select></div>
        <div class="form-group"><label>Ghi chú</label><textarea name="note" class="form-control">${invoice.note}</textarea></div>
        <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Cập nhật</button><a href="${pageContext.request.contextPath}/manager/invoice?action=detail&id=${invoice.id}" class="btn btn-outline">← Quay lại</a></div>
    </form></div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
