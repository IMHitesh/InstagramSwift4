# InstagramSwift4
Instagram login and User Post fetch with pagination, Block base structure, Swift 4 support.

## Steps:

- Install alamofire framwork into your project using https://cocoapods.org/pods/Alamofire reference
- Alamofire is mainly used for instagram API Calling.
- Drag and drop 'Instagram Helper' folder to your project.
- Create Instagramm app in dashboard and get your CLIENT_ID and REDIRECT_URI from: https://www.instagram.com/developer/
- Replace your clientId and redirectUri into Instagram+constant.swift


## How to use?

**Login With Instagram:**

    @IBAction func loginWithInstagram(_ sender:UIButton){        
                instagramLogin = InstagramSharedVC.init(clientId: Constants.clientId, redirectUri: Constants.redirectUri) { (token, error) in
                UserDefaults.standard.set(token ?? "", forKey: "instUserID")                 
            }
            present(UINavigationController(rootViewController: instagramLogin), animated: true)
    }

**Get all user photo from instagram:**
    
    @IBAction func getAllPhotos {
        if (UserDefaults.standard.value(forKey:"instUserID") != nil){
            getAllPhotosFromInstagram()
        }else{
            print("user is not logged in")
        }
    }

    fileprivate func getAllPhotosFromInstagram() {
        InstagramUserProfile.shared.getInstagramPhotoWithUrl(comptionBlock: { (aryAllPhotos, status) in
            if status {
                print(aryAllPhotos)
            }else{
                print("failed to fetch post")
            }
        })
    }


**Pagination:**
    
   
        func getAllPhotosWithPagination {        
            if && InstagramUserProfile.shared.strNextPageURL != ""{
                 if (UserDefaults.standard.value(forKey:"instUserID") != nil){
                getAllPhotosFromInstagram()
            }else{
                print("user is not logged in")
            }
    }



**Note:** For non publish application, It will give a 20 photos. Once app reviewed by instagram developer team it will give a all photos for specific user.

**Reference:**

Alamofire: https://cocoapods.org/pods/Alamofire

Instagram Developer Portal: https://www.instagram.com/developer/

Instagram API for Photos: https://api.instagram.com/v1/users/self/media/recent/?access_token='YOUR_TOKEN'


