function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
}

function confirmDelete(url, name) {
    if (confirm('Bạn có chắc chắn muốn xóa "' + name + '"?\nHành động này không thể hoàn tác.')) {
        window.location.href = url;
    }
}

function confirmAction(msg, url) {
    if (confirm(msg)) { window.location.href = url; }
}

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.alert').forEach(function(alert) {
        setTimeout(function() {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function() { alert.remove(); }, 300);
        }, 4000);
    });

    document.querySelectorAll('.sidebar-nav a').forEach(function(link) {
        if (link.href === window.location.href) {
            link.classList.add('active');
        }
    });
});
