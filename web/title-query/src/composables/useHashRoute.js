import { ref } from 'vue';

export function useHashRoute(routeOrder, fallbackRoute) {
  const currentRoute = ref(fallbackRoute);

  function normalizeRoute(hashValue) {
    const raw = String(hashValue || '')
      .replace(/^#\/?/, '')
      .split('?')[0]
      .trim()
      .toLowerCase();
    return routeOrder.includes(raw) ? raw : fallbackRoute;
  }

  function setRouteFromHash() {
    currentRoute.value = normalizeRoute(typeof window === 'undefined' ? '' : window.location.hash);
  }

  function routeHref(routeKey) {
    return `#/${routeKey}`;
  }

  function isRouteActive(routeKey) {
    return currentRoute.value === routeKey;
  }

  return {
    currentRoute,
    setRouteFromHash,
    routeHref,
    isRouteActive
  };
}
