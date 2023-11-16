import XCTest
@testable import PropertyCodingKeys

let exampleJSON = """
{
    "first_name": "Igor",
    "age": 12,
    "country": {
        "code": "UK",
        "address": "London"
    },
    "socials_info": {
        "reddit_token": "12345678",
        "facebook_token": "qwerty"
    }
}
"""

struct UserInfoSchema: PropertySchema {
    @PropertyCodingKey("first_name")
    var firstName: String.Type

    @PropertyCodingKey("age")
    var age: Int.Type

    @PropertyCodingKey("country")
    var country: Country.Type
    struct Country: Decodable {
        let code: String
        let address: String
    }

    // Can be nested
    @PropertyCodingKey("socials_info")
    var socialsInfo: SocialsSchema.Type
    struct SocialsSchema: PropertySchema {
        @PropertyCodingKey("reddit_token")
        var redditToken: String.Type

        @PropertyCodingKey("facebook_token")
        var facebookUserID: String.Type
    }
}

final class PropertyCodingKeysTests: XCTestCase {
    func testExample() throws {
        struct MiniModel: Decodable, Equatable {
            let name: String
            let address: String
            let redditToken: String

            init(name: String, address: String, redditToken: String) {
                self.name = name
                self.address = address
                self.redditToken = redditToken
            }

            init(from decoder: Decoder) throws {
                let userDecoder = decoder.propertySchema(of: UserInfoSchema.self)

                name = try userDecoder.$firstName()
                address = try userDecoder.$country().address
                redditToken = try userDecoder.$socialsInfo.$redditToken()
            }
        }

        let decodedModel = try JSONDecoder().decode(
            MiniModel.self,
            from: exampleJSON.data(using: .utf8)!
        )

        XCTAssertEqual(
            decodedModel,
            MiniModel(name: "Igor", address: "London", redditToken: "12345678")
        )
    }
}
