//

//  RootTabBarController.swift

//  bbm

//

//  Created by songgc on 16/8/5.

//  Copyright © 2016年 sprin. All rights reserved.

//



import UIKit
import Alamofire


class RootTabBarController: UITabBarController,UINavigationControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate ,XxMainDL{
    
    var titles=["首页","会话","襄助榜","我的"]
    var seltabIndex:Int = 0;
    var newmessnum:Int = 0;
    var contentView:UIView!
    var locService:BMKLocationService!
    var _search:BMKGeoCodeSearch!
    var baritem:UITabBarItem! ;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor=UIColor.whiteColor()
        self.navigationItem.title="襄助"
        self.creatSubViewControllers()
        self.tabBar.tintColor=UIColor.redColor()
        
        let navBar=UINavigationBar.appearance()
        navBar.barTintColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        var arrs=[String:AnyObject]();
        arrs[NSForegroundColorAttributeName]=UIColor.whiteColor()
        navBar.titleTextAttributes=arrs
        //self.navigationController?.navigationBar.tintColor=UIColor.redColor()
        if(seltabIndex == 0)
        {
            var img=UIImage(named: "xz_laba_icon")
            let item3=UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: self,  action: "jumpchatlist")
            item3.tintColor=UIColor.whiteColor()
            self.navigationItem.leftBarButtonItem=item3
            
        }else
        {
            var returnimg=UIImage(named: "xz_nav_return_icon")
            let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
            item3.tintColor=UIColor.whiteColor()
            self.navigationItem.leftBarButtonItem=item3
            
        }
        var searchimg=UIImage(named: "xz_nav_icon_search")
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        item4.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem=item4
        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        locService.delegate = self
        //启动LocationService
        locService.startUserLocationService()
        
        _search=BMKGeoCodeSearch()
        _search.delegate=self
        self.view.userInteractionEnabled=true
        self.automaticallyAdjustsScrollViewInsets = false
        openxmpp() //开启xmpp
        
       baritem = self.tabBar.items![1] as UITabBarItem;
       // baritem.badgeValue="1"

    }
    
    
    func openxmpp() {
        zdl().xxmaindl = self
        zdl().connect()
    }
    
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    

    
    
    func newMainMsg(aMsg: WXMessage) {
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var openmessflag:String=""
        if(defaults.boolForKey("openmessflag"))
        {
            openmessflag = defaults.objectForKey("openmessflag") as! String;
        }else
        {
            openmessflag="0"
        }
        //var openmessflag:Bool = defaults.objectForKey("openmessflag") as! Bool;
        // var openvoiceflag:Bool = defaults.objectForKey("openvoiceflag") as! Bool;
        var openvoiceflag:String=""
        if(defaults.boolForKey("openvoiceflag"))
        {
            openvoiceflag = defaults.objectForKey("openvoiceflag") as! String;
        }else
        {
            openvoiceflag="0"
        }
        
        if openmessflag=="1"
        {
            
            newmessnum=newmessnum+1;
            if(newmessnum>0)
            {
                baritem.badgeValue = String(newmessnum)
            }
            if openvoiceflag=="1"
            {
                var o:Notice=Notice();
                o.systemSound()
            }
        }
    }


  
    func searchClick()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }

    func backClick()
    {
        NSLog("back");
        //self.navigationController?.popViewControllerAnimated(true)
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    func jumpchatlist()
    {
        
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("noticeviewcontroller") as! NoticeTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    
    
    // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
    
    override func tabBar(tabBar: UITabBar!, didSelectItem item: UITabBarItem!) {
        //通过tag查询到上方容器的label，并设置为当前选择的标签页的名称
        NSLog("Selected is %d",item.tag);
        self.navigationItem.title=titles[item.tag]
      
        seltabIndex = item.tag
        if(seltabIndex == 0)
        {
            var img=UIImage(named: "xz_laba_icon")
            var item3=UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: self,  action: "jumpchatlist")
            item3.tintColor=UIColor.whiteColor()
            self.navigationItem.leftBarButtonItem=item3
        }else
        {
            var returnimg=UIImage(named: "xz_nav_return_icon")
            let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
            item3.tintColor=UIColor.whiteColor()
            self.navigationItem.leftBarButtonItem=item3
            if(seltabIndex == 1)
            {
                baritem.badgeValue=nil
            }
        }
        
        
    }
    
    
    
    /*
     
     // MARK: - Navigation
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
     // Get the new view controller using segue.destinationViewController.
     
     // Pass the selected object to the new view controller.
     
     }
     
     */
    
    
    
    
    
    func creatSubViewControllers(){
        let sb = UIStoryboard(name:"Main", bundle: nil)
        var TabOne = sb.instantiateViewControllerWithIdentifier("mainController") as! TabOneViewController
        //var TabTwo = sb.instantiateViewControllerWithIdentifier("recentviewcontroller") as! RecentTableViewController
        var TabTwo = sb.instantiateViewControllerWithIdentifier("newrecentviewcontroller") as! RecentViewController
        var TabThree = sb.instantiateViewControllerWithIdentifier("topviewController") as! TopViewController
        //var TabFour = sb.instantiateViewControllerWithIdentifier("myinfo") as! MyInfoViewController
        
        //let TabFour=singleInfoViewController()
       //var TabFour = TabBarViewController()
        
        var TabFour = sb.instantiateViewControllerWithIdentifier("mybaseinfoviewcontroller") as! MybaseInfoViewController

        
        let tabArray = [TabOne,TabTwo,TabThree,TabFour]
        var images_sel = ["xz_fang_icon_sel","xz_huihua_icon_sel","xz_lei_icon_sel","xz_wo_icon_sel"]
        var images = ["xz_fang_icon","xz_hua_icon","xz_lei_icon","xz_wo_icon"]
        for  index in 0...3{
            let item : UITabBarItem = UITabBarItem (title: titles[index], image: UIImage(named: images[index]), selectedImage: UIImage(named: images_sel[index]))
            item.tag=index
            tabArray[index].tabBarItem = item;
        }
        self.viewControllers = tabArray
    }
    
    
    //处理位置坐标更新
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        
        if(userLocation.location != nil)
            
        {
            
            print("经度: \(userLocation.location.coordinate.latitude)")
            
            print("纬度: \(userLocation.location.coordinate.longitude)")
            
            
            
            var defaults = NSUserDefaults.standardUserDefaults();
            
            defaults.setObject(String(userLocation.location.coordinate.latitude), forKey: "lat");
            
            defaults.setObject(String(userLocation.location.coordinate.longitude), forKey: "lng");
            
            defaults.synchronize();
            
            
            
            
            
            let pt:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
            
            
            
            var option:BMKReverseGeoCodeOption=BMKReverseGeoCodeOption();
            
            option.reverseGeoPoint=pt;
            
            _search.reverseGeoCode(option)
            
            locService.stopUserLocationService()
            
            let _userid = defaults.objectForKey("userid") as! NSString;
            
            if(defaults.objectForKey("token") != nil)
                
            {
                
                let _token = defaults.objectForKey("token") as! NSString;
                
                
                
                Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatechannelid.php", parameters:["_userId" : _userid,"_channelId":_token])
                    
                    .responseJSON { response in
                        
                        print(response.request)  // original URL request
                        
                        print(response.response) // URL response
                        
                        print(response.data)     // server data
                        
                        print(response.result)   // result of response serialization
                        
                        print(response.result.value)
                        
                }
                
                
                
                Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatelocation.php", parameters:["_userId" : _userid,"_lat":String(userLocation.location.coordinate.latitude),"_lng":String(userLocation.location.coordinate.longitude),"_os":"ios"])
                    
                    .responseJSON { response in
                        
                        print(response.request)  // original URL request
                        
                        print(response.response) // URL response
                        
                        print(response.data)     // server data
                        
                        print(response.result)   // result of response serialization
                        
                        print(response.result.value)
                        
                        
                        
                }
                
            }
            
        }else{
            
            NSLog("userLocation.location is nil")
            
        }
        
    }
    
    
    
    
    
    func onGetReverseGeoCodeResult(searcher:BMKGeoCodeSearch, result:BMKReverseGeoCodeResult,  errorCode:BMKSearchErrorCode)
        
    {
        
        if(errorCode.rawValue==0)
            
        {
            
            
            
            print("province: \(result.addressDetail.province)")
            
            print("city: \(result.addressDetail.city)")
            
            print("district: \(result.addressDetail.district)")
            
            print("streetName: \(result.addressDetail.streetName)")
            
            print("streetNumber: \(result.addressDetail.streetNumber)")
            
            
            
            
            
            
            
            print("address: \(result.address)")
            
            let defaults = NSUserDefaults.standardUserDefaults();
            
            defaults.setObject(result.addressDetail.province, forKey: "province");//省直辖市
            
            defaults.setObject(result.addressDetail.city , forKey: "city");//城市
            
            defaults.setObject(result.addressDetail.district , forKey: "sublocality");//区县
            
            defaults.setObject(result.addressDetail.streetName, forKey: "thoroughfare");//街道
            
            defaults.setObject(result.address  , forKey: "address");
            
            defaults.synchronize();
            
            
            
        }else
            
        {
            
            let defaults = NSUserDefaults.standardUserDefaults();
            
            let a:String = "";
            
            defaults.setObject("", forKey: "province");//省直辖市
            
            defaults.setObject(a, forKey: "city");//城市
            
            defaults.setObject(a, forKey: "sublocality");//区县
            
            defaults.setObject(a, forKey: "thoroughfare");//街道
            
            defaults.setObject(a, forKey: "address");
            
            defaults.synchronize();
            
            
            
        }
        
    }
    
    
}

