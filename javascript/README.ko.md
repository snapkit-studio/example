# Snapkit Image URL Builder - JavaScript

JavaScript로 작성된 Snapkit 이미지 프록시 URL 생성 참고용 구현입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현입니다. 아래 코드를 프로젝트에 복사하여 사용하세요.

## 전체 구현 코드

### Step 1: 코드 복사

소스 파일을 열지 않고도 바로 복사하여 사용할 수 있도록 전체 코드를 제공합니다:

<details>
<summary><strong>전체 코드 보기</strong></summary>

```javascript
/**
 * Snapkit image proxy URL builder function
 * @module buildSnapkitImageURL
 */

/**
 * Convert TransformOptions to query string
 * @param {Object} options - Transform options object
 * @param {number} [options.w] - Image width (pixels)
 * @param {number} [options.h] - Image height (pixels)
 * @param {'contain'|'cover'|'fill'|'inside'|'outside'} [options.fit] - Resize method
 * @param {'jpeg'|'png'|'webp'|'avif'} [options.format] - Output format
 * @param {number} [options.rotation] - Rotation angle (degrees)
 * @param {number} [options.blur] - Blur intensity (0.3-1000)
 * @param {boolean} [options.grayscale] - Whether to convert to grayscale
 * @param {boolean} [options.flip] - Whether to flip vertically
 * @param {boolean} [options.flop] - Whether to flip horizontally
 * @param {Object} [options.extract] - Area extraction
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
 * @param {string} params.organizationName - Organization name (used as Snapkit subdomain)
 * @param {string} [params.path] - S3 path (e.g., "project/path/to/image.jpg") - for direct S3 access
 * @param {string} [params.url] - Original image URL (CloudFront, etc.) - for external CDN proxy
 * @param {Object} [params.transform] - Image transformation options
 * @returns {string} Complete image proxy URL
 *
 * @example
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
 * @example
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
 */
export function buildSnapkitImageURL(params) {
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
  searchParams.set("url", url);

  if (transformString) {
    searchParams.set("transform", transformString);
  }

  return `${baseUrl}?${searchParams.toString()}`;
}
```

</details>

### Step 2: 프로젝트 폴더에 파일 생성 및 붙여넣기

복사한 코드를 프로젝트에 `buildSnapkitImageURL.js` 파일로 저장합니다.

## 사용법

### 기본 사용 (S3 직접 접근 - 권장)

먼저 [src/buildSnapkitImageURL.js](src/buildSnapkitImageURL.js) 파일의 코드를 프로젝트에 복사한 후 사용하세요:

```javascript
// buildSnapkitImageURL 함수를 복사한 후 사용

const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  path: "project/images/hero.jpg",
});
// → https://my-org-cdn.snapkit.studio/project/images/hero.jpg
```

### 이미지 변환 옵션

```javascript
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
// → https://my-org-cdn.snapkit.studio/project/images/hero.jpg?transform=w:300,h:200,fit:cover,format:webp
```

### 고급 변환

```javascript
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  path: "project/images/hero.jpg",
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

### 외부 CDN 프록시 (선택사항)

기존 CDN을 계속 사용해야 하는 경우:

```javascript
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
  transform: {
    w: 300,
    h: 200,
    fit: "cover",
    format: "webp",
  },
});
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2F...&transform=w:300,h:200,fit:cover,format:webp
```

## ⚠️ URL 파라미터 사용 시 주의사항

`url` 파라미터는 **선택 사항**이며, 기존 CDN을 계속 사용하고자 할 때만 사용하세요.

- **목적**: S3가 아닌 외부 URL로부터 이미지를 fetching
- **비용**: 이미지 응답 속도 저하 및 CDN 비용 증가 가능
- **권장**: 불가피한 경우에만 사용

## Transform 옵션

| 옵션        | 타입      | 설명                                                            |
| ----------- | --------- | --------------------------------------------------------------- |
| `w`         | `number`  | 이미지 너비 (픽셀)                                              |
| `h`         | `number`  | 이미지 높이 (픽셀)                                              |
| `fit`       | `string`  | 리사이즈 방식 ('contain', 'cover', 'fill', 'inside', 'outside') |
| `format`    | `string`  | 출력 포맷 ('jpeg', 'png', 'webp', 'avif')                       |
| `rotation`  | `number`  | 회전 각도 (degrees)                                             |
| `blur`      | `number`  | 블러 강도 (0.3-1000)                                            |
| `grayscale` | `boolean` | 흑백 변환                                                       |
| `flip`      | `boolean` | 상하 반전                                                       |
| `flop`      | `boolean` | 좌우 반전                                                       |
| `extract`   | `object`  | 영역 추출 `{ x, y, width, height }`                             |
| `dpr`       | `number`  | Device Pixel Ratio (1.0-4.0)                                    |

## 개발

### 테스트 실행

```bash
# 단위 테스트
pnpm test

# Watch 모드
pnpm test:watch

# 커버리지
pnpm test:coverage
```

## 라이선스

MIT
