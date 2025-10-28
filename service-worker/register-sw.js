/**
 * Snapkit Service Worker Registration (Cloudinary-style)
 *
 * @example
 * // Simple registration
 * registerSnapkitServiceWorker({
 *   delivery: { organizationName: 'my-org' },
 *   optimization: { quality: 'auto', format: 'auto' }
 * });
 *
 * @example
 * // With clientMetrics (viewport and DPR)
 * registerSnapkitServiceWorker({
 *   clientMetrics: {
 *     viewportWidth: window.innerWidth,
 *     dpr: window.devicePixelRatio || 1,
 *     enabled: true
 *   },
 *   delivery: { organizationName: 'my-org' },
 *   optimization: {
 *     quality: 'auto',
 *     format: 'auto',
 *     limitMaxWidth: true
 *   }
 * });
 */

/**
 * Register Snapkit Service Worker (Cloudinary-style)
 *
 * @param {Object} config - Configuration
 * @param {Object} [config.clientMetrics] - Client metrics
 * @param {number} [config.clientMetrics.viewportWidth] - Viewport width
 * @param {number} [config.clientMetrics.dpr] - Device pixel ratio
 * @param {boolean} [config.clientMetrics.enabled] - Enable client metrics
 * @param {Object} config.delivery - Delivery configuration
 * @param {string} config.delivery.organizationName - Snapkit organization name (required)
 * @param {Object} [config.optimization] - Optimization settings
 * @param {string|number} [config.optimization.quality] - 'auto' or 1-100
 * @param {string} [config.optimization.format] - 'auto' or 'webp', 'jpeg', 'png', 'avif'
 * @param {boolean} [config.optimization.limitMaxWidth] - Limit width to viewport
 * @param {string} [registrationMethod] - 'url' (Cloudinary-style) or 'postMessage' (default)
 * @returns {Promise<ServiceWorkerRegistration|null>}
 */
async function registerSnapkitServiceWorker(config = {}, registrationMethod = 'url') {
  // Check support
  if (!('serviceWorker' in navigator)) {
    console.warn('[Snapkit SW] Service Workers not supported');
    console.warn('  - Requires modern browser (Chrome 40+, Firefox 44+, Safari 11.1+)');
    console.warn('  - Must be served over HTTPS (or localhost)');
    return null;
  }

  // Validate organization name
  if (!config.delivery?.organizationName) {
    throw new Error('[Snapkit SW] delivery.organizationName is required');
  }

  // Build full config with defaults
  const fullConfig = {
    clientMetrics: {
      viewportWidth: window.innerWidth,
      dpr: window.devicePixelRatio || 1,
      enabled: false,
      ...config.clientMetrics,
    },
    delivery: {
      organizationName: config.delivery.organizationName,
    },
    optimization: {
      quality: 'auto',
      format: 'auto',
      limitMaxWidth: false,
      ...config.optimization,
    },
  };

  try {
    console.log('[Snapkit SW] Registering with config:', fullConfig);

    let registration;

    if (registrationMethod === 'url') {
      // Cloudinary-style: Pass config via URL parameter
      const configParam = encodeURIComponent(JSON.stringify(fullConfig));
      const swUrl = `./sw.js?config=${configParam}`;
      registration = await navigator.serviceWorker.register(swUrl, { scope: '/' });
      console.log('[Snapkit SW] Registered with URL config');
    } else {
      // Default: Register and send config via postMessage
      registration = await navigator.serviceWorker.register('./sw.js', { scope: '/' });

      // Send config to service worker
      const sendConfig = (sw) => {
        if (sw) {
          sw.postMessage({
            type: 'SNAPKIT_CONFIG',
            config: fullConfig,
          });
        }
      };

      if (registration.active) {
        sendConfig(registration.active);
      }

      registration.addEventListener('updatefound', () => {
        const newWorker = registration.installing;
        if (newWorker) {
          newWorker.addEventListener('statechange', () => {
            if (newWorker.state === 'activated') {
              sendConfig(newWorker);
            }
          });
        }
      });

      console.log('[Snapkit SW] Registered with postMessage');
    }

    return registration;
  } catch (error) {
    console.error('[Snapkit SW] Registration failed:', error);
    throw error;
  }
}

/**
 * Unregister service worker
 */
async function unregisterSnapkitServiceWorker() {
  if (!('serviceWorker' in navigator)) return false;

  try {
    const registration = await navigator.serviceWorker.getRegistration();
    if (registration) {
      const result = await registration.unregister();
      console.log('[Snapkit SW] Unregistered');
      return result;
    }
    return false;
  } catch (error) {
    console.error('[Snapkit SW] Unregister failed:', error);
    return false;
  }
}

// Exports
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { registerSnapkitServiceWorker, unregisterSnapkitServiceWorker };
}

if (typeof window !== 'undefined') {
  window.registerSnapkitServiceWorker = registerSnapkitServiceWorker;
  window.unregisterSnapkitServiceWorker = unregisterSnapkitServiceWorker;
}
