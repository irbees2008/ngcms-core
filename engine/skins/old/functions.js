// Упрощенные функции для старого шаблона NGCMS

function check_uncheck_all(form, prefix) {
    prefix = prefix || '';
    var elements = form.elements;
    var masterChecked = form.master_box.checked;
    
    for (var i = 0; i < elements.length; i++) {
        var element = elements[i];
        if (element.type == "checkbox" && element.name != "master_box") {
            if (prefix.length == 0 || element.name.substr(0, prefix.length) == prefix) {
                element.checked = masterChecked;
            }
        }
    }
}

function confirmit(url, text) {
    if (confirm(text)) {
        document.location = url;
    }
}

function insertext(open, close, field) {
    var msgfield = getCurrentTextArea();
    if (!msgfield && field) {
        msgfield = document.getElementById(field);
    }
    if (!msgfield) {
        msgfield = document.getElementById('content');
    }
    
    if (!msgfield) return;

    // IE support
    if (document.selection && document.selection.createRange) {
        msgfield.focus();
        var sel = document.selection.createRange();
        sel.text = open + sel.text + close;
    }
    // Mozilla support
    else if (msgfield.selectionStart || msgfield.selectionStart == "0") {
        var startPos = msgfield.selectionStart;
        var endPos = msgfield.selectionEnd;
        var scrollPos = msgfield.scrollTop;
        
        msgfield.value = msgfield.value.substring(0, startPos) + open + 
                        msgfield.value.substring(startPos, endPos) + close + 
                        msgfield.value.substring(endPos, msgfield.value.length);
        msgfield.selectionStart = msgfield.selectionEnd = endPos + open.length + close.length;
        msgfield.scrollTop = scrollPos;
    }
    // Fallback
    else {
        msgfield.value += open + close;
    }
    
    msgfield.focus();
}

// Совместимость с новостями
function getCurrentTextArea() {
    if (typeof currentInputAreaID !== 'undefined' && currentInputAreaID) {
        return document.getElementById(currentInputAreaID);
    }
    return document.getElementById('content');
}

// Глобальная переменная для совместимости
var currentInputAreaID = 'content';

function getCurrentInputArea() {
    return getCurrentTextArea();
}