//
//  ContentView.swift
//  Notes MVVM-C
//
//  Created by Muhammad Bilal on 30/12/2024.
//

import SwiftUI

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var content: String
    var lastModified: Date
    var isPinned: Bool
    var category: Category
    var tags: Set<String>
    
    enum Category: String, Codable, CaseIterable {
        case personal
        case work
        case ideas
        case tasks
        case other
        
        var icon: String {
            switch self {
            case .personal: return "person.circle"
            case .work: return "briefcase"
            case .ideas: return "lightbulb"
            case .tasks: return "checklist"
            case .other: return "folder"
            }
        }
        
        var color: Color {
            switch self {
            case .personal: return .blue
            case .work: return .purple
            case .ideas: return .yellow
            case .tasks: return .green
            case .other: return .gray
            }
        }
    }
    
    init(id: UUID = UUID(), 
         title: String = "", 
         content: String = "", 
         lastModified: Date = Date(),
         isPinned: Bool = false,
         category: Category = .other,
         tags: Set<String> = []) {
        self.id = id
        self.title = title
        self.content = content
        self.lastModified = lastModified
        self.isPinned = isPinned
        self.category = category
        self.tags = tags
    }
    
    // Add custom coding keys and decoding initialization
    private enum CodingKeys: String, CodingKey {
        case id, title, content, lastModified, isPinned, category, tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        lastModified = try container.decode(Date.self, forKey: .lastModified)
        
        // Provide default values for new properties if they don't exist
        isPinned = try container.decodeIfPresent(Bool.self, forKey: .isPinned) ?? false
        category = try container.decodeIfPresent(Category.self, forKey: .category) ?? .other
        tags = try container.decodeIfPresent(Set<String>.self, forKey: .tags) ?? []
    }
} 
