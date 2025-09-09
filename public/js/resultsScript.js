/*
 * Script
 */

document.querySelectorAll(".carousel").forEach((carousel) => {
  carousel.addEventListener("slide.bs.carousel", function () {
    this.classList.add("sliding");
    document.activeElement.blur();
  });
  carousel.addEventListener("slid.bs.carousel", function () {
    this.classList.remove("sliding");
  });
});

/*
 * Script
 */

window.addEventListener("scroll", () => {
  const button = document.getElementById("backToTop");
  button.style.display = window.scrollY > 500 ? "block" : "none";
});

document.getElementById("backToTop").addEventListener("click", () => {
  window.scrollTo({ top: 0, behavior: "smooth" });
});
