// --- LOGIC CHUYỂN ĐỔI THEME ---
(function () {
    const savedTheme = localStorage.getItem('app-theme') || 'default';
    if (savedTheme === 'light-new') {
        if (document.body) {
            document.body.classList.add('theme-light-new');
        } else {
            document.addEventListener('DOMContentLoaded', function () {
                document.body.classList.add('theme-light-new');
            });
        }
    }
})();

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

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.alert').forEach(function (alert) {
        setTimeout(function () {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function () { alert.remove(); }, 300);
        }, 4000);
    });

    document.querySelectorAll('.sidebar-nav a').forEach(function (link) {
        if (link.href === window.location.href) {
            link.classList.add('active');
        }
    });

    // Tạo nút nổi chuyển đổi theme (Floating Switcher)
    const savedTheme = localStorage.getItem('app-theme') || 'default';
    const switchBtn = document.createElement('button');
    switchBtn.id = 'temp-theme-switcher';

    function updateSwitchBtn(theme) {
        if (theme === 'light-new') {
            switchBtn.innerHTML = '✨ Giao diện Sáng';
            switchBtn.style.backgroundColor = '#ffffff';
            switchBtn.style.color = '#2563eb';
            switchBtn.style.border = '1px solid #2563eb';
        } else {
            switchBtn.innerHTML = '🌙 Giao diện Tối';
            switchBtn.style.backgroundColor = '#1e293b';
            switchBtn.style.color = '#f1f5f9';
            switchBtn.style.border = '1px solid #334155';
        }
    }

    updateSwitchBtn(savedTheme);

    Object.assign(switchBtn.style, {
        position: 'fixed',
        bottom: '24px',
        right: '24px',
        zIndex: '99999',
        padding: '12px 20px',
        borderRadius: '50px',
        boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.3), 0 8px 10px -6px rgba(0, 0, 0, 0.3)',
        cursor: 'pointer',
        fontWeight: '700',
        fontSize: '13px',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
        fontFamily: "'Inter', sans-serif"
    });

    switchBtn.addEventListener('mouseenter', function () {
        switchBtn.style.transform = 'translateY(-4px) scale(1.05)';
        switchBtn.style.boxShadow = '0 20px 25px -5px rgba(0, 0, 0, 0.4), 0 10px 10px -5px rgba(0, 0, 0, 0.4)';
    });
    switchBtn.addEventListener('mouseleave', function () {
        switchBtn.style.transform = 'translateY(0) scale(1)';
        switchBtn.style.boxShadow = '0 10px 25px -5px rgba(0, 0, 0, 0.3), 0 8px 10px -6px rgba(0, 0, 0, 0.3)';
    });

    switchBtn.addEventListener('click', function () {
        const isCurrentlyLight = document.body.classList.contains('theme-light-new');
        if (isCurrentlyLight) {
            document.body.classList.remove('theme-light-new');
            localStorage.setItem('app-theme', 'default');
            updateSwitchBtn('default');
        } else {
            document.body.classList.add('theme-light-new');
            localStorage.setItem('app-theme', 'light-new');
            updateSwitchBtn('light-new');
        }
    });

    document.body.appendChild(switchBtn);
});
