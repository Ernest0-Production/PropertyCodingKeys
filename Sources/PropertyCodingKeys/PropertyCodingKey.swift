//
//  File.swift
//  
//
//  Created by Ernest Babayan on 16.11.2023.
//

/// Description of property name and type
///
/// Usage:
/// ```swift
/// struct MyModelSchema: PropertySchema {
///     @PropertyCodingKey("user_name")
///     var userName: String.Type
/// }
/// ```
@propertyWrapper
struct PropertyCodingKey<ValueType>: CodingKey {
    var intValue: Int? = nil
    init?(intValue: Int) { self.intValue = intValue }

    var stringValue: String = "<unspecified>"
    init?(stringValue: String) { self.stringValue = stringValue }

    /// - Parameter propertyName: Name of property in JSON
    init(_ propertyName: String = #function) {
        stringValue = propertyName
    }

    var wrappedValue: ValueType.Type { ValueType.self }
    var projectedValue: Self { self }
}
