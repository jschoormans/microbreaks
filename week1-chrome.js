(function () {
  "use strict";
  if (document.getElementById("mb-week1-chrome-js")) return;

  var css = document.createElement("style");
  css.id = "mb-week1-chrome-js";
  css.textContent = [
    ":root{--mb-accent:#0d9488;--mb-bg:#f4f6f5;--mb-ink:#1a2332;--mb-muted:#5c6b7a;--mb-border:#e4e9ec;--mb-hover:#0f766e;--mb-soft:#ecfdf8;--mb-faint:#8a97a5;--mb-card:#fff}",
    "body{background:#0b1c24;color:var(--mb-ink)}",
    "#cont.hero,#cont{background-image:url(pic1.jpg)!important;background-size:cover!important;background-position:center!important;background-color:transparent!important}",
    "#cont .hero-overlay{opacity:.28!important;background:#0b1c24}",
    ".navbar.bg-secondary{background:rgba(255,255,255,.88)!important;backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px);border:1px solid rgba(255,255,255,.55);color:var(--mb-ink);box-shadow:0 4px 20px rgba(11,28,36,.18)}",
    "#progbar{color:var(--mb-ink)!important;background:rgba(255,255,255,.9)!important;box-shadow:0 4px 24px rgba(11,28,36,.2)}",
    ".absolute.bottom-0.fixed.pb-8{padding-bottom:5.5rem!important}",
    "#app{font-size:13px!important;opacity:.85;background:transparent!important;border:1px solid var(--mb-border)!important;color:var(--mb-muted)!important;box-shadow:none!important}",
    "#app a{color:var(--mb-muted)!important;text-decoration:none;font-size:13px}",
    ".mb-feedback-rail{z-index:30!important;position:fixed!important;top:4.75rem!important;left:.5rem!important;bottom:auto!important;margin:0!important;padding:.25rem!important;display:flex;flex-direction:column;gap:.15rem}",
    ".mb-feedback-rail a div{font-size:.7rem!important;font-weight:600;opacity:1;background:rgba(255,255,255,.88)!important;color:#1a2332!important;border-radius:10px;padding:6px 10px!important;border:1px solid rgba(228,233,236,.9)}",
    "label[for='modal-tips'] > div{bottom:auto!important;top:4.75rem!important;right:.5rem!important;font-size:.7rem!important;background:rgba(255,255,255,.88)!important;color:#1a2332!important;border-radius:10px;padding:6px 10px!important;border:1px solid rgba(228,233,236,.9)}",
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
    cont.style.setProperty("background-image", "url(pic1.jpg)", "important");
    cont.style.setProperty("background-size", "cover", "important");
    cont.style.setProperty("background-position", "center", "important");
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
    if (titles[0] && /10.?20|x faster|95%/i.test(titles[0].textContent || "")) titles[0].textContent = "Brief rests";
    if (values[0] && /10.?20|95%/.test(values[0].textContent || "")) {
      values[0].textContent = "~10s";
      values[0].classList.add("text-xl", "leading-tight");
    }
    if (descs[0] && /faster learning|guarantee/i.test(descs[0].textContent || "")) descs[0].textContent = "same timescale as motor-skill rest/replay studies";
    if (titles[1] && /10.?20|95%/i.test(titles[1].textContent || "")) titles[1].textContent = "Between bouts";
    if (values[1] && /10.?20|95%/.test(values[1].textContent || "")) {
      values[1].textContent = "Rest";
      values[1].classList.add("text-lg", "leading-tight");
    }
    if (descs[1] && /faster learning|guarantee/i.test(descs[1].textContent || "")) descs[1].textContent = "when the brain can replay what you just practiced";
    var benefitP = Array.prototype.find.call(how.querySelectorAll("p"), function (p) {
      return /benefits in a research setting/i.test(p.textContent || "");
    });
    if (benefitP && /20 times|tremendously|10–20|95%/i.test(benefitP.textContent || "")) {
      benefitP.textContent = "Claim-safe framing from motor-skill rest/replay studies (not a personal guarantee):";
    }
    var video = how.querySelector("h2.text-xl.font-bold, h2");
    var hasTrust = /Not a medical device/i.test(how.textContent || "") || how.querySelector(".mb-trust");
    if (video && /Check out this video/i.test(video.textContent || "") && !hasTrust) {
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

  function mbFirstUse() {
    var path = (location.pathname || "").toLowerCase();
    if (/app\.html|index\.html|thanks\.html/.test(path)) return;
    if (!/timer\.html/.test(path) && !document.getElementById("progbar")) return;
    try {
      if (localStorage.getItem("mb-firstuse-v1")) return;
    } catch (e) {}
    if (document.getElementById("mb-firstuse")) return;

    var fuCss = document.createElement("style");
    fuCss.id = "mb-firstuse-css";
    fuCss.textContent = [
      "#mb-firstuse{position:fixed;inset:0;z-index:200;display:flex;align-items:flex-start;justify-content:center;padding:16px;overflow:auto;background:rgba(26,35,50,.46);font-family:Inter,system-ui,-apple-system,sans-serif;-webkit-font-smoothing:antialiased}",
      "#mb-firstuse .mb-fu-sheet{width:100%;max-width:420px;background:#fff;color:#1a2332;border:1px solid #e4e9ec;border-radius:16px;padding:20px;margin:8px auto 32px;box-shadow:0 8px 32px rgba(26,35,50,.16)}",
      "#mb-firstuse h1{font-size:22px;line-height:1.25;font-weight:650;letter-spacing:-.02em;margin:0 0 16px;color:#1a2332}",
      "#mb-firstuse .mb-fu-block{margin:0 0 14px}",
      "#mb-firstuse .mb-fu-kicker{font-size:11px;font-weight:650;letter-spacing:.04em;text-transform:uppercase;color:#8a97a5;margin:0 0 4px}",
      "#mb-firstuse .mb-fu-block p.mb-fu-body{font-size:14px;line-height:1.5;color:#5c6b7a;margin:0}",
      "#mb-firstuse .mb-fu-cards{display:flex;flex-direction:column;gap:10px;margin:16px 0 20px}",
      "#mb-firstuse .mb-fu-card{background:#fff;border:1px solid #e4e9ec;border-radius:16px;padding:16px 18px}",
      "#mb-firstuse .mb-fu-card h2{font-size:15px;font-weight:650;margin:0 0 6px;color:#1a2332}",
      "#mb-firstuse .mb-fu-card p{font-size:13px;line-height:1.45;color:#5c6b7a;margin:0}",
      "#mb-firstuse .mb-fu-start{display:block;width:100%;padding:12px 16px;border:none;border-radius:10px;background:#0d9488;color:#fff;font-size:15px;font-weight:600;cursor:pointer;font-family:inherit}",
      "#mb-firstuse .mb-fu-start:hover{background:#0f766e}",
      "#mb-firstuse .mb-fu-skip{display:block;width:100%;margin-top:10px;padding:8px;border:none;background:transparent;color:#5c6b7a;font-size:14px;font-weight:500;cursor:pointer;text-align:center;font-family:inherit}",
      "#mb-firstuse .mb-fu-skip:hover{color:#0f766e}",
      "body.mb-firstuse-open{overflow:hidden}"
    ].join("");
    document.head.appendChild(fuCss);

    var wrap = document.createElement("div");
    wrap.id = "mb-firstuse";
    wrap.setAttribute("role", "dialog");
    wrap.setAttribute("aria-modal", "true");
    wrap.setAttribute("aria-labelledby", "mb-fu-title");
    wrap.innerHTML =
      '<div class="mb-fu-sheet">' +
      '<h1 id="mb-fu-title">How Microbreaks works</h1>' +
      '<div class="mb-fu-block"><p class="mb-fu-kicker">What</p>' +
      '<p class="mb-fu-body">A focus timer that inserts short, random rests (~10s) between work bouts.</p></div>' +
      '<div class="mb-fu-block"><p class="mb-fu-kicker">Why</p>' +
      '<p class="mb-fu-body">Inspired by gap / micro-rest research on skill practice (Buch et al., Cell Reports 2021). That’s motor sequences in the lab — not a guarantee for every study session. Not a medical device.</p></div>' +
      '<div class="mb-fu-cards">' +
      '<article class="mb-fu-card"><h2>Focus</h2><p>Optional attention exercise before a session. Watch a simple moving target for a few seconds to settle in. Product UX, not a proven study hack.</p></article>' +
      '<article class="mb-fu-card"><h2>Breathing</h2><p>Optional paced breathing cues you can open any time. Informational only; use at your own comfort.</p></article>' +
      '<article class="mb-fu-card"><h2>Sounds / cats</h2><p>Optional chimes and a light cat/focus visual. Flavor for the session — not a science claim.</p></article>' +
      "</div>" +
      '<button type="button" class="mb-fu-start">Start timer</button>' +
      '<button type="button" class="mb-fu-skip">Skip</button>' +
      "</div>";
    document.body.appendChild(wrap);
    document.body.classList.add("mb-firstuse-open");

    function dismiss() {
      try { localStorage.setItem("mb-firstuse-v1", "1"); } catch (e) {}
      if (wrap.parentNode) wrap.parentNode.removeChild(wrap);
      if (fuCss.parentNode) fuCss.parentNode.removeChild(fuCss);
      document.body.classList.remove("mb-firstuse-open");
    }
    wrap.querySelector(".mb-fu-start").addEventListener("click", dismiss);
    wrap.querySelector(".mb-fu-skip").addEventListener("click", dismiss);
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", mbFirstUse);
  } else {
    mbFirstUse();
  }

})();
