/* NGCMS Admin news editor helpers (moved from qt_news.tpl)
	 All functions are attached to window for use in inline handlers.
*/
(function () {
  "use strict";
  try {
    if (window.__NGCMS_EDITOR_LOADED) {
      return;
    }
    window.__NGCMS_EDITOR_LOADED = true;
  } catch (e) {}
  // Init global namespace and base URLs
  if (!window.NGCMS) window.NGCMS = {};
  if (!NGCMS.admin_url) {
    // Try to guess '/engine' from current location
    try {
      var loc = String(location.pathname || "");
      var idx = loc.toLowerCase().indexOf("/engine/");
      NGCMS.admin_url = idx >= 0 ? loc.slice(0, idx + 7) : "/engine";
    } catch (e) {
      NGCMS.admin_url = "/engine";
    }
  }
  if (!NGCMS.images_url) NGCMS.images_url = "/uploads/images";
  if (!NGCMS.files_url) NGCMS.files_url = "/uploads/files";
  // Utilities
  function notifyMsg(message, type) {
    try {
      if (typeof window.showNotify === "function") {
        window.showNotify(String(message), type || "info");
        return;
      }
    } catch (e) {}
    try {
      if (window.$ && typeof $.notify === "function") {
        $.notify({ message: String(message) }, { type: type || "info" });
        return;
      }
    } catch (e) {}
    try {
      alert(String(message));
    } catch (e) {}
  }
  window.notifyMsg = window.notifyMsg || notifyMsg;
  // Determine active editor textarea id
  function guessAreaId() {
    try {
      if (typeof window.__editorAreaId !== "undefined" && window.__editorAreaId)
        return String(window.__editorAreaId);
    } catch (e) {}
    try {
      var el = document.getElementById("content");
      if (el && el.tagName === "TEXTAREA") return "content";
    } catch (e) {}
    try {
      var tas = document.getElementsByTagName("textarea");
      if (tas && tas.length && tas[0].id) return String(tas[0].id);
    } catch (e) {}
    return "content";
  }
  window.guessAreaId = window.guessAreaId || guessAreaId;
  // Basic inserters used by toolbar and modals
  function insertAt(areaId, text) {
    try {
      if (!areaId) areaId = guessAreaId();
    } catch (e) {}
    try {
      insertAtCursor(areaId, String(text));
    } catch (e) {
      try {
        var el = document.getElementById(areaId);
        if (el) el.value += String(text);
      } catch (e_) {}
    }
  }
  window.insertAt = window.insertAt || insertAt;
  function ngInsertBB(text, areaId) {
    insertAt(areaId, text);
  }
  window.ngInsertBB = window.ngInsertBB || ngInsertBB;
  function insertext(open, close, areaId) {
    try {
      if (!areaId) areaId = guessAreaId();
      var el = document.getElementById(areaId);
      if (!el) return false;
      el.focus();
      var start = 0,
        end = 0,
        selected = "";
      if (
        typeof el.selectionStart === "number" &&
        typeof el.selectionEnd === "number"
      ) {
        start = el.selectionStart;
        end = el.selectionEnd;
        selected = el.value.substring(start, end);
        var replacement = String(open) + selected + String(close || "");
        var scroll = el.scrollTop;
        el.value =
          el.value.substring(0, start) + replacement + el.value.substring(end);
        el.selectionStart = el.selectionEnd = start + replacement.length;
        el.scrollTop = scroll;
      } else if (document.selection && document.selection.createRange) {
        var sel = document.selection.createRange();
        sel.text = String(open) + (sel.text || "") + String(close || "");
      } else {
        el.value += String(open) + String(close || "");
      }
      try {
        if (typeof window.__ng_hist_push === "function")
          window.__ng_hist_push(areaId);
      } catch (e_) {}
      return false;
    } catch (e) {
      return false;
    }
  }
  window.insertext = window.insertext || insertext;
  // Modal show helper to work with Bootstrap 3/5 and without jQuery
  function showModalById(id) {
    try {
      var m = document.getElementById(String(id));
      if (!m) return false;
      try {
        if (window.jQuery && typeof jQuery(m).modal === "function") {
          jQuery(m).modal("show");
          return true;
        }
      } catch (e) {}
      // vanilla fallback
      m.classList.add("show");
      m.style.display = "block";
      m.removeAttribute("aria-hidden");
      return true;
    } catch (e) {
      return false;
    }
  }
  window.showModalById = window.showModalById || showModalById;
  // Core RPC uploader used by drag-and-drop and buttons
  async function rpcUpload(file, opts) {
    var o = opts || {};
    var kind = (o.type || "file").toLowerCase();
    var methodCandidates = [];
    if (kind === "image") {
      methodCandidates = [
        "admin.images.upload",
        "images.upload",
        "admin.upload.image",
        "admin.files.upload",
      ];
    } else {
      methodCandidates = [
        "admin.files.upload",
        "files.upload",
        "admin.upload.file",
      ];
    }
    var base = String(NGCMS.admin_url || "/engine") + "/rpc.php?methodName=";
    var lastError = "";
    for (var i = 0; i < methodCandidates.length; i++) {
      var fd = new FormData();
      try {
        fd.append("Filedata", file);
      } catch (e) {}
      try {
        fd.append("file", file);
      } catch (e) {}
      // Common switches understood by NG CMS backends
      if (o.rand != null) fd.append("rand", String(o.rand ? 1 : 0));
      if (o.replace != null) fd.append("replace", String(o.replace ? 1 : 0));
      if (o.thumb != null) fd.append("thumb", String(o.thumb ? 1 : 0));
      if (o.stamp != null) fd.append("stamp", String(o.stamp ? 1 : 0));
      fd.append("json", "1");
      // Some handlers may want the type explicitly
      try {
        fd.append("type", kind);
      } catch (e) {}
      try {
        fd.append("uploadType", kind);
      } catch (e) {}
      try {
        var resp = await fetch(base + methodCandidates[i], {
          method: "POST",
          body: fd,
          credentials: "same-origin",
        });
        var text = await resp.text();
        var data = null;
        try {
          data = JSON.parse(text);
        } catch (_) {}
        if (
          data &&
          (data.status === true || data.status === 1 || data.success === true)
        ) {
          var d = data.data || data.result || data.file || data.image || {};
          var url = d.url || d.link || d.fileurl || d.full || data.url || "";
          var id = d.id || d.imageId || d.fileId || data.id || "";
          return { ok: true, url: String(url || "").trim(), id: id, data: d };
        }
        lastError =
          (data && (data.errorText || data.message || data.error)) ||
          (resp && !resp.ok ? "HTTP " + resp.status : "Unknown response");
      } catch (e) {
        lastError = String(e);
      }
    }
    return { ok: false, errorText: lastError || "Upload failed" };
  }
  window.rpcUpload = window.rpcUpload || rpcUpload;
  function insertAtCursor(fieldId, text) {
    var el = null;
    try {
      el = document.getElementById(fieldId);
    } catch (e) {}
    if (!el) return;
    el.focus();
    if (document.selection && document.selection.createRange) {
      var sel = document.selection.createRange();
      sel.text = text;
    } else if (
      typeof el.selectionStart === "number" &&
      typeof el.selectionEnd === "number"
    ) {
      var startPos = el.selectionStart,
        endPos = el.selectionEnd,
        scrollPos = el.scrollTop;
      el.value =
        el.value.substring(0, startPos) +
        text +
        el.value.substring(endPos, el.value.length);
      el.selectionStart = el.selectionEnd = startPos + text.length;
      el.scrollTop = scrollPos;
    } else {
      el.value += text;
    }
    try {
      if (typeof window.__ng_hist_push === "function") {
        window.__ng_hist_push(fieldId);
      }
    } catch (e) {}
  }
  async function performImageUpload(file, areaId) {
    // По умолчанию: миниатюра включена, случайное имя выключено (имя + хеш делает сервер)
    var randEl = document.getElementById("imageRandomTitle");
    const rand = randEl ? (randEl.checked ? 1 : 0) : 0;
    var thumbEl = document.getElementById("imageCreateThumb");
    const thumb = thumbEl ? (thumbEl.checked ? 1 : 0) : 1;
    const res = await rpcUpload(file, {
      type: "image",
      rand,
      replace: 0,
      thumb,
      stamp: 1,
    });
    if (!res.ok) {
      throw new Error(res.errorText || "Ошибка загрузки");
    }
    const d = res.data || {};
    const fname = (
      d.name ||
      d.filename ||
      (file && file.name) ||
      ""
    ).toString();
    var baseImg = String(NGCMS.images_url || "/uploads/images");
    if (baseImg && !/\/$/.test(baseImg)) baseImg += "/";
    var cat = String(d.category || d.folder || "").replace(/^\/+|\/+$/g, "");
    if (cat) cat += "/";
    let fullUrl = String(res.url || "").trim();
    if (!fullUrl && fname) fullUrl = baseImg + cat + fname;
    let thumbUrl = "";
    if (fname) thumbUrl = baseImg + cat + "thumb/" + fname;
    if (!fullUrl)
      throw new Error("Файл загружен, но URL не получен от сервера");
    const imgId = res.id || d.id || d.imageId || d.fileId || "";
    const w = d.width || d.w || "",
      h = d.height || d.h || "",
      size = d.size || d.filesize || "";
    const name = d.name || d.filename || file.name || "";
    // Render item in list
    try {
      var ul = document.getElementById("newsimage-area");
      if (ul) {
        var li = document.createElement("li");
        if (imgId) li.id = "newsimage-item-" + imgId;
        li.style.margin = "10px 0";
        li.style.backgroundColor = "#fff";
        var im = document.createElement("img");
        im.width = 50;
        im.height = 50;
        im.src = thumbUrl;
        li.appendChild(im);
        li.appendChild(document.createTextNode("\u00A0\u00A0"));
        var aT = document.createElement("a");
        aT.href = "#";
        aT.title = "Вставить миниатюру";
        aT.textContent = "Миниатюра";
        aT.addEventListener("click", function (ev) {
          ev.preventDefault();
          ngInsertBB('[img="' + thumbUrl + '"][/img]', areaId);
        });
        li.appendChild(document.createTextNode("["));
        li.appendChild(aT);
        li.appendChild(document.createTextNode("] "));
        var aF = document.createElement("a");
        aF.href = "#";
        aF.title = "Вставить изображение";
        aF.textContent = "Картинка";
        aF.addEventListener("click", function (ev) {
          ev.preventDefault();
          ngInsertBB('[img="' + fullUrl + '"][/img]', areaId);
        });
        li.appendChild(document.createTextNode("["));
        li.appendChild(aF);
        li.appendChild(document.createTextNode("] - "));
        var metaText = "";
        if (w && h) metaText += "[" + w + "x" + h;
        if (size) metaText += (metaText ? ", " : "[") + String(size);
        if (metaText) metaText += " ]";
        li.appendChild(
          document.createTextNode(name + (metaText ? " " + metaText : ""))
        );
        if (imgId) {
          li.appendChild(document.createTextNode("  "));
          var del = document.createElement("a");
          del.href = "#";
          del.className = "btn btn-sm btn-danger";
          del.innerHTML = '<i class="fa fa-trash"></i>';
          del.addEventListener("click", function (ev) {
            ev.preventDefault();
            deleteUploadedImage(String(imgId));
          });
          li.appendChild(del);
        }
        ul.prepend(li);
      }
    } catch (e) {}
    // optional resolve
    try {
      let resolved = { url: fullUrl, thumb: thumbUrl };
      const got = await resolveUrlById(imgId);
      if (!resolved.url && got && got.url) resolved.url = got.url;
      if (!resolved.thumb && got && got.thumb) resolved.thumb = got.thumb;
    } catch (e) {}
  }
  async function uploadNewsImage(areaId) {
    try {
      try {
        if (
          !areaId &&
          typeof window.__editorAreaId !== "undefined" &&
          window.__editorAreaId
        ) {
          areaId = window.__editorAreaId;
        }
      } catch (e) {}
      areaId = areaId || guessAreaId();
      const input = document.getElementById("uploadimage");
      if (!input || !input.files || !input.files[0]) {
        notifyMsg("Выберите файл изображения", "warning");
        return false;
      }
      notifyMsg("Загрузка изображения...", "info");
      await performImageUpload(input.files[0], areaId);
      notifyMsg("Изображение загружено", "success");
      return false;
    } catch (e) {
      notifyMsg("Исключение при загрузке: " + e, "danger");
      return false;
    }
  }
  window.uploadNewsImage = uploadNewsImage;
  async function resolveUrlById(id) {
    if (!id) return { url: "", thumb: "" };
    const base = String(NGCMS.admin_url || "/engine") + "/rpc.php?methodName=";
    const methods = [
      "admin.images.info",
      "admin.files.info",
      "admin.images.get",
      "admin.files.get",
      "admin.images.link",
      "admin.files.link",
    ];
    const fd = new FormData();
    fd.append("id", String(id));
    fd.append("json", "1");
    for (let i = 0; i < methods.length; i++) {
      try {
        const resp = await fetch(base + methods[i], {
          method: "POST",
          body: fd,
          credentials: "same-origin",
        });
        const text = await resp.text();
        let d = null;
        try {
          d = JSON.parse(text);
        } catch (_) {}
        if (d && (d.status === true || d.status === 1)) {
          let data = d.data || d.result || d.file || d.image || {};
          let url =
            data.url ||
            data.link ||
            data.fileurl ||
            data.full ||
            data.src ||
            "";
          let thumb =
            data.thumb || data.thumbUrl || data.thumb_url || data.preview || "";
          return {
            url: String(url || "").trim(),
            thumb: String(thumb || "").trim(),
          };
        }
      } catch (e) {}
    }
    return { url: "", thumb: "" };
  }

  async function deleteUploadedImage(id) {
    try {
      if (!id) {
        notifyMsg("ID изображения не получен", "warning");
        return false;
      }
      let ok = false,
        lastMsg = "";
      try {
        const baseRPC =
          String(NGCMS.admin_url || "/engine") + "/rpc.php?methodName=";
        const methods = [
          "admin.images.delete",
          "admin.files.delete",
          "admin.files.remove",
        ];
        const fd = new FormData();
        fd.append("id", String(id));
        fd.append("json", "1");
        for (let i = 0; i < methods.length && !ok; i++) {
          try {
            const resp = await fetch(baseRPC + methods[i], {
              method: "POST",
              body: fd,
              credentials: "same-origin",
            });
            const text = await resp.text();
            let data = null;
            try {
              data = JSON.parse(text);
            } catch (_) {}
            if (data && (data.status === true || data.status === 1)) {
              ok = true;
              break;
            }
            lastMsg =
              (data && (data.errorText || data.message)) || "Unknown response";
          } catch (e_) {
            lastMsg = String(e_);
          }
        }
      } catch (_) {}
      if (!ok) {
        try {
          const url =
            String(NGCMS.admin_url || "/engine") +
            "/admin.php?mod=images&subaction=delete";
          const f = new FormData();
          f.append("files[]", String(id));
          const resp = await fetch(url, {
            method: "POST",
            body: f,
            credentials: "same-origin",
          });
          if (resp && resp.ok) ok = true;
          else lastMsg = "HTTP " + (resp ? resp.status : "unknown");
        } catch (e__) {
          lastMsg = String(e__);
        }
      }
      if (ok) {
        try {
          var li = document.getElementById("newsimage-item-" + id);
          if (li && li.parentNode) li.parentNode.removeChild(li);
        } catch (e) {}
        notifyMsg("Изображение удалено", "success");
      } else {
        notifyMsg("Не удалось удалить изображение: " + lastMsg, "danger");
      }
    } catch (e) {
      notifyMsg("Ошибка удаления: " + e, "danger");
    }
    return false;
  }
  window.deleteUploadedImage = deleteUploadedImage;
  // URL modal helpers
  function prepareUrlModal(areaId) {
    try {
      document.getElementById("urlAreaId").value = areaId;
    } catch (e) {}
    var ta = null;
    try {
      ta = document.getElementById(areaId);
    } catch (e) {}
    if (!ta) return;
    var selText = "";
    if (
      typeof ta.selectionStart === "number" &&
      typeof ta.selectionEnd === "number"
    )
      selText = ta.value.substring(ta.selectionStart, ta.selectionEnd);
    else if (document.selection && document.selection.createRange) {
      ta.focus();
      var sel = document.selection.createRange();
      selText = sel.text || "";
    }
    var urlText = document.getElementById("urlText");
    var urlHref = document.getElementById("urlHref");
    if (urlText) urlText.value = selText || urlText.value || "";
    var looksLikeUrl = /^([a-z]+:\/\/|www\.|\/|#).+/i.test(selText.trim());
    if (looksLikeUrl && urlHref && !urlHref.value)
      urlHref.value = selText.trim();
  }
  function insertUrlFromModal() {
    var areaId = document.getElementById("urlAreaId").value || "";
    var href = (document.getElementById("urlHref").value || "").trim();
    var text = (document.getElementById("urlText").value || "").trim();
    var target = document.getElementById("urlTarget").value;
    var nofollow = document.getElementById("urlNofollow").checked;
    if (!href) {
      document.getElementById("urlHref").focus();
      return;
    }
    if (!/^([a-z]+:\/\/|\/|#|mailto:)/i.test(href)) href = "http://" + href;
    var attrs = '="' + href.replace(/"/g, "&quot;") + '"';
    if (target)
      attrs += ' target="' + target.replace(/[^_a-zA-Z0-9\-]/g, "") + '"';
    if (nofollow) attrs += ' rel="nofollow"';
    var bb = "[url" + attrs + "]" + (text || href) + "[/url]";
    insertAt(areaId, bb);
    try {
      if (window.jQuery) jQuery("#modal-insert-url").modal("hide");
    } catch (e) {
      var m = document.getElementById("modal-insert-url");
      if (m) {
        m.classList.remove("show");
        m.style.display = "none";
      }
    }
  }
  window.prepareUrlModal = prepareUrlModal;
  window.insertUrlFromModal = insertUrlFromModal;
  // Toolbar undo/redo
  function ngToolbarUndo(areaId) {
    try {
      if (typeof window.__ng_hist_flush === "function") {
        window.__ng_hist_flush(areaId);
      }
    } catch (e) {}
    try {
      if (
        typeof window.__ng_hist_undo === "function" &&
        window.__ng_hist_undo(areaId)
      )
        return;
    } catch (e) {}
    try {
      var ta = document.getElementById(areaId);
      if (ta) ta.focus();
    } catch (e) {}
  }
  function ngToolbarRedo(areaId) {
    try {
      if (typeof window.__ng_hist_flush === "function") {
        window.__ng_hist_flush(areaId);
      }
    } catch (e) {}
    try {
      if (
        typeof window.__ng_hist_redo === "function" &&
        window.__ng_hist_redo(areaId)
      )
        return;
    } catch (e) {}
    try {
      var ta = document.getElementById(areaId);
      if (ta) ta.focus();
    } catch (e) {}
  }
  window.ngToolbarUndo = ngToolbarUndo;
  window.ngToolbarRedo = ngToolbarRedo;
  // Simple textarea history
  (function () {
    var MAX_DEPTH = 100;
    var maps = {};
    var timers = {};
    function getId(areaId) {
      try {
        if (typeof areaId === "string") return areaId;
        if (areaId && typeof areaId === "object") {
          if (areaId.id) return String(areaId.id);
          if (areaId.getAttribute) {
            var aid = areaId.getAttribute("id");
            if (aid) return String(aid);
          }
        }
        if (typeof areaId === "number") return String(areaId);
      } catch (e) {}
      return "content";
    }
    function getEl(id) {
      try {
        return document.getElementById(id);
      } catch (e) {
        return null;
      }
    }
    function getMap(id) {
      if (!maps[id])
        maps[id] = { stack: [], index: -1, attached: false, lock: false };
      return maps[id];
    }
    function snapshot(el) {
      var v = String(el && el.value != null ? el.value : "");
      var s = 0,
        e = 0;
      try {
        if (
          typeof el.selectionStart === "number" &&
          typeof el.selectionEnd === "number"
        ) {
          s = el.selectionStart;
          e = el.selectionEnd;
        }
      } catch (e_) {}
      return { v: v, s: s, e: e };
    }
    function applyState(el, st) {
      if (!el || !st) return;
      try {
        maps[el.id] && (maps[el.id].lock = true);
      } catch (e) {}
      el.value = st.v;
      try {
        if (
          typeof el.selectionStart === "number" &&
          typeof el.selectionEnd === "number"
        ) {
          el.selectionStart = st.s;
          el.selectionEnd = st.e;
        }
      } catch (e_) {}
      try {
        el.focus();
      } catch (e) {}
      setTimeout(function () {
        try {
          maps[el.id] && (maps[el.id].lock = false);
        } catch (e) {}
      }, 0);
    }
    function push(id) {
      id = getId(id);
      var el = getEl(id);
      if (!el) return false;
      var m = getMap(id);
      var st = snapshot(el);
      var top = m.stack[m.index] || null;
      if (top && top.v === st.v) return false;
      if (m.index < m.stack.length - 1) m.stack = m.stack.slice(0, m.index + 1);
      m.stack.push(st);
      if (m.stack.length > MAX_DEPTH) m.stack.shift();
      m.index = m.stack.length - 1;
      return true;
    }
    function attach(id) {
      id = getId(id);
      var el = getEl(id);
      if (!el) return;
      var m = getMap(id);
      if (m.attached) return;
      m.attached = true;
      push(id);
      var handler = function () {
        if (m.lock) return;
        if (timers[id]) clearTimeout(timers[id]);
        timers[id] = setTimeout(function () {
          push(id);
        }, 250);
      };
      el.addEventListener("input", handler);
      el.addEventListener("change", handler);
      el.addEventListener("paste", function () {
        if (!m.lock) {
          if (timers[id]) clearTimeout(timers[id]);
          timers[id] = setTimeout(function () {
            push(id);
          }, 50);
        }
      });
      el.addEventListener("drop", function () {
        if (!m.lock) {
          if (timers[id]) clearTimeout(timers[id]);
          timers[id] = setTimeout(function () {
            push(id);
          }, 50);
        }
      });
      el.addEventListener("blur", function () {
        if (!m.lock) push(id);
      });
      el.addEventListener("keyup", function (e) {
        if (m.lock) return;
        var k = e && e.key;
        if (k === "Enter" || k === "Backspace" || k === "Delete") {
          if (timers[id]) clearTimeout(timers[id]);
          timers[id] = setTimeout(function () {
            push(id);
          }, 100);
        }
      });
    }
    function undo(id) {
      id = getId(id);
      var el = getEl(id);
      if (!el) return false;
      var m = getMap(id);
      if (!m.attached) attach(id);
      if (m.index <= 0) return false;
      m.index--;
      applyState(el, m.stack[m.index]);
      return true;
    }
    function redo(id) {
      id = getId(id);
      var el = getEl(id);
      if (!el) return false;
      var m = getMap(id);
      if (!m.attached) attach(id);
      if (m.index >= m.stack.length - 1) return false;
      m.index++;
      applyState(el, m.stack[m.index]);
      return true;
    }
    window.__ng_hist_attach = attach;
    window.__ng_hist_push = push;
    window.__ng_hist_undo = undo;
    window.__ng_hist_redo = redo;
    window.__ng_hist_flush = function (id) {
      id = getId(id);
      var el = getEl(id);
      if (!el) return false;
      attach(id);
      if (timers[id]) {
        try {
          clearTimeout(timers[id]);
        } catch (e) {}
        timers[id] = null;
      }
      return push(id);
    };
    try {
      document.addEventListener(
        "focusin",
        function (ev) {
          try {
            var t = ev && ev.target;
            if (t && t.tagName === "TEXTAREA" && t.id) {
              attach(t.id);
            }
          } catch (e) {}
        },
        true
      );
    } catch (e) {}
    try {
      var __el0 = document.getElementById("content");
      if (__el0) attach("content");
    } catch (e) {}
  })();
  // Email modal
  function prepareEmailModal(areaId) {
    try {
      document.getElementById("emailAreaId").value = areaId;
    } catch (e) {}
    var ta = null;
    try {
      ta = document.getElementById(areaId);
    } catch (e) {}
    if (!ta) return;
    var selText = "";
    if (
      typeof ta.selectionStart === "number" &&
      typeof ta.selectionEnd === "number"
    )
      selText = ta.value.substring(ta.selectionStart, ta.selectionEnd);
    else if (document.selection && document.selection.createRange) {
      ta.focus();
      var sel = document.selection.createRange();
      selText = sel.text || "";
    }
    var emailField = document.getElementById("emailAddress");
    var textField = document.getElementById("emailText");
    var looksLikeEmail = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,20}$/i.test(
      selText.trim()
    );
    if (looksLikeEmail) {
      if (emailField && !emailField.value) emailField.value = selText.trim();
      if (textField && !textField.value) textField.value = selText.trim();
    } else {
      if (textField) textField.value = selText || textField.value || "";
    }
  }
  function insertEmailFromModal() {
    var areaId = document.getElementById("emailAreaId").value || "";
    var email = (document.getElementById("emailAddress").value || "").trim();
    var text = (document.getElementById("emailText").value || "").trim();
    if (!email || email.indexOf("@") === -1) {
      document.getElementById("emailAddress").focus();
      return;
    }
    if (!text) text = email;
    var bb =
      text === email
        ? "[email]" + email + "[/email]"
        : '[email="' + email.replace(/"/g, "&quot;") + '"]' + text + "[/email]";
    insertAt(areaId, bb);
    try {
      if (window.jQuery) jQuery("#modal-insert-email").modal("hide");
    } catch (e) {
      var m = document.getElementById("modal-insert-email");
      if (m) {
        m.classList.remove("show");
        m.style.display = "none";
      }
    }
  }
  window.prepareEmailModal = prepareEmailModal;
  window.insertEmailFromModal = insertEmailFromModal;
  // Image modal
  function prepareImgModal(areaId) {
    try {
      document.getElementById("imgAreaId").value = areaId;
    } catch (e) {}
    var ta = null;
    try {
      ta = document.getElementById(areaId);
    } catch (e) {}
    if (!ta) return;
    var selText = "";
    if (
      typeof ta.selectionStart === "number" &&
      typeof ta.selectionEnd === "number"
    )
      selText = ta.value.substring(ta.selectionStart, ta.selectionEnd);
    else if (document.selection && document.selection.createRange) {
      ta.focus();
      var sel = document.selection.createRange();
      selText = sel.text || "";
    }
    var hrefField = document.getElementById("imgHref");
    var altField = document.getElementById("imgAlt");
    var looksLikeImg =
      /^((https?:\/\/|ftp:\/\/|\/).+)\.(jpg|jpeg|png|gif|webp|svg)(\?.*)?$/i.test(
        selText.trim()
      );
    if (looksLikeImg && hrefField && !hrefField.value)
      hrefField.value = selText.trim();
    if (altField && !looksLikeImg)
      altField.value = selText || altField.value || "";
  }
  function insertImgFromModal() {
    var areaId = document.getElementById("imgAreaId").value || "";
    var href = (document.getElementById("imgHref").value || "").trim();
    var alt = (document.getElementById("imgAlt").value || "").trim();
    var width = (document.getElementById("imgWidth").value || "").trim();
    var height = (document.getElementById("imgHeight").value || "").trim();
    var align = document.getElementById("imgAlign").value;
    if (!href) {
      document.getElementById("imgHref").focus();
      return;
    }
    if (!/^((https?:\/\/|ftp:\/\/)|\/|#)/i.test(href)) href = "http://" + href;
    var attrs = '="' + href.replace(/"/g, "&quot;") + '"';
    if (width) attrs += ' width="' + width.replace(/[^0-9]/g, "") + '"';
    if (height) attrs += ' height="' + height.replace(/[^0-9]/g, "") + '"';
    if (align)
      attrs += ' align="' + align.replace(/[^a-z]/gi, "").toLowerCase() + '"';
    var bb = "[img" + attrs + "]" + (alt || "") + "[/img]";
    insertAt(areaId, bb);
    try {
      if (window.jQuery) jQuery("#modal-insert-image").modal("hide");
    } catch (e) {
      var m = document.getElementById("modal-insert-image");
      if (m) {
        m.classList.remove("show");
        m.style.display = "none";
      }
    }
  }
  window.prepareImgModal = prepareImgModal;
  window.insertImgFromModal = insertImgFromModal;
  // Media modal
  function prepareMediaModal(areaId) {
    try {
      document.getElementById("mediaAreaId").value = areaId;
    } catch (e) {}
    var ta = null;
    try {
      ta = document.getElementById(areaId);
    } catch (e) {}
    if (!ta) return;
    var selText = "";
    if (
      typeof ta.selectionStart === "number" &&
      typeof ta.selectionEnd === "number"
    )
      selText = ta.value.substring(ta.selectionStart, ta.selectionEnd);
    else if (document.selection && document.selection.createRange) {
      ta.focus();
      var sel = document.selection.createRange();
      selText = sel.text || "";
    }
    var hrefField = document.getElementById("mediaHref");
    if (hrefField && !hrefField.value) hrefField.value = selText.trim();
  }
  function insertMediaFromModal() {
    var areaId = document.getElementById("mediaAreaId").value || "";
    var href = (document.getElementById("mediaHref").value || "").trim();
    var w = (document.getElementById("mediaWidth").value || "").trim();
    var h = (document.getElementById("mediaHeight").value || "").trim();
    var p = (document.getElementById("mediaPreview").value || "").trim();
    if (!href) {
      document.getElementById("mediaHref").focus();
      return;
    }
    var attrs = "";
    if (w) attrs += ' width="' + w.replace(/[^0-9]/g, "") + '"';
    if (h) attrs += ' height="' + h.replace(/[^0-9]/g, "") + '"';
    if (p) attrs += ' preview="' + p.replace(/"/g, "&quot;") + '"';
    var bb = attrs
      ? "[media" + attrs + "]" + href + "[/media]"
      : "[media]" + href + "[/media]";
    insertAt(areaId, bb);
    try {
      if (window.jQuery) jQuery("#modal-insert-media").modal("hide");
    } catch (e) {
      var m = document.getElementById("modal-insert-media");
      if (m) {
        m.classList.remove("show");
        m.style.display = "none";
      }
    }
  }
  window.prepareMediaModal = prepareMediaModal;
  window.insertMediaFromModal = insertMediaFromModal;
  // Prompt-based media inserter (legacy skins)
  async function performFileUpload(file, areaId) {
    // По умолчанию: случайное имя выключено (имя + хеш делает сервер)
    var randFileEl = document.getElementById("fileRandomTitle");
    const rand = randFileEl ? (randFileEl.checked ? 1 : 0) : 0;
    const res = await rpcUpload(file, {
      type: "file",
      rand,
      replace: 0,
      stamp: 1,
    });
    if (!res.ok) throw new Error(res.errorText || "Ошибка загрузки");
    const d = res.data || {};
    const fname = (
      d.name ||
      d.filename ||
      (file && file.name) ||
      ""
    ).toString();
    var baseFiles = String(NGCMS.files_url || "/uploads/files");
    if (baseFiles && !/\/$/.test(baseFiles)) baseFiles += "/";
    var cat = String(d.category || d.folder || "").replace(/^\/+|\/+$/g, "");
    if (cat) cat += "/";
    let link = String(res.url || "").trim();
    if (!link && fname) link = baseFiles + cat + fname;
    if (!link) throw new Error("Файл загружен, но URL не получен от сервера");
    const text = file.name || "файл";
    const bb =
      '[url="' +
      link.replace(/"/g, "&quot;") +
      '"]' +
      text.replace(/[\[\]]/g, "") +
      "[/url]";
    insertAt(areaId, bb);
    try {
      var ul = document.getElementById("newsfile-area");
      if (ul) {
        var li = document.createElement("li");
        li.innerHTML =
          '<a href="' + link + '" target="_blank">' + link + "</a>";
        ul.prepend(li);
      }
    } catch (e) {}
  }
  async function uploadNewsFile(areaId) {
    try {
      try {
        if (
          !areaId &&
          typeof window.__editorAreaId !== "undefined" &&
          window.__editorAreaId
        ) {
          areaId = window.__editorAreaId;
        }
      } catch (e) {}
      areaId = areaId || guessAreaId();
      const input = document.getElementById("uploadfile");
      if (!input || !input.files || !input.files[0]) {
        notifyMsg("Выберите файл", "warning");
        return false;
      }
      notifyMsg("Загрузка файла...", "info");
      await performFileUpload(input.files[0], areaId);
      try {
        if (window.jQuery) jQuery("#modal-uplimg").modal("hide");
      } catch (e) {
        var m = document.getElementById("modal-uplimg");
        if (m) {
          m.classList.remove("show");
          m.style.display = "none";
        }
      }
      notifyMsg("Файл загружен", "success");
    } catch (e) {
      notifyMsg("Исключение при загрузке: " + e, "danger");
    }
    return false;
  }
  window.uploadNewsFile = uploadNewsFile;

  // Drag & Drop zones
  function attachDropzone(el, kind) {
    if (!el) return;
    var over = function (e) {
      try {
        e.preventDefault();
        e.stopPropagation();
      } catch (_) {}
      try {
        el.classList.add("ng-dropzone-over");
      } catch (_) {}
    };
    var leave = function (e) {
      try {
        e.preventDefault();
        e.stopPropagation();
      } catch (_) {}
      try {
        el.classList.remove("ng-dropzone-over");
      } catch (_) {}
    };
    var drop = async function (e) {
      try {
        e.preventDefault();
        e.stopPropagation();
      } catch (_) {}
      try {
        el.classList.remove("ng-dropzone-over");
      } catch (_) {}
      var dt =
        e.dataTransfer || (e.originalEvent && e.originalEvent.dataTransfer);
      if (!dt || !dt.files || !dt.files.length) return;
      var files = Array.prototype.slice.call(dt.files);
      var areaId = null;
      try {
        if (
          typeof window.__editorAreaId !== "undefined" &&
          window.__editorAreaId
        )
          areaId = window.__editorAreaId;
      } catch (_) {}
      if (!areaId) areaId = guessAreaId();
      var total = files.length,
        ok = 0,
        fail = 0;
      notifyMsg("Загрузка " + total + " файл(ов)...", "info");
      for (var i = 0; i < files.length; i++) {
        var f = files[i];
        try {
          if (kind === "image") {
            if (f && f.type && !/^image\//i.test(f.type)) {
              fail++;
              continue;
            }
            await performImageUpload(f, areaId);
          } else {
            await performFileUpload(f, areaId);
          }
          ok++;
        } catch (err) {
          fail++;
        }
      }
      if (ok && !fail)
        notifyMsg("Готово: " + ok + " файл(ов) загружено", "success");
      else if (ok && fail)
        notifyMsg("Загружено: " + ok + ", не удалось: " + fail, "warning");
      else notifyMsg("Не удалось загрузить файлы", "danger");
    };
    try {
      el.addEventListener("dragenter", over);
      el.addEventListener("dragover", over);
      el.addEventListener("dragleave", leave);
      el.addEventListener("drop", drop);
      el.addEventListener("dragend", leave);
    } catch (e) {}
  }
  try {
    document.addEventListener("DOMContentLoaded", function () {
      var nodes = document.querySelectorAll("[data-ng-dropzone]");
      for (var i = 0; i < nodes.length; i++) {
        var kind = nodes[i].getAttribute("data-ng-dropzone");
        attachDropzone(nodes[i], kind === "image" ? "image" : "file");
      }
    });
  } catch (e) {}
  // Acronym modal
  function prepareAcronymModal(areaId) {
    try {
      document.getElementById("acronymAreaId").value = areaId || "";
    } catch (e) {}
  }
  function insertAcronymFromModal() {
    var title = (document.getElementById("acronymTitle").value || "")
      .replace(/\]/g, ")")
      .trim();
    if (title === "") {
      document.getElementById("acronymTitle").focus();
      return;
    }
    var aid = document.getElementById("acronymAreaId").value || "";
    window.insertext("[acronym=" + title + "]", "[/acronym]", aid);
    try {
      if (window.jQuery) jQuery("#modal-insert-acronym").modal("hide");
    } catch (e) {
      var m = document.getElementById("modal-insert-acronym");
      if (m) {
        m.classList.remove("show");
        m.style.display = "none";
      }
    }
  }
  window.prepareAcronymModal = prepareAcronymModal;
  window.insertAcronymFromModal = insertAcronymFromModal;
  // Code modal
  function prepareCodeModal(areaId) {
    try {
      document.getElementById("codeAreaId").value = areaId || "";
    } catch (e) {}
  }
  function insertCodeFromModal() {
    var lang = (document.getElementById("codeLang").value || "").trim();
    var aid = document.getElementById("codeAreaId").value || "";
    window.insertext("[code" + (lang ? "=" + lang : "") + "]", "[/code]", aid);
    try {
      if (window.jQuery) jQuery("#modal-insert-code").modal("hide");
    } catch (e) {
      var m = document.getElementById("modal-insert-code");
      if (m) {
        m.classList.remove("show");
        m.style.display = "none";
      }
    }
  }
  window.prepareCodeModal = prepareCodeModal;
  window.insertCodeFromModal = insertCodeFromModal;
  // Code brush helper
  function insertCodeBrush(alias, areaId) {
    try {
      if (!alias) return;
    } catch (e) {}
    var a = String(alias || "").toLowerCase();
    var map = {
      html: "xml",
      xhtml: "xml",
      xml: "xml",
      javascript: "js",
      node: "js",
      js: "js",
      "c#": "csharp",
      csharp: "csharp",
      cs: "csharp",
      "c++": "cpp",
      cpp: "cpp",
      c: "cpp",
      text: "plain",
      plain: "plain",
      txt: "plain",
      mysql: "sql",
      mariadb: "sql",
      pgsql: "sql",
      postgres: "sql",
    };
    var lang = map[a] || a;
    var el = null;
    try {
      el = document.getElementById(areaId);
    } catch (e) {}
    if (!el) {
      window.insertext("[code=" + lang + "]", "[/code]", areaId);
      return;
    }
    var start = 0,
      end = 0,
      selected = "";
    if (
      typeof el.selectionStart === "number" &&
      typeof el.selectionEnd === "number"
    ) {
      start = el.selectionStart;
      end = el.selectionEnd;
      selected = el.value.substring(start, end);
    } else if (document.selection && document.selection.createRange) {
      el.focus();
      var sel = document.selection.createRange();
      selected = sel.text || "";
    }
    var selStr = String(selected);
    var reBlock = /^\[code(?:=[^\]]+)?\]([\s\S]*?)\[\/code\]$/i;
    if (selStr && reBlock.test(selStr)) {
      var inner = selStr
        .replace(/^\[code(?:=[^\]]+)?\]/i, "")
        .replace(/\[\/code\]$/i, "");
      var replacement = "[code=" + lang + "]" + inner + "[/code]";
      if (document.selection && document.selection.createRange) {
        var r = document.selection.createRange();
        r.text = replacement;
      } else if (
        typeof el.selectionStart === "number" &&
        typeof el.selectionEnd === "number"
      ) {
        var scroll = el.scrollTop;
        el.value =
          el.value.substring(0, start) + replacement + el.value.substring(end);
        el.selectionStart = el.selectionEnd = start + replacement.length;
        el.scrollTop = scroll;
      } else {
        el.value += replacement;
      }
      return;
    }
    window.insertext("[code=" + lang + "]", "[/code]", areaId);
  }
  window.insertCodeBrush = window.insertCodeBrush || insertCodeBrush;
  // Legacy Bootstrap 3 combined modal (#modal-url) handler (skin default2)
  try {
    document.addEventListener("DOMContentLoaded", function () {
      var submit = document.getElementById("modal-url-submit");
      var modal = document.getElementById("modal-url");
      if (!submit || !modal) return;
      var handler = function (ev) {
        try {
          // Prefer explicit area id if set by opener
          var areaId = null;
          try {
            if (
              typeof window.__editorAreaId !== "undefined" &&
              window.__editorAreaId
            ) {
              areaId = window.__editorAreaId;
            }
          } catch (e) {}
          if (!areaId) areaId = guessAreaId();
          // Determine active tab pane
          var panes = modal.querySelectorAll(".tab-pane");
          var active = null;
          for (var i = 0; i < panes.length; i++) {
            if (panes[i].classList.contains("active")) {
              active = panes[i];
              break;
            }
          }
          var activeId = active ? active.id : "";
          // Build BBCode per tab
          if (activeId === "tags-link") {
            var href = (
              document.getElementById("modal-url-1").value || ""
            ).trim();
            var text = (
              document.getElementById("modal-url-2").value || ""
            ).trim();
            var targetLink = document.getElementById("modal-url-3").checked
              ? ' target="_blank"'
              : "";
            if (!text) text = href;
            var bb = "[url=" + href + targetLink + "]" + text + "[/url]";
            insertAt(areaId, bb);
          } else if (activeId === "tags-email") {
            var email = (
              document.getElementById("modal-email-1").value || ""
            ).trim();
            var etext = (
              document.getElementById("modal-email-2").value || ""
            ).trim();
            if (!etext) etext = email;
            var ebb = "[email=" + email + "]" + etext + "[/email]";
            insertAt(areaId, ebb);
          } else if (activeId === "tags-img-url") {
            var iurl = (
              document.getElementById("modal-img-url-1").value || ""
            ).trim();
            var ialt = (
              document.getElementById("modal-img-url-2").value || ""
            ).trim();
            var iw = (
              document.getElementById("modal-img-url-3").value || ""
            ).trim();
            var ih = (
              document.getElementById("modal-img-url-4").value || ""
            ).trim();
            var ia = (
              document.getElementById("modal-img-url-5").value || "0"
            ).trim();
            var ic = (
              document.getElementById("modal-img-url-6").value || ""
            ).trim();
            var iattrs = "";
            if (iw) iattrs += ' width="' + iw + '"';
            if (ih) iattrs += ' height="' + ih + '"';
            if (ia && ia !== "0") iattrs += ' align="' + ia + '"';
            if (ic) iattrs += ' class="' + ic.replace(/"/g, "&quot;") + '"';
            var ibb = "[img=" + iurl + iattrs + "]" + ialt + "[/img]";
            insertAt(areaId, ibb);
          } else if (activeId === "tags-bbmedia") {
            var murl = (
              document.getElementById("modal-bbmedia-url-1").value || ""
            ).trim();
            var mw = (
              document.getElementById("modal-bbmedia-url-2").value || ""
            ).trim();
            var mh = (
              document.getElementById("modal-bbmedia-url-3").value || ""
            ).trim();
            var mp = (
              document.getElementById("modal-bbmedia-img-url-4").value || ""
            ).trim();
            var mattrs = "";
            if (mw) mattrs += ' width="' + mw + '"';
            if (mh) mattrs += ' height="' + mh + '"';
            if (mp) mattrs += ' preview="' + mp.replace(/"/g, "&quot;") + '"';
            var mbb = "[media " + mattrs.trim() + "]" + murl + "[/media]";
            insertAt(areaId, mbb);
          }
          // Hide modal
          try {
            if (window.jQuery) jQuery(modal).modal("hide");
          } catch (e) {
            modal.classList.remove("show");
            modal.style.display = "none";
          }
        } catch (e) {}
      };
      submit.addEventListener("click", handler);
    });
  } catch (e) {}
})();
