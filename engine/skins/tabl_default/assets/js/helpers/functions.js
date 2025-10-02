/*
|--------------------------------------------------------------------------
| JavaScript-функции, используемые в админ. панели.
|--------------------------------------------------------------------------
|
| Содержит функционал, перенесенный из `{{ home }}/lib/admin.js`,  `{{ home }}/lib/functions.js`.
|
*/

/**
 * [json_encode description]
 * @param  {object} params
 * @return {string}
 */
export function json_encode(params) {
    return JSON.stringify(params);
}

/**
 * [ngShowLoading description]
 */
export function ngShowLoading() {
    const setX = ($(window).width() - $("#loading-layer").width()) / 2;
    const setY = ($(window).height() - $("#loading-layer").height()) / 2;

    $("#loading-layer").css({
            left: setX + 'px',
            top: setY + 'px'
        })
        .fadeIn(0);
}

/**
 * [ngHideLoading description]
 */
export function ngHideLoading() {
    $("#loading-layer").fadeOut('slow');
}

/**
 * [ngNotifySticker description]
 * @param  {string}  message
 * @param  {object}  params
 */
export function ngNotifySticker(message, params = {}) {
    params = $.extend({
        time: 5000,
        speed: 'slow',
        className: 'alert-info',
        sticked: false,
        closeBTN: false,
        position: { top: 16, right: 16 }
    }, params);

    let container = document.getElementById('ng-toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'ng-toast-container';
        container.setAttribute('aria-live', 'polite');
        container.setAttribute('aria-atomic', 'true');
        document.body.appendChild(container);
    }
    const pos = params.position || {};
    container.style.top = (pos.top != null ? pos.top : 16) + 'px';
    container.style.right = (pos.right != null ? pos.right : 16) + 'px';
    container.style.bottom = (pos.bottom != null ? pos.bottom : 'auto');
    container.style.left = (pos.left != null ? pos.left : 'auto');

    const type = /danger|error/i.test(params.className) ? 'error' : /success/i.test(params.className) ? 'success' : /warn/i.test(params.className) ? 'warning' : 'info';
    const toast = document.createElement('div');
    toast.className = 'ng-toast ng-toast--' + type;
    const icon = document.createElement('div');
    icon.className = 'ng-toast__icon';
    const svg = { info:'<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12" y2="8"></line></svg>', success:'<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>', warning:'<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12" y2="17"></line></svg>', error:'<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>' }[type];
    icon.innerHTML = svg;
    const content = document.createElement('div');
    content.className = 'ng-toast__content';
    content.innerHTML = message;
    const close = document.createElement('button');
    close.className = 'ng-toast__close';
    close.type = 'button';
    close.setAttribute('aria-label', 'Close');
    close.innerHTML = '&times;';
    if (!params.sticked && !params.closeBTN) close.style.display = 'none';
    toast.appendChild(icon);
    toast.appendChild(content);
    toast.appendChild(close);
    container.appendChild(toast);
    let removed = false;
    function removeToast(){ if (removed) return; removed = true; toast.style.animation = 'ng-toast-out .25s ease-in forwards'; toast.addEventListener('animationend', ()=> toast.remove(), { once:true }); }
    close.addEventListener('click', removeToast);
    if (!params.sticked) { const ttl = Math.max(2500, Math.min(10000, String(message).length * 60)); setTimeout(removeToast, ttl); }
}

/**
 * [confirmit description]
 * @param  {string} url
 * @param  {string} text
 */
export function confirmit(url, text) {
    if (confirm(text)) {
        document.location = url;
    }
}

/**
 * [setCookie description]
 * @param {string} name
 * @param {string} value
 */
export function setCookie(name, value) {
    document.cookie = name + "=" + value + '; path="/";' + " expires=Thu, 1 Jan 2030 00:00:00 GMT;";
}

/**
 * [deleteCookie description]
 * @param  {string} name
 */
export function deleteCookie(name) {
    document.cookie = name + "=" + "; path=/;" + " expires=Sut, 1 Jan 2000 00:00:01 GMT;";
}

/**
 * [getCookie description]
 * @param  {string} name
 * @return {string}
 */
export function getCookie(name) {
    const cookie = " " + document.cookie;
    const search = " " + name + "=";
    let setStr = null;
    let offset = 0;
    let end = 0;

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

    return (setStr);
}

