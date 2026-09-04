(function () {
  "use strict";
  if (document.getElementById("mb-week1-chrome-js")) return;
  var css = document.createElement("style");
  css.id = "mb-week1-chrome-js";
  css.textContent = [
    "body{background:#0b1c24!important}",
    "#cont.hero,#cont{background-image:url(pic1.jpg)!important;background-size:cover!important;background-position:center!important;background-color:transparent!important}",
    "#cont .hero-overlay{opacity:.28!important;background:#0b1c24!important}",
    ".navbar.bg-secondary{background:rgba(255,255,255,.88)!important;backdrop-filter:blur(10px)!important;-webkit-backdrop-filter:blur(10px)!important;border:1px solid rgba(255,255,255,.55)!important;color:#1a2332!important;box-shadow:0 4px 20px rgba(11,28,36,.18)!important}",
    "#progbar{color:#1a2332!important;background:rgba(255,255,255,.9)!important;box-shadow:0 4px 24px rgba(11,28,36,.2)!important}",
    ".absolute.bottom-0.fixed.pb-8 .btn-group{background:rgba(255,255,255,.88)!important;backdrop-filter:blur(10px)!important;border-radius:999px!important;padding:6px!important;border:1px solid rgba(255,255,255,.55)!important}",
    "#app,#app a{color:#1a2332!important;font-weight:600!important}",
    ".mb-feedback-rail a div,label[for='modal-tips'] > div{background:rgba(255,255,255,.88)!important;color:#1a2332!important;border-radius:10px!important;padding:6px 10px!important}",
    "#mb-founder-unlock{max-width:420px;margin:1rem auto 2rem;padding:0 1rem}",
    "#mb-founder-unlock .card{background:#fff!important;border:1px solid #e4e9ec!important;border-radius:16px!important;padding:16px 18px!important}",
    "#mb-founder-unlock a{display:inline-flex!important;padding:10px 14px!important;border-radius:10px!important;background:#0d9488!important;color:#fff!important;font-size:15px!important;font-weight:600!important;text-decoration:none!important}",
    "#howitworks{background:rgba(255,255,255,.92)!important;border-radius:16px!important}"
  ].join("");
  document.head.appendChild(css);
  var cont = document.getElementById("cont");
  if (cont) {
    cont.style.setProperty("background-image", "url(pic1.jpg)", "important");
    cont.style.setProperty("background-size", "cover", "important");
  }
  var feedback = Array.prototype.find.call(document.querySelectorAll("div.fixed"), function (el) {
    return /Feedback/i.test(el.textContent || "") && el.className.indexOf("bottom-0") !== -1;
  });
  if (feedback) feedback.className = "mb-feedback-rail";
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
  if (!document.getElementById("mb-founder-unlock")) {
    var aside = document.createElement("aside");
    aside.id = "mb-founder-unlock";
    aside.innerHTML = '<div class="card"><h2>Founder unlock — $12</h2><p>Early iOS access + supporters credit when Pro ships. Web timer stays free.</p><a href="https://buy.stripe.com/dRmeVc4WccRL6JC9NveAg07">Unlock early access — $12</a></div>';
    var marker = document.getElementById("howitworks");
    if (marker && marker.parentNode) marker.parentNode.insertBefore(aside, marker.nextSibling);
  }
  function mbFirstUse() {
    try { if (localStorage.getItem("mb-firstuse-v1")) return; } catch (e) {}
    if (!document.getElementById("progbar") || document.getElementById("mb-firstuse")) return;
    var wrap = document.createElement("div");
    wrap.id = "mb-firstuse";
    wrap.style.cssText = "position:fixed;inset:0;z-index:200;display:flex;align-items:flex-start;justify-content:center;padding:16px;overflow:auto;background:rgba(26,35,50,.46)";
    wrap.innerHTML = '<div style="width:100%;max-width:390px;background:#f4f6f5;border-radius:16px;padding:20px;margin:8px auto"><h1 style="font-size:22px;margin:0 0 12px">How Microbreaks works</h1><p style="color:#5c6b7a;font-size:14px;line-height:1.5">A focus timer that inserts brief (~10s) microbreaks at random while you work.</p><p style="color:#5c6b7a;font-size:14px;line-height:1.5">Inspired by Buch et al., Cell Reports 2021. Lab skill practice — not a guarantee. Not a medical device.</p><p style="font-size:13px;color:#5c6b7a"><b>Focus</b> — optional cat attention exercise.</p><p style="font-size:13px;color:#5c6b7a"><b>Breathing</b> — optional cue.</p><p style="font-size:13px;color:#5c6b7a"><b>Sounds / cats</b> — atmosphere, not science.</p><button id="mb-fu-go" style="width:100%;height:48px;border:0;border-radius:10px;background:#0f766e;color:#fff;font-weight:600;margin-top:16px">Start timer</button><button id="mb-fu-skip" style="width:100%;margin-top:16px;border:0;background:transparent;color:#5c6b7a">Skip</button></div>';
    document.body.appendChild(wrap);
    function dismiss() { try { localStorage.setItem("mb-firstuse-v1", "1"); } catch (e) {} wrap.remove(); }
    wrap.querySelector("#mb-fu-go").onclick = dismiss;
    wrap.querySelector("#mb-fu-skip").onclick = dismiss;
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", mbFirstUse);
  else mbFirstUse();
})();
