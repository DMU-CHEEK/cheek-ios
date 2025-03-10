//
//  SearchView.swift
//  CHEEK
//
//  Created by 김태은 on 8/26/24.
//

import SwiftUI
import WrappingHStack

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthenticationViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @StateObject private var viewModel: SearchViewModel = SearchViewModel()
    
    var catetory: Int64?
    
    @State private var selectedCategory: Int64? = nil
    @State private var searchText: String = ""
    @State private var selectedTab: Int = 0
    
    @State var isStoryOpen: Bool = false
    @State var selectedStories: [Int64] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 뒤로가기와 검색
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
                
                if selectedCategory != nil {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 9) {
                                if let selectedCategory {
                                    ChipSearch(
                                        text: CategoryModels().categories[Int(selectedCategory) - 1].name,
                                        onTap: { onTapChipClose() })
                                    .id(0)
                                }
                                
                                TextField(
                                    "",
                                    text: $searchText,
                                    prompt: Text("회사, 사람, 키워드로 검색")
                                        .foregroundColor(.cheekTextAlternative)
                                )
                                .submitLabel(.search)
                                .label1(font: "SUIT", color: .cheekTextNormal, bold: true)
                                .foregroundColor(.cheekTextStrong)
                                .id(1)
                                .onChange(of: searchText) { _ in
                                    proxy.scrollTo(1, anchor: .trailing)
                                }
                                .onSubmit {
                                    onSubmitSearch()
                                    viewModel.saveSearched(string: searchText)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                        }
                        .background(
                            Capsule()
                                .foregroundColor(.cheekLineAlternative)
                        )
                    }
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            
            // 검색 전
            if !viewModel.isSearched || selectedCategory == nil {
                if selectedCategory != nil {
                    ScrollView {
                        if !viewModel.recentSearches.isEmpty {
                            VStack(spacing: 8) {
                                // 최근 검색
                                HStack {
                                    Text("최근 검색")
                                        .label1(font: "SUIT", color: .cheekTextStrong, bold: true)
                                        .padding(.vertical, 12)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.removeAllSearched()
                                    }) {
                                        Text("전체 삭제")
                                            .label2(font: "SUIT", color: .cheekTextAlternative, bold: false)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 14)
                                    }
                                }
                                .padding(.horizontal, 16)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(viewModel.recentSearches, id: \.self) { search in
                                            Button(action: {
                                                searchText = search
                                            }) {
                                                ChipDefault(text: search)
                                            }
                                        }
                                        
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            .padding(.top, 16)
                        }
                        
                        // 트렌딩 키워드
                        HStack {
                            Category(title: "트렌딩 키워드", description: "지난 7일간 가장 많이 발견된 키워드예요!")
                            
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.leading, 16)
                        
                        WrappingHStack(viewModel.trendingKeywords, id: \.self, spacing: .constant(8), lineSpacing: 8) { keyword in
                            Button(action: {
                                self.searchText = keyword
                            }) {
                                ChipDefault(text: keyword)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("카테고리를 선택해주세요")
                                .headline1(font: "SUIT", color: .cheekTextStrong, bold: true)
                            
                            ForEach(CategoryModels().categories) { category in
                                HStack {
                                    Button(action: {
                                        selectedCategory = category.id
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(category.image)
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .padding(8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .strokeBorder(.cheekLineNormal, lineWidth: 1)
                                                )
                                            
                                            Text(category.name)
                                                .label1(font: "SUIT", color: .cheekTextNormal, bold: true)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                }
            }
            // 검색 후
            else {
                VStack(spacing: 0) {
                    TabsText(tabs: ["전체", "프로필", "스토리", "질문"], selectedTab: $selectedTab)
                    
                    TabView(selection: $selectedTab) {
                        SearchResultAllView(
                            authViewModel: authViewModel,
                            profileViewModel: profileViewModel,
                            searchViewModel: viewModel,
                            selectedTab: $selectedTab,
                            isStoryOpen: $isStoryOpen,
                            selectedStories: $selectedStories)
                        .tag(0)
                        
                        SearchResultProfileView(
                            authViewModel: authViewModel,
                            searchViewModel: viewModel)
                        .tag(1)
                        
                        SearchResultStoryView(
                            searchViewModel: viewModel,
                            isStoryOpen: $isStoryOpen,
                            selectedStories: $selectedStories)
                        .tag(2)
                        
                        SearchResultQuestionView(
                            authViewModel: authViewModel,
                            profileViewModel: profileViewModel,
                            searchViewModel: viewModel)
                        .tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.top, 16)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.cheekBackgroundTeritory)
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            authViewModel.checkRefreshTokenValid()
            
            if catetory != nil {
                selectedCategory = catetory
            }
            
            viewModel.getRecentSearched()
            viewModel.getTrendingKeywords()
        }
        .fullScreenCover(isPresented: $isStoryOpen) {
            if #available(iOS 16.4, *) {
                StoryView(authViewModel: authViewModel, storyIds: $selectedStories)
                    .presentationBackground(.clear)
            } else {
                StoryView(authViewModel: authViewModel, storyIds: $selectedStories)
            }
        }
    }
    
    func onTapChipClose() {
        selectedCategory = nil
        
        viewModel.isSearched = false
        viewModel.searchResult = nil
    }
    
    func onSubmitSearch() {
        if !searchText.isEmpty && selectedCategory != nil {
            viewModel.getSearchResult(categoryId: selectedCategory!, keyword: searchText)
        }
    }
}

struct SearchCategoryBlock: View {
    let category: CategoryModel
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(category.image)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(.cheekLineNormal, lineWidth: 1)
                    )
                
                Text(category.name)
                    .label1(font: "SUIT", color: .cheekTextNormal, bold: true)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SearchView(authViewModel: AuthenticationViewModel(), profileViewModel: ProfileViewModel())
}
