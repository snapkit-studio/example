import { describe, it, expect } from "vitest";
import { buildSnapkitImageURL } from "../buildSnapkitImageURL.js";

describe("buildSnapkitImageURL", () => {
  const baseParams = {
    organizationName: "test-org",
    url: "https://cdn.cloudfront.net/image.jpg",
  };

  describe("Basic URL generation", () => {
    it("should generate basic URL without transform", () => {
      const result = buildSnapkitImageURL(baseParams);

      expect(result).toBe(
        "https://cdn.snapkit.studio/test-org/external?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg",
      );
    });

    it("should properly encode URL", () => {
      const result = buildSnapkitImageURL({
        organizationName: "my-org",
        url: "https://example.com/path with spaces/image.jpg?query=value",
      });

      expect(result).toContain(
        "url=https%3A%2F%2Fexample.com%2Fpath+with+spaces%2Fimage.jpg%3Fquery%3Dvalue",
      );
    });
  });

  describe("Numeric/string transform parameters", () => {
    it("should apply width (w) parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { w: 300 },
      });

      expect(result).toContain("transform=w%3A300");
    });

    it("should apply height (h) parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { h: 200 },
      });

      expect(result).toContain("transform=h%3A200");
    });

    it("should apply fit parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { fit: "cover" },
      });

      expect(result).toContain("transform=fit%3Acover");
    });

    it("should apply format parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { format: "webp" },
      });

      expect(result).toContain("transform=format%3Awebp");
    });

    it("should apply rotation parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { rotation: 90 },
      });

      expect(result).toContain("transform=rotation%3A90");
    });

    it("should apply blur parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { blur: 5 },
      });

      expect(result).toContain("transform=blur%3A5");
    });

    it("should apply dpr parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { dpr: 2 },
      });

      expect(result).toContain("transform=dpr%3A2");
    });

    it("should apply quality parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { quality: 85 },
      });

      expect(result).toContain("transform=quality%3A85");
    });
  });

  describe("Boolean transform parameters", () => {
    it("should apply grayscale parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { grayscale: true },
      });

      expect(result).toContain("transform=grayscale");
    });

    it("should apply flip parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { flip: true },
      });

      expect(result).toContain("transform=flip");
    });

    it("should apply flop parameter", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { flop: true },
      });

      expect(result).toContain("transform=flop");
    });

    it("should not include false Boolean parameters", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { grayscale: false },
      });

      expect(result).not.toContain("grayscale");
    });
  });

  describe("extract parameter", () => {
    it("should apply extract parameter in correct format", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: {
          extract: { x: 10, y: 20, width: 100, height: 200 },
        },
      });

      expect(result).toContain("transform=extract%3A10-20-100-200");
    });
  });

  describe("Combined parameter combinations", () => {
    it("should combine multiple parameters", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: {
          w: 300,
          h: 200,
          fit: "cover",
          format: "webp",
        },
      });

      expect(result).toContain("w%3A300");
      expect(result).toContain("h%3A200");
      expect(result).toContain("fit%3Acover");
      expect(result).toContain("format%3Awebp");
    });

    it("should combine all types of parameters", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: {
          w: 300,
          h: 200,
          fit: "cover",
          format: "webp",
          rotation: 90,
          blur: 5,
          grayscale: true,
          flip: true,
          dpr: 2,
          quality: 85,
          extract: { x: 10, y: 20, width: 100, height: 200 },
        },
      });

      expect(result).toContain("w%3A300");
      expect(result).toContain("h%3A200");
      expect(result).toContain("fit%3Acover");
      expect(result).toContain("format%3Awebp");
      expect(result).toContain("rotation%3A90");
      expect(result).toContain("blur%3A5");
      expect(result).toContain("grayscale");
      expect(result).toContain("flip");
      expect(result).toContain("dpr%3A2");
      expect(result).toContain("quality%3A85");
      expect(result).toContain("extract%3A10-20-100-200");
    });
  });

  describe("Edge cases", () => {
    it("should not generate transform parameter for empty transform object", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: {},
      });

      expect(result).not.toContain("transform=");
    });

    it("should handle zero values correctly", () => {
      const result = buildSnapkitImageURL({
        ...baseParams,
        transform: { w: 0, rotation: 0 },
      });

      expect(result).toContain("w%3A0");
      expect(result).toContain("rotation%3A0");
    });

    it("should handle special characters in organizationName", () => {
      const result = buildSnapkitImageURL({
        organizationName: "my-org-123",
        url: "https://cdn.example.com/image.jpg",
      });

      expect(result).toContain("https://cdn.snapkit.studio/my-org-123/external");
    });
  });
});
