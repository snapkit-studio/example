/**
 * Snapkit Service Worker Configuration (Cloudinary-style)
 *
 * Inspired by Cloudinary's Service Worker configuration approach.
 */

const snapkitConfig = {
  // Client metrics (viewport, DPR)
  clientMetrics: {
    viewportWidth: window.innerWidth,      // Current viewport width
    dpr: window.devicePixelRatio || 1,     // Device pixel ratio (retina = 2)
    enabled: true,                         // Enable client metrics
  },

  // Delivery configuration
  delivery: {
    organizationName: 'my-org',  // REQUIRED: Change to your Snapkit organization
  },

  // Optimization settings
  optimization: {
    quality: 'auto',      // 'auto' (→ 85) or number (1-100)
    format: 'auto',       // 'auto' (→ webp) or 'webp', 'jpeg', 'png', 'avif'
    limitMaxWidth: true,  // Limit image width to viewport width

    // Optional: Additional optimization settings
    // w: 1200,           // Max width (overrides limitMaxWidth)
    // h: 800,            // Max height
    // fit: 'cover',      // Fit mode: cover, contain, fill, inside, outside
    // blur: 10,          // Blur intensity (0.3-1000)
    // grayscale: true,   // Convert to grayscale
    // rotation: 90,      // Rotate degrees
  },
};

// Export
if (typeof module !== 'undefined' && module.exports) {
  module.exports = snapkitConfig;
}

export default snapkitConfig;
