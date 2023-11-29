//
//  DailyQuoteViewWithBackground.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/28/23.
//

import SwiftUI

struct DailyQuoteViewWithBackground: View {
    // Your existing properties and methods

    var body: some View {
        ZStack {
            Image("stoicbackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            // Your existing DailyQuoteView content
            // ...
        }
    }
}
