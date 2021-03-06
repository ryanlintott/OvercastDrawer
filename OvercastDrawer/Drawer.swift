//
//  Drawer.swift
//  OvercastDrawer
//
//  Created by Ryan Lintott on 2022-07-16.
//

import SwiftUI

enum DrawerState: Equatable {
    case open
    case closing(amount: CGFloat)
    case closed
    case opening(amount: CGFloat)
    
    var label: String {
        switch self {
        case .open:
            return "open"
        case .closing(let amount):
            return "closing \(amount)"
        case .closed:
            return "closed"
        case .opening(let amount):
            return "opening \(amount)"
        }
    }
    
    var openAmount: CGFloat {
        switch self {
        case .open:
            return 1
        case .closing(let amount):
            return 1 - amount
        case .closed:
            return 0
        case .opening(let amount):
            return amount
        }
    }
    
    func settingAmount(to amount: CGFloat) -> Self {
        switch self {
        case .open, .closing:
             return .closing(amount: amount)
        case .closed, .opening:
             return .opening(amount: -amount)
        }
    }
    
    func value(open: CGFloat, closed: CGFloat) -> CGFloat {
        closed + ((open - closed) * openAmount)
    }
    
    mutating func toggle() {
        switch self {
        case .open:
            self = .closed
        case .closed:
            self = .open
        default:
            break
        }
    }
}

struct Drawer<Content: View, Background: View>: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    @Binding var drawerState: DrawerState
    let proxy: GeometryProxy
    let closedHeight: CGFloat
    let content: Content
    let background: Background
    
    init(_ drawerState: Binding<DrawerState>, proxy: GeometryProxy, closedHeight: CGFloat, content: () -> Content, background: () -> Background) {
        self._drawerState = drawerState
        self.proxy = proxy
        self.closedHeight = closedHeight
        self.content = content()
        self.background = background()
    }
    
    let haptics = DrawerViewHaptics.shared
    
    @State private var dragOffset: CGFloat = .zero
    @State private var predictedDragOffset: CGFloat = .zero
    @GestureState private var isDragging: Bool = false
    
    var openHeight: CGFloat { proxy.size.height }
    var heightDifference: CGFloat {
        openHeight - closedHeight
    }

    var drawerHeight: CGFloat {
        closedHeight + (heightDifference * drawerState.openAmount)
    }
    
    var drawerOffset: CGFloat {
        openHeight - drawerHeight
    }
    
    var body: some View {
        Color.clear
            .overlay(
                content
                    .background(
                        background
                            .padding(.top, drawerState.value(open: -proxy.safeAreaInsets.top, closed: 0))
                            .ignoresSafeArea(.all, edges: .bottom)
                    )
                    .frame(height: drawerHeight)
                , alignment: .top
            )
            .frame(height: openHeight)
            .offset(y: drawerOffset)
            .onAppear(perform: haptics.prepareHaptics)
            .onChange(of: isDragging) { isDragging in
                if isDragging {
                    haptics.prepareHaptics()
                } else {
                    onDragEnded()
                }
            }
            .gesture(drag)
//            .overlay(Text(drawerState.label), alignment: .leading)
//            .overlay(Text("\(drawerState.openAmount)"), alignment: .trailing)
    }
    
    var drag: some Gesture {
        DragGesture()
            .updating($isDragging) { value, gestureState, transaction in
                gestureState = true
            }
            .onChanged { value in
                predictedDragOffset = value.predictedEndTranslation.height
                dragOffset = value.translation.height
                drawerState = drawerState.settingAmount(to: dragOffset / heightDifference)
            }
    }
    
    func onDragEnded() {
        let velocity = predictedDragOffset - dragOffset

        withAnimation(.spring()) {
            drawerState = velocity > 0 ? .closed : .open
            dragOffset = .zero
            predictedDragOffset = .zero
        }
        haptics.playClaspHaptic(after: 0.4)
    }
}

struct Drawer_Previews: PreviewProvider {
    struct PreviewData: View {
        @State private var drawerState: DrawerState = .closed
        
        var body: some View {
            ZStack {
                Color.blue
                
                GeometryReader { proxy in
                    Drawer($drawerState, proxy: proxy, closedHeight: 200) {
                        HStack {
                            Text("Cover")
                            Spacer()
                            VStack {
                                Text("Cover")
                                Spacer()
                                Text("Cover")
                            }
                            Spacer()
                            Text("Cover")
                        }
                    } background: {
                        Color.red
                    }
                }
            }
        }
        
    }
    
    static var previews: some View {
        PreviewData()
    }
}
