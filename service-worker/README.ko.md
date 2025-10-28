# Snapkit Service Worker (Cloudinary 스타일)

**뷰포트 인식 크기 조정 및 DPR 감지로 웹사이트의 모든 이미지를 자동으로 최적화합니다.**

Cloudinary의 Service Worker 접근 방식에서 영감을 받았습니다.

## 기능

✅ **코드 변경 불필요** - 기존 `<img>` 태그와 함께 작동
🎯 **clientMetrics** - 뷰포트 너비 및 DPR 자동 감지
🚀 **자동 모드** - `quality: 'auto'`, `format: 'auto'`
📐 **뷰포트 인식** - 이미지 너비를 뷰포트에 자동으로 제한
⚡ **3분 설정** - Cloudinary 스타일 구성

## 작동 원리

```
브라우저가 이미지 요청
    ↓
Service Worker가 가로챔
    ↓
clientMetrics 적용 (뷰포트, DPR)
    ↓
Snapkit URL로 변환
    ↓
최적화된 이미지 반환
```

**예시:**
```
HTML:     <img src="https://example.com/photo.jpg">
          ↓
Config:   viewport=1920, dpr=2, quality=auto, format=auto, limitMaxWidth=true
          ↓
Request:  https://demo.snapkit.dev/image?url=https://example.com/photo.jpg&transform=w:1920,dpr:2,format:webp,quality:85
```

## 언제 사용해야 할까요?

⚠️ **중요**: 이 Service Worker는 브라우저 수준에서 이미지 요청을 가로채서 변환을 적용합니다. 강력하지만, 이 접근 방식은 **특정 시나리오**에서만 필요합니다:

**Service Worker 사용을 고려해야 할 때:**
- 하드코딩된 이미지 URL이 많은 기존 사이트가 있을 때
- HTML/컴포넌트 코드를 수정할 수 없을 때
- 제어할 수 없는 서드파티 이미지를 최적화해야 할 때
- 코드 변경 없이 이미지 최적화가 필요할 때

**대부분의 경우 직접 통합이 더 간단합니다:**
- 컴포넌트에서 직접 Snapkit URL 빌더 사용
- 사용 사례별로 이미지 최적화를 더 잘 제어
- 더 간단한 디버깅 및 유지보수
- Service Worker 복잡성 없음

새 프로젝트를 시작하거나 코드를 수정할 수 있다면, [메인 Snapkit 통합](../README.ko.md)을 대신 사용하는 것을 고려하세요.

---

## 빠른 시작

### 1. 파일 복사

```
your-project/
├── sw.js                    # Service Worker
├── register-sw.js           # 등록
└── snapkit-sw-config.js     # 설정 (선택사항)
```

### 2. 설정 (Cloudinary 스타일)

```javascript
const config = {
  clientMetrics: {
    viewportWidth: window.innerWidth,      // 현재 뷰포트
    dpr: window.devicePixelRatio || 1,     // 디바이스 픽셀 비율
    enabled: true,                         // 메트릭 활성화
  },
  delivery: {
    organizationName: 'my-org',  // 필수
  },
  optimization: {
    quality: 'auto',      // 'auto' → 85
    format: 'auto',       // 'auto' → webp
    limitMaxWidth: true,  // 최대 너비 = 뷰포트
  },
};
```

### 3. 등록

**옵션 A: URL 파라미터 (Cloudinary 스타일)**
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

  // URL을 통해 config 전달 (Cloudinary처럼)
  registerSnapkitServiceWorker(config, 'url');
</script>
```

**옵션 B: 설정 파일**
```html
<script type="module">
  import config from './snapkit-sw-config.js';
  import { registerSnapkitServiceWorker } from './register-sw.js';

  registerSnapkitServiceWorker(config, 'url');
</script>
```

### 4. 완료!

이제 모든 이미지가 뷰포트 인식 크기 조정으로 자동 최적화됩니다:

```html
<!-- 변경 불필요 -->
<img src="https://example.com/photo.jpg">
```

## 설정

### 전체 설정 구조

```javascript
{
  // 클라이언트 메트릭 (뷰포트 및 디바이스 정보)
  clientMetrics: {
    viewportWidth: window.innerWidth,  // 뷰포트 너비 (픽셀)
    dpr: window.devicePixelRatio || 1, // 디바이스 픽셀 비율 (1, 2, 3)
    enabled: true,                     // clientMetrics 활성화
  },

  // 전달 (조직)
  delivery: {
    organizationName: 'my-org',  // 필수
  },

  // 최적화 설정
  optimization: {
    quality: 'auto',      // 'auto' 또는 1-100
    format: 'auto',       // 'auto' 또는 'webp', 'jpeg', 'png', 'avif'
    limitMaxWidth: true,  // 뷰포트 너비로 제한

    // 선택적 오버라이드
    // w: 1200,           // 고정 너비 (limitMaxWidth 무시)
    // h: 800,            // 고정 높이
    // fit: 'cover',      // 맞춤 모드
    // blur: 10,          // 흐림 강도
    // grayscale: true,   // 흑백
    // rotation: 90,      // 회전
  }
}
```

### 자동 모드

| 설정 | 자동 값 | 설명 |
|---------|------------|-------------|
| `quality: 'auto'` | `85` | 최적의 품질/크기 균형 |
| `format: 'auto'` | `webp` | 최고의 압축률을 가진 최신 포맷 |

### clientMetrics

| 메트릭 | 목적 | 효과 |
|--------|---------|--------|
| `viewportWidth` | 현재 뷰포트 너비 | `limitMaxWidth: true`일 때 최대 이미지 너비 설정 |
| `dpr` | 디바이스 픽셀 비율 | 레티나 디스플레이를 위해 크기 배율 적용 |
| `enabled` | 메트릭 활성화/비활성화 | clientMetrics 기능 토글 |

## 예제

### 예제 1: 기본 (자동 모드)

```javascript
registerSnapkitServiceWorker({
  delivery: { organizationName: 'my-org' },
  optimization: {
    quality: 'auto',
    format: 'auto',
  }
}, 'url');
```

### 예제 2: 뷰포트 인식 (권장)

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
    limitMaxWidth: true,  // 이미지가 뷰포트를 초과하지 않음
  }
}, 'url');
```

