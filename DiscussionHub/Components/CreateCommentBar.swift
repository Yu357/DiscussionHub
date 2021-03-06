//
//  CreateCommentBar.swift
//  DiscussionHub
//
//  Created by Yu on 2022/01/28.
//

import SwiftUI

struct CreateCommentBar: View {
    
    var parentThreadId: String
    var isTextEditorFocused: FocusState<Bool>.Binding
    
    @State var inputStr = ""
    
    var body: some View {
        HStack(alignment: .center) {
            
            // Input area
            ZStack(alignment: .topLeading) {
                TextEditor(text: $inputStr)
                    .focused(isTextEditorFocused)
                    .frame(height: 60)
                    .background(Color("TextEditorBackground"))
                    .cornerRadius(10)
                Text("コメント")
                    .foregroundColor(Color(UIColor.placeholderText))
                    .opacity(inputStr.isEmpty ? 1 : 0)
                    .padding(.top, 8)
                    .padding(.leading, 5)
                    .onTapGesture {
                        isTextEditorFocused.wrappedValue = true
                    }
            }
            .padding(.leading)
            .padding(.vertical, 8)
            
            // Send button
            Button(action: {
                CommentViewModel.addComment(parentThreadId: parentThreadId, content: inputStr)
                inputStr = ""
                isTextEditorFocused.wrappedValue = false
            }){
                Image(systemName: "paperplane.fill")
                    .font(.title3)
            }
            .disabled(inputStr.isEmpty)
            .padding(.trailing)
            .padding(.leading, 6)
        }
        .background(Color.secondary.opacity(0.2))
    }
}

