//
//  HomeView.swift
//  CHEEK
//
//  Created by 김태은 on 5/29/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @StateObject var viewModel: TopMembersViewModel = TopMembersViewModel()
    
    @Binding var currentMainIndex: Int
    
    var categories: [CategoryModel]
    @Binding var selectedCategory: Int64
    
    @State var banners: [String] = ["ImageBannerSample1"]
    
    @State var currentIndex: Int = 0
    @State var imgIndex: Int = 0
    
    var categoriesColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 21), count: 4)
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { reader in
                VStack(spacing: 0) {
                    // 상단
                    Color.cheekMainNormal
                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
                    
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("회사, 사람 키워드로 검색")
                                .label1(font: "SUIT", color: .cheekTextAssitive, bold: false)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        .background(
                            Capsule()
                                .fill(.cheekLineAlternative)
                        )
                        
                        Image("IconBell")
                            .resizable()
                            .foregroundColor(.cheekTextNormal)
                            .frame(width: 48, height: 48)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                    .background(.cheekMainNormal)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            TabView(selection: $currentIndex) {
                                ForEach(banners.indices, id: \.self) { index in
                                    // AsyncImage(url: URL(string:""))
                                    Image(banners[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .cornerRadius(16)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(maxWidth: .infinity)
                            .frame(height: (UIScreen.main.bounds.width - (16 * 2)) * 0.4432133)
                            .onChange(of: currentIndex) { newIndex in
                                /*
                                if newIndex == 0  {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        currentIndex = banners.count - 1
                                    }
                                }
                                
                                if newIndex == banners.count - 1 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        currentIndex = 0
                                    }
                                }
                                 */
                            }
                            .overlay(
                                BannerList(currentIndex: currentIndex + 1, maxLength: banners.count)
                                    .padding(.trailing, 21)
                                    .padding(.bottom, 16), alignment: .bottomTrailing
                            )
                            .padding(.horizontal, 16)
                            .padding(.top, 24)
                            
                            LazyVGrid(columns: categoriesColumns, spacing: 24) {
                                ForEach(categories) { data in
                                    VStack(spacing: 8) {
                                        Image(data.image)
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .padding(16)
                                            .background(Circle().fill(.cheekLineAlternative))
                                        
                                        Text(data.name)
                                            .label2(font: "SUIT", color: .cheekTextNormal, bold: true)
                                    }
                                    .onTapGesture {
                                        currentMainIndex = 1
                                        selectedCategory = data.id
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 32)
                        }
                        
                        DividerLarge()
                            .padding(.top, 32)
                        
                        HStack {
                            Category(title: "주간 TOP3 인기 유저", description: "주간 가장 많은 좋아요를 받은 유저예요")
                            
                            Spacer()
                        }
                        .padding(.top, 32)
                        .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.topMembers.indices, id: \.self) { index in
                                    RankingCard(myProfileViewModel: profileViewModel, rank: index, data: viewModel.topMembers[index])
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 18)
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.cheekBackgroundTeritory)
        }
        .onAppear {
            viewModel.getTopMembers()
        }
        .background(.cheekBackgroundTeritory)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView(profileViewModel: ProfileViewModel(), currentMainIndex: .constant(0), categories: [
        CategoryModel(id: 0, image: "IconJobDevelop", name: "개발"),
        CategoryModel(id: 1, image: "IconJobManage", name: "기획"),
        CategoryModel(id: 2, image: "IconJobDesign", name: "디자인"),
        CategoryModel(id: 3, image: "IconJobFinance", name: "재무/회계"),
        CategoryModel(id: 4, image: "IconJobSales", name: "영업"),
        CategoryModel(id: 5, image: "IconJobMed", name: "의료"),
        CategoryModel(id: 6, image: "IconJobEdu", name: "교육"),
        CategoryModel(id: 7, image: "IconJobLaw", name: "법"),
    ], selectedCategory: .constant(1))
}
