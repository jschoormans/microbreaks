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
    "#app{font-size:13px!important;opacity:.85;background:transparent!important;border:1px solid var(--mb-border)!important;color:var(--mb-muted)!important;box-shadow:none!important}",
    "#app a{color:var(--mb-muted)!important;text-decoration:none;font-size:13px}",
    ".mb-feedback-rail{z-index:30!important;position:fixed!important;top:4.75rem!important;left:.5rem!important;bottom:auto!important;margin:0!important;padding:.25rem!important;display:flex;flex-direction:column;gap:.15rem}",
    ".mb-feedback-rail a div{font-size:.7rem!important;font-weight:600;opacity:.8}",
    "label[for='modal-tips'] > div{bottom:auto!important;top:4.75rem!important;right:.5rem!important;font-size:.7rem!important}",
    "#mb-founder-unlock{max-width:420px;margin:1rem auto 2rem;padding:0 1rem}",
    "#mb-founder-unlock .card{background:var(--mb-card);border:1px solid var(--mb-border);border-radius:16px;padding:16px 18px;text-align:left;font-family:Inter,system-ui,sans-serif}",
    "#mb-founder-unlock h2{font-size:15px;font-weight:650;margin:0 0 4px;color:var(--mb-ink)}",
    "#mb-founder-unlock p{font-size:13px;color:var(--mb-muted);margin:0 0 12px;line-height:1.45}",
    "#mb-founder-unlock a{display:inline-flex;padding:10px 14px;border-radius:10px;border:1px solid var(--mb-accent);background:var(--mb-accent);color:#fff;font-size:15px;font-weight:600;text-decoration:none}",
    "#mb-founder-unlock a:hover{border-color:var(--mb-accent)}",
    "@media (max-width:440px){.absolute.bottom-0.fixed.pb-8{padding-bottom:6.5rem!important}.mb-feedback-rail{top:4.5rem!important}}",
    "#howitworks .stats{display:flex!important;flex-direction:column!important;flex-wrap:wrap;width:100%!important;overflow:hidden!important}#howitworks .stat{width:100%!important;max-width:100%!important}@media (max-width:1023px){#howitworks .stat-figure{display:none!important}}@media (min-width:1024px){#howitworks .stats{flex-direction:row!important}}"
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
    var paras = how.querySelectorAll(".collapse-content > p, .collapse-content p");
    if (paras[0] && /tremendously|20 times|study material/i.test(paras[0].textContent || "")) {
      paras[0].innerHTML = "Short pauses between practice bouts, inspired by gap / micro-rest research. Research on skill practice found compressed neural replay during short waking rests (Buch et al., Cell Reports 2021). That's motor sequences in the lab — not a guarantee for every study session. Read more in our <b><a href=\"https://www.microbreaks.co/blog/public/posts/the-value-of-microbreaks/\">blog post</a></b>.";
    }
    var titles = how.querySelectorAll(".stat-title");
    var values = how.querySelectorAll(".stat-value");
    var descs = how.querySelectorAll(".stat-desc");
    if (titles[0]) titles[0].textContent = "Brief rests";
    if (values[0]) {
      values[0].textContent = "~10s";
      values[0].classList.add("text-xl", "leading-tight");
    }
    if (descs[0]) descs[0].textContent = "same timescale as motor-skill rest/replay studies";
    if (titles[1]) titles[1].textContent = "Between bouts";
    if (values[1]) {
      values[1].textContent = "Rest";
      values[1].classList.add("text-lg", "leading-tight");
    }
    if (descs[1]) descs[1].textContent = "when the brain can replay what you just practiced";
    var benefitP = Array.prototype.find.call(how.querySelectorAll("p"), function (p) {
      return /benefits in a research setting/i.test(p.textContent || "");
    });
    if (benefitP) {
      benefitP.textContent = "Claim-safe framing from motor-skill rest/replay studies (not a personal guarantee):";
    }
    var video = how.querySelector("h2.text-xl.font-bold, h2");
    if (video && /Check out this video/i.test(video.textContent || "") && !how.querySelector(".mb-trust")) {
      var trust = document.createElement("p");
      trust.className = "mb-trust";
      trust.textContent = "Inspired by peer-reviewed motor-skill rest/replay research (Buch et al., Cell Reports 2021). Not a medical device; results vary.";
      video.parentNode.insertBefore(trust, video);
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
