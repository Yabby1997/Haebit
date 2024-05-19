//
//  LoadingView.swift
//  HaebitDev
//
//  Created by Seunghun on 5/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import Combine

struct LoadingView: View {
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var from: CGFloat = .zero
    @State private var to: CGFloat = 100
    let count: Int
    let duration: Double
    let delay: Double
    
    init(count: Int, duration: Double, delay: Double) {
        self.count = count
        self.duration = duration
        self.delay = delay
        self.timer = Timer.publish(every: duration + delay , on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                Spacer()
                ZStack {
                    ForEach(Range(0...count - 1), id: \.self) { index in
                        Circle()
                            .fill(Color(uiColor: .white))
                            .frame(width: circleSize(with: proxy), height: circleSize(with: proxy))
                            .offset(x: from)
                            .opacity(0.7)
                            .animation(Animation.easeInOut(duration: duration).delay(delay * Double(index)))
                    }
                }
                Spacer()
            }
            .onAppear {
                from = .zero
                to = proxy.size.width - circleSize(with: proxy)
            }
            .onReceive(timer) { _ in
                swap(&from, &to)
            }
        }
    }
    
    func circleSize(with proxy: GeometryProxy) -> CGFloat {
        proxy.size.height / 2.0
    }
}

#Preview {
    LoadingView(count: 3, duration: 1, delay: 0.4)
        .frame(maxHeight: 80)
}
