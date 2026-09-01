(function () {
  "use strict";
  if (document.getElementById("mb-week1-chrome-js")) return;

  var css = document.createElement("style");
  css.id = "mb-week1-chrome-js";
  css.textContent = [
    ":root{--mb-accent:#0d9488;--mb-bg:#f4f6f5;--mb-ink:#1a2332;--mb-muted:#5c6b7a;--mb-border:#e4e9ec;--mb-hover:#0f766e;--mb-soft:#ecfdf8;--mb-faint:#8a97a5;--mb-card:#fff}",
    "body{background:var(--mb-bg)!important;color:var(--mb-ink)}",
    "#cont.hero,#cont{background-image:none!important;background:var(--mb-bg)!important}",
    "#cont .hero-overlay{opacity:0!important}",
    ".navbar.bg-secondary{background:#fff!important;border:1px solid var(--mb-border);color:var(--mb-ink)}",
    "#progbar{color:var(--mb-ink)!important;background:#fff}",
    ".absolute.bottom-0.fixed.pb-8{padding-bottom:5.5rem!important}",
    "#app{font-size:.7rem!important;opacity:.85;background:transparent!important;border:1px solid var(--mb-border)!important;color:var(--mb-muted)!important;box-shadow:none!important}",
    "#app a{color:var(--mb-faint)!important;text-decoration:none}",
    ".mb-feedback-rail{z-index:30!important;position:fixed!important;top:4.75rem!important;left:.5rem!important;bottom:auto!important;margin:0!important;padding:.25rem!important;display:flex;flex-direction:column;gap:.15rem}",
    ".mb-feedback-rail a div{font-size:.7rem!important;font-weight:600;opacity:.8}",
    "label[for='modal-tips'] > div{bottom:auto!important;top:4.75rem!important;right:.5rem!important;font-size:.7rem!important}",
    "#mb-founder-unlock{max-width:420px;margin:1rem auto 2rem;padding:0 1rem}",
    "#mb-founder-unlock .card{background:var(--mb-card);border:1px solid var(--mb-border);border-radius:16px;padding:16px 18px;text-align:left;font-family:Inter,system-ui,sans-serif}",
    "#mb-founder-unlock h2{font-size:15px;font-weight:650;margin:0 0 4px;color:var(--mb-ink)}",
    "#mb-founder-unlock p{font-size:13px;color:var(--mb-muted);margin:0 0 12px;line-height:1.45}",
    "#mb-founder-unlock a{display:inline-flex;padding:10px 14px;border-radius:10px;border:1px solid var(--mb-border);background:var(--mb-soft);color:var(--mb-hover);font-size:13.5px;font-weight:600;text-decoration:none}",
    "#mb-founder-unlock a:hover{border-color:var(--mb-accent)}",
    "@media (max-width:440px){.absolute.bottom-0.fixed.pb-8{padding-bottom:6.5rem!important}.mb-feedback-rail{top:4.5rem!important}}"
  ].join("");
  document.head.appendChild(css);

  var cont = document.getElementById("cont");
  if (cont) {
    cont.style.backgroundImage = "none";
    cont.style.backgroundColor = "#f4f6f5";
  }

  var feedback = Array.prototype.find.call(document.querySelectorAll("div.fixed"), function (el) {
    return /Feedback/i.test(el.textContent || "") && el.className.indexOf("bottom-0") !== -1;
  });
  if (feedback) {
    feedback.className = "mb-feedback-rail";
    feedback.setAttribute("aria-label", "Feedback and support");
  }

  var app = document.getElementById("app");
  if (app) {
    app.setAttribute("aria-label", "iOS waitlist");
    app.setAttribute("title", "iOS waitlist");
    var appLink = app.querySelector("a");
    if (appLink) {
      appLink.textContent = "iOS waitlist";
      appLink.setAttribute("href", "app.html");
      appLink.removeAttribute("target");
    }
  }

  function label(el, text) {
    if (!el) return;
    el.setAttribute("aria-label", text);
    if (!el.getAttribute("title")) el.setAttribute("title", text);
  }
  label(document.getElementById("focusModeCheckBox"), "Focus exercise");
  label(document.getElementById("breathingModeCheckBox"), "Breathing exercise");
  label(document.getElementById("audioToggleCheckBox"), "Sound");
  label(document.getElementById("stop"), "Pause");
  label(document.getElementById("para"), "Start");
  label(document.getElementById("reset"), "Reset");
  var settings = document.querySelector("label[for='modal-settings']");
  if (settings) label(settings, "Settings");
  document.querySelectorAll('button[onclick="toggleFullScreen()"]').forEach(function (b) {
    label(b, "Fullscreen");
  });
  var breathBtn = document.querySelector('label[for="modal-breaths"]');
  if (breathBtn) label(breathBtn, "Breathing exercise");
  if (breathBtn && breathBtn.parentElement && breathBtn.parentElement.tagName === "BUTTON") {
    label(breathBtn.parentElement, "Breathing exercise");
  }

  var how = document.getElementById("howitworks");
  if (how) {
    how.innerHTML = how.innerHTML
      .replace(/10-20x/gi, "~10s")
      .replace(/10–20×/g, "~10s")
      .replace(/95%\s*of learning done in rest/gi, "when the brain can replay what you just practiced")
      .replace(/of learning done in rest/gi, "when the brain can replay what you just practiced");
    var benefitP = Array.prototype.find.call(how.querySelectorAll("p"), function (p) {
      return /benefits in a research setting/i.test(p.textContent || "");
    });
    if (benefitP) {
      benefitP.textContent = "Claim-safe framing from motor-skill rest/replay studies (not a personal guarantee):";
    }
  }

  if (!document.getElementById("mb-founder-unlock") && !document.getElementById("founder-unlock")) {
    var aside = document.createElement("aside");
    aside.id = "mb-founder-unlock";
    aside.setAttribute("aria-label", "Founder unlock");
    aside.innerHTML =
      '<div class="card"><h2>Founder unlock — $12</h2><p>Early iOS access + supporters credit when Pro ships. Web timer stays free.</p><a href="https://buy.stripe.com/dRmeVc4WccRL6JC9NveAg07">Unlock early access — $12</a></div>';
    var marker = document.getElementById("howitworks");
    if (marker && marker.parentNode) marker.parentNode.insertBefore(aside, marker.nextSibling);
    else document.body.appendChild(aside);
  }
})();
