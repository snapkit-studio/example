# Snapkit Image URL Builder - TypeScript

[English](README.md) | [한국어](README.ko.md)

Snapkit image proxy URL builder reference implementation written in TypeScript.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

## Full Implementation Code

### Step 1: Copy the code

The complete code is provided below so you can copy and use it directly without opening source files:

<details>
<summary><strong>View Full Code</strong></summary>

```typescript
/**
 * Snapkit image proxy URL builder function
 * @module buildSnapkitImageURL
 */

/**
 * Image transformation parameter type definition
 */
export interface TransformOptions {
  /** Image width (pixels) */
  w?: number;
  /** Image height (pixels) */
  h?: number;
  /** Resize mode */
  fit?: "contain" | "cover" | "fill" | "inside" | "outside";
  /** Output format */
  format?: "jpeg" | "png" | "webp" | "avif";
  /** Rotation angle (degrees) */
  rotation?: number;
  /** Blur strength (0.3-1000) */
  blur?: number;
  /** Whether to convert to grayscale */
  grayscale?: boolean;
  /** Whether to flip vertically */
  flip?: boolean;
  /** Whether to flip horizontally */
  flop?: boolean;
  /** Region extraction (x, y, width, height) */
  extract?: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
  /** Device Pixel Ratio (1.0-4.0) */
  dpr?: number;
  /** Image quality (1-100) */
  quality?: number;
}

/**
 * buildSnapkitImageURL function parameters
 */
export interface BuildSnapkitImageURLParams {
  /** Organization name (used as Snapkit subdomain) */
  organizationName: string;
  /** S3 path (e.g., "project/path/to/image.jpg") - for direct S3 access */
  path?: string;
  /** Original image URL (CloudFront, etc.) - for external CDN proxy */
  url?: string;
  /** Image transformation options */
  transform?: TransformOptions;
}

/**
 * Convert TransformOptions to query string
 * @param options - Transformation options object
 * @returns Query string (e.g., "w:100,h:100,fit:cover")
 */
function buildTransformString(options: TransformOptions): string {
  const parts: string[] = [];

  // Numeric/string value parameters
  if (options.w !== undefined) parts.push(`w:${options.w}`);
  if (options.h !== undefined) parts.push(`h:${options.h}`);
  if (options.fit) parts.push(`fit:${options.fit}`);
  if (options.format) parts.push(`format:${options.format}`);
  if (options.rotation !== undefined)
    parts.push(`rotation:${options.rotation}`);
  if (options.blur !== undefined) parts.push(`blur:${options.blur}`);
  if (options.dpr !== undefined) parts.push(`dpr:${options.dpr}`);
  if (options.quality !== undefined) parts.push(`quality:${options.quality}`);

  // Boolean parameters (key only, no value)
  if (options.grayscale) parts.push("grayscale");
  if (options.flip) parts.push("flip");
  if (options.flop) parts.push("flop");

  // extract parameter (x-y-width-height)
  if (options.extract) {
    const { x, y, width, height } = options.extract;
    parts.push(`extract:${x}-${y}-${width}-${height}`);
  }

  return parts.join(",");
}

/**
 * Build Snapkit image proxy URL
 *
 * @param params - URL generation parameters
 * @returns Complete image proxy URL
 *
 * @example
 * ```typescript
 * // S3 direct access (recommended)
 * const imageUrl = buildSnapkitImageURL({
 *   organizationName: 'my-org',
 *   path: 'project/images/hero.jpg',
 *   transform: {
 *     w: 300,
 *     h: 200,
 *     fit: 'cover',
 *     format: 'webp'
 *   }
 * });
 * // → "https://my-org-cdn.snapkit.studio/project/images/hero.jpg?transform=w:300,h:200,fit:cover,format:webp"
 *
 * // External CDN proxy (optional)
 * const externalUrl = buildSnapkitImageURL({
 *   organizationName: 'my-org',
 *   url: 'https://cdn.cloudfront.net/image.jpg',
 *   transform: {
 *     w: 300,
 *     h: 200,
 *     fit: 'cover',
 *     format: 'webp'
 *   }
 * });
 * // → "https://my-org.snapkit.dev/image?url=https%3A%2F%2F...&transform=w:300,h:200,fit:cover,format:webp"
 * ```
 */
export function buildSnapkitImageURL(
  params: BuildSnapkitImageURLParams,
): string {
  const { organizationName, path, url, transform } = params;

  // Validate parameters
  if (!path && !url) {
    throw new Error("Either 'path' or 'url' parameter must be provided");
  }

  if (path && url) {
    throw new Error("Cannot use both 'path' and 'url' parameters simultaneously");
  }

  // Build transform query string
  const transformString = transform ? buildTransformString(transform) : "";

  // S3 direct access
  if (path) {
    const baseUrl = `https://${organizationName}-cdn.snapkit.studio/${path}`;
    return transformString ? `${baseUrl}?transform=${transformString}` : baseUrl;
  }

  // External CDN proxy
  const baseUrl = `https://${organizationName}.snapkit.dev/image`;
  const searchParams = new URLSearchParams();
  searchParams.set("url", url!);

  if (transformString) {
    searchParams.set("transform", transformString);
  }

  return `${baseUrl}?${searchParams.toString()}`;
}
```

</details>

### Step 2: Create and paste file in your project

Save the copied code as `buildSnapkitImageURL.ts` file in your project.

## Usage

### Basic Usage (S3 Direct Access - Recommended)

First, copy the code from [src/buildSnapkitImageURL.ts](src/buildSnapkitImageURL.ts) into your project:

```typescript
// Use the copied buildSnapkitImageURL function and types

