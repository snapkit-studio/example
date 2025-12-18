//
//  ResponseModelParseTests.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import Testing
@testable import Data

@Suite("BannerResponseModel JSON Decoding")
struct BannerResponseModelDecodingTests {
    private let decoder = JSONDecoder()

    @Test("Decodes valid JSON")
    func decodesValidJSON() throws {
        let json = #"{"banner_message":"Hello, world!"}"#.data(using: .utf8)!
        let model = try decoder.decode(BannerResponseModel.self, from: json)
        #expect(model.bannerMessage == "Hello, world!")
    }
}

@Suite("CategoryResponseModel JSON Decoding")
struct CategoryResponseModelDecodingTests {
    private let decoder = JSONDecoder()

    @Test("Decodes valid category JSON")
    func decodesValidCategoryJSON() throws {
        let json = #"""
        {
          "items": [
            {
              "image_url": "https://wippy-dev-assets.dev.nrise.io/app/lounge/entertainment/img_dice_30.png",
              "title": "전체"
            },
            {
              "image_url": "https://wippy-dev-assets.dev.nrise.io/app/lounge/entertainment/img_food_30.png",
              "title": "카페/맛집"
            },
            {
              "image_url": "https://wippy-dev-assets.dev.nrise.io/app/lounge/entertainment/img_ticket_30.png",
              "title": "문화생활"
            },
            {
              "image_url": "https://wippy-dev-assets.dev.nrise.io/app/lounge/entertainment/img_festival_30.png",
              "title": "축제/행사"
            }
          ]
        }
        """#.data(using: .utf8)!

        let model = try decoder.decode(CategoryResponseModel.self, from: json)

        let first = try #require(model.cotegories.first)
        #expect(first.imageURL == "https://wippy-dev-assets.dev.nrise.io/app/lounge/entertainment/img_dice_30.png")
        #expect(first.title == "전체")

        let last = try #require(model.cotegories.last)
        #expect(last.imageURL == "https://wippy-dev-assets.dev.nrise.io/app/lounge/entertainment/img_festival_30.png")
        #expect(last.title == "축제/행사")
    }
}

@Suite("CurationsResponseModel JSON Decoding")
struct CurationsResponseModelDecodingTests {
    private let decoder = JSONDecoder()

    @Test("Decodes valid curations JSON")
    func decodesValidCurationsJSON() throws {
        let json = #"""
        {
          "items": [
            {
              "title": "인기 있는 장소",
              "items": [
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/71845438016a9b7260eb097950d40448f8c31a199a2b3a3dacfd05d14c190464.png",
                  "title": "화이팅!",
                  "tags": [
                    "경기",
                    "전시"
                  ],
                  "participant_count": null,
                  "ended_at": "2025-07-16T15:00:00+00:00"
                },
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/6926e5c56fb2cdbc4bd3b4d869d2510d634dfd6b501490184db88e31602ce046.png",
                  "title": "타이틀",
                  "tags": [
                    "서울",
                    "카페"
                  ],
                  "participant_count": null,
                  "ended_at": null
                },
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/4776fb4cc87cae1e1ea40875ef75f00300db4442906ab27ea192efecda082c47.png",
                  "title": "모울",
                  "tags": [
                    "서울",
                    "카페"
                  ],
                  "participant_count": null,
                  "ended_at": "2026-07-16T15:00:00+00:00"
                },
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/5ba0a7f6acfdd14829af529a5947eb574d16c2714208bbfeb11b652dc669f3b7.png",
                  "title": "크레이트컬피 한남",
                  "tags": [
                    "서울",
                    "카페",
                    "전문 바리스타",
                    "미슐랭",
                    "엔라이즈",
                    "iOS",
                    "Xcode",
                    "Mocking",
                    "iPhone",
                    "MacBook",
                    "iPad"
                  ],
                  "participant_count": null,
                  "ended_at": null
                },
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/becd8fa1a52efe8fc28bcd161ccd5a3c8746472971c947223039b90ba5850be7.png",
                  "title": "본지르르",
                  "tags": [
                    "경기",
                    "카페"
                  ],
                  "participant_count": null,
                  "ended_at": null
                }
              ]
            },
            {
              "title": "내 주변 놀거리",
              "items": [
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/e1abb12b970e542e7f3e02e07b3f650aaa23e09ab67e8566ebbd45b3ea292282.png",
                  "title": "ㅇㅇㅇㅇㅇ",
                  "tags": [
                    "모든 지역",
                    "연극"
                  ],
                  "participant_count": null,
                  "ended_at": null
                },
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/0110dbb5af3ea7891c0b02a481b0ec847a89c10d2691bb7704b2507249b3b03c.png",
                  "title": "루서비스 301",
                  "tags": [
                    "서울",
                    "카페"
                  ],
                  "participant_count": null,
                  "ended_at": null
                },
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/68b614e2b9676b9fb1d8355925939ee42967fbdcda3733b8489b7f95d4f06b0c.png",
                  "title": "개조심",
                  "tags": [
                    "서울",
                    "영화"
                  ],
                  "participant_count": null,
                  "ended_at": null
                },
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/76bab24ea587f4bccf16db535f90471dc412e362cdcdf0b2a87cee5b6767432b.png",
                  "title": "언얼드챔",
                  "tags": [
                    "서울",
                    "카페"
                  ],
                  "participant_count": null,
                  "ended_at": null
                },
                {
                  "image_url": "https://wippy-dev-assets.dev.nrise.io/a26cbe976835119f47b375dbb80f78ffe62d83a3c73706bef7ed0fefc07485a8.png",
                  "title": "마우이 서재",
                  "tags": [
                    "서울",
                    "주점"
                  ],
                  "participant_count": null,
                  "ended_at": null
                }
              ]
            }
          ]
        }
        """#.data(using: .utf8)!

        let model = try decoder.decode(CurationsResponseModel.self, from: json)
        #expect(model.curations.count == 2)

        let firstCuration = try #require(model.curations.first)
        #expect(firstCuration.title == "인기 있는 장소")
        #expect(firstCuration.items.count == 5)

        let firstItem = try #require(firstCuration.items.first)
        #expect(firstItem.imageURL == "https://wippy-dev-assets.dev.nrise.io/71845438016a9b7260eb097950d40448f8c31a199a2b3a3dacfd05d14c190464.png")
        #expect(firstItem.title == "화이팅!")
        #expect(firstItem.tags == ["경기", "전시"])
        #expect(firstItem.participantCount == nil)
        #expect(firstItem.endedAt == "2025-07-16T15:00:00+00:00")

        let lastItem = try #require(firstCuration.items.last)
        #expect(lastItem.title == "본지르르")
        #expect(lastItem.tags == ["경기", "카페"])
        #expect(lastItem.participantCount == nil)
        #expect(lastItem.endedAt == nil)

        let secondCuration = try #require(model.curations.last)
        #expect(secondCuration.title == "내 주변 놀거리")
        #expect(secondCuration.items.count == 5)

        let secondFirstItem = try #require(secondCuration.items.first)
        #expect(secondFirstItem.title == "ㅇㅇㅇㅇㅇ")
        #expect(secondFirstItem.tags == ["모든 지역", "연극"])
        #expect(secondFirstItem.endedAt == nil)

        let secondLastItem = try #require(secondCuration.items.last)
        #expect(secondLastItem.title == "마우이 서재")
        #expect(secondLastItem.tags == ["서울", "주점"])
        #expect(secondLastItem.endedAt == nil)
    }
}

@Suite("TagsResponseModel JSON Decoding")
struct TagsResponseModelDecodingTests {
    private let decoder = JSONDecoder()

    @Test("Decodes valid tags JSON")
    func decodesValidTagsJSON() throws {
        let json = #"""
        {
          "items": [
            "모든 지역",
            "서울",
            "경기",
            "그 외 지역"
          ]
        }
        """#.data(using: .utf8)!

        let model = try decoder.decode(TagsResponseModel.self, from: json)
        #expect(model.tags.count == 4)
        #expect(model.tags[0] == "모든 지역")
        #expect(model.tags[1] == "서울")
        #expect(model.tags[2] == "경기")
        #expect(model.tags[3] == "그 외 지역")
    }
}

@Suite("PlacesResponseModel JSON Decoding")
struct PlacesResponseModelDecodingTests {
    private let decoder = JSONDecoder()

    @Test("Decodes valid places JSON")
    func decodesValidPlacesJSON() throws {
        let json = #"""
        {
          "items": [
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/0110dbb5af3ea7891c0b02a481b0ec847a89c10d2691bb7704b2507249b3b03c.png",
              "participant_count": 15,
              "tags": [
                "서울",
                "카페",
                "전문 바리스타",
                "미슐랭",
                "엔라이즈",
                "iOS",
                "Xcode",
                "Mocking",
                "iPhone",
                "MacBook",
                "iPad"
              ],
              "title": "룸서비스 301"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/02b83e3e203e7ed4968b7f6505b4990ee75ae48c1592b99d1582a6607c2bfc38.png",
              "participant_count": 1,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "서초구"
            },
            {
              "ended_at": "2025-07-20T15:00:00+00:00",
              "image_url": "https://wippy-dev-assets.dev.nrise.io/0dc5d60a8d4eed3123ad760933900ce21768ee38d338220647e5d1a21abeaaad.png",
              "participant_count": 1,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "블루보틀 제주"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/0f1f58dd01111c21c860c87f00615a2827e8c2f2a99d733a4ed240800d640dcd.png",
              "participant_count": 2,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "안녕"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/2d1d1e888e79b674b71d0599f9c4422678e03179d45ad251b3eae573f570403e.png",
              "participant_count": 1,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "하이"
            },
            {
              "ended_at": "2028-08-16T15:00:00+00:00",
              "image_url": "https://wippy-dev-assets.dev.nrise.io/41611e462f3529d0bebf8ac7be79111a42d982ef762a927a1442ac743d4d3f92.png",
              "participant_count": 11,
              "tags": [
                "모든 지역",
                "카페"
              ],
              "title": "테스트"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/60053c6d8fc85aa4d85dd41bbde82c60ec6ecf9842c99b34c3c0669025cc4eac.png",
              "participant_count": 3,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "테스트테스트"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/67970f3e58891c3f24db7de09fdad55e0a58212e1c7be9e68f68e8ac25ee07d1.png",
              "participant_count": 2,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "테스트 중"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/76bab24ea587f4bccf16db535f90471dc412e362cdcdf0b2a87cee5b6767432b.png",
              "participant_count": 17,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "언올드참"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/97c3bee1de15dec5703259f1ca8126816daa23bdb043b80f4fc1d7ca7459d242.png",
              "participant_count": 2,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "서초구 진짜 떠야함"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/a26cbe976835119f47b375dbb80f78ffe62d83a3c73706bef7ed0fefc07485a8.png",
              "participant_count": 13,
              "tags": [
                "서울",
                "주점"
              ],
              "title": "마우이 서재"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/b105f8465738543f7e7a74f83d2b400b2782b4ae75bc41e3121a18b7f8d54d79.png",
              "participant_count": 8,
              "tags": [
                "경기",
                "전시"
              ],
              "title": "고구마 축제"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/c78392ccc8ea800b0ac11347999d42f5856b72340eeaa63e22f952ec687e1320.png",
              "participant_count": 3,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "서초구카페"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/dc184dc8bba12e38531e1849ff0e3b2e33a8e2f89bb1de84642e1265f248da10.png",
              "participant_count": 1,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "그냥"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/e1abb12b970e542e7f3e02e07b3f650aaa23e09ab67e8566ebbd45b3ea292282.png",
              "participant_count": 1,
              "tags": [
                "모든 지역",
                "연극"
              ],
              "title": "ㅏㅏㅏㅏㅏ"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/e54e7793520f0e2f77ce1b27567068e1dcfef872a8790f84e42f93a8b1ee0a90.png",
              "participant_count": 1,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "매머드커피"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/e7f618f2b0a5c6f18f8ebf604263441ec1d4161d886a1e104099a28046014fd0.png",
              "participant_count": 3,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "다시 카페"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/e9b066dcbf1995cd996548812b4521d08b203c6b5e3fcfce5868f7e81fc87b8c.png",
              "participant_count": 3,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "테스트용"
            },
            {
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/f93403e6aeecf94d009070d49dbb260d2d8e243201e7194d3dbbb09fc2ee07d2.png",
              "participant_count": 1,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "용산카페"
            },
            {
              "id": 99,
              "ended_at": null,
              "image_url": "https://wippy-dev-assets.dev.nrise.io/fb85c2551e2dc869479bb49a9bff8b1c4dcd9a31fd144126b0f843e3960fdbfa.png",
              "participant_count": 4,
              "tags": [
                "서울",
                "카페"
              ],
              "title": "양재 카페"
            }
          ]
        }
        """#.data(using: .utf8)!

        let model = try decoder.decode(PlacesResponseModel.self, from: json)
        #expect(model.place.count == 20)

        let first = try #require(model.place.first)
        #expect(first.id == nil)
        #expect(first.title == "룸서비스 301")
        #expect(first.imageURL == "https://wippy-dev-assets.dev.nrise.io/0110dbb5af3ea7891c0b02a481b0ec847a89c10d2691bb7704b2507249b3b03c.png")
        #expect(first.participantCount == 15)
        #expect(first.endedAt == nil)
        #expect(first.tags == [
            "서울", "카페", "전문 바리스타", "미슐랭", "엔라이즈", "iOS", "Xcode", "Mocking", "iPhone", "MacBook", "iPad"
        ])

        // Check an item with a non-nil endedAt
        let third = model.place[2]
        #expect(third.title == "블루보틀 제주")
        #expect(third.participantCount == 1)
        #expect(third.endedAt == "2025-07-20T15:00:00+00:00")

        // Check the last item
        let last = try #require(model.place.last)
        #expect(last.id == 99)
        #expect(last.title == "양재 카페")
        #expect(last.participantCount == 4)
        #expect(last.endedAt == nil)
      }
}

@Suite("PlacesResponseModel Empty JSON Decoding")
struct PlacesResponseModelEmptyDecodingTests {
    private let decoder = JSONDecoder()

    @Test("Decodes empty items array")
    func decodesEmptyPlacesJSON() throws {
        let json = #"""
        {
          "items": []
        }
        """#.data(using: .utf8)!

        let model = try decoder.decode(PlacesResponseModel.self, from: json)
        #expect(model.place.isEmpty)
    }
}

@Suite("DetailResponseModel JSON Decoding")
struct DetailResponseModelDecodingTests {
    private let decoder = JSONDecoder()

    @Test("Decodes valid detail JSON")
    func decodesValidDetailJSON() throws {
        let json = #"""
        {
          "description": "2023년 기획전 «YOSHIDA YUNI ; Alchemy» 는 전 세계를 무대로 패션브랜드, 잡지, 광고, 아티스트의 비주얼을 디렉팅하는 요시다 유니의 여정을 소개합니다.\n\n다양한 실험을 통해 황금을 만들려 시도했던 고대의 연금술사들처럼 작가는 빛과 어둠,유형과 무형 사이의 상호 작용을 세밀하게 조작하여 평범한 것을 비범한 것으로 ‘변환’시키고 원물의 형태를 재조합하여 아름답고 의미 있는 작품으로 ‘변형’합니다. 이번 전시에 최초로 공개되는Playing Cards (2023) 연작을 포함해 230여점에 이르는 요시다 유니만의 독특하고 신비로운 예술의 장에서 다른 차원의 아름다움과 헤아릴 수 없는 즐거움을 경험하시길 바랍니다.\n출처: 석파정 서울미술관 홈페이지",
          "end_at": "2025-07-16T15:00:00+00:00",
          "images": [
            "https://wippy-dev-assets.dev.nrise.io/0bfe9199130d12f43a8b1b548f8dfdae62c954a5e27e1e2354856556dbc47caa.png",
            "https://wippy-dev-assets.dev.nrise.io/59e2de8c480d8f33d6152745984f239351c9e2cfb2e1b7cb42edd4ec7e52b141.png",
            "https://wippy-dev-assets.dev.nrise.io/93b3d93f7c41f4ec7e65746b6973055ad43aada5262dabf620347d70277c3796.png",
            "https://wippy-dev-assets.dev.nrise.io/c7b5311edb55b02ce53686128e60e72dd8c471d04ab8a72e511807ac88d28140.png",
            "https://wippy-dev-assets.dev.nrise.io/c84d0a6b29915ee9915c19165fefaddfc1bf5f148bd953fa33da331f981e02cc.png"
          ],
          "is_participated": false,
          "location": "석파정 서울미술관\n(서울 종로구 창의문로11길 4-1, 제 1전시실 2F)",
          "location_opening_hour_info": "휴무 : 매주 월, 화\n매일 : 미술관 10:00 ~ 18:00, \n석파정 및 별관 11:00 ~ 17:00\n(관람 종료 1시간 전까지 입장 가능)",
          "recommend_cta_text": "관심 있어요",
          "recommend_description": "'관심 있어요'를 눌러서\n같이 갈만한 친구들을 확인해보세요!",
          "recommend_title": "이곳을 가고 싶어 하는 친구",
          "start_at": "2023-05-23T15:00:00+00:00",
          "title": "요시다 유니 : Alchemy 요시다 유니 : Alchemy 요시다 유니 : Alchemy"
        }
        """#.data(using: .utf8)!

        let model = try decoder.decode(DetailResponseModel.self, from: json)

        // Simple fields
        #expect(model.title == "요시다 유니 : Alchemy 요시다 유니 : Alchemy 요시다 유니 : Alchemy")
        #expect(model.endAt == "2025-07-16T15:00:00+00:00")
        #expect(model.startAt == "2023-05-23T15:00:00+00:00")
        #expect(model.isParticipated == false)
        #expect(model.location == "석파정 서울미술관\n(서울 종로구 창의문로11길 4-1, 제 1전시실 2F)")

        // Multiline fields
        let expectedDescription = """
        2023년 기획전 «YOSHIDA YUNI ; Alchemy» 는 전 세계를 무대로 패션브랜드, 잡지, 광고, 아티스트의 비주얼을 디렉팅하는 요시다 유니의 여정을 소개합니다.
        
        다양한 실험을 통해 황금을 만들려 시도했던 고대의 연금술사들처럼 작가는 빛과 어둠,유형과 무형 사이의 상호 작용을 세밀하게 조작하여 평범한 것을 비범한 것으로 ‘변환’시키고 원물의 형태를 재조합하여 아름답고 의미 있는 작품으로 ‘변형’합니다. 이번 전시에 최초로 공개되는Playing Cards (2023) 연작을 포함해 230여점에 이르는 요시다 유니만의 독특하고 신비로운 예술의 장에서 다른 차원의 아름다움과 헤아릴 수 없는 즐거움을 경험하시길 바랍니다.
        출처: 석파정 서울미술관 홈페이지
        """
        #expect(model.description == expectedDescription)

        let expectedOpening = """
        휴무 : 매주 월, 화
        매일 : 미술관 10:00 ~ 18:00, 
        석파정 및 별관 11:00 ~ 17:00
        (관람 종료 1시간 전까지 입장 가능)
        """
        #expect(model.locationOpeningHourInfo == expectedOpening)

        // Images
        #expect(model.images.count == 5)
        #expect(model.images.first == "https://wippy-dev-assets.dev.nrise.io/0bfe9199130d12f43a8b1b548f8dfdae62c954a5e27e1e2354856556dbc47caa.png")
        #expect(model.images.last == "https://wippy-dev-assets.dev.nrise.io/c84d0a6b29915ee9915c19165fefaddfc1bf5f148bd953fa33da331f981e02cc.png")

        // Recommendation texts
        #expect(model.recommendCTAText == "관심 있어요")
        #expect(model.recommendDescription == "'관심 있어요'를 눌러서\n같이 갈만한 친구들을 확인해보세요!")
        #expect(model.recommendTitle == "이곳을 가고 싶어 하는 친구")
    }
}
