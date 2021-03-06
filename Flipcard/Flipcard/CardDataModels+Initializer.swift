//
//  CardDataModels+Dictionary.swift
//  Flipcard
//
//  Created by Natalia Zarawska 2 on 08/02/17.
//  Copyright © 2017 Natalia Zarawska 2. All rights reserved.
//

import UIKit
import os.log

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension CardDeck {
    
    init(_ json: [String: Any]) throws {
        guard let name = json["name"] as? String
            else {
                throw SerializationError.missing("name")
        }
        
        var cards = [Card]()
        // the deck might not have any cards yet
        if let cardsJson = json["cards"] as? [Any] {
            for cardJson in cardsJson {
                guard let card = try? Card(cardJson as! [String: Any]) else {
                    throw SerializationError.invalid("card", cardJson)
                }
                cards.append(card)
            }
        }
        
        let id = json["id"] as? String ?? "id placeholder"
        self.init(name: name, id: id, cards: cards)
        
    }
    
    init(name: String, id: String) {
        let cards = [Card]()
        self.init(name: name, id: id, cards: cards)
    }
}


extension Card {
    
    init(_ json: [String: Any]) throws {
        
        guard let questionJson = json["question"] as? [String: Any],
            let answerJson = json["answer"] as? [String: Any]
            else {
                throw SerializationError.missing("answer")
        }
        
        guard let answer = try? CardSide(answerJson) else {
            throw SerializationError.invalid("answer", answerJson)
        }
        guard  let question = try? CardSide(questionJson) else {
            throw SerializationError.invalid("question", questionJson)
        }
        
        self.init(question: question, answer: answer)
        
    }
    
}

extension CardSide {
    
    init(_ json: [String: Any]) throws {
        
        guard let text = json["text"] as? String else {
            throw SerializationError.missing("text")
        }
        
        self.init(text: text, image:json["image"] as? String)
    }
    
}
