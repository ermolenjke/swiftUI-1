//
//  ContentView.swift
//  SwiftUI#1
//
//  Created by Даниил Ермоленко on 01.10.2023.
//

import SwiftUI

struct InnerContentSize: PreferenceKey {
    typealias Value = [CGRect]
    
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct HomeView: View {
    @State private var playerOffset: CGFloat = 0
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 1) {
                    ForEach(0..<49) {
                        Text("\($0)")
                            .foregroundStyle(.black)
                            .frame(width: UIScreen.screenWidth, height: 25)
                            .background(.yellow)
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                PlayerView(playerOffset: playerOffset)
            }
            .preference(key: InnerContentSize.self, value: [proxy.frame(in: CoordinateSpace.global)])
        }
    }
}

struct PlayerView: View {
    var playerOffset: CGFloat
    
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
            .opacity(0.8)
            .frame(height: 50)
            .offset(y: -playerOffset)
    }
}


struct ContentView: View {
    @State private var playerOffset: CGFloat = 0
    var body: some View {
        GeometryReader { geometry in
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("First")
                    }
            }
            .ignoresSafeArea()
            .onPreferenceChange(InnerContentSize.self, perform: { value in
                self.playerOffset = geometry.size.height - (value.last?.height ?? 0)
            })
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