### 예제 3: 고품질 사진

```javascript
registerSnapkitServiceWorker({
  clientMetrics: {
    viewportWidth: window.innerWidth,
    dpr: window.devicePixelRatio || 1,
    enabled: true,
  },
  delivery: { organizationName: 'my-org' },
  optimization: {
    quality: 95,          // 더 높은 품질
    format: 'webp',
    limitMaxWidth: false, // 제한 없음
    w: 2400,             // 최대 2400px
  }
}, 'url');
```

### 예제 4: 모바일 최적화

```javascript
registerSnapkitServiceWorker({
  clientMetrics: {
    viewportWidth: window.innerWidth,
    dpr: window.devicePixelRatio || 1,
    enabled: true,
  },
  delivery: { organizationName: 'my-org' },
  optimization: {
    quality: 75,          // 속도를 위한 낮은 품질
    format: 'webp',
    limitMaxWidth: true,  // 뷰포트로 제한
  }
}, 'url');
```

## 등록 방법

### URL 파라미터 방법 (Cloudinary 스타일)

URL 쿼리 파라미터를 통해 config 전달:

```javascript
registerSnapkitServiceWorker(config, 'url');
// 등록: ./sw.js?config={...인코딩된 config...}
```

**장점:**
- Config를 즉시 사용 가능
- postMessage 불필요
- Cloudinary 호환 접근 방식

### postMessage 방법 (기본)

등록 후 config 전송:

```javascript
registerSnapkitServiceWorker(config, 'postMessage');
// 또는
registerSnapkitServiceWorker(config);
```

**장점:**
- 더 작은 URL
- 동적으로 config 업데이트 가능

## 데모

예제 실행:

```bash
cd service-worker
python -m http.server 8000

# http://localhost:8000/examples/ 열기
```

데모 기능:
- 실시간 뷰포트 및 DPR 표시
- URL 변환 로그
- 전/후 비교
- 반응형 테스트 (창 크기 조정)

## 디버깅

### clientMetrics 확인

DevTools 콘솔 열기:
```
[Snapkit SW] Registering with config: {
  clientMetrics: { viewportWidth: 1920, dpr: 2, enabled: true },
  ...
}
```

### 변환된 URL 보기

DevTools → Network → Img:
```
https://demo.snapkit.dev/image?url=https://picsum.photos/800/600&transform=w:1920,dpr:2,format:webp,quality:85
```

### 뷰포트 인식 테스트

1. 데모 페이지 열기
2. config 표시에서 뷰포트 너비 확인
3. 브라우저 창 크기 조정
4. 페이지 새로고침
5. URL에서 업데이트된 뷰포트 너비 확인

## 브라우저 지원

- ✅ Chrome 40+
- ✅ Firefox 44+
- ✅ Safari 11.1+
- ✅ Edge 17+
- ✅ **HTTPS 필수** (또는 localhost)

## API 참조

### registerSnapkitServiceWorker(config, registrationMethod)

**파라미터:**
- `config` (객체, 필수) - Cloudinary 스타일 설정
  - `clientMetrics` (객체) - 뷰포트 및 DPR 설정
  - `delivery` (객체) - 조직 설정
  - `optimization` (객체) - 이미지 변환 설정
- `registrationMethod` (문자열, 선택) - `'url'` 또는 `'postMessage'` (기본: `'url'`)

**반환:** `Promise<ServiceWorkerRegistration|null>`

**예제:**
```javascript
await registerSnapkitServiceWorker({
  clientMetrics: { viewportWidth: 1920, dpr: 2, enabled: true },
  delivery: { organizationName: 'my-org' },
  optimization: { quality: 'auto', format: 'auto', limitMaxWidth: true }
}, 'url');
```

## Cloudinary와 비교

| 기능 | Cloudinary | Snapkit |
|---------|-----------|---------|
| clientMetrics | ✅ viewport, DPR | ✅ viewport, DPR |
| 자동 모드 | ✅ q_auto, f_auto | ✅ quality: 'auto', format: 'auto' |
| URL config | ✅ 쿼리 파라미터 | ✅ 쿼리 파라미터 |
| 뷰포트 제한 | ✅ | ✅ limitMaxWidth |
| Config 구조 | delivery, optimization | delivery, optimization |

## 성능 팁

1. **limitMaxWidth 활성화** - 과도하게 큰 이미지 로딩 방지
2. **clientMetrics 사용** - 디바이스에 적합한 크기 제공
3. **자동 모드** - 품질과 크기의 최적 균형
4. **DPR 감지** - 레티나 디스플레이에 고해상도 이미지 제공

## 단순 버전에서 마이그레이션

**이전:**
```javascript
registerSnapkitServiceWorker({
  organizationName: 'my-org',
  transform: { format: 'webp', quality: 85 }
});
```

**이후 (Cloudinary 스타일):**
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

## 파일

- **sw.js** (216줄) - clientMetrics가 있는 Service Worker
- **register-sw.js** (157줄) - Cloudinary 스타일 등록
- **snapkit-sw-config.js** (42줄) - 예제 설정
- **examples/index.html** - 인터랙티브 데모

## 라이선스

MIT

## 링크

- [메인 문서](../README.ko.md)
- [예제](./examples/)
- [GitHub](https://github.com/snapkit/image-url)
