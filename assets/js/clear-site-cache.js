// Retire Chirpy's old offline copy without touching caches for other applications.
(async () => {
  if (!('serviceWorker' in navigator)) return;
  const workerUrl = new URL('../../sw.min.js', document.currentScript.src);
  workerUrl.search = '';
  try {
    const controller = navigator.serviceWorker.controller;
    const controlled = controller && controller.scriptURL === workerUrl.href;
    const registrations = await navigator.serviceWorker.getRegistrations();
    for (const registration of registrations) {
      const workers = [registration.active, registration.waiting, registration.installing];
      if (workers.some((worker) => worker && worker.scriptURL === workerUrl.href)) {
        await registration.unregister();
      }
    }
    if ('caches' in window) {
      const keys = await caches.keys();
      await Promise.all(keys.filter((key) => key.startsWith('chirpy-')).map((key) => caches.delete(key)));
    }
    if (controlled) window.location.reload();
  } catch (error) {
    console.warn('Could not clear the previous offline copy.', error);
  }
})();
