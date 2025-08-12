//
//  Patung.swift
//  KalcerPOC
//
//  Created by Gede Pramananda Kusuma Wisesa on 12/08/25.
//

import Foundation
import Supabase

struct Patung: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String?
    let image: String?
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let metadataID: UUID?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, image
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
        case metadataID = "metadata_id"
    }
}

struct PatungMetadata: Codable, Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let metadata: String
    
    enum CodingKeys: String, CodingKey {
        case id, metadata
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
    }
}

struct PatungLocation: Decodable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let latitude: Double
    let longitude: Double
    let patung_id: UUID?
    
    enum CodingKeys: String, CodingKey {
        case id, latitude, longitude
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
        case patung_id = "patung_id"
    }
}
