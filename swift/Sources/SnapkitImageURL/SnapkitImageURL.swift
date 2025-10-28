import Foundation

/// Image transformation parameters
public struct TransformOptions {
    /// Image width (pixels)
    public var w: Int?
    /// Image height (pixels)
    public var h: Int?
    /// Resize method
    public var fit: Fit?
    /// Output format
    public var format: Format?
    /// Rotation angle (degrees)
    public var rotation: Int?
    /// Blur intensity (0.3-1000)
    public var blur: Int?
    /// Whether to convert to grayscale
    public var grayscale: Bool?
    /// Whether to flip vertically
    public var flip: Bool?
    /// Whether to flip horizontally
    public var flop: Bool?
    /// Region extraction
    public var extract: Extract?
    /// Device Pixel Ratio (1.0-4.0)
    public var dpr: Double?
    /// Image quality (1-100)
    public var quality: Int?

    public init(
        w: Int? = nil,
        h: Int? = nil,
        fit: Fit? = nil,
        format: Format? = nil,
        rotation: Int? = nil,
        blur: Int? = nil,
        grayscale: Bool? = nil,
        flip: Bool? = nil,
        flop: Bool? = nil,
        extract: Extract? = nil,
        dpr: Double? = nil,
        quality: Int? = nil
    ) {
        self.w = w
        self.h = h
        self.fit = fit
        self.format = format
        self.rotation = rotation
        self.blur = blur
        self.grayscale = grayscale
        self.flip = flip
        self.flop = flop
        self.extract = extract
        self.dpr = dpr
        self.quality = quality
    }

    /// Resize method
    public enum Fit: String {
        case contain
        case cover
        case fill
        case inside
        case outside
    }

    /// Output format
    public enum Format: String {
        case jpeg
        case png
        case webp
        case avif
    }

    /// Region extraction
    public struct Extract {
        public let x: Int
        public let y: Int
        public let width: Int
        public let height: Int

        public init(x: Int, y: Int, width: Int, height: Int) {
            self.x = x
            self.y = y
            self.width = width
            self.height = height
        }
    }
}

/// Snapkit image URL builder
public struct SnapkitImageURLBuilder {
    private let organizationName: String

    public init(organizationName: String) {
        self.organizationName = organizationName
    }

    /// Generate Snapkit image proxy URL
    ///
    /// - Parameters:
    ///   - path: S3 path (e.g., "project/path/to/image.jpg") - for direct S3 access
    ///   - url: Original image URL (CloudFront, etc.) - for external CDN proxy
    ///   - transform: Image transformation options
    /// - Returns: Complete image proxy URL
    ///
    /// # Example - S3 Direct Access (Recommended)
    /// ```swift
    /// let builder = SnapkitImageURLBuilder(organizationName: "my-org")
    /// let imageURL = builder.build(
    ///     path: "project/images/hero.jpg",
    ///     transform: TransformOptions(
    ///         w: 300,
    ///         h: 200,
    ///         fit: .cover,
    ///         format: .webp
    ///     )
    /// )
    /// // → "https://my-org-cdn.snapkit.studio/project/images/hero.jpg?transform=w:300,h:200,fit:cover,format:webp"
    /// ```
    ///
    /// # Example - External CDN Proxy (Optional)
    /// ```swift
    /// let imageURL = builder.build(
    ///     url: "https://cdn.cloudfront.net/image.jpg",
    ///     transform: TransformOptions(
    ///         w: 300,
    ///         h: 200,
    ///         fit: .cover,
    ///         format: .webp
    ///     )
    /// )
    /// // → "https://my-org.snapkit.dev/image?url=https%3A%2F%2F...&transform=w:300,h:200,fit:cover,format:webp"
    /// ```
    public func build(path: String? = nil, url: String? = nil, transform: TransformOptions? = nil) -> URL? {
        // Validate parameters
        guard path != nil || url != nil else {
            return nil
        }

        guard !(path != nil && url != nil) else {
            return nil
        }

        let transformString = transform.map { buildTransformString($0) } ?? ""

        // S3 direct access
        if let path = path {
            let baseUrl = "https://\(organizationName)-cdn.snapkit.studio/\(path)"
            if !transformString.isEmpty {
                return URL(string: "\(baseUrl)?transform=\(transformString)")
            }
            return URL(string: baseUrl)
        }

        // External CDN proxy
        var components = URLComponents(string: "https://\(organizationName).snapkit.dev/image")
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "url", value: url)
        ]

        if !transformString.isEmpty {
            queryItems.append(URLQueryItem(name: "transform", value: transformString))
        }

        components?.queryItems = queryItems
        return components?.url
    }

    private func buildTransformString(_ options: TransformOptions) -> String {
        var parts: [String] = []

        // Numeric/string value parameters
        if let w = options.w {
            parts.append("w:\(w)")
        }
        if let h = options.h {
            parts.append("h:\(h)")
        }
        if let fit = options.fit {
            parts.append("fit:\(fit.rawValue)")
        }
        if let format = options.format {
            parts.append("format:\(format.rawValue)")
        }
        if let rotation = options.rotation {
            parts.append("rotation:\(rotation)")
        }
        if let blur = options.blur {
            parts.append("blur:\(blur)")
        }
        if let dpr = options.dpr {
            parts.append("dpr:\(dpr)")
        }
        if let quality = options.quality {
            parts.append("quality:\(quality)")
        }

        // Boolean parameters
        if options.grayscale == true {
            parts.append("grayscale")
        }
        if options.flip == true {
            parts.append("flip")
        }
        if options.flop == true {
            parts.append("flop")
        }

        // extract parameter
        if let extract = options.extract {
            parts.append("extract:\(extract.x)-\(extract.y)-\(extract.width)-\(extract.height)")
        }

        return parts.joined(separator: ",")
    }
}
