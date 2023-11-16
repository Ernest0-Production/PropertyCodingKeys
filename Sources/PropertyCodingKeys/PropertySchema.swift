//
//  File.swift
//  
//
//  Created by Ernest Babayan on 16.11.2023.
//


/// Descrption of  properties composition, aka schema.
///
/// In most cases, corresponds to the backend-service model.
/// Example
/// ```swift
///  struct UserInfoSchema: PropertySchema {
///     @PropertyCodingKey("first_name")
///     var firstName: String.Type
///
///     @PropertyCodingKey("age")
///     var age: Int.Type
///
///     @PropertyCodingKey("country")
///     var country: Country.Type
///
///     // Can be nested
///     @PropertyCodingKey("socials_info")
///     var socialsInfo: SocialsPropertySchema.Type
///     struct SocialsSchema: PropertySchema {
///        @PropertyCodingKey("reddit_token")
///        var redditToken: String.Type
///
///        @PropertyCodingKey("facebook_token")
///        var facebookUserID: String.Type
///     }
///  }
///
///  struct ApplicationSettingsSchema: PropertySchema {
///     @PropertyCodingKey("notification_enabled")
///     var notificationEnabled: Bool.Type
///
///     @PropertyCodingKey("feature-flags")
///     var flags: [String].Type
///  }
/// ```
protocol PropertySchema {
    init()
}
