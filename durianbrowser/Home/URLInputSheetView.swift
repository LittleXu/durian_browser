//
//  URLInputSheetView.swift
//  durianbrowser
//
//  Created by liuxu on 2025/5/15.
//

import SwiftUI

struct URLInputSheetView: View {
    @Binding var urlString: String
    @Binding var isPresented: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Text("输入网址")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    
                    TextField("https://example.com", text: $urlString)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .frame(height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .focused($isFocused)
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        isPresented = false
                    }
                    .disabled(urlString.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isFocused = true
                }
            }
        }
        .interactiveDismissDisabled() // 防止下滑意外关闭
    }
}
