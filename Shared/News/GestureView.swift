//
//  GestureView.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/13/21.
//

import SwiftUI

struct GestureView: View {
    @State private var isPressed = false
    @GestureState private var longPressTap = false
    
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    
    var body: some View {
        VStack{
            Image(systemName: "star.circle.fill")
                .font(.system(size: 100))
                .scaleEffect(isPressed ? 0.5 : 1.0)
                .animation(.easeInOut)
                .foregroundColor(.green)
                .gesture(
                    TapGesture()
                        .onEnded({
                            print("Tapped!")
                            self.isPressed.toggle()
                        })
                )
            
            Image(systemName: "star.circle.fill")
                .font(.system(size: 100))
                .opacity(longPressTap ? 0.4 : 1.0)
                .scaleEffect(isPressed ? 0.5 : 1.0)
                .animation(.easeInOut)
                .foregroundColor(.green)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                    .updating($longPressTap, body: { (currentState, state, transaction) in
                        state = currentState
                    })
                        .onEnded({_ in
                            print("Tapped!")
                            self.isPressed.toggle()
                        })
                )
            
            Image(systemName: "star.circle.fill")
               .font(.system(size: 100))
               .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
               .animation(.easeInOut)
               .foregroundColor(.green)
               .gesture(
                   DragGesture()
                       .updating($dragOffset, body: { (value, state, transaction) in
                           state = value.translation
                       })
                       .onEnded({ (value) in
                           self.position.height += value.translation.height
                           self.position.width += value.translation.width
                       })
               )
            
            Image(systemName: "star.circle.fill")
                .font(.system(size: 100))
                .opacity(longPressTap ? 0.5 : 1.0)
                .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
                .animation(.easeInOut)
                .foregroundColor(.green)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .updating($longPressTap, body: { (currentState, state, transaction) in
                            state = currentState
                        })
                        .sequenced(before: DragGesture())
                        .updating($dragOffset, body: { (value, state, transaction) in
                            switch value {
                            case .first(true):
                                print("Tapping")
                            case .second(true, let drag):
                                state = drag?.translation ?? .zero
                            default:
                                break
                            }
                        })
                        .onEnded({ (value) in
                            guard case .second(true, let drag?) = value else {
                                return
                            }
                            self.position.height += drag.translation.height
                            self.position.width += drag.translation.width
                        })
                )
            

        }
    }
}

struct GestureView_Previews: PreviewProvider {
    static var previews: some View {
        GestureView()
    }
}
