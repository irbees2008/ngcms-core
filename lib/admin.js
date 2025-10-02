//
// JS Functions used for admin panel
//
function getCookie(name)
{
    var cookie = " " + document.cookie;
    var search = " " + name + "=";
    var setStr = null;
    var offset = 0;
    var end = 0;
    if (cookie.length > 0) {
        offset = cookie.indexOf(search);
        if (offset != -1) {
            offset += search.length;
            end = cookie.indexOf(";", offset)
            if (end == -1) {
                end = cookie.length;
            }
            setStr = unescape(cookie.substring(offset, end));
        }
    }
    return setStr;
}
function setCookie(name, value, expires, path, domain, secure)
{
    document.cookie = name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
    return true;
}
function toggleAdminGroup(ref)
{
    // Decide to find parent node for this block
    var maxIter = 5;
    var node = ref;
    while (maxIter) {
        if (node.className == 'admGroup') {
            break;
        }
        node = node.parentNode;
        maxIter--;
    }
    if (!maxIter) {
        alert('Scripting Error');
    }
    for (var i = 0; i < node.childNodes.length; i++) {
        var item = node.childNodes[i];
        if (item.className == 'content') {
            mode = (item.style.display == 'none') ? 1 : 0;
            item.style.display = mode ? '' : 'none';
            break;
        }
    }
}
function ngShowLoading(msg)
{
    var setX = ( $(window).width() - $("#loading-layer").width()  ) / 2;
    var setY = ( $(window).height() - $("#loading-layer").height() ) / 2;
    $("#loading-layer").css({
        left: setX + "px",
        top: setY + "px",
        position: 'fixed',
        zIndex: '99'
    });
    $("#loading-layer").fadeIn(0);
}
function ngHideLoading()
{
    $("#loading-layer").fadeOut('slow');
}
function ngNotifyWindow(msg, title)
{
    $("#ngNotifyWindowDIV").remove();
    $("body").append("<div id='ngNotifyWindowDIV' title='" + title + "' style='display:none'><br />" + msg + "</div>");
    $('#ngNotifyWindowDIV').dialog({
        autoOpen: true,
        width: 470,
        dialogClass: "modalfixed",
        buttons: {
            "Ok": function () {
                $(this).dialog("close");
                $("#ngNotifyWindowDIV").remove();
            }
        }
    });
    $('.modalfixed.ui-dialog').css({position: "fixed"});
    $('#ngNotifyWindowDIV').dialog("option", "position", ['0', '0']);
}
function ngNotifySticker(msg, opts) {
    // Defaults. Сохраняем совместимость со старыми вызовами (alert-*)
    opts = $.extend({
        time: 5000,
        speed: 'slow',
        className: 'alert-info',
        sticked: false,
        closeBTN: false,
        position: { top: 16, right: 16 }
    }, opts);
    // 1) Ensure container once and position (стили подключены статически в index.tpl)
    var container = document.getElementById('ng-toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'ng-toast-container';
        container.setAttribute('aria-live', 'polite');
        container.setAttribute('aria-atomic', 'true');
        document.body.appendChild(container);
    }
    var pos = opts.position || {};
    // Apply global position if provided (window.NGCMS.toast_position)
    try {
        var gpos = (window.NGCMS && NGCMS.toast_position) ? String(NGCMS.toast_position) : 'top-right';
        switch (gpos) {
            case 'top-left':
                pos = { top: 16, left: 16 };
                break;
            case 'bottom-right':
                pos = { bottom: 16, right: 16 };
                break;
            case 'bottom-left':
                pos = { bottom: 16, left: 16 };
                break;
            default:
                pos = { top: 16, right: 16 };
        }
    } catch (e) {}
    container.style.top = (pos.top != null ? pos.top : 'auto') === 'auto' ? 'auto' : pos.top + 'px';
    container.style.right = (pos.right != null ? pos.right : 'auto') === 'auto' ? 'auto' : pos.right + 'px';
    container.style.bottom = (pos.bottom != null ? pos.bottom : 'auto') === 'auto' ? 'auto' : pos.bottom + 'px';
    container.style.left = (pos.left != null ? pos.left : 'auto') === 'auto' ? 'auto' : pos.left + 'px';
    // 2) Normalize type from className like 'alert-success' | 'alert-danger' | ...
    var cname = String(opts.className || '').toLowerCase();
    var type = /danger|error/.test(cname) ? 'error' : /success/.test(cname) ? 'success' : /warn/.test(cname) ? 'warning' : 'info';
    // 3) Build toast
    var toast = document.createElement('div');
    toast.className = 'ng-toast ng-toast--' + type;
    var icon = document.createElement('div');
    icon.className = 'ng-toast__icon';
    var svgMap = {
        info: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12" y2="8"></line></svg>',
        success: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>',
        warning: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12" y2="17"></line></svg>',
        error: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>'
    };
    icon.innerHTML = svgMap[type];
    var content = document.createElement('div');
    content.className = 'ng-toast__content';
    content.innerHTML = msg;
    var close = document.createElement('button');
    close.className = 'ng-toast__close';
    close.type = 'button';
    close.setAttribute('aria-label', 'Close');
    close.innerHTML = '&times;';
    if (!opts.sticked && !opts.closeBTN) {
        // По умолчанию кнопку можно скрыть, если сообщение авто-закрывается
        close.style.display = 'none';
    }
    toast.appendChild(icon);
    toast.appendChild(content);
    toast.appendChild(close);
    container.appendChild(toast);
    // 4) Remove logic with animation
    var removed = false;
    function removeToast() {
        if (removed) return;
        removed = true;
        toast.style.animation = 'ng-toast-out .25s ease-in forwards';
        toast.addEventListener('animationend', function () {
            if (toast && toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, { once: true });
    }
    close.addEventListener('click', removeToast);
    if (!opts.sticked) {
        var ttl = Math.max(2500, Math.min(10000, String(msg).length * 60));
        setTimeout(removeToast, ttl);
    }
}
$.datepicker.regional['ru'] = {
    closeText: 'Закрыть',
    prevText: '<Пред',
    nextText: 'След>',
    currentText: 'Сегодня',
    monthNames: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
        'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
    monthNamesShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
        'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
    dayNames: ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
    dayNamesShort: ['вск', 'пнд', 'втр', 'срд', 'чтв', 'птн', 'сбт'],
    dayNamesMin: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
    weekHeader: 'Не',
    dateFormat: 'dd.mm.yy',
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: ''
};
$.timepicker.regional['ru'] = {
    timeOnlyTitle: 'Выберите время',
    timeText: 'Время',
    hourText: 'Часы',
    minuteText: 'Минуты',
    secondText: 'Секунды',
    millisecText: 'Миллисекунды',
    timezoneText: 'Часовой пояс',
    currentText: 'Сейчас',
    closeText: 'Закрыть',
    timeFormat: 'HH:mm',
    amNames: ['AM', 'A'],
    pmNames: ['PM', 'P'],
    isRTL: false
};
