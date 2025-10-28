# Snapkit Image URL Builder

[English](README.md) | [한국어](README.ko.md)

Build Snapkit image proxy URLs for multiple languages and frameworks.

> **⚠️ Note**: These are reference implementations, not published packages. Copy the example code from each language directory into your project.

## Supported Languages & Frameworks

| Language/Framework        | Platform                  | Package Manager       | Documentation                |
| ------------------------- | ------------------------- | --------------------- | ---------------------------- |
| [TypeScript](#typescript) | Node.js, Browser          | npm, pnpm, yarn       | [Docs](typescript/README.md) |
| [JavaScript](#javascript) | Node.js, Browser          | npm, pnpm, yarn       | [Docs](javascript/README.md) |
| [Next.js](#nextjs)        | React (SSR)               | npm, pnpm, yarn       | [Docs](nextjs/README.md)     |
| [Swift](#swift)           | iOS, macOS, tvOS, watchOS | Swift Package Manager | [Docs](swift/README.md)      |
| [Kotlin](#kotlin)         | Android                   | Gradle                | [Docs](kotlin/README.md)     |
| [Dart](#dart)             | Flutter                   | pub                   | [Docs](dart/README.md)       |
| [PHP](#php)               | Web                       | Composer              | [Docs](php/README.md)        |
| [Service Worker](#service-worker) 🧪 | Browser | - | [Docs](service-worker/README.md) |

## Quick Start Examples

### TypeScript

Copy the `buildSnapkitImageURL` function from [typescript/src/buildSnapkitImageURL.ts](typescript/src/buildSnapkitImageURL.ts) and use it:

```typescript
// Copy the function from typescript/src/buildSnapkitImageURL.ts
// Then use it in your code:

// S3 direct access (recommended)
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  path: "project/images/hero.jpg",
  transform: {
    w: 300,
    h: 200,
    fit: "cover",
    format: "webp",
  },
});

// External CDN proxy (optional)
const externalUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
  transform: {
    w: 300,
    h: 200,
    fit: "cover",
    format: "webp",
  },
});
```

### JavaScript

Copy the `buildSnapkitImageURL` function from [javascript/src/buildSnapkitImageURL.js](javascript/src/buildSnapkitImageURL.js) and use it:

```javascript
// Copy the function from javascript/src/buildSnapkitImageURL.js
// Then use it in your code:

// S3 direct access (recommended)
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  path: "project/images/hero.jpg",
  transform: {
    w: 300,
    h: 200,
    fit: "cover",
    format: "webp",
  },
});
```

### Next.js

See the [Next.js documentation](nextjs/README.md) for complete implementation. Copy the helper functions and create a custom loader:

```typescript
// 1. Copy functions to src/snapkit-loader.js
// 2. Configure next.config.js

// next.config.js
module.exports = {
  images: {
    loader: "custom",
    loaderFile: "./src/snapkit-loader.js",
  },
};

// S3 Direct Access (Recommended)
export default createSnapkitLoader({
  organizationName: 'my-org',
  basePath: 'project/images',
});

// Component
<Image
  src="hero.jpg"  // Relative to basePath
  width={300}
  height={200}
  alt="Example"
/>
```

### Swift

Copy the Swift implementation from [swift/Sources/](swift/Sources/) and use it:

```swift
// Copy the implementation files from swift/Sources/
// Then use it in your code:

let builder = SnapkitImageURL(organizationName: "my-org")

// S3 direct access (recommended)
let imageURL = builder.build(
    path: "project/images/hero.jpg",
    transform: TransformOptions(
        w: 300,
        h: 200,
        fit: .cover,
        format: .webp
    )
)
```

### Kotlin

Copy the Kotlin implementation from [kotlin/src/](kotlin/src/) and use it:

```kotlin
// Copy the implementation files from kotlin/src/
// Then use it in your code:

val builder = SnapkitImageURL("my-org")

// S3 direct access (recommended)
val imageUrl = builder.build(
    path = "project/images/hero.jpg",
    transform = TransformOptions(
        w = 300,
        h = 200,
        fit = TransformOptions.Fit.COVER,
        format = TransformOptions.Format.WEBP
    )
)
```

### Dart

Copy the Dart implementation from [dart/lib/](dart/lib/) and use it:

```dart
// Copy the implementation files from dart/lib/
// Then use it in your code:

final builder = SnapkitImageURL('my-org');

// S3 direct access (recommended)
final imageUrl = builder.build(
  path: 'project/images/hero.jpg',
  transform: TransformOptions(
    w: 300,
    h: 200,
    fit: Fit.cover,
    format: Format.webp,
  ),
);
```

### PHP

Copy the PHP implementation from [php/src/](php/src/) and use it:

```php
<?php
// Copy the implementation files from php/src/
// Then use it in your code:

$builder = new SnapkitImageURL('my-org');

// S3 direct access (recommended)
$imageUrl = $builder->build(
    path: 'project/images/hero.jpg',
    transform: new TransformOptions([
        'w' => 300,
        'h' => 200,
        'fit' => 'cover',
        'format' => 'webp',
    ])
);
```

### Service Worker 🧪

**Experimental**: Browser-level image optimization without code changes. Copy files from [service-worker/](service-worker/) and register:

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

  registerSnapkitServiceWorker(config, 'url');
</script>

<!-- Existing img tags work automatically -->
<img src="https://example.com/photo.jpg">
```

**Use Service Worker when:**
- You have an existing site with hardcoded image URLs
- You cannot modify HTML/component code
- You need to optimize third-party images

**For new projects, direct integration (above) is recommended.**

## Usage Modes

### S3 Direct Access (Recommended)
- **URL Format**: `https://{org}-cdn.snapkit.studio/{path}?transform=...`
- **Use `path` parameter**: Provide S3 path like `"project/images/hero.jpg"`
- **Benefits**: Faster response, lower costs, direct S3 integration

### External CDN Proxy (Optional)
- **URL Format**: `https://{org}.snapkit.dev/image?url=...&transform=...`
- **Use `url` parameter**: Provide external URL like `"https://cdn.cloudfront.net/image.jpg"`
- **Purpose**: For existing CDN integration
- **Recommendation**: Use only when unavoidable

## Transform Options

All implementations support the following transform options:

| Option      | Type      | Description                                                  |
| ----------- | --------- | ------------------------------------------------------------ |
| `w`         | `number`  | Image width in pixels                                        |
| `h`         | `number`  | Image height in pixels                                       |
| `fit`       | `string`  | Resize mode: `contain`, `cover`, `fill`, `inside`, `outside` |
| `format`    | `string`  | Output format: `jpeg`, `png`, `webp`, `avif`                 |
| `rotation`  | `number`  | Rotation angle in degrees                                    |
| `blur`      | `number`  | Blur intensity (0.3-1000)                                    |
| `grayscale` | `boolean` | Convert to grayscale                                         |
| `flip`      | `boolean` | Flip vertically                                              |
| `flop`      | `boolean` | Flip horizontally                                            |
| `extract`   | `object`  | Extract region `{x, y, width, height}`                       |
| `dpr`       | `number`  | Device Pixel Ratio (1.0-4.0)                                 |

## Usage

**These are reference implementations**. Copy the code examples from the language-specific directories into your project:

- **TypeScript/JavaScript**: Copy code from [typescript/](typescript/) or [javascript/](javascript/)
- **Next.js**: Copy code from [nextjs/](nextjs/)
- **Swift**: Copy code from [swift/](swift/)
- **Kotlin**: Copy code from [kotlin/](kotlin/)
- **Dart**: Copy code from [dart/](dart/)
- **PHP**: Copy code from [php/](php/)

See individual documentation for detailed implementation instructions.

## Testing

Each implementation includes comprehensive unit tests:

```bash
# TypeScript/JavaScript/Next.js
pnpm test

# Swift
swift test

# Kotlin
./gradlew test

# Dart
dart test

# PHP
composer test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT

## Documentation

For detailed documentation, examples, and API reference, see the individual language documentation:

- [TypeScript Documentation](typescript/README.md)
- [JavaScript Documentation](javascript/README.md)
- [Next.js Documentation](nextjs/README.md)
- [Swift Documentation](swift/README.md)
- [Kotlin Documentation](kotlin/README.md)
- [Dart Documentation](dart/README.md)
- [PHP Documentation](php/README.md)
