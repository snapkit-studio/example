## Overview
- An example using [snapkit-image](https://github.com/snapkit-studio/snapkit-ios) SPM together with [Snapkit](https://www.snapkit.studio/ko/docs)

## Environment
- OS: **Taho 26.0 (25A354)**
- Xcode: **Version 26.0.1 (17A400)**
- Tuist: **4.38.2**
- Minimum iOS: **16.0**

## Metrics
- **Downloaded**: Total amount of data used for downloads  
- **LCP**: The image that took the longest time to download  
- **Images**: Total number of images downloaded  

## Behavior

| Scenario | Demo |
|--------|------|
| Original Images | ![original480](https://github.com/user-attachments/assets/d5b13e59-41ba-4286-b3c9-89fc304301b2) |
| Optimized Images ([snapkit-image](https://github.com/snapkit-studio/snapkit-ios)) | ![snapkit480](https://github.com/user-attachments/assets/5c209ed0-4b7a-4f11-a0c6-f4ffd5d6b128) |

## Usage Example
- Orignal Image
![curation_2](https://github.com/user-attachments/assets/21cb26ee-b81b-4b59-9b8a-efac8013d711)

```Swift

// PresentationMapper.swift
public struct SnapkitHomePresentationMapper: PresentationMappale {
    
    public init() {}
    
    public func transform(from: CurationInfo) -> CurationInfoPresentation {
        return CurationInfoPresentation(
            info: from,
            options: TransformOptions()
                .setWidth(195)
                .setDPR(2.0)
                .setFormat(.webp)
        )
    }
    
    public func transform(from: [HomeCategory]) -> [HomeCategoryPresentation] {
        return from.map { category in
            HomeCategoryPresentation(
                homeCategory: category,
                options: TransformOptions()
                    .setWidth(95)
                    .setDPR(2.0)
                    .setFormat(.webp)
            )
        }
    }
    
    public func transform(from: Place) -> PlacePresentation {
        return PlacePresentation(
            place: from,
            options: TransformOptions()
                .setHeight(148)
                .setDPR(2.0)
                .setFormat(.webp)
        )
    }
}

// CurationCell.swift
public final class CurationCell: UICollectionViewCell {
...
  public func configure(model: CurationInfoPresentation) {
        Task { [weak self] in
            let image = try? await ImageDownloader.shared.downloadImage(
                from: TransformQueryBuilder(url: model.info.imageURL)
                    .buildTransformURL(
                        options: model.options
                    )
            )
            self?.imageView.image = image
        }
        ...
}
