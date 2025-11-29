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
  /** alias of w */
  width?: number;
  /** Image height (pixels) */
  h?: number;
  /** alias of h */
  height?: number;
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
  organizationId: string;
  /** Original image URL (S3, CloudFront, etc.) */
  src?: string;
  /** External image URL (CloudFront, etc.) - for external CDN proxy */
  externalURL?: string;
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
  if (options.width !== undefined) parts.push(`w:${options.width}`);
  if (options.height !== undefined) parts.push(`h:${options.height}`);
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
 *   organizationId: 'my-org',
 *   src: 'https://cdn.snapkit.studio/my-org-id/project/images/hero.jpg',
 *   transform: {
 *     w: 300,
 *     h: 200,
 *     fit: 'cover',
 *     format: 'webp'
 *   }
 * });
 * // → "https://cdn.snapkit.studio/my-org-id/project/images/hero.jpg?transform=w:300,h:200,fit:cover,format:webp"
 *
 * // External CDN proxy (optional)
 * const externalUrl = buildSnapkitImageURL({
 *   organizationId: 'my-org',
 *   externalURL: 'https://cdn.cloudfront.net/image.jpg',
 *   transform: {
 *     w: 300,
 *     h: 200,
 *     fit: 'cover',
 *     format: 'webp'
 *   }
 * });
 * // → "https://cdn.snapkit.studio/my-org-id/external?url=https%3A%2F%2F...&transform=w:300,h:200,fit:cover,format:webp"
 * ```
 */
export function buildSnapkitImageURL(
  params: BuildSnapkitImageURLParams & {
    defaultTransformOptions?: TransformOptions;
  }
): string {
  const {
    organizationId,
    externalURL,
    src,
    transform,
    defaultTransformOptions = {
      dpr: 2,
    },
  } = params;

  // Validate parameters
  if (!externalURL && !src) {
    throw new Error("Either 'src' or 'url' parameter must be provided");
  }

  if (src && externalURL) {
    throw new Error(
      "Cannot use both 'src' and 'url' parameters simultaneously"
    );
  }

  // Build transform query string
  const transformString = transform
    ? buildTransformString({ ...defaultTransformOptions, ...transform })
    : "";

  // S3 direct access
  if (src) {
    return transformString ? `${src}?transform=${transformString}` : src;
  }

  // External CDN proxy
  const baseUrl = `https://cdn.snapkit.studio/${organizationId}/external`;
  const searchParams = new URLSearchParams();
  searchParams.set("url", externalURL!);

  if (transformString) {
    searchParams.set("transform", transformString);
  }

  return `${baseUrl}?${searchParams.toString()}`;
}