// S3 direct access (recommended)
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  path: "project/images/hero.jpg",
});
// → https://my-org-cdn.snapkit.studio/project/images/hero.jpg
```

### External CDN Proxy (Optional)

```typescript
// External CDN proxy (only when necessary)
const externalUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
});
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### Image Transform Options

```typescript
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  path: "project/images/product.jpg",
  transform: {
    w: 300,
    h: 200,
    fit: "cover",
    format: "webp",
  },
});
// → https://my-org-cdn.snapkit.studio/project/images/product.jpg?transform=w:300,h:200,fit:cover,format:webp
```

### Advanced Transforms

```typescript
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  path: "project/images/banner.jpg",
  transform: {
    w: 400,
    h: 300,
    fit: "cover",
    format: "webp",
    rotation: 90,
    blur: 5,
    grayscale: true,
    dpr: 2,
    extract: {
      x: 10,
      y: 20,
      width: 100,
      height: 150,
    },
  },
});
```

## ⚠️ URL Parameter Usage Notes

The `url` parameter is **optional** and should only be used when you need to continue using your existing CDN.

- **Purpose**: Fetching images from external URLs (not S3)
- **Cost**: May increase image response time and CDN costs
- **Recommendation**: Use only when unavoidable

## Transform Options

| Option      | Type                                                      | Description                  |
| ----------- | --------------------------------------------------------- | ---------------------------- |
| `w`         | `number`                                                  | Image width (pixels)         |
| `h`         | `number`                                                  | Image height (pixels)        |
| `fit`       | `'contain' \| 'cover' \| 'fill' \| 'inside' \| 'outside'` | Resize method                |
| `format`    | `'jpeg' \| 'png' \| 'webp' \| 'avif'`                     | Output format                |
| `rotation`  | `number`                                                  | Rotation angle (degrees)     |
| `blur`      | `number`                                                  | Blur intensity (0.3-1000)    |
| `grayscale` | `boolean`                                                 | Convert to grayscale         |
| `flip`      | `boolean`                                                 | Flip vertically              |
| `flop`      | `boolean`                                                 | Flip horizontally            |
| `extract`   | `{ x, y, width, height }`                                 | Extract region               |
| `dpr`       | `number`                                                  | Device Pixel Ratio (1.0-4.0) |

## Development

### Run Tests

```bash
# Unit tests
pnpm test

# Watch mode
pnpm test:watch

# Coverage
pnpm test:coverage
```

### Build

```bash
pnpm build
```

### Type Check

```bash
pnpm type-check
```

## License

MIT
