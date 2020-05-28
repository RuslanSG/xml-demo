//
//  NewsRow.swift
//  XML
//
//  Created by Hrytsenko Ruslan on 5/25/20.
//  Copyright © 2020 Grid Dynamics. All rights reserved.
//

import SwiftUI

struct ArticleRow: View {
    var article: Article
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top) {
                Text(article.title)
                    .font(.system(.headline))
                    .layoutPriority(1)
                    .lineLimit(3)
                Spacer()
                Text(article.date)
                    .font(.system(.footnote))
                    .lineLimit(2)
                    .frame(width: 100)
            }
            Text(article.body)
                .font(.system(.body))
                .lineLimit(7)
        }
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        let article = Article(
            title: "Свежие фишечки Cisco Wi-Fi 6",
            body: "Уже год как мы слушаем о преимуществах революционного с технологической точки зрения стандарта Wi-Fi 6. Российская нормативная база под этот стандарт проходит стадии согласования и через несколько месяцев вступит в законную силу, создав условия для проведения сертификации средств связи.",
            date: "May 23, 2020 at 12:25 PM"
        )
        return ArticleRow(article: article)
    }
}
