'use client'

/**
 * Snapkit Custom Loader for Next.js Image Component
 * @see https://nextjs.org/docs/app/api-reference/components/image#loaderfile
 */

/**
 * Convert TransformOptions to query string
 * @param {Object} options - Transform options
 * @param {number} width - Image width
 * @returns {string} Transform query string
 */
function buildTransformString(options, width) {
  const parts = [];

  // Use width provided by Next.js
  parts.push(`w:${width}`);

  // Other options
  if (options.h !== undefined) parts.push(`h:${options.h}`);
  if (options.fit) parts.push(`fit:${options.fit}`);
  if (options.format) parts.push(`format:${options.format}`);
  if (options.rotation !== undefined)
    parts.push(`rotation:${options.rotation}`);
  if (options.blur !== undefined) parts.push(`blur:${options.blur}`);
  if (options.dpr !== undefined) parts.push(`dpr:${options.dpr}`);
  if (options.quality !== undefined) parts.push(`quality:${options.quality}`);

  // Boolean parameters
  if (options.grayscale) parts.push("grayscale");
  if (options.flip) parts.push("flip");
  if (options.flop) parts.push("flop");

  // extract parameter
  if (options.extract) {
    const { x, y, width: w, height } = options.extract;
    parts.push(`extract:${x}-${y}-${w}-${height}`);
  }

  return parts.join(",");
}

/**
 * Snapkit Custom Loader factory function
 *
 * @param {Object} config - Snapkit loader configuration
 * @param {string} config.organizationName - Organization name
 * @param {string} [config.basePath] - Base S3 path (e.g., "project/images") - for direct S3 access
 * @param {boolean} [config.useExternalProxy] - Use external CDN proxy mode
 * @param {Object} [config.transform] - Default transform options
 * @returns {Function} Next.js Image Loader function
 *
 * @example
 * ```js
 * // S3 Direct Access (Recommended)
 * // next.config.js
 * module.exports = {
 *   images: {
 *     loader: 'custom',
 *     loaderFile: './src/snapkit-loader.js',
 *   },
 * };
 *
 * // src/snapkit-loader.js
 * import { createSnapkitLoader } from './snapkit-loader';
 *
 * export default createSnapkitLoader({
 *   organizationName: 'my-org',
 *   basePath: 'project/images',
 *   transform: {
 *     format: 'webp',
 *     fit: 'cover',
 *   },
 * });
 * ```
 *
 * @example
 * ```jsx
 * // Usage in Component (S3 Direct Access)
 * import Image from 'next/image';
 *
 * export function MyComponent() {
 *   return (
 *     <Image
 *       src="hero.jpg"  // Relative path from basePath
 *       width={300}
 *       height={200}
 *       alt="Example"
 *     />
 *   );
 * }
 * ```
 *
 * @example
 * ```jsx
 * // Usage with External CDN Proxy (Optional)
 * export default createSnapkitLoader({
 *   organizationName: 'my-org',
 *   useExternalProxy: true,
 *   transform: {
 *     format: 'webp',
 *     fit: 'cover',
 *   },
 * });
 *
 * // Component
 * <Image
 *   src="https://cdn.cloudfront.net/image.jpg"
 *   width={300}
 *   height={200}
 *   alt="Example"
 * />
 * ```
 */
export function createSnapkitLoader(config) {
  return function snapkitLoader({ src, width, quality }) {
    const { organizationName, basePath, useExternalProxy, transform = {} } = config;

    // Generate transform string
    const transformOptions = {
      ...transform,
      // Map quality to format (webp generally has the best quality/size ratio)
      format: transform.format || "webp",
      // Use quality from Next.js if not specified in transform
      quality: transform.quality !== undefined ? transform.quality : quality,
    };

    const transformString = buildTransformString(transformOptions, width);

    // External CDN proxy mode
    if (useExternalProxy) {
      const baseUrl = `https://${organizationName}.snapkit.dev/image`;
      const searchParams = new URLSearchParams();
      searchParams.set("url", src);

      if (transformString) {
        searchParams.set("transform", transformString);
      }

      return `${baseUrl}?${searchParams.toString()}`;
    }

    // S3 direct access mode (default)
    const path = basePath ? `${basePath}/${src}` : src;
    const baseUrl = `https://${organizationName}-cdn.snapkit.studio/${path}`;
    return transformString ? `${baseUrl}?transform=${transformString}` : baseUrl;
  };
}

/**
 * Default Snapkit Loader (reads organizationName from environment variables)
 *
 * @param {Object} params - Next.js Image Loader parameters
 * @param {string} params.src - Image source URL
 * @param {number} params.width - Image width
 * @param {number} [params.quality] - Image quality (1-100)
 * @returns {string} Snapkit image URL
 *
 * @example
 * ```js
 * // .env.local
 * NEXT_PUBLIC_SNAPKIT_ORG=my-org
 *
 * // next.config.js
 * module.exports = {
 *   images: {
 *     loader: 'custom',
 *     loaderFile: './src/snapkit-loader.js',
 *   },
 * };
 * ```
 */
export default function snapkitLoader(params) {
  const organizationName = process.env.NEXT_PUBLIC_SNAPKIT_ORG;

  if (!organizationName) {
    throw new Error("NEXT_PUBLIC_SNAPKIT_ORG environment variable is not set");
  }

  const loader = createSnapkitLoader({ organizationName });
  return loader(params);
}
