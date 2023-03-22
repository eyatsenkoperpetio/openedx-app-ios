//
//  DiscussionTopicsViewModelTests.swift
//  DiscussionTests
//
//  Created by  Stepanok Ivan on 31.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Discussion
import Alamofire
import SwiftUI

final class DiscussionTopicsViewModelTests: XCTestCase {
    
    let topics = Topics(coursewareTopics: [
        CoursewareTopics(id: "1", name: "1", threadListURL: "1", children: [
            CoursewareTopics(id: "11", name: "11", threadListURL: "11", children: [])
        ]),
        CoursewareTopics(id: "2", name: "2", threadListURL: "2", children: [
            CoursewareTopics(id: "22", name: "22", threadListURL: "22", children: [])
        ]),
        CoursewareTopics(id: "3", name: "3", threadListURL: "3", children: [
            CoursewareTopics(id: "33", name: "33", threadListURL: "33", children: [])
        ])
    ], nonCoursewareTopics: [
        CoursewareTopics(id: "4", name: "4", threadListURL: "4", children: [
            CoursewareTopics(id: "44", name: "44", threadListURL: "44", children: [])
        ]),
        CoursewareTopics(id: "5", name: "5", threadListURL: "5", children: [
            CoursewareTopics(id: "55", name: "55", threadListURL: "55", children: [])
        ]),
        CoursewareTopics(id: "6", name: "6", threadListURL: "6", children: [
            CoursewareTopics(id: "66", name: "66", threadListURL: "66", children: [])
        ])
    ])
    
    func testGetTopicsSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = DiscussionTopicsViewModel(interactor: interactor, router: router, config: config)
        
        Given(interactor, .getTopics(courseID: .any, willReturn: topics))
        
        await viewModel.getTopics(courseID: "1")
        
        Verify(interactor, .getTopics(courseID: .any))
        
        XCTAssertNotNil(viewModel.topics)
        XCTAssertNotNil(viewModel.discussionTopics)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testGetTopicsNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = DiscussionTopicsViewModel(interactor: interactor, router: router, config: config)
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .getTopics(courseID: .any, willThrow: noInternetError))
        
        await viewModel.getTopics(courseID: "1")
        
        Verify(interactor, .getTopics(courseID: .any))
        
        XCTAssertNil(viewModel.topics)
        XCTAssertNil(viewModel.discussionTopics)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testGetTopicsUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = DiscussionTopicsViewModel(interactor: interactor, router: router, config: config)
                
        Given(interactor, .getTopics(courseID: .any, willThrow: NSError()))
        
        await viewModel.getTopics(courseID: "1")
        
        Verify(interactor, .getTopics(courseID: .any))
        
        XCTAssertNil(viewModel.topics)
        XCTAssertNil(viewModel.discussionTopics)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
    }
}
