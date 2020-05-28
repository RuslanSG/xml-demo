//
//  FeedViewModel.swift
//  XML
//
//  Created by Hrytsenko Ruslan on 5/27/20.
//  Copyright © 2020 Grid Dynamics. All rights reserved.
//

import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    @Published var articles: [Article] = []
    
    private let parser = FeedParser()
    
    init() {
        let url = URL(string: "https://habr.com/en/rss/flows/develop/all/?fl=en")!
        parser.getFeed(url: url) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    strongSelf.articles = articles
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
