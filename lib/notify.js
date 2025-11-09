// Lightweight toast implementation (vanilla JS), shared for frontend
(function () {
  function ensureContainer() {
    var c = document.querySelector(".ngt-toast__container");
    if (!c) {
      c = document.createElement("div");
      c.className = "ngt-toast__container";
      document.body.appendChild(c);
    }
    return c;
  }
  function iconSVG(variant) {
    var colors = {
      blue: "#2c7bd1",
      green: "#239c58",
      red: "#c0392b",
      orange: "#c87f0a",
    };
    var color = colors[variant] || colors.blue;
    if (variant === "green") {
      return (
        '<svg class="ngt-toast__svg" viewBox="0 0 24 24" aria-hidden="true"><path fill="' +
        color +
        '" d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm-1 13.2-3.2-3.2 1.4-1.4L11 12.6l4.8-4.8 1.4 1.4L11 15.2z"/></svg>'
      );
    } else if (variant === "red") {
      return (
        '<svg class="ngt-toast__svg" viewBox="0 0 24 24" aria-hidden="true"><path fill="' +
        color +
        '" d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm-1 5h2v7h-2V7zm0 9h2v2h-2v-2z"/></svg>'
      );
    } else if (variant === "orange") {
      return (
        '<svg class="ngt-toast__svg" viewBox="0 0 24 24" aria-hidden="true"><path fill="' +
        color +
        '" d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>'
      );
    }
    return (
      '<svg class="ngt-toast__svg" viewBox="0 0 24 24" aria-hidden="true"><path fill="' +
      color +
      '" d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>'
    );
  }
  function removeToast(el) {
    if (!el) return;
    el.classList.remove("ngt-toast--show");
    el.classList.add("ngt-toast--hide");
    el.addEventListener("transitionend", function onEnd() {
      el.removeEventListener("transitionend", onEnd);
      if (el && el.parentNode) {
        el.parentNode.removeChild(el);
      }
    });
  }
  function showToast(message, options) {
    var opts = Object.assign(
      { title: "", type: "info", sticked: false, timeout: 5000 },
      options || {}
    );
    var variant = (function (t) {
      if (t === "success") return "green";
      if (t === "error" || t === "danger") return "red";
      if (t === "warning") return "orange";
      return "blue";
    })(opts.type);
    var container = ensureContainer();
    var toast = document.createElement("div");
    toast.className = "ngt-toast ngt-toast--" + variant;
    toast.setAttribute("role", "status");
    toast.setAttribute("aria-live", "polite");
    var html =
      "" +
      '<div class="ngt-toast__icon">' +
      iconSVG(variant) +
      "</div>" +
      '<div class="ngt-toast__content">' +
      (opts.title ? '<p class="ngt-toast__type">' + opts.title + "</p>" : "") +
      '<p class="ngt-toast__message">' +
      message +
      "</p>" +
      "</div>" +
      '<button type="button" class="ngt-toast__close" aria-label="Close">' +
      '<svg width="16" height="16" viewBox="0 0 16 16" aria-hidden="true"><path d="M3 3l10 10M13 3L3 13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>' +
      "</button>";
    toast.innerHTML = html;
    var closeBtn = toast.querySelector(".ngt-toast__close");
    closeBtn.addEventListener("click", function (e) {
      e.preventDefault();
      removeToast(toast);
    });
    container.appendChild(toast);
    requestAnimationFrame(function () {
      toast.classList.add("ngt-toast--show");
    });
    var hideTimer = null;
    if (!opts.sticked) {
      hideTimer = setTimeout(function () {
        removeToast(toast);
      }, opts.timeout);
    }
    toast.addEventListener("mouseenter", function () {
      if (hideTimer) {
        clearTimeout(hideTimer);
        hideTimer = null;
      }
    });
    toast.addEventListener("mouseleave", function () {
      if (!opts.sticked && !hideTimer) {
        hideTimer = setTimeout(function () {
          removeToast(toast);
        }, 1500);
      }
    });
    return toast;
  }
  window.showToast = showToast;
})();
