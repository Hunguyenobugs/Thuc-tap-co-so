<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Sửa loại phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>`n    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Sửa <span>loại phòng</span></h1></div></div>
    <div class="card" style="max-width:600px;">
        <form method="post" action="${pageContext.request.contextPath}/manager/roomtype" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${roomType.id}">
            <div class="form-row">
                <div class="form-group"><label>Tên <span class="required">*</span></label><input type="text" name="name" class="form-control" value="${roomType.name}" required></div>
                <div class="form-group"><label>Giá/đêm (₫) <span class="required">*</span></label><input type="number" name="basePrice" class="form-control" value="${roomType.basePrice}" required></div>
            </div>
            <div class="form-row-3">
                <div class="form-group"><label>Sức chứa</label><input type="number" name="capacity" class="form-control" value="${roomType.capacity}" min="1"></div>
                <div class="form-group"><label>Diện tích</label><input type="text" name="area" class="form-control" value="${roomType.area}"></div>
            </div>
            <div class="form-group" style="margin-top: 16px;">
                <label>Hình ảnh (Có thể chọn nhiều)</label>
                <div class="image-upload-wrapper" onclick="document.getElementById('imageFiles').click()">
                    <div style="font-size:32px; margin-bottom:8px;">📸</div>
                    <div style="color:var(--text-muted); font-size:14px;">Nhấn vào đây để tải ảnh lên</div>
                </div>
                <input type="file" id="imageFiles" name="imageFiles" class="form-control" accept="image/*" multiple style="display:none;" onchange="handleFileSelect(event)">
                <input type="hidden" id="imageUrl" name="imageUrl" value="${roomType.imageUrl}">
                
                <div class="image-preview-grid" id="imagePreviewGrid">
                    <c:if test="${not empty roomType.imageUrl}">
                        <c:forEach var="url" items="${roomType.imageUrl.split(',')}">
                            <div class="image-preview-item" data-existing="${url}">
                                <img src="${pageContext.request.contextPath}${url}" alt="Room image">
                                <button type="button" class="image-preview-remove" onclick="removeExistingImage('${url}', this)">×</button>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
            <div class="form-group"><label>Tiện nghi</label><input type="text" name="amenities" class="form-control" value="${roomType.amenities}"></div>
            <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control">${roomType.description}</textarea></div>
            <div class="form-actions"><button type="submit" class="btn btn-primary">💾 Cập nhật</button><a href="${pageContext.request.contextPath}/manager/roomtype?action=search" class="btn btn-outline">← Quay lại</a></div>
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
                    <img src="\${e.target.result}">
                    <button type="button" class="image-preview-remove" onclick="removeNewImage('\${file.name}', this)">×</button>
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
