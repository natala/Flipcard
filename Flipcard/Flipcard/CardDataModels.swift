//
//  Card.swift
//  Flipcard
//
//  Created by Natalia Zarawska 2 on 08/02/17.
//  Copyright © 2017 Natalia Zarawska 2. All rights reserved.
//

import UIKit

struct CardDeck {
    let name: String
    let id: String
    let cards: [Card]?
}

struct Card {
    let question: CardSide
    let answer: CardSide
}

struct CardSide {
    let text: String
    let image: String?
}
