/**
 * Snapkit image proxy URL builder function
 * @module buildSnapkitImageURL
 */

/**
 * Convert TransformOptions to query string
 * @param {Object} options - Transform options object
 * @param {number} [options.w] - Image width (pixels)
 * @param {number} [options.width] - alias of w
 * @param {number} [options.h] - Image height (pixels)
 * @param {number} [options.height] - alias of h
 * @param {'contain'|'cover'|'fill'|'inside'|'outside'} [options.fit] - Resize method
 * @param {'jpeg'|'png'|'webp'|'avif'} [options.format] - Output format
 * @param {number} [options.rotation] - Rotation angle (degrees)
 * @param {number} [options.blur] - Blur intensity (0.3-1000)
 * @param {boolean} [options.grayscale] - Whether to convert to grayscale
 * @param {boolean} [options.flip] - Whether to flip vertically
 * @param {boolean} [options.flop] - Whether to flip horizontally
 * @param {Object} [options.extract] - Area extraction (x, y, width, height)
 * @param {number} options.extract.x - X coordinate
 * @param {number} options.extract.y - Y coordinate
 * @param {number} options.extract.width - Width
 * @param {number} options.extract.height - Height
 * @param {number} [options.dpr] - Device Pixel Ratio (1.0-4.0)
 * @param {number} [options.quality] - Image quality (1-100)
 * @returns {string} Query string (e.g., "w:100,h:100,fit:cover")
 */
function buildTransformString(options) {
  const parts = [];

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
 * @param {Object} params - URL generation parameters
 * @param {string} params.organizationId - Organization name (used as Snapkit subdomain)
 * @param {string} [params.src] - Original image URL (S3, CloudFront, etc.)
 * @param {string} [params.externalURL] - External image URL (CloudFront, etc.) - for external CDN proxy
 * @param {Object} [params.transform] - Image transformation options
 * @param {Object} [params.defaultTransformOptions] - Default transformation options
 * @returns {string} Complete image proxy URL
 *
 * @example
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
 * @example
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
 */
export function buildSnapkitImageURL(params) {
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
  searchParams.set("url", externalURL);

  if (transformString) {
    searchParams.set("transform", transformString);
  }

  return `${baseUrl}?${searchParams.toString()}`;
}
