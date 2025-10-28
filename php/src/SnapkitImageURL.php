<?php

namespace Snapkit\ImageURL;

/**
 * Image transformation parameters
 */
class TransformOptions
{
    /** @var int|null Image width (pixels) */
    public ?int $w = null;

    /** @var int|null Image height (pixels) */
    public ?int $h = null;

    /** @var string|null Resize mode (contain, cover, fill, inside, outside) */
    public ?string $fit = null;

    /** @var string|null Output format (jpeg, png, webp, avif) */
    public ?string $format = null;

    /** @var int|null Rotation angle (degrees) */
    public ?int $rotation = null;

    /** @var int|null Blur intensity (0.3-1000) */
    public ?int $blur = null;

    /** @var bool|null Whether to convert to grayscale */
    public ?bool $grayscale = null;

    /** @var bool|null Whether to flip vertically */
    public ?bool $flip = null;

    /** @var bool|null Whether to flip horizontally */
    public ?bool $flop = null;

    /** @var Extract|null Area extraction */
    public ?Extract $extract = null;

    /** @var float|null Device Pixel Ratio (1.0-4.0) */
    public ?float $dpr = null;

    /** @var int|null Image quality (1-100) */
    public ?int $quality = null;

    public function __construct(array $options = [])
    {
        foreach ($options as $key => $value) {
            if (property_exists($this, $key)) {
                $this->$key = $value;
            }
        }
    }
}

/**
 * Area extraction
 */
class Extract
{
    public int $x;
    public int $y;
    public int $width;
    public int $height;

    public function __construct(int $x, int $y, int $width, int $height)
    {
        $this->x = $x;
        $this->y = $y;
        $this->width = $width;
        $this->height = $height;
    }
}

/**
 * Snapkit image URL builder
 *
 * @example S3 Direct Access (Recommended)
 * ```php
 * $builder = new SnapkitImageURL('my-org');
 * $imageUrl = $builder->build(
 *     path: 'project/images/hero.jpg',
 *     transform: new TransformOptions([
 *         'w' => 300,
 *         'h' => 200,
 *         'fit' => 'cover',
 *         'format' => 'webp'
 *     ])
 * );
 * // → "https://my-org-cdn.snapkit.studio/project/images/hero.jpg?transform=w:300,h:200,fit:cover,format:webp"
 * ```
 *
 * @example External CDN Proxy (Optional)
 * ```php
 * $imageUrl = $builder->build(
 *     url: 'https://cdn.cloudfront.net/image.jpg',
 *     transform: new TransformOptions([
 *         'w' => 300,
 *         'h' => 200,
 *         'fit' => 'cover',
 *         'format' => 'webp'
 *     ])
 * );
 * // → "https://my-org.snapkit.dev/image?url=https%3A%2F%2F...&transform=w:300,h:200,fit:cover,format:webp"
 * ```
 */
class SnapkitImageURL
{
    private string $organizationName;

    public function __construct(string $organizationName)
    {
        $this->organizationName = $organizationName;
    }

    /**
     * Generate Snapkit image proxy URL
     *
     * @param string|null $path S3 path (e.g., "project/path/to/image.jpg") - for direct S3 access
     * @param string|null $url Original image URL - for external CDN proxy
     * @param TransformOptions|null $transform Image transformation options
     * @return string Complete image proxy URL
     */
    public function build(?string $path = null, ?string $url = null, ?TransformOptions $transform = null): string
    {
        // Validate parameters
        if ($path === null && $url === null) {
            throw new \InvalidArgumentException("Either 'path' or 'url' parameter must be provided");
        }

        if ($path !== null && $url !== null) {
            throw new \InvalidArgumentException("Cannot use both 'path' and 'url' parameters simultaneously");
        }

        $transformString = $transform !== null ? $this->buildTransformString($transform) : '';

        // S3 direct access
        if ($path !== null) {
            $baseUrl = "https://{$this->organizationName}-cdn.snapkit.studio/{$path}";
            return !empty($transformString) ? "{$baseUrl}?transform={$transformString}" : $baseUrl;
        }

        // External CDN proxy
        $baseUrl = "https://{$this->organizationName}.snapkit.dev/image";
        $queryParams = ['url' => $url];

        if (!empty($transformString)) {
            $queryParams['transform'] = $transformString;
        }

        return $baseUrl . '?' . http_build_query($queryParams);
    }

    private function buildTransformString(TransformOptions $options): string
    {
        $parts = [];

        // Numeric/string value parameters
        if ($options->w !== null) {
            $parts[] = "w:{$options->w}";
        }
        if ($options->h !== null) {
            $parts[] = "h:{$options->h}";
        }
        if ($options->fit !== null) {
            $parts[] = "fit:{$options->fit}";
        }
        if ($options->format !== null) {
            $parts[] = "format:{$options->format}";
        }
        if ($options->rotation !== null) {
            $parts[] = "rotation:{$options->rotation}";
        }
        if ($options->blur !== null) {
            $parts[] = "blur:{$options->blur}";
        }
        if ($options->dpr !== null) {
            $parts[] = "dpr:{$options->dpr}";
        }
        if ($options->quality !== null) {
            $parts[] = "quality:{$options->quality}";
        }

        // Boolean parameters
        if ($options->grayscale === true) {
            $parts[] = 'grayscale';
        }
        if ($options->flip === true) {
            $parts[] = 'flip';
        }
        if ($options->flop === true) {
            $parts[] = 'flop';
        }

        // extract parameter
        if ($options->extract !== null) {
            $e = $options->extract;
            $parts[] = "extract:{$e->x}-{$e->y}-{$e->width}-{$e->height}";
        }

        return implode(',', $parts);
    }
}
