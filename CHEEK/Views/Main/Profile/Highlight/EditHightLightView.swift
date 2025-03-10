//
//  SelectStoriesView.swift
//  CHEEK
//
//  Created by 김태은 on 9/4/24.
//

import SwiftUI
import Kingfisher

fileprivate let LAZY_V_GRID_SPACING: CGFloat = 4

struct EditHighlightView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var authViewModel: AuthenticationViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var highlightViewModel: HighlightViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단바
            HStack {
                Button(action: {
                    dismiss()}
                ) {
                    Image("IconChevronLeft")
                        .resizable()
                        .foregroundColor(.cheekTextNormal)
                        .frame(width: 32, height: 32)
                        .padding(8)
                }
                
                                            
                
                Spacer()
                
                if highlightViewModel.selectedStories.count > 0 {
                    NavigationLink(destination: SetHighlightView(
                        authViewModel: authViewModel,
                        profileViewModel: profileViewModel,
                        highlightViewModel: highlightViewModel)) {
                        HStack(spacing: 4) {
                            Text("완료")
                                .label1(font: "SUIT", color: .cheekTextNormal, bold: false)
                            
                            Text("\(highlightViewModel.selectedStories.count)")
                                .label1(font: "SUIT", color: .cheekMainStrong, bold: true)
                        }
                        .padding(.horizontal, 11)
                    }
                        
                                            
                } else {
                    Text("완료")
                        .label1(font: "SUIT", color: .cheekTextNormal, bold: false)
                        .padding(.horizontal, 18)
                }
            }
            .overlay(
                Text("스토리 선택")
                    .label1(font: "SUIT", color: .cheekTextNormal, bold: true)
                , alignment: .center
            )
            .padding(.top, 8)
            .padding(.horizontal, 16)
            
            // 선택한 스토리
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(highlightViewModel.selectedStories) { story in
                        KFImage(URL(string: story.storyPicture))
                            .placeholder {
                                Color.cheekLineAlternative
                            }
                            .retry(maxCount: 2, interval: .seconds(2))
                            .onSuccess { result in
                                
                            }
                            .onFailure { error in
                                print("이미지 불러오기 실패: \(error)")
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 159, height: 281)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 159, height: 281)
                        .foregroundColor(.cheekLineAlternative)
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 17)
            
            // 내 스토리 목록
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: LAZY_V_GRID_SPACING), count: 3), spacing: 4) {
                    ForEach(profileViewModel.stories) { story in
                        ZStack(alignment: .leading) {
                            KFImage(URL(string: story.storyPicture))
                                .placeholder {
                                    Color.cheekLineAlternative
                                }
                                .retry(maxCount: 2, interval: .seconds(2))
                                .onSuccess { result in
                                    
                                }
                                .onFailure { error in
                                    print("이미지 불러오기 실패: \(error)")
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 156)
                                .frame(maxWidth: .infinity)
                                .clipped()
                            
                            if highlightViewModel.selectedStories.contains(story) {
                                Rectangle()
                                    .foregroundColor(.cheekMainNormal.opacity(0.2))
                                    .overlay(
                                        Rectangle()
                                            .strokeBorder(.cheekMainNormal, lineWidth: 2)
                                    )
                            }
                            
                            VStack {
                                if highlightViewModel.selectedStories.contains(story) {
                                    Circle()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.cheekMainNormal)
                                        .overlay(
                                            Image("IconCheck")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.cheekTextNormal)
                                        )
                                        .padding(8)
                                } else {
                                    Circle()
                                        .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29).opacity(0.6))
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(.cheekWhite, lineWidth: 2)
                                        )
                                        .padding(8)
                                }
                                
                                Spacer()
                            }
                            
                            VStack {
                                Spacer()
                                
                                Text(convertToDate(dateString: story.modifiedAt!) ?? "")
                                    .caption1(font: "SUIT", color: .cheekWhite, bold: true)
                                    .frame(alignment: .bottomLeading)
                                    .padding(8)
                            }
                        }
                        .contentShape(Rectangle())
                        .frame(height: 156)
                        .onTapGesture {
                            if let index = highlightViewModel.selectedStories.firstIndex(of: story) {
                                highlightViewModel.selectedStories.remove(at: index)
                            } else {
                                highlightViewModel.selectedStories.append(story)
                            }
                        }
                    }
                }
            }
            .padding(.top, 27)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.cheekBackgroundTeritory)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.cheekBackgroundTeritory)
        .onAppear {
            authViewModel.checkRefreshTokenValid()
            
            if highlightViewModel.isDone {
                dismiss()
            }
        }
    }
}


#Preview {
    EditHighlightView(authViewModel: AuthenticationViewModel(), profileViewModel: ProfileViewModel(), highlightViewModel: HighlightViewModel())
}
