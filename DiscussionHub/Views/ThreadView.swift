//
//  OpinionsView.swift
//  DiscussionHub
//
//  Created by Yu on 2022/01/27.
//

import SwiftUI

struct ThreadView: View {
    
    let threadId: String
    
    @ObservedObject var threadViewModel: ThreadViewModel
    @ObservedObject var commentViewModel: CommentViewModel
    
    @State var inputStr = ""
    @FocusState var isTextEditorFocused: Bool
    
    init(threadId: String) {
        self.threadId = threadId
        self.threadViewModel = ThreadViewModel(threadId: threadId)
        self.commentViewModel = CommentViewModel(threadId: self.threadId)
    }
    
    var body: some View {
        
        ScrollViewReader {proxy in
            
            ZStack(alignment: .bottomLeading) {
                
                // Thraed title and comments list
                List {
                    Text(threadViewModel.currentThread!.title)
                        .font(.title)
                        .fontWeight(.bold)
                    ForEach(commentViewModel.comments, id: \.self) {comment in
                        VStack(alignment: .leading) {
                            Divider()
                            HStack {
                                Text("\(comment.order)")
                                    .fontWeight(.semibold)
                                Text(comment.userId)
                                    .fontWeight(.semibold)
                                Text("\(formatDate(inputDate: comment.createdAt))")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            Text(comment.content)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 6)
                                .padding(.horizontal, 12)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(6)
                    }
                }
                .listStyle(PlainListStyle())
                .onTapGesture {
                    isTextEditorFocused = false
                }
                .padding(.bottom, 76)
                
                // If comments changed, Scroll list to end
                .onChange(of: commentViewModel.comments) {value in
                    withAnimation {
                        proxy.scrollTo(commentViewModel.comments[commentViewModel.comments.endIndex - 1])
                    }
                }
                
                // TODO: When TextEditor focused, Scroll list to end
//                .onChange(of: isTextEditorFocused) {value in
//                    if value {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                            withAnimation {
//                                proxy.scrollTo(commentViewModel.comments[commentViewModel.comments.endIndex - 1])
//                            }
//                        }
//                    }
//                }
                
//                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { value in
//                    // Write code for keyboard opened.
//                    if isTextEditorFocused {
//                        print("HELLO \(value)")
//
//                    }
//                }
                
                // Input bar
                HStack(alignment: .center) {
                    
                    // Input area
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $inputStr)
                            .focused($isTextEditorFocused)
                            .frame(height: 60)
                            .background(Color("TextEditorBackground"))
                            .cornerRadius(10)
                        Text("コメント")
                            .foregroundColor(Color(UIColor.placeholderText))
                            .opacity(inputStr.isEmpty ? 1 : 0)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    .padding(.leading)
                    .padding(.vertical, 8)
                    
                    // Send button
                    Button(action: {
                        commentViewModel.addComment(content: inputStr)
                        inputStr = ""
                        isTextEditorFocused = false
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
        .navigationBarTitle("", displayMode: .inline)
    }
    
    func formatDate(inputDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd E HH:mm:ss"
        return dateFormatter.string(from: inputDate)
    }
    
}
