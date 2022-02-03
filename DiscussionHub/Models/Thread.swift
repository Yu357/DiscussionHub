//
//  discussion.swift
//  DiscussionHub
//
//  Created by Yu on 2022/01/27.
//

import Foundation

struct Thread: Identifiable {
    var id: String
    var title: String
    var authorId: String
    var createdAt: Date
    var commentCount: Int
}
