//
//  DeckDetailView.swift
//  Linguo
//
//  Created by Steve Alex on 16/08/2024.
//

import Foundation
//
//  File.swift
//  Linguo
//
//  Created by Steve Alex on 16/08/2024.
//

import Foundation
import SwiftUI

struct DeckDetailView: View {
    var deck: IDeck

    var body: some View {
        Text("Name: \(deck.name)")
        Text("Language: \(deck.language)")
        Text("Reviewed Today: \(deck.reviewedToday)")
        Text("Review Cards Remaining: \(deck.reviewCardsRemaining)")
    }
}

