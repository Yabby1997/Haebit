//
//  HaebitConfigView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/23/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

public struct HaebitConfigView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                Section {} header: {
                    ZStack {
                        VStack(spacing: 8) {
                            Spacer()
                            HStack {
                                Text("Having fun with illumeter?")
                                    .font(.system(size: 40, weight: .bold, design: .serif))
                                Spacer()
                            }
                            HStack {
                                Text("If so, consider to buy me a roll of film 🎞️. It would be very pleasant for me")
                                    .font(.system(size: 16, weight: .semibold, design: .serif))
                                Spacer()
                            }
                        }
                    }
                    .onTapGesture {
                        print("!!")
                    }
                }
                Section {
                    NavigationLink {
                        Text("Aperture")
                    } label: {
                        HStack {
                            Text("Aperture")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("12 items")
                                .font(.system(size: 14, design: .monospaced))
                        }
                    }
                    NavigationLink {
                        Text("Shutter Speed")
                    } label: {
                        HStack {
                            Text("Shutter Speed")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("8 items")
                                .font(.system(size: 14, design: .monospaced))
                        }
                    }
                    NavigationLink {
                        Text("ISO")
                    } label: {
                        HStack {
                            Text("ISO")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("400")
                            }
                            .font(.system(size: 14, design: .monospaced))
                        }
                    }
                    NavigationLink {
                        Text("Focal Length")
                    } label: {
                        HStack {
                            Text("Focal Length")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("50mm")
                            }
                            .font(.system(size: 14, design: .monospaced))
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "f.cursive")
                        Text("Control")
                    }
                    .font(.system(size: 14, weight: .bold))
                } footer: {
                    Text("At least a type of exposure related value should have more than two items.")
                }
                Section {
                    NavigationLink {
                        Text("Aperture Ring")
                    } label: {
                        HStack {
                            Text("Aperture Ring")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("Rigid")
                                .font(.system(size: 14, design: .monospaced))
                        }
                    }
                    NavigationLink {
                        Text("Shutter Speed Dial")
                    } label: {
                        HStack {
                            Text("Shutter Speed Dial")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("Heavy")
                                .font(.system(size: 14, design: .monospaced))
                        }
                    }
                    NavigationLink {
                        Text("ISO Dial")
                    } label: {
                        HStack {
                            Text("ISO Dial")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("Heavy")
                                .font(.system(size: 14, design: .monospaced))
                        }
                    }
                    NavigationLink {
                        Text("Focal Length Ring")
                    } label: {
                        HStack {
                            Text("Focal Length Ring")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("Soft")
                                .font(.system(size: 14, design: .monospaced))
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "hand.draw")
                        Text("Feedback")
                    }
                    .font(.system(size: 14, weight: .bold))
                }
                Section {
                    NavigationLink {
                        Text("Perforation")
                    } label: {
                        HStack {
                            Text("Perforation")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("Bell and Howell")
                                .font(.system(size: 14, design: .monospaced))
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Appearance")
                    }
                    .font(.system(size: 14, weight: .bold))
                }
                Section {
                    NavigationLink {
                        Text("OpenSource")
                    } label: {
                        Text("OpenSource")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    NavigationLink {
                        Text("AppStore")
                    } label: {
                        Text("Review on AppStore")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    NavigationLink {
                        Text("Buy me a film")
                    } label: {
                        Text("Buy me a film")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    NavigationLink {
                        Text("Contact")
                    } label: {
                        Text("Contact")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    HStack {
                        Text("App Version")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                        Text("1.4.0")
                            .font(.system(size: 14, design: .monospaced))
                    }
                } header: {
                    HStack {
                        Image(systemName: "text.bubble")
                        Text("Other")
                    }
                    .font(.system(size: 14, weight: .bold))
                }
            }
            .navigationTitle("Config")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
            .headerProminence(.increased)
            .toolbar {
                ToolbarItem {
                    Button {
                        print("Close")
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    HaebitConfigView()
}
