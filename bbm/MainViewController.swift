//
//  MainViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
import AudioToolbox

class MainViewController: UIViewController,UIScrollViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,XxMainDL{

    var items:[itemDaymic]=[]
    var ggid:String = "";
    
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    
    @IBOutlet weak var ggview: UIView!
    

  
    var locService:BMKLocationService!
     var _search:BMKGeoCodeSearch!
    var marquee: CHWMarqueeView?
    var timer:NSTimer!
    var imageView:BadgeView!;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title="小区"
        
       
         self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Done, target: self, action: "SetClick")
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = -10;
        
        
        
        
        
        imageView = BadgeView()
        imageView.frame = CGRectMake(0, 0, 35, 25)
        
        imageView.backgroundColor=UIColor.redColor()
        imageView.value=0;
        if(imageView.value>0)
        {
            imageView.hidden=false
        }else
        {
            imageView.hidden=true
        }
        //imageView.addTarget(self, action: "jumpchatlist", forControlEvents: .TouchUpInside)
       //imageView.add
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"jumpchatlist")
        tapGestureRecognizer.cancelsTouchesInView = false
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let rightBarBtn = UIBarButtonItem(customView: imageView)
        
        self.navigationItem.rightBarButtonItems = [spacer,rightBarBtn]
        
        //self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Done, target: self, action: "SetClick")
        //self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Done, target: self, action: "exitClick")
        
       // self.navigationItem.
        
       self.view.userInteractionEnabled=true
        pictureGallery();
        
        showgg()
      
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
        

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
        
        openxmpp() //开启xmpp
        
        loaduser()
       
     }
    
    func loaduser() {
        let defaults = NSUserDefaults.standardUserDefaults();
         let _userid = defaults.objectForKey("userid") as! NSString;
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/login.php", parameters:["_userid" : _userid])
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let JSON = response.result.value {
                        print("JSON1: \(JSON.count)")
                        if(JSON.count>0)
                        {
                            
                                let isrecvmess:String = JSON.objectForKey("isrecvmess") as! String;
                                let isopenvoice:String = JSON.objectForKey("isopenvoice") as! String;
                            
                                
                                defaults.setObject(isrecvmess, forKey: "openmessflag");
                                defaults.setObject(isopenvoice, forKey: "openvoiceflag");
                                defaults.synchronize();
                                
                            
                        }else
                        {
                            defaults.setObject("1", forKey: "openmessflag");
                            defaults.setObject("1", forKey: "openvoiceflag");
                            defaults.synchronize();
                        }
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
    
     func openxmpp() {
        zdl().xxmaindl = self
        zdl().connect()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        print("-2");
        locService.stopUserLocationService()
        _search.delegate=nil
        locService.delegate=self
    }

    
   override  func viewDidDisappear(animated: Bool)
   {
        print("-1");
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
            //对方正在输入
            if aMsg.isComposing {
                self.navigationItem.title = "对方正在输入。。。"
            }else if (aMsg.body != "") {
                
                imageView.value=imageView.value+1
                if(imageView.value>0)
                {
                    imageView.hidden=false
                }else
                {
                    imageView.hidden=true
                }
                if openvoiceflag=="1"
                {
                    
                    var o:Notice=Notice();
                    o.systemSound()
                    
                }
            }
            }
    }

       
    @IBAction func gonggaobtn(sender: UIButton) {
        
        var urlstr:String="http://api.bbxiaoqu.com/wap/gonggao.php?id=".stringByAppendingString(ggid)
        var url=NSURL(string: urlstr)
        UIApplication.sharedApplication().openURL(url!)
    }
    @IBAction func cansos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("tabone") as! OneViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func sos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=0;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    @IBAction func top(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("topviewController") as! TopViewController
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    //处理方向变更信息
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        if(userLocation.location != nil)
        {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.setObject(String(userLocation.location.coordinate.longitude), forKey: "lng");
            defaults.synchronize();
            
            
            locService.stopUserLocationService()
        }else{
            NSLog("userLocation.location is nil")
        }
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
            
//            defaults.setNilValueForKey("province");//省直辖市
//            defaults.setNilValueForKey("city");//城市
//            defaults.setNilValueForKey("sublocality");//区县
//            defaults.setNilValueForKey("thoroughfare");//街道
//            defaults.setNilValueForKey("address");


            defaults.synchronize();
            
            
            let pt:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
            
            var option:BMKReverseGeoCodeOption=BMKReverseGeoCodeOption();
            option.reverseGeoPoint=pt;
            _search.reverseGeoCode(option)
            
            let _userid = defaults.objectForKey("userid") as! NSString;
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
    

    override func viewWillAppear(animated: Bool) {
            locService.delegate = self
    }
    
   
   
    
    
  
  
    
    func showpage()
    {
        print("showggpage")
        var urlstr:String="http://api.bbxiaoqu.com/wap/gonggao.php?id=".stringByAppendingString(ggid)
        var url=NSURL(string: urlstr)
        UIApplication.sharedApplication().openURL(url!)

    }
    
    func showgg()
    {
        var url:String="http://api.bbxiaoqu.com/gonggao.php"
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if response.result.isSuccess
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            //print("data: \(data)")
                              let id:String = data.objectForKey("id") as! String;
                            let title:String = data.objectForKey("title") as! String;
                           
                            self.ggid=id;
                            self.marquee = CHWMarqueeView(frame: CGRectMake(45, 250, self.view.bounds.size.width-45, 45), title: title)
                            self.marquee!.userInteractionEnabled = true
                            self.marquee!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("showpage")))
                            //fffbca
                            //self.marquee?.backgroundColor=UIColor(red: 0x100/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
                            
                            self.marquee?.backgroundColor=UIColor(red: 255/255, green: 251/255, blue: 202/255, alpha: 1)


                            self.view.addSubview(self.marquee!)
                        }
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
    func jumpchatlist()
    {
        imageView.value=0;
        imageView.hidden=true;
        
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("recentviewcontroller") as! RecentTableViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func SetClick()
    {
        NSLog("SetClick")
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("tabfour") as! FourViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func exitClick()
    {
        NSLog("exitClick")
        //exit(0)
        var alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定要退出吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
        
       
    }
    
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            
        }
        else
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
            //创建导航控制器
            let nvc=UINavigationController(rootViewController:vc);
            //设置根视图
            self.view.window!.rootViewController=nvc;

        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var pics:[String]=["banner1","banner2","banner3","banner4"]
    func pictureGallery(){   //实现图片滚动播放；
        //image width
        let imageW:CGFloat = self.galleryScrollView.frame.size.width;//获取ScrollView的宽作为图片的宽；
        let imageH:CGFloat = self.galleryScrollView.frame.size.height;//获取ScrollView的高作为图片的高；
        var imageY:CGFloat = 0;//图片的Y坐标就在ScrollView的顶端；
        var totalCount:NSInteger = 4//轮播的图片数量；
        for index in 0..<totalCount{
            var imageView:UIImageView = UIImageView();
            let imageX:CGFloat = CGFloat(index) * imageW;
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);//设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但

            imageView.image = UIImage(named:  self.pics[index]);
            
            self.galleryScrollView.showsHorizontalScrollIndicator = false;//不设置水平滚动条；
            self.galleryScrollView.addSubview(imageView);//把图片加入到ScrollView中去，实现轮播的效果；
        }
        
        //需要非常注意的是：ScrollView控件一定要设置contentSize;包括长和宽；
        let contentW:CGFloat = imageW * CGFloat(totalCount);//这里的宽度就是所有的图片宽度之和；
        self.galleryScrollView.contentSize = CGSizeMake(contentW, 0);
        self.galleryScrollView.pagingEnabled = true;
        self.galleryScrollView.delegate = self;
        self.galleryPageControl.numberOfPages = totalCount;//下面的页码提示器；
        self.addTimer()
        
    }
    
    func nextImage(sender:AnyObject!){//图片轮播；
        var page:Int = self.galleryPageControl.currentPage;
        if(page == 3){   //循环；
            page = 0;
        }else{
            page++;
        }
        let x:CGFloat = CGFloat(page) * self.galleryScrollView.frame.size.width;
        self.galleryScrollView.contentOffset = CGPointMake(x, 0);//注意：contentOffset就是设置ScrollView的偏移；
    }


    func scrollViewDidScroll(scrollView: UIScrollView) {
        //这里的代码是在ScrollView滚动后执行的操作，并不是执行ScrollView的代码；
        //这里只是为了设置下面的页码提示器；该操作是在图片滚动之后操作的；
        let scrollviewW:CGFloat = galleryScrollView.frame.size.width;
        let x:CGFloat = galleryScrollView.contentOffset.x;
        let page:Int = (Int)((x + scrollviewW / 2) / scrollviewW);
        self.galleryPageControl.currentPage = page;
        
    }

    func addTimer(){   //图片轮播的定时器；
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextImage:", userInfo: nil, repeats: true);
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
