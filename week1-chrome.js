(function () {
  "use strict";
  if (document.getElementById("mb-week1-chrome-js")) return;

  var css = document.createElement("style");
  css.id = "mb-week1-chrome-js";
  css.textContent = [
    "body{background:#0b1c24!important;color:#1a2332}",
    "#cont.hero,#cont{background-image:url(pic1.jpg)!important;background-size:cover!important;background-position:center!important;background-color:transparent!important}",
    "#cont .hero-overlay{opacity:.28!important;background:#0b1c24!important}",
    ".navbar.bg-secondary{background:rgba(255,255,255,.88)!important;backdrop-filter:blur(10px)!important;-webkit-backdrop-filter:blur(10px)!important;border:1px solid rgba(255,255,255,.55)!important;color:#1a2332!important;box-shadow:0 4px 20px rgba(11,28,36,.18)!important}",
    "#progbar{color:#1a2332!important;background:rgba(255,255,255,.9)!important;box-shadow:0 4px 24px rgba(11,28,36,.2)!important}",
    ".absolute.bottom-0.fixed.pb-8{padding-bottom:5.5rem!important}",
    ".absolute.bottom-0.fixed.pb-8 .btn-group{background:rgba(255,255,255,.88)!important;backdrop-filter:blur(10px)!important;border-radius:999px!important;padding:6px!important;border:1px solid rgba(255,255,255,.55)!important}",
    "#app,#app a{color:#1a2332!important;font-weight:600!important}",
    ".mb-feedback-rail{z-index:30!important;position:fixed!important;top:4.75rem!important;left:.5rem!important;bottom:auto!important;display:flex;flex-direction:column;gap:.15rem}",
    ".mb-feedback-rail a div,label[for='modal-tips'] > div{background:rgba(255,255,255,.88)!important;color:#1a2332!important;border-radius:10px!important;padding:6px 10px!important;font-size:.7rem!important;font-weight:600}",
    "label[for='modal-tips'] > div{bottom:auto!important;top:4.75rem!important;right:.5rem!important}",
    "#mb-founder-unlock{max-width:420px;margin:1rem auto 2rem;padding:0 1rem}",
    "#mb-founder-unlock .card{background:#fff!important;border:1px solid #e4e9ec!important;border-radius:16px!important;padding:16px 18px!important}",
    "#mb-founder-unlock h2{font-size:15px;font-weight:650;margin:0 0 4px;color:#1a2332}",
    "#mb-founder-unlock p{font-size:13px;color:#5c6b7a;margin:0 0 12px;line-height:1.45}",
    "#mb-founder-unlock a{display:inline-flex!important;padding:10px 14px!important;border-radius:10px!important;background:#0d9488!important;color:#fff!important;font-size:15px!important;font-weight:600!important;text-decoration:none!important}",
    "#howitworks{background:rgba(255,255,255,.92)!important;border-radius:16px!important}",
    "#howitworks .stats{display:flex!important;flex-direction:column!important;width:100%!important;overflow:hidden!important}",
    "@media (max-width:1023px){#howitworks .stat-figure{display:none!important}}",
    "@media (max-width:440px){#app{display:none}}"
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

  var how = document.getElementById("howitworks");
  if (how) {
    var titles = how.querySelectorAll(".stat-title");
    var values = how.querySelectorAll(".stat-value");
    var descs = how.querySelectorAll(".stat-desc");
    if (titles[0]) titles[0].textContent = "Brief rests";
    if (values[0]) { values[0].textContent = "~10s"; values[0].classList.add("text-xl", "leading-tight"); }
    if (descs[0]) descs[0].textContent = "same timescale as motor-skill rest/replay studies";
    if (titles[1]) titles[1].textContent = "Between bouts";
    if (values[1]) { values[1].textContent = "Rest"; values[1].classList.add("text-lg", "leading-tight"); }
    if (descs[1]) descs[1].textContent = "when the brain can replay what you just practiced";
  }

  if (!document.getElementById("mb-founder-unlock") && !document.getElementById("founder-unlock")) {
    var aside = document.createElement("aside");
    aside.id = "mb-founder-unlock";
    aside.setAttribute("aria-label", "Founder unlock");
    aside.innerHTML = '<div class="card"><h2>Founder unlock — $12</h2><p>Early iOS access + supporters credit when Pro ships. Web timer stays free.</p><a href="https://buy.stripe.com/dRmeVc4WccRL6JC9NveAg07">Unlock early access — $12</a></div>';
    var marker = document.getElementById("howitworks");
    if (marker && marker.parentNode) marker.parentNode.insertBefore(aside, marker.nextSibling);
    else document.body.appendChild(aside);
  }

  function mbFirstUse() {
    var path = (location.pathname || "").toLowerCase();
    if (/app\.html|index\.html|thanks\.html/.test(path)) return;
    if (!/timer\.html/.test(path) && !document.getElementById("progbar")) return;
    try { if (localStorage.getItem("mb-firstuse-v1")) return; } catch (e) {}
    if (document.getElementById("mb-firstuse")) return;

    var fuCss = document.createElement("style");
    fuCss.id = "mb-firstuse-css";
    fuCss.textContent = [
      "#mb-firstuse{position:fixed;inset:0;z-index:200;display:flex;align-items:flex-start;justify-content:center;padding:16px;overflow:auto;background:rgba(26,35,50,.46);font-family:Inter,system-ui,sans-serif}",
      "#mb-firstuse .mb-fu-sheet{width:100%;max-width:390px;background:#f4f6f5;color:#1a2332;border:1px solid #e4e9ec;border-radius:16px;padding:20px;margin:8px auto 32px;box-shadow:0 8px 32px rgba(26,35,50,.16)}",
      "#mb-firstuse h1{font-size:22px;line-height:1.25;font-weight:650;margin:0 0 16px}",
      "#mb-firstuse .mb-fu-kicker{font-size:11px;font-weight:650;letter-spacing:.04em;text-transform:uppercase;color:#8a97a5;margin:0 0 4px}",
      "#mb-firstuse .mb-fu-body{font-size:14px;line-height:1.5;color:#5c6b7a;margin:0 0 14px}",
      "#mb-firstuse .mb-fu-cards{display:flex;flex-direction:column;gap:10px;margin:16px 0 20px}",
      "#mb-firstuse .mb-fu-card{background:#fff;border:1px solid #e4e9ec;border-radius:16px;padding:16px 18px}",
      "#mb-firstuse .mb-fu-card h2{font-size:15px;font-weight:650;margin:0 0 6px}",
      "#mb-firstuse .mb-fu-card p{font-size:13px;line-height:1.45;color:#5c6b7a;margin:0}",
      "#mb-firstuse .mb-fu-start{display:block;width:100%;padding:12px 16px;border:none;border-radius:10px;background:#0f766e;color:#fff;font-size:15px;font-weight:600;cursor:pointer}",
      "#mb-firstuse .mb-fu-skip{display:block;width:100%;margin-top:16px;border:none;background:transparent;color:#5c6b7a;font-size:13px;cursor:pointer}"
    ].join("");
    document.head.appendChild(fuCss);

    var wrap = document.createElement("div");
    wrap.id = "mb-firstuse";
    wrap.setAttribute("role", "dialog");
    wrap.setAttribute("aria-modal", "true");
    wrap.innerHTML =
      '<div class="mb-fu-sheet">' +
      '<h1>How Microbreaks works</h1>' +
      '<p class="mb-fu-kicker">What</p><p class="mb-fu-body">A focus timer that inserts brief (~10s) microbreaks at random while you work — short pauses between practice bouts, not another Pomodoro clone.</p>' +
      '<p class="mb-fu-kicker">Why</p><p class="mb-fu-body">Inspired by peer-reviewed motor-skill rest/replay research on short waking rests (Buch et al., Cell Reports 2021). That\'s lab skill practice, not a guarantee for every study session. Not a medical device; results vary.</p>' +
      '<div class="mb-fu-cards">' +
      '<article class="mb-fu-card"><h2>Focus</h2><p>Optional ~15s visual attention exercise before you start — look at the point (or cat) and let your mind settle. Product habit, not a study finding.</p></article>' +
      '<article class="mb-fu-card"><h2>Breathing</h2><p>Optional breathing cue if you want to feel more alert. Informational only — skip anytime.</p></article>' +
      '<article class="mb-fu-card"><h2>Sounds / cats</h2><p>Optional background sound and a focus visual. Atmosphere, not science.</p></article>' +
      '</div>' +
      '<button type="button" class="mb-fu-start">Start timer</button>' +
      '<button type="button" class="mb-fu-skip">Skip</button>' +
      '</div>';
    document.body.appendChild(wrap);

    function dismiss() {
      try { localStorage.setItem("mb-firstuse-v1", "1"); } catch (e) {}
      if (wrap.parentNode) wrap.parentNode.removeChild(wrap);
      if (fuCss.parentNode) fuCss.parentNode.removeChild(fuCss);
    }
    wrap.querySelector(".mb-fu-start").addEventListener("click", dismiss);
    wrap.querySelector(".mb-fu-skip").addEventListener("click", dismiss);
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", mbFirstUse);
  else mbFirstUse();
})();
