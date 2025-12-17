//
//  TransformOptions.swift
//  snapkit-image
//
//  Created by 김재한 on 12/16/25.
//

import Foundation

/// Image transformation parameters
public struct TransformOptions {
    
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
    
    private let values: [Key: Value]

    private init(values: [Key: Value]) {
        self.values = values
    }

    public init() {
        self.values = [:]
    }

    // MARK: - Builder-style chainable setters
    /// Sets the image width in pixels.
    ///
    /// - Parameter value: The target width (pixels).
    /// - Returns: A new `TransformOptions` with updated width, allowing method chaining.
    @discardableResult
    public func setWidth(_ value: Int) -> TransformOptions {
        return updating(.w, .int(value))
    }

    /// Sets the image height in pixels.
    ///
    /// - Parameter value: The target height (pixels).
    /// - Returns: A new `TransformOptions` with updated height, allowing method chaining.
    @discardableResult
    public func setHeight(_ value: Int) -> TransformOptions {
        return updating(.h, .int(value))
    }

    /// Sets the resizing strategy for the image.
    ///
    /// - Parameter value: The resize method to apply (e.g., `.cover`, `.contain`).
    /// - Returns: A new `TransformOptions` with updated fit, allowing method chaining.
    @discardableResult
    public func setFit(_ value: Fit) -> TransformOptions {
        return updating(.fit, .string(value.rawValue))
    }

    /// Sets the output image format.
    ///
    /// - Parameter value: The desired output format (e.g., `.jpeg`, `.png`).
    /// - Returns: A new `TransformOptions` with updated format, allowing method chaining.
    @discardableResult
    public func setFormat(_ value: Format) -> TransformOptions {
        return updating(.format, .string(value.rawValue))
    }

    /// Sets the rotation angle in degrees.
    ///
    /// - Parameter value: The rotation angle in degrees.
    /// - Returns: A new `TransformOptions` with updated rotation, allowing method chaining.
    @discardableResult
    public func setRotation(_ value: Int) -> TransformOptions {
        return updating(.rotation, .int(value))
    }

    /// Sets the blur intensity.
    ///
    /// - Parameter value: The blur amount (e.g., 1–1000).
    /// - Returns: A new `TransformOptions` with updated blur, allowing method chaining.
    @discardableResult
    public func setBlur(_ value: Int) -> TransformOptions {
        return updating(.blur, .int(value))
    }

    /// Enables or disables grayscale conversion.
    ///
    /// - Parameter value: `true` to convert to grayscale, `false` otherwise.
    /// - Returns: A new `TransformOptions` with updated grayscale flag, allowing method chaining.
    @discardableResult
    public func setGrayscale(_ value: Bool) -> TransformOptions {
        return updating(.grayscale, .bool(value))
    }

    /// Sets vertical flipping of the image.
    ///
    /// - Parameter value: `true` to flip vertically.
    /// - Returns: A new `TransformOptions` with updated flip flag, allowing method chaining.
    @discardableResult
    public func setFlip(_ value: Bool) -> TransformOptions {
        return updating(.flip, .bool(value))
    }

    /// Sets horizontal flipping of the image.
    ///
    /// - Parameter value: `true` to flip horizontally.
    /// - Returns: A new `TransformOptions` with updated flop flag, allowing method chaining.
    @discardableResult
    public func setFlop(_ value: Bool) -> TransformOptions {
        return updating(.flop, .bool(value))
    }

    /// Sets the region to extract from the original image.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate of the top-left corner.
    ///   - y: The y-coordinate of the top-left corner.
    ///   - width: The width of the region to extract.
    ///   - height: The height of the region to extract.
    /// - Returns: A new `TransformOptions` with updated extract region, allowing method chaining.
    @discardableResult
    public func setExtract(x: Int, y: Int, width: Int, height: Int) -> TransformOptions {
        return updating(.extract, .extract(x: x, y: y, width: width, height: height))
    }

    /// Sets the device pixel ratio (DPR).
    ///
    /// - Parameter value: The DPR value (e.g., 1.0–4.0).
    /// - Returns: A new `TransformOptions` with updated DPR, allowing method chaining.
    @discardableResult
    public func setDPR(_ value: Double) -> TransformOptions {
        return updating(.dpr, .double(value))
    }

    /// Sets the output image quality.
    ///
    /// - Parameter value: The quality value (1–100).
    /// - Returns: A new `TransformOptions` with updated quality, allowing method chaining.
    @discardableResult
    public func setQuality(_ value: Int) -> TransformOptions {
        return updating(.quality, .int(value))
    }

    private func updating(_ key: Key, _ newValue: Value) -> TransformOptions {
        var copy = values
        copy[key] = newValue
        return TransformOptions(values: copy)
    }

    /// Builds the transform string representation for URL queries as a comma-separated list without any prefix.
    public func buildTransformString() -> String {
        var parts: [String] = []
        for (key, value) in values {
            switch (key, value) {
            case (.w, .int(let v)): parts.append("w:\(v)")
            case (.h, .int(let v)): parts.append("h:\(v)")
            case (.fit, .string(let s)): parts.append("fit:\(s)")
            case (.format, .string(let s)): parts.append("format:\(s)")
            case (.rotation, .int(let v)): parts.append("rotation:\(v)")
            case (.blur, .int(let v)): parts.append("blur:\(v)")
            case (.dpr, .double(let d)): parts.append("dpr:\(d)")
            case (.quality, .int(let v)): parts.append("quality:\(v)")
            case (.grayscale, .bool(let b)):
                if b { parts.append("grayscale") }
            case (.flip, .bool(let b)):
                if b { parts.append("flip") }
            case (.flop, .bool(let b)):
                if b { parts.append("flop") }
            case (.extract, .extract(let x, let y, let w, let h)):
                parts.append("extract:\(x)-\(y)-\(w)-\(h)")
            default:
                break
            }
        }
        if parts.isEmpty {
            return ""
        }
        return parts.joined(separator: ",")
    }

    private enum Key: Hashable {
        case w, h, fit, format, rotation, blur, grayscale, flip, flop, extract, dpr, quality
    }

    private enum Value {
        case int(Int)
        case double(Double)
        case bool(Bool)
        case string(String)
        case extract(x: Int, y: Int, width: Int, height: Int)
    }
}
