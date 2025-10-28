/**
 * Snapkit Image Optimization Service Worker
 *
 * Automatically transforms ALL image requests to use Snapkit's optimization service.
 * Inspired by Cloudinary's Service Worker approach.
 */

// Default configuration (Cloudinary-style structure)
let config = {
  clientMetrics: {
    viewportWidth: 1920,
    dpr: 1,
    enabled: false,
  },
  delivery: {
    organizationName: '',
  },
  optimization: {
    quality: 'auto',  // 'auto' or number (1-100)
    format: 'auto',   // 'auto' or 'webp', 'jpeg', 'png', 'avif'
    limitMaxWidth: false,
  },
};

// Try to read config from URL parameters (Cloudinary-style)
try {
  const urlParams = new URLSearchParams(self.location.search);
  if (urlParams.has('config')) {
    const urlConfig = JSON.parse(decodeURIComponent(urlParams.get('config')));
    config = mergeConfig(config, urlConfig);
    console.log('[Snapkit SW] Config from URL:', config);
  }
} catch (error) {
  console.warn('[Snapkit SW] Failed to parse URL config:', error);
}

// Listen for configuration updates via postMessage
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SNAPKIT_CONFIG') {
    config = mergeConfig(config, event.data.config);
    console.log('[Snapkit SW] Config updated:', config);
  }
});

/**
 * Deep merge configuration objects
 */
function mergeConfig(base, update) {
  const result = { ...base };
  for (const key in update) {
    if (update[key] && typeof update[key] === 'object' && !Array.isArray(update[key])) {
      result[key] = { ...base[key], ...update[key] };
    } else {
      result[key] = update[key];
    }
  }
  return result;
}

/**
 * Get transform options based on config and clientMetrics
 */
function getTransformOptions() {
  const transform = {};
  const { optimization, clientMetrics } = config;

  // Handle auto quality
  if (optimization.quality === 'auto') {
    transform.quality = 85;
  } else if (typeof optimization.quality === 'number') {
    transform.quality = optimization.quality;
  }

  // Handle auto format
  if (optimization.format === 'auto') {
    transform.format = 'webp';
  } else if (optimization.format) {
    transform.format = optimization.format;
  }

  // Apply DPR from clientMetrics
  if (clientMetrics.enabled && clientMetrics.dpr && clientMetrics.dpr > 1) {
    transform.dpr = clientMetrics.dpr;
  }

  // Apply viewport-based width limit
  if (optimization.limitMaxWidth && clientMetrics.enabled && clientMetrics.viewportWidth) {
    transform.w = clientMetrics.viewportWidth;
  }

  // Copy other optimization settings
  if (optimization.w) transform.w = optimization.w;
  if (optimization.h) transform.h = optimization.h;
  if (optimization.fit) transform.fit = optimization.fit;
  if (optimization.blur) transform.blur = optimization.blur;
  if (optimization.grayscale) transform.grayscale = optimization.grayscale;
  if (optimization.rotation) transform.rotation = optimization.rotation;
  if (optimization.flip) transform.flip = optimization.flip;
  if (optimization.flop) transform.flop = optimization.flop;
  if (optimization.extract) transform.extract = optimization.extract;

  return transform;
}

/**
 * Build transform string from options
 */
function buildTransformString(options) {
  const parts = [];

  if (options.w !== undefined) parts.push(`w:${options.w}`);
  if (options.h !== undefined) parts.push(`h:${options.h}`);
  if (options.fit) parts.push(`fit:${options.fit}`);
  if (options.format) parts.push(`format:${options.format}`);
  if (options.rotation !== undefined) parts.push(`rotation:${options.rotation}`);
  if (options.blur !== undefined) parts.push(`blur:${options.blur}`);
  if (options.dpr !== undefined) parts.push(`dpr:${options.dpr}`);
  if (options.quality !== undefined) parts.push(`quality:${options.quality}`);

  if (options.grayscale) parts.push('grayscale');
  if (options.flip) parts.push('flip');
  if (options.flop) parts.push('flop');

  if (options.extract) {
    const { x, y, width, height } = options.extract;
    parts.push(`extract:${x}-${y}-${width}-${height}`);
  }

  return parts.join(',');
}

/**
 * Check if request is for an image
 */
function isImageRequest(request) {
  const url = request.url.toLowerCase();
  const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.avif', '.bmp'];
  return imageExtensions.some(ext => url.includes(ext));
}

/**
 * Transform image URL to Snapkit URL
 */
function transformToSnapkitURL(originalUrl, transform) {
  const transformString = buildTransformString(transform);
  const baseUrl = `https://${config.delivery.organizationName}.snapkit.dev/image`;
  const params = new URLSearchParams();
  params.set('url', originalUrl);
  if (transformString) {
    params.set('transform', transformString);
  }
  return `${baseUrl}?${params.toString()}`;
}

/**
 * Handle fetch events
 */
self.addEventListener('fetch', (event) => {
  const request = event.request;

  // Only handle GET requests for images
  if (request.method !== 'GET' || !isImageRequest(request)) {
    return;
  }

  // Skip if no organization configured
  if (!config.delivery.organizationName) {
    return;
  }

  const originalUrl = request.url;
  const url = new URL(originalUrl);

  // Skip if already a Snapkit URL
  if (url.hostname.includes('snapkit.dev') || url.hostname.includes('snapkit.studio')) {
    return;
  }

  event.respondWith(
    (async () => {
      try {
        // Get transform options based on config and clientMetrics
        const transform = getTransformOptions();

        // Transform to Snapkit URL
        const snapkitUrl = transformToSnapkitURL(originalUrl, transform);

        console.log('[Snapkit SW]', originalUrl, '→', snapkitUrl);

        // Fetch optimized image
        return await fetch(snapkitUrl, {
          mode: 'cors',
          credentials: 'omit',
        });
      } catch (error) {
        console.error('[Snapkit SW] Error:', error);
        // Fallback to original
        return fetch(request);
      }
    })()
  );
});

/**
 * Service worker lifecycle
 */
self.addEventListener('install', () => {
  console.log('[Snapkit SW] Installing...');
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  console.log('[Snapkit SW] Activated');
  event.waitUntil(self.clients.claim());
});
