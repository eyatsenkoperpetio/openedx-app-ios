//
//  CourseBlockModel.swift
//  Core
//
//  Created by  Stepanok Ivan on 14.03.2023.
//

import Foundation

public struct CourseStructure: Equatable {
    public init(id: String,
                graded: Bool,
                completion: Double,
                viewYouTubeUrl: String,
                encodedVideo: String,
                displayName: String,
                topicID: String? = nil,
                childs: [CourseChapter]) {
        self.id = id
        self.graded = graded
        self.completion = completion
        self.viewYouTubeUrl = viewYouTubeUrl
        self.encodedVideo = encodedVideo
        self.displayName = displayName
        self.topicID = topicID
        self.childs = childs
    }
    
    public static func == (lhs: CourseStructure, rhs: CourseStructure) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id: String
    public let graded: Bool
    public let completion: Double
    public let viewYouTubeUrl: String
    public let encodedVideo: String
    public let displayName: String
    public let topicID: String?
    public let childs: [CourseChapter]
}

public struct CourseChapter {
    public init(blockId: String,
                id: String,
                displayName: String,
                type: BlockType,
                childs: [CourseSequential]) {
        self.blockId = blockId
        self.id = id
        self.displayName = displayName
        self.type = type
        self.childs = childs
    }
    
    public let blockId: String
    public let id: String
    public let displayName: String
    public let type: BlockType
    public let childs: [CourseSequential]
}

public struct CourseSequential {
    public init(blockId: String,
                id: String,
                displayName: String,
                type: BlockType,
                completion: Double,
                childs: [CourseVertical]) {
        self.blockId = blockId
        self.id = id
        self.displayName = displayName
        self.type = type
        self.completion = completion
        self.childs = childs
    }
    
    public let blockId: String
    public let id: String
    public let displayName: String
    public let type: BlockType
    public let completion: Double
    public let childs: [CourseVertical]
    
    public var isDownloadable: Bool {
        return childs.first(where: { $0.isDownloadable }) != nil
    }
}

public struct CourseVertical {
    public init(blockId: String,
                id: String,
                displayName: String,
                type: BlockType,
                completion: Double,
                childs: [CourseBlock]) {
        self.blockId = blockId
        self.id = id
        self.displayName = displayName
        self.type = type
        self.completion = completion
        self.childs = childs
    }
    
    public let blockId: String
    public let id: String
    public let displayName: String
    public let type: BlockType
    public let completion: Double
    public let childs: [CourseBlock]
    
    public var isDownloadable: Bool {
        return childs.first(where: { $0.isDownloadable }) != nil
    }
}

public struct CourseBlock: Equatable {
    
    public init(blockId: String,
                id: String,
                topicId: String? = nil,
                graded: Bool,
                completion: Double,
                type: BlockType,
                displayName: String,
                studentUrl: String,
                videoUrl: String? = nil,
                youTubeUrl: String? = nil) {
        self.blockId = blockId
        self.id = id
        self.topicId = topicId
        self.graded = graded
        self.completion = completion
        self.type = type
        self.displayName = displayName
        self.studentUrl = studentUrl
        self.videoUrl = videoUrl
        self.youTubeUrl = youTubeUrl
    }
    
    public let blockId: String
    public let id: String
    public let topicId: String?
    public let graded: Bool
    public let completion: Double
    public let type: BlockType
    public let displayName: String
    public let studentUrl: String
    public let videoUrl: String?
    public let youTubeUrl: String?
    
    public var isDownloadable: Bool {
        return videoUrl != nil
    }
}
