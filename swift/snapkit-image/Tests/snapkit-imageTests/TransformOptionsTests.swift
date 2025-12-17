import Testing
@testable import snapkit_image

@Suite("TransformOptions Tests")
struct TransformOptionsTests {

    @Test("Default build produces empty string")
    func defaultBuildIsEmpty() async throws {
        let options = TransformOptions()
        let result = options.buildTransformString()
        #expect(result.isEmpty)
    }

    @Test("Set width and height")
    func setWidthHeight() async throws {
        let options = TransformOptions()
            .setWidth(300)
            .setHeight(200)
        let str = options.buildTransformString()
        // Order isn't guaranteed because underlying storage is a dictionary; assert contains both tokens
        #expect(str.contains("w:300"))
        #expect(str.contains("h:200"))
    }

    @Test("Set fit and format")
    func setFitAndFormat() async throws {
        let options = TransformOptions()
            .setFit(.cover)
            .setFormat(.webp)
        let str = options.buildTransformString()
        #expect(str.contains("fit:cover"))
        #expect(str.contains("format:webp"))
    }

    @Test("Rotation, blur, dpr, quality")
    func setNumericOptions() async throws {
        let options = TransformOptions()
            .setRotation(90)
            .setBlur(12)
            .setDPR(2.0)
            .setQuality(85)
        let str = options.buildTransformString()
        #expect(str.contains("rotation:90"))
        #expect(str.contains("blur:12"))
        #expect(str.contains("dpr:2.0"))
        #expect(str.contains("quality:85"))
    }

    @Test("Boolean flags only appear when true")
    func booleanFlags() async throws {
        let off = TransformOptions()
            .setGrayscale(false)
            .setFlip(false)
            .setFlop(false)
        let offStr = off.buildTransformString()
        #expect(!offStr.contains("grayscale"))
        #expect(!offStr.contains("flip"))
        #expect(!offStr.contains("flop"))

        let on = TransformOptions()
            .setGrayscale(true)
            .setFlip(true)
            .setFlop(true)
        let onStr = on.buildTransformString()
        #expect(onStr.contains("grayscale"))
        #expect(onStr.contains("flip"))
        #expect(onStr.contains("flop"))
    }

    @Test("Extract region formatting")
    func extractFormatting() async throws {
        let options = TransformOptions()
            .setExtract(x: 10, y: 20, width: 300, height: 400)
        let str = options.buildTransformString()
        #expect(str.contains("extract:10-20-300-400"))
    }

    @Test("Chaining accumulates all options")
    func chainingAccumulation() async throws {
        let options = TransformOptions()
            .setWidth(100)
            .setHeight(150)
            .setFit(.contain)
            .setFormat(.png)
            .setRotation(180)
            .setBlur(5)
            .setGrayscale(true)
            .setFlip(true)
            .setFlop(false)
            .setExtract(x: 1, y: 2, width: 3, height: 4)
            .setDPR(3.0)
            .setQuality(70)
        let str = options.buildTransformString()
        let expectedTokens = [
            "w:100",
            "h:150",
            "fit:contain",
            "format:png",
            "rotation:180",
            "blur:5",
            "grayscale",
            "flip",
            "extract:1-2-3-4",
            "dpr:3.0",
            "quality:70"
        ]
        for token in expectedTokens {
            #expect(str.contains(token), "Missing token: \(token)")
        }
        // Ensure flop:false does not appear
        #expect(!str.contains("flop"))
    }

    @Test("Final string equals expected (order-insensitive)")
    func finalStringEqualityIgnoringOrder() async throws {
        let options = TransformOptions()
            .setWidth(100)
            .setHeight(150)
            .setFit(.contain)
            .setFormat(.png)
            .setRotation(180)
            .setBlur(5)
            .setGrayscale(true)
            .setFlip(true)
            .setFlop(false)
            .setExtract(x: 1, y: 2, width: 3, height: 4)
            .setDPR(3.0)
            .setQuality(70)

        let actual = options.buildTransformString()
        // Split into tokens and sort for deterministic comparison
        let actualTokens = actual.split(separator: ",").map { String($0) }.sorted()
        let expectedTokens = [
            "w:100",
            "h:150",
            "fit:contain",
            "format:png",
            "rotation:180",
            "blur:5",
            "grayscale",
            "flip",
            "extract:1-2-3-4",
            "dpr:3.0",
            "quality:70"
        ].sorted()
        #expect(actualTokens == expectedTokens, "Expected: \(expectedTokens)\nActual:   \(actualTokens)")
    }
}

