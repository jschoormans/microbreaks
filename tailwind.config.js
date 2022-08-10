/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["*.{html,js}"],
  theme: {
    extend: {
      keyframes: {
        deepbreath: {
          "5%, 95%": { transform: "scale(1,1)" },
          "45%, 55%" : { transform: "scale(5,5)" },
        },
      },
      animation: {
        "spin-slow": "spin 3s linear infinite",
        "ping-slow": "ping 8s linear infinite",
        "deepbreath-6s": "deepbreath 6s linear infinite",
        "deepbreath-8s": "deepbreath 8s linear infinite",
        "deepbreath-10s": "deepbreath 10s linear infinite",
        "deepbreath-12s": "deepbreath 12s linear infinite",
        "deepbreath-14s": "deepbreath 14s linear infinite",

      },
    },
  },
  plugins: [require("daisyui")],
};
