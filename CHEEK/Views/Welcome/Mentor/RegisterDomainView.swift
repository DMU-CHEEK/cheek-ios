//
//  SetProfileMentorView.swift
//  CHEEK
//
//  Created by 김태은 on 6/5/24.
//

import SwiftUI

struct RegisterDomainView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var socialProvider: String
    @State private var isMentor: Bool = false
    
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    
    @StateObject private var viewModel = VerifyEmailMentorViewModel()
    @State private var isEmailValidated: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var isSent: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var time = 3
    @State private var timeRunning: Bool = false
    
    @State private var isDone: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image("IconArrowLeft")
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                        Spacer()
                    }
                    .padding(.bottom, 24)
                    
                    Text("사내 이메일 도메인 등록을\n신청해주세요.")
                        .headline1(font: "SUIT", color: .cheekTextStrong, bold: true)
                        .padding(.bottom, 4)
                    
                    Text("인증을 위한 용도로만 사용되며,\n관리자 확인 후 멘토 회원으로 전환됩니다.")
                        .caption1(font: "SUIT", color: .cheekTextAlternative, bold: true)
                        .padding(.bottom, 48)
                    
                    
                    Text("이메일")
                        .caption1(font: "SUIT", color: .cheekTextStrong, bold: true)
                        .padding(.bottom, 4)
                    
                    // 이메일 입력칸
                    TextField(
                        "",
                        text: $email,
                        prompt:
                            Text(verbatim: "예 > cheek@cheek.com")
                            .foregroundColor(.cheekTextAlternative)
                    )
                    .keyboardType(.emailAddress)
                    .disabled(isLoading)
                    .caption1(font: "SUIT", color: .cheekTextStrong, bold: true)
                    .foregroundColor(.cheekTextStrong)
                    .frame(height: 32)
                    .padding(.leading, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.cheekTextStrong, lineWidth: 1)
                    )
                    .padding(.bottom, 12)
                    .onChange(of: email) { _ in
                        isEmailValidated = viewModel.validateEmail(email: email)
                    }
                    
                    // 인증번호 받기
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(isEmailValidated ? .cheekTextStrong : .cheekTextAssitive, lineWidth: 1)
                        .foregroundColor(.cheekBackgroundTeritory)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .overlay(
                            Text("등록 신청하기")
                                .caption1(font: "SUIT", color: isEmailValidated ? .cheekTextStrong : .cheekTextAssitive, bold: true)
                        )
                        .padding(.bottom, 24)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                            
                            if !isLoading {
                                isLoading = true
                                if viewModel.validateEmail(email: email) {
                                    viewModel.registerDomain(email: email) { response in
                                        if response != nil && response == "ok" {
                                            isLoading = false
                                            
                                            isSent = true
                                            timeRunning = true
                                            
                                        } else {
                                            alertMessage = "오류가 발생하였습니다.\n다시 시도해주세요."
                                            showAlert = true
                                            isLoading = false
                                        }
                                        
                                    }
                                } else {
                                    alertMessage = "이메일을 다시 확인해주세요."
                                    showAlert = true
                                    isLoading = false
                                }
                            }
                        }
                    
                    Spacer()
                }
                .padding(.top, 48)
                .padding(.bottom, 40)
                .padding(.horizontal, 23)
                .background(.cheekBackgroundTeritory)
                
                if isSent {
                    ZStack {
                        VStack(spacing: 0) {
                            Text("멘토 신청이 완료되었습니다.")
                                .headline1(font: "SUIT", color: .cheekTextStrong, bold: true)
                                .padding(.bottom, 8)
                            
                            Text("관리자가 확인 후 유효한 이메일 도메인일 시\n멘토 회원으로 전환되며, 알림을 보내드려요.")
                                .caption1(font: "SUIT", color: .cheekTextAlternative, bold: true)
                        }
                        
                        VStack {
                            Spacer()
                            
                            Text("\(time)초 후에 프로필 설정 창으로 전환됩니다.")
                                .caption1(font: "SUIT", color: .cheekTextAlternative, bold: true)
                                .padding(.bottom, 32)
                        }
                        .onReceive(timer) { _ in
                            if timeRunning {
                                if time > 0 {
                                    time -= 1
                                }
                            } else {
                                isDone = true
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.cheekBackgroundTeritory)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $isDone, destination: {
            SetProfileView(socialProvider: $socialProvider, isMentor: $isMentor)
        })
        .alert(isPresented: $showAlert) {
                Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }
    
    // 키보드 숨기기
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    RegisterDomainView(socialProvider: .constant("Kakao"))
}
