<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Quản lý thông tin KS</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>`n    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>Thông tin <span>khách sạn</span></h1></div></div>
    <% if ("update_success".equals(request.getParameter("msg"))) { %><div class="alert alert-success">Cập nhật thông tin khách sạn thành công</div><% } %>
    <c:if test="${error != null}"><div class="alert alert-danger">${error}</div></c:if>
    <div class="card" style="max-width:700px;">
        <form method="post" action="${pageContext.request.contextPath}/manager/hotel" enctype="multipart/form-data">
            <div class="form-group"><label>Tên khách sạn <span class="required">*</span></label><input type="text" name="name" class="form-control" value="${hotel.name}" required></div>
            <div class="form-row">
                <div class="form-group"><label>Số điện thoại</label><input type="text" name="phone" class="form-control" value="${hotel.phone}"></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" class="form-control" value="${hotel.email}"></div>
            </div>
            <div class="form-group"><label>Địa chỉ</label><input type="text" name="address" class="form-control" value="${hotel.address}"></div>
            <div class="form-group"><label>Số sao</label>
                <select name="starRating" class="form-control" style="max-width:200px;">
                    <c:forEach begin="1" end="5" var="i"><option value="${i}" ${hotel.starRating==i?'selected':''}>${i} sao</option></c:forEach>
                </select></div>
            <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control">${hotel.description}</textarea></div>
            
            <div class="form-group" style="margin-top: 16px;">
                <label>Hình ảnh khách sạn (Có thể chọn nhiều)</label>
                <div class="image-upload-wrapper" onclick="document.getElementById('imageFiles').click()">
                    <div style="font-size:32px; margin-bottom:8px;">Ảnh</div>
                    <div style="color:var(--text-muted); font-size:14px;">Nhấn vào đây để tải ảnh lên</div>
                </div>
                <input type="file" id="imageFiles" name="imageFiles" class="form-control" accept="image/*" multiple style="display:none;" onchange="handleFileSelect(event)">
                <input type="hidden" id="imageUrl" name="imageUrl" value="${hotel.imageUrl}">
                
                <div class="image-preview-grid" id="imagePreviewGrid">
                    <c:if test="${not empty hotel.imageUrl}">
                        <c:forEach var="url" items="${hotel.imageUrl.split(',')}">
                            <div class="image-preview-item" data-existing="${url}">
                                <img src="${pageContext.request.contextPath}${url}" alt="Hotel image">
                                <button type="button" class="image-preview-remove" onclick="removeExistingImage('${url}', this)">×</button>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    let dt = new DataTransfer();

    function handleFileSelect(event) {
        const files = event.target.files;
        const grid = document.getElementById('imagePreviewGrid');
        
        for (let i = 0; i < files.length; i++) {
            const file = files[i];
            dt.items.add(file);
            
            const reader = new FileReader();
            reader.onload = function(e) {
                const div = document.createElement('div');
                div.className = 'image-preview-item';
                div.innerHTML = `
                    <img src="${e.target.result}">
                    <button type="button" class="image-preview-remove" onclick="removeNewImage('${file.name}', this)">×</button>
                `;
                grid.appendChild(div);
            };
            reader.readAsDataURL(file);
        }
        document.getElementById('imageFiles').files = dt.files;
    }

    function removeNewImage(fileName, btn) {
        btn.parentElement.remove();
        const newDt = new DataTransfer();
        for (let i = 0; i < dt.files.length; i++) {
            if (dt.files[i].name !== fileName) {
                newDt.items.add(dt.files[i]);
            }
        }
        dt = newDt;
        document.getElementById('imageFiles').files = dt.files;
    }

    function removeExistingImage(url, btn) {
        btn.parentElement.remove();
        const hiddenInput = document.getElementById('imageUrl');
        let urls = hiddenInput.value.split(',').filter(u => u.trim() !== '' && u.trim() !== url.trim());
        hiddenInput.value = urls.join(',');
    }
</script>
</body></html>
