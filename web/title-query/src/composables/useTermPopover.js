import { computed, ref } from 'vue';

export function useTermPopover() {
  const activeTermKey = ref('');
  const popoverAnchorStyle = ref({ top: '0px', left: '0px' });
  const isMobileViewport = ref(false);
  const isMobilePopover = computed(() => isMobileViewport.value);

  function closeTermPopover() {
    activeTermKey.value = '';
  }

  function updateViewportMode() {
    if (typeof window === 'undefined') {
      return;
    }

    isMobileViewport.value = window.innerWidth <= 640;
  }

  function updatePopoverAnchor(targetElement) {
    if (typeof window === 'undefined') {
      return;
    }

    const rect = targetElement.getBoundingClientRect();
    const popoverWidth = 420;
    const popoverHeight = 320;
    const margin = 12;
    const preferredLeft = rect.left + rect.width / 2 - popoverWidth / 2;
    const preferredTop = rect.bottom + 10;
    const left = Math.min(Math.max(margin, preferredLeft), window.innerWidth - popoverWidth - margin);
    const top = Math.min(Math.max(margin, preferredTop), window.innerHeight - popoverHeight - margin);
    popoverAnchorStyle.value = {
      top: `${Math.round(top)}px`,
      left: `${Math.round(left)}px`
    };
  }

  function toggleTermPopover(termKey, targetElement = null) {
    if (!termKey) {
      return;
    }

    if (activeTermKey.value === termKey) {
      closeTermPopover();
      return;
    }

    activeTermKey.value = termKey;
    if (!isMobilePopover.value && targetElement) {
      updatePopoverAnchor(targetElement);
    }
  }

  function handleGlobalPointerDown(event) {
    const target = event.target;
    if (!(target instanceof HTMLElement)) {
      return;
    }

    if (target.closest('.term-popover') || target.closest('.term-trigger')) {
      return;
    }

    closeTermPopover();
  }

  function handleGlobalEscape(event) {
    if (event.key === 'Escape') {
      closeTermPopover();
    }
  }

  return {
    activeTermKey,
    popoverAnchorStyle,
    isMobilePopover,
    closeTermPopover,
    updateViewportMode,
    toggleTermPopover,
    handleGlobalPointerDown,
    handleGlobalEscape
  };
}
