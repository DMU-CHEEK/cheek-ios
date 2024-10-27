//
//  AddScrapFolderView.swift
//  CHEEK
//
//  Created by 김태은 on 10/22/24.
//

import SwiftUI

struct AddScrapFolderView: View {
    var storyModel: StoryModel
    
    @ObservedObject var authViewModel: AuthenticationViewModel
    @ObservedObject var scrapViewModel: ScrapViewModel
    
    @Binding var isScrapOpen: Bool
    @Binding var isKeyboardUp: Bool
    @FocusState private var isFocused: Bool
    
    @State var text: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("이름 설정")
                            .body1(font: "SUIT", color: .cheekTextNormal, bold: true)
                            .padding(.top, 36)
                        
                        HStack(spacing: 12) {
                            ProfileS(url: storyModel.storyPicture)
                            
                            TextField(
                                "",
                                text: $text,
                                prompt:
                                    Text("새로운 폴더")
                                    .foregroundColor(.cheekTextAlternative)
                            )
                            .focused($isFocused)
                            .submitLabel(.send)
                            .tint(.cheekMainNormal)
                            .body2(font: "SUIT", color: .cheekTextNormal, bold: true)
                            .onChange(of: isFocused) { _ in
                                isKeyboardUp = isFocused
                            }
                            .onSubmit {
                                addCollection()
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.cheekBackgroundTeritory)
                
                if scrapViewModel.isLoading {
                    LoadingView()
                }
            }
            .onTapGesture {
                Utils().hideKeyboard()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            authViewModel.isRefreshTokenValid = authViewModel.checkRefreshTokenValid()
        }
    }
    
    func addCollection() {
        Utils().hideKeyboard()
        
        scrapViewModel.addCollection(storyId: storyModel.storyId, categoryId: storyModel.categoryId, forlderName: text) { isDone in
            isScrapOpen = false
        }
    }
}

#Preview {
    AddScrapFolderView(storyModel: StoryModel(storyId: 1, categoryId: 1, storyPicture: "", upvoted: false, upvoteCount: 0, memberDto: MemberDto(memberId: 1, nickname: "", profilePicture: "")), authViewModel: AuthenticationViewModel(), scrapViewModel: ScrapViewModel(), isScrapOpen: .constant(true), isKeyboardUp: .constant(true))
}