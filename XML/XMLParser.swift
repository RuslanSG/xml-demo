//
//  XMLParser.swift
//  XML
//
//  Created by Hrytsenko Ruslan on 5/25/20.
//  Copyright © 2020 Grid Dynamics. All rights reserved.
//

import Foundation
import Combine

struct Article: Identifiable, Decodable, Equatable {
    let id = UUID()
    let title: String
    let body: String
    let date: String
}

final class FeedParser: NSObject {
    
    // MARK: - Private Properties
        
    private var articles: [Article] = []
    
    private var currentElement = "" {
        didSet {
            currentElement = currentElement.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentTitle = "" {
           didSet {
               currentTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines)
           }
       }
    private var currentDescription = "" {
           didSet {
               currentDescription = currentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
           }
       }
    private var currentPubDate = "" {
           didSet {
               currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
           }
       }
    
    private var completion: ((Result<[Article], Error>) -> Void)?
    
    // MARK: - Public Methods
    
    func getFeed(url: URL, completion: ((Result<[Article], Error>) -> Void)? = nil) {
        self.completion = completion
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion?(.failure(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else { return }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
}

// MARK: - XML Parser Delegate

extension FeedParser: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let article = Article(
                title: currentTitle,
                body: currentDescription,
                date: currentPubDate
            )
            articles.append(article)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion?(.success(articles))
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completion?(.failure(parseError))
    }
}