/**
 * [check_uncheck_all description]
 * @param  {HTMLFormElement} form
 * @param  {string} prefix
 */
export function check_uncheck_all(form, prefix = '') {
    [...form.elements].map(function(element) {
        if ((element.type == "checkbox") && (element.name != "master_box") &&
            ((prefix.length == 0) || (element.name.substr(0, prefix.length) == prefix))
        ) {
            element.checked = form.master_box.checked ? true : false;
        }
    });
}

/**
 * [insertext description]
 * @param  {string} open
 * @param  {string} close
 * @param  {string} field
 */
export function insertext(open, close, field) {
    window.event.preventDefault();

    const msgfield = document.getElementById(field || 'content');

    // IE support
    if (document.selection && document.selection.createRange) {
        msgfield.focus();
        sel = document.selection.createRange();
        sel.text = open + sel.text + close;
    }
    // Moz support
    else if (msgfield.selectionStart || msgfield.selectionStart == "0") {
        const startPos = msgfield.selectionStart;
        const endPos = msgfield.selectionEnd;
        const scrollPos = msgfield.scrollTop;

        msgfield.value = msgfield.value.substring(0, startPos) + open + msgfield.value.substring(startPos, endPos) + close + msgfield.value.substring(endPos, msgfield.value.length);
        msgfield.selectionStart = msgfield.selectionEnd = endPos + open.length + close.length;
        msgfield.scrollTop = scrollPos;
    }
    // Fallback support for other browsers
    else {
        msgfield.value += open + close;
    }

    msgfield.focus();
}

/**
 * [insertimage description]
 * @param  {string} text
 * @param  {string} area
 */
export function insertimage(text, area) {
    var win = window.opener;
    var form = win.document.forms['form'];

    try {
        var xarea = win.document.forms['DATA_tmp_storage'].area.value;
        if (xarea != '') {
            area = xarea;
        }
    } catch (err) {
        ;
    }

    var control = win.document.getElementById(area);

    control.focus();

    // IE
    if (win.selection && win.selection.createRange) {
        sel = win.selection.createRange();
        sel.text = text = sel.text;
    }
    // Mozilla
    else {
        if (control.selectionStart || control.selectionStart == "0") {
            var startPos = control.selectionStart;
            var endPos = control.selectionEnd;

            control.value = control.value.substring(0, startPos) + text + control.value.substring(startPos, control.value.length);
            //control.selectionStart = msgfield.selectionEnd = endPos + open.length + close.length;
        } else {
            control.value += text;
        }
    }

    control.focus();
}

/**
 * [ResponseException description]
 * @param  {string}  message
 * @param  {object}  response
 */
function ResponseException(message, response) {
    this.message = message;
    this.response = response;
    this.name = 'AJAX Response Exception';
    this.toString = function() {
        return `${this.name}: ${this.message}`
    };
}

/**
 * Выполнить асинхронный POST-запрос (AJAX) на сервер.
 * @param  {string}  methodName  Имя метода.
 * @param  {object}  params  Параметры запроса.
 * @param  {boolean} notifyResult  Отобразить результат запроса во всплывающем сообщении.
 * @return {jqXHR}
 */
export function post(methodName, params = {}, notifyResult = true) {
    const token = $('input[name="token"]').val();

    return $.ajax({
            method: 'POST',
            url: NGCMS.admin_url + '/rpc.php',
            dataType: 'json',
            headers: {
                'X-CSRF-TOKEN': token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            data: {
                json: 1,
                token: token,
                methodName: methodName,
                params: JSON.stringify(params)
            },
            beforeSend() {
                ngShowLoading();
            }
        })
        .then(function(response) {
            if (!response.status) {
                throw new ResponseException(`Error [${response.errorCode}]: ${response.errorText}`, response);
            }

            return response;
        })
        .done(function(response) {
            // title: `<h5>${NGCMS.lang.notifyWindowInfo}</h5>`,
            notifyResult && ngNotifySticker(response.errorText, {
                className: 'alert-success',
                closeBTN: true
            });

            return response;
        })
        .fail(function(error) {
            // title: `<h5>${NGCMS.lang.notifyWindowError}</h5>`,
            ngNotifySticker(error.message || NGCMS.lang.rpc_httpError, {
                className: 'alert-danger',
                closeBTN: true
            });
        })
        .always(function() {
            ngHideLoading();
        });
}
