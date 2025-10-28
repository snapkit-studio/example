# Snapkit Service Worker (Cloudinary-style)

**Automatically optimize ALL images on your website with viewport-aware sizing and DPR detection.**

Inspired by Cloudinary's Service Worker approach.

## Features

✅ **Zero Code Changes** - Works with existing `<img>` tags
🎯 **clientMetrics** - Viewport width and DPR auto-detection
🚀 **Auto Mode** - `quality: 'auto'`, `format: 'auto'`
📐 **Viewport-Aware** - Automatically limit image width to viewport
⚡ **3-Minute Setup** - Cloudinary-style configuration

## How It Works

```
Browser requests image
    ↓
Service Worker intercepts
    ↓
Applies clientMetrics (viewport, DPR)
    ↓
Transforms to Snapkit URL
    ↓
Returns optimized image
```

**Example:**
```
HTML:     <img src="https://example.com/photo.jpg">
          ↓
Config:   viewport=1920, dpr=2, quality=auto, format=auto, limitMaxWidth=true
          ↓
Request:  https://demo.snapkit.dev/image?url=https://example.com/photo.jpg&transform=w:1920,dpr:2,format:webp,quality:85
```

## When to Use This

⚠️ **Important**: This Service Worker intercepts image requests at the browser level to apply transformations. While powerful, this approach is needed only in **specific scenarios**:

**Consider using Service Worker when:**
- You have an existing site with many hardcoded image URLs
- You cannot modify the HTML/component code
- You need to optimize third-party images you don't control
- You want zero-code-change image optimization

**For most cases, direct integration is more straightforward:**
- Use Snapkit URL builder directly in your components
- Better control over image optimization per use case
- Simpler debugging and maintenance
- No Service Worker complexity

If you're starting a new project or can modify your code, consider using the [main Snapkit integration](../README.md) instead.

---

## Quick Start

### 1. Copy Files

```
your-project/
├── sw.js                    # Service Worker
├── register-sw.js           # Registration
└── snapkit-sw-config.js     # Config (optional)
```

### 2. Configure (Cloudinary-style)

```javascript
const config = {
  clientMetrics: {
    viewportWidth: window.innerWidth,      // Current viewport
    dpr: window.devicePixelRatio || 1,     // Device pixel ratio
    enabled: true,                         // Enable metrics
  },
  delivery: {
    organizationName: 'my-org',  // REQUIRED
  },
  optimization: {
    quality: 'auto',      // 'auto' → 85
    format: 'auto',       // 'auto' → webp
    limitMaxWidth: true,  // Max width = viewport
  },
};
```

### 3. Register

**Option A: URL Parameter (Cloudinary-style)**
```html
<script src="./register-sw.js"></script>
<script>
  const config = {
    clientMetrics: {
      viewportWidth: window.innerWidth,
      dpr: window.devicePixelRatio || 1,
      enabled: true,
    },
    delivery: { organizationName: 'my-org' },
    optimization: {
      quality: 'auto',
      format: 'auto',
      limitMaxWidth: true,
    },
  };

  // Pass config via URL (like Cloudinary)
  registerSnapkitServiceWorker(config, 'url');
</script>
```

**Option B: Config File**
```html
<script type="module">
  import config from './snapkit-sw-config.js';
  import { registerSnapkitServiceWorker } from './register-sw.js';

  registerSnapkitServiceWorker(config, 'url');
</script>
```

### 4. Done!

All images now automatically optimized with viewport-aware sizing:

```html
<!-- No changes needed -->
<img src="https://example.com/photo.jpg">
```

## Configuration

### Full Configuration Structure

```javascript
{
  // Client metrics (viewport and device info)
  clientMetrics: {
    viewportWidth: window.innerWidth,  // Viewport width in pixels
    dpr: window.devicePixelRatio || 1, // Device pixel ratio (1, 2, 3)
    enabled: true,                     // Enable clientMetrics
  },

  // Delivery (organization)
  delivery: {
    organizationName: 'my-org',  // REQUIRED
  },

  // Optimization settings
  optimization: {
    quality: 'auto',      // 'auto' or 1-100
    format: 'auto',       // 'auto' or 'webp', 'jpeg', 'png', 'avif'
    limitMaxWidth: true,  // Limit to viewport width

    // Optional overrides
    // w: 1200,           // Fixed width (overrides limitMaxWidth)
    // h: 800,            // Fixed height
    // fit: 'cover',      // Fit mode
    // blur: 10,          // Blur intensity
    // grayscale: true,   // Grayscale
    // rotation: 90,      // Rotation
  }
}
```

### Auto Mode

| Setting | Auto Value | Description |
|---------|------------|-------------|
| `quality: 'auto'` | `85` | Optimal quality/size balance |
| `format: 'auto'` | `webp` | Modern format with best compression |

### clientMetrics

| Metric | Purpose | Effect |
|--------|---------|--------|
| `viewportWidth` | Current viewport width | Sets max image width when `limitMaxWidth: true` |
| `dpr` | Device pixel ratio | Multiplies dimensions for retina displays |
| `enabled` | Enable/disable metrics | Toggle clientMetrics features |

## Examples

### Example 1: Basic (Auto Mode)

```javascript
registerSnapkitServiceWorker({
  delivery: { organizationName: 'my-org' },
  optimization: {
    quality: 'auto',
    format: 'auto',
  }
}, 'url');
```

### Example 2: Viewport-Aware (Recommended)

