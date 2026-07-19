(() => {
  const body = document.body;
  const localePreferenceKey = "phoebe-chubby-locale";

  document.querySelectorAll("[data-locale]").forEach((link) => {
    link.addEventListener("click", () => {
      try {
        window.localStorage.setItem(localePreferenceKey, link.dataset.locale);
      } catch {
        // Language selection still works through the link when storage is unavailable.
      }
    });
  });

  const installUrl = [
    "codex://pets/install?name=",
    encodeURIComponent(body.dataset.petName),
    "&imageUrl=",
    encodeURIComponent(body.dataset.spriteUrl),
    "&description=",
    encodeURIComponent(body.dataset.petDescription),
    "&spriteVersionNumber=2",
  ].join("");

  const fallbackDialog = document.querySelector("[data-install-dialog]");
  const installLinks = [...document.querySelectorAll("[data-install]")];
  let fallbackTimer;

  const openFallback = () => {
    if (!fallbackDialog) return;
    if (typeof fallbackDialog.showModal === "function") {
      fallbackDialog.showModal();
    } else {
      fallbackDialog.setAttribute("open", "");
      fallbackDialog.classList.add("is-open");
    }
  };

  const closeFallback = () => {
    if (!fallbackDialog) return;
    if (typeof fallbackDialog.close === "function") fallbackDialog.close();
    fallbackDialog.removeAttribute("open");
    fallbackDialog.classList.remove("is-open");
  };

  const stopFallback = () => window.clearTimeout(fallbackTimer);
  window.addEventListener("blur", stopFallback);
  document.addEventListener("visibilitychange", () => {
    if (document.hidden) stopFallback();
  });

  installLinks.forEach((link) => {
    link.href = installUrl;
    link.addEventListener("click", () => {
      link.classList.add("is-launching");
      const label = link.querySelector("[data-install-label]");
      if (label) label.textContent = body.dataset.openingLabel;
      fallbackTimer = window.setTimeout(() => {
        link.classList.remove("is-launching");
        if (label) label.textContent = body.dataset.installLabel;
        if (fallbackDialog && !fallbackDialog.open) openFallback();
      }, 1800);
    });
  });

  document.querySelectorAll("[data-dialog-close]").forEach((button) => {
    button.addEventListener("click", closeFallback);
  });

  fallbackDialog?.addEventListener("click", (event) => {
    if (event.target === fallbackDialog) closeFallback();
  });

  document.querySelectorAll("[data-copy]").forEach((button) => {
    button.addEventListener("click", async () => {
      const target = document.getElementById(button.dataset.copy);
      if (!target) return;
      try {
        await navigator.clipboard.writeText(target.textContent.trim());
        const original = button.textContent;
        button.textContent = body.dataset.copiedLabel;
        button.classList.add("is-copied");
        window.setTimeout(() => {
          button.textContent = original;
          button.classList.remove("is-copied");
        }, 1600);
      } catch {
        const selection = window.getSelection();
        const range = document.createRange();
        range.selectNodeContents(target);
        selection.removeAllRanges();
        selection.addRange(range);
      }
    });
  });

  const reveals = document.querySelectorAll("[data-reveal]");
  if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    reveals.forEach((item) => item.classList.add("is-visible"));
  } else {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12 },
    );
    reveals.forEach((item) => observer.observe(item));
  }

  document.querySelectorAll("[data-year]").forEach((item) => {
    item.textContent = new Date().getFullYear();
  });
})();
