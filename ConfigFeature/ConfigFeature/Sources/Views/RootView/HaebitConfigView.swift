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
                Section {
                    HStack {
                        ZStack {
                            FilmMagazineView()
                            VStack {
                                Spacer()
                                Text("illumeter is developed without profits.\nHow about buy me a roll of films?")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(height: 200)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        print("@@@")
                    }
                }
                Section {
                    NavigationLink {
                        Text("Apertures")
                    } label: {
                        HStack {
                            Text("Apertures")
                            Spacer()
                            Text("12 values")
                        }
                    }
                    NavigationLink {
                        Text("Shutter Speeds")
                    } label: {
                        HStack {
                            Text("Shutter Speeds")
                            Spacer()
                            Text("8 values")
                        }
                    }
                    NavigationLink {
                        Text("ISO Values")
                    } label: {
                        HStack {
                            Text("ISO Values")
                            Spacer()
                            Text("4 values")
                        }
                    }
                    NavigationLink {
                        Text("Focal Lengths")
                    } label: {
                        HStack {
                            Text("Focal Lengths")
                            Spacer()
                            Text("3 values")
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "f.cursive")
                        Text("Values")
                    }
                }
                Section {
                    NavigationLink {
                        Text("Aperture Ring")
                    } label: {
                        HStack {
                            Text("Aperture Ring")
                            Spacer()
                            Text("Rigid")
                        }
                    }
                    NavigationLink {
                        Text("Shutter Speed Dial")
                    } label: {
                        HStack {
                            Text("Shutter Speed Dial")
                            Spacer()
                            Text("Heavy")
                        }
                    }
                    NavigationLink {
                        Text("ISO Dial")
                    } label: {
                        HStack {
                            Text("ISO Dial")
                            Spacer()
                            Text("Heavy")
                        }
                    }
                    NavigationLink {
                        Text("Focal Length Ring")
                    } label: {
                        HStack {
                            Text("Focal Length Ring")
                            Spacer()
                            Text("Soft")
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "hand.draw")
                        Text("Feedbacks")
                    }
                }
                Section {
                    NavigationLink {
                        Text("Perforation Shape")
                    } label: {
                        HStack {
                            Text("Perforation Shape")
                            Spacer()
                            Text("Bell and Howell")
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Design")
                    }
                }
                Section {
                    NavigationLink {
                        Text("OpenSource")
                    } label: {
                        Text("OpenSource")
                    }
                    NavigationLink {
                        Text("AppStore")
                    } label: {
                        Text("Review on AppStore")
                    }
                    NavigationLink {
                        Text("Contact")
                    } label: {
                        Text("Contact")
                    }
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.4.0")
                    }
                } header: {
                    HStack {
                        Image(systemName: "text.bubble")
                        Text("Others")
                    }
                }
            }
            .navigationTitle("Config")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
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