```javascript
registerSnapkitServiceWorker({
  clientMetrics: {
    viewportWidth: window.innerWidth,
    dpr: window.devicePixelRatio || 1,
    enabled: true,
  },
  delivery: { organizationName: 'my-org' },
  optimization: {
    quality: 'auto',
    format: 'auto',
    limitMaxWidth: true,  // Images won't exceed viewport
  }
}, 'url');
```

### Example 3: High-Quality Photography

```javascript
registerSnapkitServiceWorker({
  clientMetrics: {
    viewportWidth: window.innerWidth,
    dpr: window.devicePixelRatio || 1,
    enabled: true,
  },
  delivery: { organizationName: 'my-org' },
  optimization: {
    quality: 95,          // Higher quality
    format: 'webp',
    limitMaxWidth: false, // No limit
    w: 2400,             // Max 2400px
  }
}, 'url');
```

### Example 4: Mobile-Optimized

```javascript
registerSnapkitServiceWorker({
  clientMetrics: {
    viewportWidth: window.innerWidth,
    dpr: window.devicePixelRatio || 1,
    enabled: true,
  },
  delivery: { organizationName: 'my-org' },
  optimization: {
    quality: 75,          // Lower quality for speed
    format: 'webp',
    limitMaxWidth: true,  // Limit to viewport
  }
}, 'url');
```

## Registration Methods

### URL Parameter Method (Cloudinary-style)

Passes config via URL query parameter:

```javascript
registerSnapkitServiceWorker(config, 'url');
// Registers: ./sw.js?config={...encoded config...}
```

**Pros:**
- Config available immediately
- No postMessage needed
- Cloudinary-compatible approach

### postMessage Method (Default)

Sends config after registration:

```javascript
registerSnapkitServiceWorker(config, 'postMessage');
// or
registerSnapkitServiceWorker(config);
```

**Pros:**
- Smaller URL
- Can update config dynamically

## Demo

Run the example:

```bash
cd service-worker
python -m http.server 8000

# Open http://localhost:8000/examples/
```

Features in demo:
- Real-time viewport and DPR display
- URL transformation log
- Before/After comparison
- Responsive testing (resize window)

## Debugging

### Check clientMetrics

Open DevTools Console:
```
[Snapkit SW] Registering with config: {
  clientMetrics: { viewportWidth: 1920, dpr: 2, enabled: true },
  ...
}
```

### View Transformed URLs

DevTools → Network → Img:
```
https://demo.snapkit.dev/image?url=https://picsum.photos/800/600&transform=w:1920,dpr:2,format:webp,quality:85
```

### Test Viewport Awareness

1. Open demo page
2. Note viewport width in config display
3. Resize browser window
4. Reload page
5. See updated viewport width in URLs

## Browser Support

- ✅ Chrome 40+
- ✅ Firefox 44+
- ✅ Safari 11.1+
- ✅ Edge 17+
- ✅ **HTTPS required** (or localhost)

## API Reference

### registerSnapkitServiceWorker(config, registrationMethod)

**Parameters:**
- `config` (object, required) - Cloudinary-style configuration
  - `clientMetrics` (object) - Viewport and DPR settings
  - `delivery` (object) - Organization configuration
  - `optimization` (object) - Image transform settings
- `registrationMethod` (string, optional) - `'url'` or `'postMessage'` (default: `'url'`)

**Returns:** `Promise<ServiceWorkerRegistration|null>`

**Example:**
```javascript
await registerSnapkitServiceWorker({
  clientMetrics: { viewportWidth: 1920, dpr: 2, enabled: true },
  delivery: { organizationName: 'my-org' },
  optimization: { quality: 'auto', format: 'auto', limitMaxWidth: true }
}, 'url');
```

## Comparison with Cloudinary

| Feature | Cloudinary | Snapkit |
|---------|-----------|---------|
| clientMetrics | ✅ viewport, DPR | ✅ viewport, DPR |
| Auto mode | ✅ q_auto, f_auto | ✅ quality: 'auto', format: 'auto' |
| URL config | ✅ Query param | ✅ Query param |
| Viewport limit | ✅ | ✅ limitMaxWidth |
| Config structure | delivery, optimization | delivery, optimization |

## Performance Tips

1. **Enable limitMaxWidth** - Prevents loading oversized images
2. **Use clientMetrics** - Serves appropriate size for device
3. **Auto mode** - Optimal balance of quality and size
4. **DPR detection** - Retina displays get high-res images

## Migration from Simple Version

**Before:**
```javascript
registerSnapkitServiceWorker({
  organizationName: 'my-org',
  transform: { format: 'webp', quality: 85 }
});
```

**After (Cloudinary-style):**
```javascript
registerSnapkitServiceWorker({
  clientMetrics: {
    viewportWidth: window.innerWidth,
    dpr: window.devicePixelRatio || 1,
    enabled: true,
  },
  delivery: { organizationName: 'my-org' },
  optimization: { quality: 'auto', format: 'auto', limitMaxWidth: true }
}, 'url');
```

## Files

- **sw.js** (216 lines) - Service Worker with clientMetrics
- **register-sw.js** (157 lines) - Cloudinary-style registration
- **snapkit-sw-config.js** (42 lines) - Example configuration
- **examples/index.html** - Interactive demo

## License

MIT

## Links

- [Main Documentation](../README.md)
- [Examples](./examples/)
- [GitHub](https://github.com/snapkit/image-url)
