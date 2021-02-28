//
//  ContentView.swift
//  Kakao_Login
//
//  Created by Emily Nan on 2021/01/21.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct ContentView: View {
    
    @State var kakao_accessToken: String = "accessToken"
    @State var kakao_email: String = "email"
    @State var kakao_img: UIImage = UIImage(systemName: "person")!
    @State var kakao_nickName: String = "nickName"
    @State var kakao_age_range: String = "age_range"
    @State var kakao_gender: String = "gender"
    
    
    var body: some View {
        VStack{
            Button(action:{self.login_Web()}){
                Text("KaKao Login")
            }
            Button(action:{
                //self.logout()
                self.unlink()
            }){
                Text("KaKao Logout")
            }
            //Text(accessToken)
            Text(kakao_email)
            Image(uiImage: kakao_img)
                .resizable()
                .frame(width:100,height: 100)
            Text(kakao_nickName)
            Text(kakao_age_range)
            Text(kakao_gender)
        }
    }
    
    func login_KaKaoTalk(){
        
        if (AuthApi.isKakaoTalkLoginAvailable()) {  // 카카오톡 설치 여부 확인
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    //로그인 취소 등
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    self.kakao_accessToken = oauthToken!.accessToken
                }
            }
        }
    }
    
    func login_Web(){
        AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {  //로그인 성공
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
                self.kakao_accessToken = oauthToken!.accessToken
                
                
                self.set_User()
            }
        }
        
    }
    
    func set_User(){
        //사용자 관리 api 호출
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                self.kakao_email = (user?.kakaoAccount?.email)!
                self.kakao_nickName = (user?.kakaoAccount?.profile!.nickname)!
                self.kakao_age_range = (user?.kakaoAccount?.ageRange)!.rawValue
                self.kakao_gender = (user?.kakaoAccount?.gender)!.rawValue
                if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                   let data = try? Data(contentsOf: url) {
                    self.kakao_img = UIImage(data: data)!
                    
                }
                else{
                    print("No imgURL")
                }
            }
        }
    }
    
    func logout(){
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
    
    func unlink(){
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                initialize()
                print("unlink() success.")
            }
        }
    }
    
    func initialize(){
        self.kakao_accessToken="accessToken"
        self.kakao_email = "email"
        self.kakao_nickName="nickName"
        self.kakao_img=UIImage(systemName: "person")!
        self.kakao_age_range = "age_range"
        self.kakao_gender = "gedner"
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
