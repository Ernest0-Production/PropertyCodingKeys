//
//  File.swift
//  
//
//  Created by Ernest Babayan on 16.11.2023.
//

extension Decoder {
    /// Prepare decoder for type-safe decoding according to a given schema
    func propertySchema<SchemaType: PropertySchema>(of type: SchemaType.Type) -> PropertySchemaDecoder<SchemaType> {
        PropertySchemaDecoder(decoder: self)
    }
}

/// Type-safe `Decoder` wrapper for decode values according to a specific `Schema`
@dynamicMemberLookup
struct PropertySchemaDecoder<Schema: PropertySchema> {
    init(decoder: Decoder) { self.decoder = decoder }

    private let schema = Schema()
    private let decoder: Decoder

    subscript<ValueType: Decodable>(
        dynamicMember keyPath: KeyPath<Schema, PropertyCodingKey<ValueType>>
    ) -> () throws -> ValueType {
        return {
            try decoder
                .container(keyedBy: PropertyCodingKey<ValueType>.self)
                .decode(ValueType.self, forKey: schema[keyPath: keyPath])
        }
    }

    subscript<NestedSchema>(
        dynamicMember keyPath: KeyPath<Schema, PropertyCodingKey<NestedSchema>>
    ) -> Nested<PropertyCodingKey<NestedSchema>, NestedSchema> {
        Nested(
            rootCodingKey: schema[keyPath: keyPath],
            decodingContainer: try decoder.container(keyedBy: PropertyCodingKey<NestedSchema>.self)
        )
    }
}

extension PropertySchemaDecoder {
    /// Type-safe `Decoder` wrapper for decode nested values of sub-scheme
    @dynamicMemberLookup
    struct Nested<RootKey: CodingKey, Schema: PropertySchema> {
        init(
            rootCodingKey: RootKey,
            decodingContainer: @autoclosure @escaping () throws -> KeyedDecodingContainer<RootKey>
        ) {
            self.rootCodingKey = rootCodingKey
            self.decodingContainer = decodingContainer
        }

        private let schema = Schema()
        private let rootCodingKey: RootKey
        private let decodingContainer: () throws -> KeyedDecodingContainer<RootKey>

        subscript<ValueType: Decodable>(
            dynamicMember keyPath: KeyPath<Schema, PropertyCodingKey<ValueType>>
        ) -> () throws -> ValueType {
            return {
                let propertyCodingKey = schema[keyPath: keyPath]
                return try decodingContainer()
                    .nestedContainer(
                        keyedBy: PropertyCodingKey<ValueType>.self,
                        forKey: rootCodingKey
                    )
                    .decode(
                        ValueType.self,
                        forKey: propertyCodingKey
                    )
            }
        }

        subscript<NestedSchema>(
            dynamicMember keyPath: KeyPath<Schema, PropertyCodingKey<NestedSchema>>
        ) -> Nested<PropertyCodingKey<NestedSchema>, NestedSchema> {
            Nested<PropertyCodingKey<NestedSchema>, NestedSchema>(
                rootCodingKey: schema[keyPath: keyPath],
                decodingContainer: try decodingContainer().nestedContainer(
                    keyedBy: PropertyCodingKey<NestedSchema>.self,
                    forKey: rootCodingKey
                )
            )
        }
    }
}
