import { ref } from 'vue';

export function useThemeMode(storageKey) {
  const themeMode = ref('light');

  function detectSystemTheme() {
    if (typeof window === 'undefined' || typeof window.matchMedia !== 'function') {
      return 'light';
    }

    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  function applyTheme(nextMode, persist = true) {
    const normalized = nextMode === 'dark' ? 'dark' : 'light';
    themeMode.value = normalized;

    if (typeof window !== 'undefined') {
      document.documentElement.dataset.theme = normalized;
      if (persist) {
        window.localStorage.setItem(storageKey, normalized);
      }
    }
  }

  function initTheme() {
    if (typeof window === 'undefined') {
      return;
    }

    const savedTheme = window.localStorage.getItem(storageKey);
    if (savedTheme === 'light' || savedTheme === 'dark') {
      applyTheme(savedTheme, false);
      return;
    }

    applyTheme(detectSystemTheme(), false);
  }

  function toggleTheme() {
    applyTheme(themeMode.value === 'dark' ? 'light' : 'dark');
  }

  return {
    themeMode,
    initTheme,
    toggleTheme
  };
}
