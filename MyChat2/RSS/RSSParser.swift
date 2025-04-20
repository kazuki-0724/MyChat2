//
//  RSSParser.swift
//  MyChat2
//
//
import Foundation

class RSSParser: NSObject, XMLParserDelegate, ObservableObject {
    @Published var items: [RSSItem] = []
    
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    
    func parseFeed(url: String) {
        // URLの空入力を許さない
        guard let feedURL = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: feedURL) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - XMLParserDelegate methods
    //    以下の順番でparserは勝手に呼ばれる
    //    didStartElement → <item>
    //    didStartElement → <title>
    //    foundCharacters → "記事タイトル"
    //    didEndElement → </title>
    //    didStartElement → <link>
    //    foundCharacters → "https://example.com"
    //    didEndElement → </link>
    //    didEndElement → </item>

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = RSSItem(
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            DispatchQueue.main.async {
                self.items.append(item)
            }
        }
    }
}
