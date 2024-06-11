//
//  DateInfoView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct DateInfoView: View {
    @Binding var date: Date
    @State var internalDate: Date
    @State var isPresenting = false
    
    @State var detentHeight = CGFloat.zero
    
    init(date: Binding<Date>) {
        self._date = date
        self.internalDate = date.wrappedValue
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(.dateInfoViewTitle)
                .font(.system(size: 12, weight: .semibold))
            HStack {
                Text(date, style: .date)
                Text(date, style: .time)
            }
            .contentTransition(.numericText())
            .animation(.easeInOut, value: date)
            .font(.system(size: 18, weight: .bold, design: .serif))
        }
        .frame(maxWidth: .infinity)
        .onTapGesture { isPresenting = true }
        .sheet(isPresented: $isPresenting) {
            DatePicker(selection: $internalDate) {}
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding(20)
                .onDisappear { date = internalDate }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .highPriorityGesture(DragGesture())
                .presentationDetents([.height(389.667)])
        }
    }
}
