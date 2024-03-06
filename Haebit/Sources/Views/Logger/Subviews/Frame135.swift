//
//  Perforation.swift
//  HaebitDev
//
//  Created by Seunghun on 2/22/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct Frame135: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                HStack(spacing: .zero) {
                    Color.black.frame(width: geo.size.width * 2.0 / 35.0)
                    PerforationHoles(size: geo.size)
                    Color.black.frame(width: geo.size.width * 25.8 / 35.0, height: geo.size.width * 36.0 / 35.0)
                    PerforationHoles(size: geo.size)
                    Color.black.frame(width: geo.size.width * 2.0 / 35.0)
                }
                LeftPerforationMetadataLabel(size: geo.size, text: "\t13\t\tHAEBIT 400")
                RightPerforationMetadataLabel(size: geo.size, text: "\t13\t\t\t\t\t➞")
            }
            .background(.black)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Frame135()
        .frame(width: 350, height: 360)
}

struct LeftPerforationMetadataLabel: View {
    let size: CGSize
    let text: String
    
    var body: some View {
        HStack {
            VStack(spacing: .zero) {
                Spacer()
                Text(text)
                    .offset(x: -size.width * 2.0 / 35.0)
                    .frame(height: size.width * 2.0 / 35.0)
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .rotationEffect(.degrees(270), anchor: .topLeading)
                    .foregroundStyle(.yellow)
            }
            Spacer()
        }
    }
}

struct RightPerforationMetadataLabel: View {
    let size: CGSize
    let text: String
    
    var body: some View {
        HStack {
            VStack(spacing: .zero) {
                Spacer()
                Text(text)
                    .offset(y: size.width)
                    .frame(height: size.width * 2.0 / 35.0)
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .rotationEffect(.degrees(270), anchor: .bottomLeading)
                    .foregroundStyle(.yellow)
            }
            Spacer()
        }
    }
}

struct PerforationHoles: View {
    let size: CGSize
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Color.black.frame(height: size.width * 1.0 / 36.0)
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size.width * 2.6 / 35.0, height: size.width * 2.0 / 35.0)
                .foregroundStyle(.white.shadow(.inner(color: .black.opacity(0.7), radius: 1)))
            Spacer()
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size.width * 2.6 / 35.0, height: size.width * 2.0 / 35.0)
                .foregroundStyle(.white.shadow(.inner(color: .black.opacity(0.7), radius: 1)))
            Spacer()
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size.width * 2.6 / 35.0, height: size.width * 2.0 / 35.0)
                .foregroundStyle(.white.shadow(.inner(color: .black.opacity(0.7), radius: 1)))
            Spacer()
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size.width * 2.6 / 35.0, height: size.width * 2.0 / 35.0)
                .foregroundStyle(.white.shadow(.inner(color: .black.opacity(0.7), radius: 1)))
            Spacer()
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size.width * 2.6 / 35.0, height: size.width * 2.0 / 35.0)
                .foregroundStyle(.white.shadow(.inner(color: .black.opacity(0.7), radius: 1)))
            Spacer()
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size.width * 2.6 / 35.0, height: size.width * 2.0 / 35.0)
                .foregroundStyle(.white.shadow(.inner(color: .black.opacity(0.7), radius: 1)))
            Spacer()
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size.width * 2.6 / 35.0, height: size.width * 2.0 / 35.0)
                .foregroundStyle(.white.shadow(.inner(color: .black.opacity(0.7), radius: 1)))
            Spacer()
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size.width * 2.6 / 35.0, height: size.width * 2.0 / 35.0)
                .foregroundStyle(.white.shadow(.inner(color: .black.opacity(0.7), radius: 1)))
            Color.black.frame(height: size.width * 2.0 / 36.0)
        }
    }
}
