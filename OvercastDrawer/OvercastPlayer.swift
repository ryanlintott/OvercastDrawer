//
//  OvercastPlayer.swift
//  OvercastDrawer
//
//  Created by Ryan Lintott on 2022-07-16.
//

import SwiftUI

struct OvercastPlayer: View {
    @State private var drawerState: DrawerState = .open
    let size: CGSize
    let closedHeight: CGFloat = 60
    
    var playerButtonsPadding: CGFloat {
        drawerState.value(open: 10, closed: 80)
    }
    
    var body: some View {
        GeometryReader { proxy in
            Drawer($drawerState, proxy: proxy, closedHeight: closedHeight) {
                VStack {
                    VStack {
                        VStack {
                            Rectangle()
                                .aspectRatio(1, contentMode: .fit)
                                .hidden()
                            
                            HStack {
                                Image(systemName: "line.3.horizontal.circle")
                                VStack {
                                    Text("SwiftUI Updates".uppercased())
                                        .font(.caption2.bold())
                                        .foregroundColor(.gray)
//                                        .underline()
                                    
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(.gray)
                                            .frame(height: 3)
                                        
                                        ZStack(alignment: .trailing) {
                                            Capsule()
                                                .frame(height: 3)
                                            
                                            Circle()
                                                .frame(width: 10, height: 10)
                                                .alignmentGuide(.trailing) { d in
                                                    d[HorizontalAlignment.center]
                                                }
                                        }
                                        .frame(width: 100)
                                    }
                                        .drawingGroup()
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    HStack {
                                        Text("5:22")
                                        Spacer()
                                        Text("-1:59:00")
                                    }
                                    .font(.caption.bold())
                                    .foregroundColor(.gray)
                                }
                                Image(systemName: "forward.end.fill")
                            }
                            .padding()
                            .padding(.top, closedHeight)
                        }
                        .opacity(drawerState.value(open: 1, closed: -3))
                        
                        HStack {
                            Image(systemName: "gobackward.15")
                            Spacer()
                            Image(systemName: "play.fill")
                            Spacer()
                            Image(systemName: "goforward.15")
                        }
                        .font(.largeTitle)
                        .padding(.horizontal, playerButtonsPadding)
                        .frame(height: closedHeight)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .alignmentGuide(.top) { d in
                        drawerState.value(open: d[.top], closed: d[.bottom] - closedHeight)
                    }
                }
                .overlay(
                    HStack {
                        Spacer()
                        VStack {
                            Text("491: Salmon and SwiftUI")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Text("Accidental Tech Podcast".uppercased())
                                .font(.caption2.bold())
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                    }
                    .padding(.horizontal)
                    .frame(height: closedHeight)
                    .opacity(drawerState.value(open: 1, closed: -3))
                    , alignment: .top
                )
                .overlay(
                    Button {
                        withAnimation(.spring()) { drawerState.toggle() }
                    } label: {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(drawerState.value(open: 0, closed: 180)))
                            .font(.title)
                            .padding()
                    }
                    , alignment: .topLeading
                )
                .frame(height: drawerState.value(open: proxy.size.height, closed: closedHeight), alignment: .top)
                .overlay(
                    VStack {
                        Image("ATP")
                            .resizable()
                            .onTapGesture {
                                if drawerState == .closed {
                                    withAnimation(.spring()) { drawerState.toggle() }
                                }
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .frame(height: drawerState.value(open: proxy.size.width, closed: closedHeight), alignment: .top)
                            .padding(.top, drawerState.value(open: closedHeight, closed: 0))
                        
                        Spacer(minLength: 0)
                    }
                )
                .foregroundColor(.orange)
                .padding(.bottom, 200)
                .background(Rectangle().fill(.white).ignoresSafeArea())
                .clipped()
            } background: {
                Color.white
                    .shadow(radius: 10)
            }
        }
//        .background(Color.init(white: 0.9))
    }
}

struct OvercastPlayer_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            OvercastPlayer(size: proxy.size)
        }
    }
}
