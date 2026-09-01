(function () {
  "use strict";
  if (document.getElementById("mb-week1-chrome")) return;

  var css = document.createElement("style");
  css.id = "mb-week1-chrome";
  css.textContent = [
    "body{background:#f4f6f5!important}",
    "#cont.hero{background-image:none!important;background:#f4f6f5!important}",
    "#cont .hero-overlay{opacity:0!important}",
    ".navbar.bg-secondary{background:#fff!important;border:1px solid #e4e9ec;color:#1a2332}",
    "#progbar{color:#1a2332!important;background:#fff}",
    ".absolute.bottom-0.fixed.pb-8{padding-bottom:5.5rem!important}",
    "#app{font-size:.7rem!important;opacity:.85}",
    "#app a{color:#8a97a5!important;text-decoration:none}",
    "#mb-founder-unlock{max-width:420px;margin:1rem auto 2rem;padding:0 1rem}",
    "#mb-founder-unlock .card{background:#fff;border:1px solid #e4e9ec;border-radius:16px;padding:16px 18px;text-align:left;font-family:Inter,system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif}",
    "#mb-founder-unlock h2{font-size:15px;font-weight:650;margin:0 0 4px;color:#1a2332}",
    "#mb-founder-unlock p{font-size:13px;color:#5c6b7a;margin:0 0 12px;line-height:1.45}",
    "#mb-founder-unlock a{display:inline-flex;padding:10px 14px;border-radius:10px;border:1px solid #e4e9ec;background:#ecfdf8;color:#0f766e;font-size:13.5px;font-weight:600;text-decoration:none}",
    ".mb-trust{font-size:12px;color:#8a97a5;margin-top:12px;line-height:1.45}",
    "@media (max-width:440px){#app{display:none}}"
  ].join("");
  document.head.appendChild(css);

  var cont = document.getElementById("cont");
  if (cont) cont.style.background = "#f4f6f5";

  var appLink = document.querySelector("#app a");
  if (appLink) appLink.textContent = "iOS waitlist";

  var focus = document.getElementById("focusModeCheckBox");
  if (focus) focus.setAttribute("aria-label", "Focus exercise");
  var breath = document.getElementById("breathingModeCheckBox");
  if (breath) breath.setAttribute("aria-label", "Breathing exercise");
  var audio = document.getElementById("audioToggleCheckBox");
  if (audio) audio.setAttribute("aria-label", "Sound");
  var settings = document.querySelector("label[for='modal-settings']");
  if (settings) {
    settings.setAttribute("aria-label", "Settings");
    settings.setAttribute("title", "Settings");
  }
  document.querySelectorAll('button[onclick="toggleFullScreen()"]').forEach(function (b) {
    b.setAttribute("aria-label", "Fullscreen");
    b.setAttribute("title", "Fullscreen");
  });

  var how = document.getElementById("howitworks");
  if (how) {
    var paras = how.querySelectorAll(".collapse-content > p");
    if (paras[0]) {
      paras[0].innerHTML = "Short pauses between practice bouts, inspired by gap / micro-rest research. Research on skill practice found compressed neural replay during short waking rests (Buch et al., Cell Reports 2021). That’s motor sequences in the lab — not a guarantee for every study session. Read more in our <b><a href=\"https://www.microbreaks.co/blog/public/posts/the-value-of-microbreaks/\">blog post</a></b>.";
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

    var video = how.querySelector("h2.text-xl.font-bold");
    if (video && !how.querySelector(".mb-trust")) {
      var trust = document.createElement("p");
      trust.className = "mb-trust";
      trust.textContent = "Inspired by peer-reviewed motor-skill rest/replay research (Buch et al., Cell Reports 2021). Not a medical device; results vary.";
      video.parentNode.insertBefore(trust, video);
    }
  }

  if (!document.getElementById("mb-founder-unlock")) {
    var aside = document.createElement("aside");
    aside.id = "mb-founder-unlock";
    aside.setAttribute("aria-label", "Founder unlock");
    aside.innerHTML = '<div class="card"><h2>Founder unlock — $12</h2><p>Early iOS access + supporters credit when Pro ships. Web timer stays free.</p><a href="https://buy.stripe.com/dRmeVc4WccRL6JC9NveAg07">Unlock early access — $12</a></div>';
    var marker = document.getElementById("howitworks");
    if (marker && marker.parentNode) {
      marker.parentNode.insertBefore(aside, marker.nextSibling);
    } else {
      document.body.appendChild(aside);
    }
  }
})();
