//
//  InstagramUserProfile.swift
//  Capchur
//
//  Created by Hitesh Surani on 04/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import UIKit
import Alamofire

struct FbPhoto {
    var id:String!
    var name:String?
    var urlSource:String?
}

typealias InstaCompletionHandler = (( _ aryAllAlbumList:[FbPhoto]?, _ status:Bool)->())?


class InstagramUserProfile: NSObject {
    static let shared = InstagramUserProfile()
    

    var aryAllData = [FbPhoto]()
    var strNextPageURL = ""
    var isAPICallInProgress = false
    var isLoadedAllPhotos = false
    
    private enum API {
        static let authURL = "https://api.instagram.com/oauth/authorize"
        static let baseURL = "https://api.instagram.com/v1"
    }
    
    
    func getInstagramPhotoWithUrl(comptionBlock:InstaCompletionHandler){
        
        if isAPICallInProgress{
            return
        }
        
        if isLoadedAllPhotos{
            comptionBlock!(aryAllData,true)
            return
        }
        
        var finalAPICallUrl = strNextPageURL
        
        if strNextPageURL == ""{
            let token = UserDefaults.standard.value(forKey:"instUserID")!
            finalAPICallUrl = API.baseURL + "/users/self/media/recent?access_token=\(token)&count=10"
//            finalAPICallUrl = API.baseURL + "/users/self/media/recent?access_token=\(token)"
        }
        getInstagramPhoto(url: finalAPICallUrl, comptionBlock:comptionBlock)
    }

    
//    MARK: - API calling with JSON data response
    func getInstagramPhoto(url:String,comptionBlock:InstaCompletionHandler) {

        isAPICallInProgress = true
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate().responseJSON { (response) in

            self.isAPICallInProgress = false
            
            switch response.result {
            case .success:
                let dictResponse = response.result.value as? NSDictionary

                if ((dictResponse?.value(forKey:"meta") as? NSDictionary)?.value(forKey:"code") as? Int ?? 404)! == 200{
                    
                    let aryAllReocrd = dictResponse?.value(forKey:"data") as? [NSDictionary]
                    
                    if let strNext = ((dictResponse?.value(forKey: "pagination") as? NSDictionary)?.value(forKey:"next_url") as? String){
                        self.isLoadedAllPhotos = false
                        self.strNextPageURL = strNext

                    }else{
                        self.isLoadedAllPhotos = true
                        self.strNextPageURL = ""
                    }
                    
                    for dictRecord in aryAllReocrd ?? [NSDictionary](){
                        print(dictRecord)
                        
                        
                        let idPhoto = dictRecord.value(forKey: "id") as? String ?? "0"
                        
                        let name = dictRecord["caption"] as? String
                        
                        let ImageUrl = ((dictRecord.value(forKey: "images") as? NSDictionary)?.value(forKey: "standard_resolution") as? NSDictionary)?.value(forKey: "url") as? String ?? ""
                        
                        self.aryAllData.append(FbPhoto(id: idPhoto, name: name, urlSource: ImageUrl))
                    }
                    comptionBlock!(self.aryAllData,true)
                }else{
                    comptionBlock!([FbPhoto](),true)
                }
                
                
            case .failure(let error):
                print(error)
                    comptionBlock!([FbPhoto](),false)
            }
        }
    }
    
}
