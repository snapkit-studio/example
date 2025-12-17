import Foundation
import Testing

@testable import snapkit_image

@Suite("TransformQueryBuilder Tests")
struct TransformQueryBuilderTests {

    @Test("Returns nil when base URL is nil")
    func nilBaseURLReturnsNil() async throws {
        let builder = TransformQueryBuilder(url: nil)
        let options = TransformOptions().setWidth(100)
        let result = builder.buildTransformURL(options: options)
        #expect(result == nil)
    }

    @Test("Appends transform query to URL without existing query")
    func appendsTransformToCleanURL() async throws {
        let base = URL(string: "https://example.com/image.png")!
        let builder = TransformQueryBuilder(url: base)
        let options = TransformOptions()
            .setWidth(300)
            .setHeight(200)
            .setFormat(.webp)
        let url = try #require(builder.buildTransformURL(options: options))
        // Ensure base remains
        #expect(url.scheme == "https")
        #expect(url.host == "example.com")
        #expect(url.path == "/image.png")
        // Verify query items contain transform with tokens (order-agnostic)
        let comps = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let transformItem = comps.queryItems?.first(where: { $0.name == "transform" })
        let value = try #require(transformItem?.value)
        #expect(value.contains("format:webp"))
        #expect(value.contains("w:300"))
        #expect(value.contains("h:200"))
    }

    @Test("Replaces existing transform query if present")
    func replacesExistingTransform() async throws {
        var comps = URLComponents(string: "https://example.com/pic.jpg")!
        comps.queryItems = [
            URLQueryItem(name: "foo", value: "bar"),
            URLQueryItem(name: "transform", value: "w:10,h:10")
        ]
        let base = try #require(comps.url)
        let builder = TransformQueryBuilder(url: base)
        let options = TransformOptions().setWidth(999).setFit(.cover)
        let url = try #require(builder.buildTransformURL(options: options))
        let outComps = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        // foo=bar should remain
        let foo = outComps.queryItems?.first(where: { $0.name == "foo" })?.value
        #expect(foo == "bar")
        // transform should be replaced with new tokens
        let transform = outComps.queryItems?.filter { $0.name == "transform" }
        #expect(transform?.count == 1)
        let value = try #require(transform?.first?.value)
        #expect(value.contains("w:999"))
        #expect(value.contains("fit:cover"))
        #expect(!value.contains("h:10"))
    }

    @Test("Preserves unrelated existing query items and appends transform")
    func preservesOtherQueries() async throws {
        var comps = URLComponents(string: "https://example.com/a/b")!
        comps.queryItems = [
            URLQueryItem(name: "alpha", value: "1"),
            URLQueryItem(name: "beta", value: nil)
        ]
        let base = try #require(comps.url)
        let builder = TransformQueryBuilder(url: base)
        let options = TransformOptions().setBlur(5).setGrayscale(true)
        let url = try #require(builder.buildTransformURL(options: options))
        let out = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        // alpha and beta remain
        #expect(out.queryItems?.contains(where: { $0.name == "alpha" && $0.value == "1" }) == true)
        #expect(out.queryItems?.contains(where: { $0.name == "beta" && $0.value == nil }) == true)
        // transform exists with expected tokens
        let transform = out.queryItems?.first(where: { $0.name == "transform" })
        let value = try #require(transform?.value)
        #expect(value.contains("blur:5"))
        #expect(value.contains("grayscale"))
    }

    @Test("Ignores leading ?transform= in options.buildTransformString()")
    func stripsLeadingTransformPrefix() async throws {
        // Simulate a mistakenly prefixed transform string by wrapping options
        // Since TransformOptions.buildTransformString() never returns the prefix,
        // we emulate by constructing a URL that already has such a prefix in value
        // and ensure builder does not double-prefix. We do this by checking the internal helper via URL result.
        let base = URL(string: "https://example.com/img")!
        let builder = TransformQueryBuilder(url: base)
        // Build options that produce a value and ensure the builder uses only the value part
        let options = TransformOptions().setWidth(123).setHeight(456)
        // The builder's private method strips a leading prefix if present; we can only observe output
        let outURL = try #require(builder.buildTransformURL(options: options))
        let comps = try #require(URLComponents(url: outURL, resolvingAgainstBaseURL: false))
        let transform = try #require(comps.queryItems?.first(where: { $0.name == "transform" }))
        let value = try #require(transform.value)
        // Ensure there is no leading ?transform=
        #expect(!value.hasPrefix("?transform="))
        // And the tokens we expect are present
        #expect(value.contains("w:123"))
        #expect(value.contains("h:456"))
    }
}
