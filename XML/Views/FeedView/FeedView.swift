//
//  ContentView.swift
//  XML
//
//  Created by Hrytsenko Ruslan on 5/25/20.
//  Copyright © 2020 Grid Dynamics. All rights reserved.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel: FeedViewModel
    
    var body: some View {
        List(viewModel.articles, id: \.id) { article in
            ArticleRow(article: article)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FeedViewModel()
        return FeedView(viewModel: viewModel)
    }
}
