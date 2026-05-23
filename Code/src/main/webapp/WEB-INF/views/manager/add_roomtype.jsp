<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Thêm loại phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>Thêm <span>loại phòng</span></h1><div class="breadcrumb"><a href="${pageContext.request.contextPath}/manager/roomtype?action=manage">Loại phòng</a><span>Thêm mới</span></div></div></div>
    <c:if test="${error != null}"><div class="alert alert-danger">${error}</div></c:if>
    <div class="card" style="max-width:600px;">
        <form method="post" action="${pageContext.request.contextPath}/manager/roomtype" enctype="multipart/form-data">
            <input type="hidden" name="action" value="insert">
            <div class="form-row">
                <div class="form-group"><label>Tên <span class="required">*</span></label><input type="text" name="name" class="form-control" required></div>
                <div class="form-group"><label>Giá/đêm (₫) <span class="required">*</span></label><input type="number" name="basePrice" class="form-control" required></div>
            </div>
            <div class="form-row-3">
                <div class="form-group"><label>Sức chứa</label><input type="number" name="capacity" class="form-control" min="1" value="2"></div>
                <div class="form-group"><label>Diện tích</label><input type="text" name="area" class="form-control" placeholder="VD: 25m²"></div>
            </div>
            <div class="form-group" style="margin-top: 16px;">
                <label>Hình ảnh (Có thể chọn nhiều)</label>
                <div class="image-upload-wrapper" onclick="document.getElementById('imageFiles').click()">
                    <div style="font-size:32px; margin-bottom:8px;">Ảnh</div>
                    <div style="color:var(--text-muted); font-size:14px;">Nhấn vào đây để tải ảnh lên</div>
                </div>
                <input type="file" id="imageFiles" name="imageFiles" class="form-control" accept="image/*" multiple style="display:none;" onchange="handleFileSelect(event)">
                <input type="hidden" id="imageUrl" name="imageUrl" value="">
                
                <div class="image-preview-grid" id="imagePreviewGrid">
                </div>
            </div>
            <div class="form-group"><label>Tiện nghi</label><input type="text" name="amenities" class="form-control" placeholder="TV, minibar, wifi..."></div>
            <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control"></textarea></div>
            <div class="form-actions"><button type="submit" class="btn btn-primary">Lưu</button><a href="${pageContext.request.contextPath}/manager/roomtype?action=manage" class="btn btn-outline">← Quay lại</a></div>
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
</script>
</body></html>
