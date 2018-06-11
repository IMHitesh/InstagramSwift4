# InstagramSwift4
Instagram login and User Post fetch with pagination, Block base structure, Swift 4 support.

## Steps:

- Setup pod file for pod installation in project using 'pod init' comand to your project directory.
- Add 'Alamofire' library as below.
    pod 'Alamofire', '~> 4.4’
    
- Execute 'pod install' comand for pod installation.
- Drag and drop 'Instagram Helper' folder to your project.
- Create Instagramm app in dashboard and get your CLIENT_ID and REDIRECT_URI from: https://www.instagram.com/developer/
- Replace your clientId and redirectUri into Instagram+constant.swift


## How to use?

**Sign-In:**

@IBAction func loginWithInstagram(_ sender:UIButton){

if (UserDefaults.standard.value(forKey:"instUserID") != nil){
getAllPhotosFromInstagram()
}else{
instagramLogin = InstagramSharedVC.init(clientId: Constants.clientId, redirectUri: Constants.redirectUri) { (token, error) in
UserDefaults.standard.set(token ?? "", forKey: "instUserID")

self.instagramLogin.dismiss(animated: true, completion: {
self.getAllPhotosFromInstagram()
})
}
present(UINavigationController(rootViewController: instagramLogin), animated: true)
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
