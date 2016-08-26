//
//  OneViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class OneViewController: UIViewController,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,ApnsDelegate ,UINavigationControllerDelegate{

    var start:Int = 0
    var limit:Int = 10
   
    var items:[itemMess]=[]
    var fwitems:[itemfwMess]=[]
     @IBOutlet weak var _tableView: UITableView!
    func NewMessage(string:String){
        if(selectedSegmentval==0)
        {
            
            querydata(0)
        }else if(selectedSegmentval==1)
        {
            
            querydata(1)
        }else if(selectedSegmentval==2)
        {
            
            querydata(2)
        }
        

    }
    
    //添加Tab Bar控件
    var tabBar:UITabBar!
    //Tab Bar Item的名称数组
    var tabs = ["待解决","全部","我的"]
    //Tab Bar上方的容器
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="我能帮"
        let item1 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: #selector(OneViewController.backClick))
        item1.tintColor=UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem=item1
        
        var item2 = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Done, target: self, action: #selector(OneViewController.addClick))
        item2.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem=item2

        _tableView!.delegate=self
        _tableView!.dataSource=self
  
        self._tableView.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")
        self._tableView.headerView?.beginRefreshing()
        self._tableView.headerView?.endRefreshing()
        self._tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
        _tableView.frame=CGRectMake(0,44,self.view.frame.size.width,self.view.frame.size.height)
        addtabbar()
        var w:CGFloat = UIScreen.mainScreen().bounds.width
        var posx=w/CGFloat(3);
        addline(posx);
        addline(posx*2);
        tabBar.selectedItem=tabBar.items![0] as! UITabBarItem
        selectedSegmentval=0
        querydata(0)

    }
    
    
    
    

    func addtabbar()
    {
        //在底部创建Tab Bar
        tabBar = UITabBar(frame:
            CGRectMake(0,60,CGRectGetWidth(self.view.bounds),30))
        var tabItem1 = UITabBarItem(title: tabs[0], image: nil, tag: 0)
        var tabItem2 = UITabBarItem(title: tabs[1], image: nil, tag: 1)
        var tabItem3 = UITabBarItem(title: tabs[2], image: nil, tag: 2)
        var attributes =  [NSForegroundColorAttributeName: UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),
                           NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        var selattributes =  [NSForegroundColorAttributeName: UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        
        tabItem1.setTitleTextAttributes(attributes , forState: UIControlState.Selected)
        tabItem1.setTitleTextAttributes(attributes , forState: UIControlState.Normal)
        tabItem1.setTitleTextAttributes(selattributes , forState: UIControlState.Highlighted)
        
        tabItem2.setTitleTextAttributes(attributes , forState: UIControlState.Selected)
        tabItem2.setTitleTextAttributes(attributes , forState: UIControlState.Normal)
        tabItem2.setTitleTextAttributes(selattributes , forState: UIControlState.Highlighted)
        
        tabItem3.setTitleTextAttributes(attributes , forState: UIControlState.Selected)
        tabItem3.setTitleTextAttributes(attributes , forState: UIControlState.Normal)
        tabItem3.setTitleTextAttributes(selattributes , forState: UIControlState.Highlighted)
        var items:[UITabBarItem] = [tabItem1,tabItem2,tabItem3]
        tabBar.tintColor=UIColor.redColor()
        
        let image = UIImage(named: "xz_you_icon")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 40), resizingMode: UIImageResizingMode.Stretch)
         tabBar.selectionIndicatorImage=image
         let meiimage1 = UIImage(named: "xz_mei_icon")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 40), resizingMode: UIImageResizingMode.Stretch)
        
        tabBar.backgroundImage=meiimage1
        //设置Tab Bar的标签页
        tabBar.setItems(items, animated: true)
        //本类实现UITabBarDelegate代理，切换标签页时能响应事件
        tabBar.delegate = self
        //代码添加到界面上来
        
        
        
        self.view.addSubview(tabBar);
    }
    
    func addline(posx:CGFloat)
    {
        
        var posy=CGFloat(tabBar.frame.origin.y+15);
        let customView = UIView(frame: CGRect(x: posx, y: posy, width:1, height: tabBar.frame.size.height))
        let imageView=UIImageView(image:UIImage(named:"xz_xi_icon"))
        imageView.frame=CGRectMake(0,0,1,30)
        customView.addSubview(imageView)
        self.view.addSubview(customView)
    }
    
    // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //通过tag查询到上方容器的label，并设置为当前选择的标签页的名称
        //print( item.title);
        self.items.removeAll()
        self.fwitems.removeAll()
        if(item.title=="待解决")
        {
            selectedSegmentval=0
            self.items.removeAll()
            querydata(0)
        }else if(item.title=="全部")
        {
            selectedSegmentval=1
             self.items.removeAll()
            querydata(1)
        }else if(item.title=="我的")
        {
            selectedSegmentval=2
            self.items.removeAll()
            querydata(2)
        }
        self._tableView.reloadData()
        
    }
    var selectedSegmentval:Int=0;

//    @IBOutlet weak var segment1: UISegmentedControl!
//    @IBAction func segmentValueChange(sender: AnyObject) {
//        NSLog("you Selected Index\(segment1.selectedSegmentIndex)")
//        self.selectedSegmentval=segment1.selectedSegmentIndex;
//        
//        self.items.removeAll()
//        self.fwitems.removeAll()
//        
//       
//        if(self.selectedSegmentval==0)
//        {
//            self.items.removeAll()
//            querydata(0)
//        }else if(self.selectedSegmentval==1)
//        {
//            self.items.removeAll()
//            querydata(1)
//        }else if(self.selectedSegmentval==2)
//        {
//            self.items.removeAll()
//            querydata(2)
//        }
//         self._tableView.reloadData()
//    }
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func addClick()
    {
        NSLog("addClick");
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK: 加载数据
    func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            self.start=0;
            if(self.selectedSegmentval==0)
            {
                self.querydata(0)
            }else if(self.selectedSegmentval==1)
            {
                self.querydata(1)
            }else if(self.selectedSegmentval==2)
            {
                self.querydata(2)
            }
            self._tableView.reloadData()
            self._tableView.headerView?.endRefreshing()
        }
    }
    
    func downPlullLoadData(){
        
        xwDelay(1) { () -> Void in
            self.start=self.limit;
            if(self.selectedSegmentval==0)
            {
                
                self.querydata(0)
            }else if(self.selectedSegmentval==1)
            {
                
                self.querydata(1)
            }else if(self.selectedSegmentval==2)
            {
                
                self.querydata(2)
            }
            self._tableView.reloadData()
            self._tableView.footerView?.endRefreshing()
        }
        
    }

    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            NSLog("indexPath is = %i",self.selectedSegmentval);

            
            if(self.selectedSegmentval==3)
            {
                return self.fwitems.count;
            }else
            {
                return self.items.count;
            }
        }
    
            func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
                //var ppp:String = (items[indexPath.row] as itemMess).photo;
            
                    let cellId="mycell1"
                    var cell:InfopicTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! InfopicTableViewCell?
                    if(cell == nil)
                    {
                        cell = InfopicTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
                    }
                    
                    cell?.senduser.text=(items[indexPath.row] as itemMess).username
                    var mess=(items[indexPath.row] as itemMess).content
                    var messcontent:String;
                    if mess.characters.count>80
                    {
                        messcontent=(mess as NSString).substringToIndex(80).stringByAppendingString("...")
                    }else
                    {
                        messcontent=mess;
                    }
                    cell?.message.text=messcontent
                    
                    cell?.sendtime.text=(items[indexPath.row] as itemMess).time
                    cell?.sendaddress.text=(items[indexPath.row] as itemMess).address
            
//                    if ((items[indexPath.row] as itemMess).status == "0")
//                    {
//                        cell?.status.text="求助中"
//                        cell?.status.textColor = UIColor.redColor()
//                        
//                    }else if ((items[indexPath.row] as itemMess).status == "1")
//                    {
//                        cell?.status.text="解决中"
//                        cell?.status.textColor = UIColor.redColor()
//                        
//                    }else if ((items[indexPath.row] as itemMess).status == "2")
//                    {
//                        cell?.status.text="已解决"
//                        cell?.status.textColor = UIColor.greenColor()
//                        
//                    }

                    cell?.gz.text="关:"+(items[indexPath.row] as itemMess).visnum;
                    cell?.pl.text="评:"+(items[indexPath.row] as itemMess).plnum;
                    return cell!
                
            
        }
    
//    var seltel:String = "";
//    func teltapped(button:UIButton){
//        //print(button.titleForState(.Normal))
//        var pos:Int = button.tag
//        seltel = (fwitems[pos] as itemfwMess).telphone;
//        
//        var alertView = UIAlertView()
//        alertView.title = "系统提示"
//        alertView.message = "您确定要呼叫吗？"
//        alertView.addButtonWithTitle("取消")
//        alertView.addButtonWithTitle("确定")
//        alertView.cancelButtonIndex=0
//        alertView.delegate=self;
//        alertView.show()
//
//    }
//    func zantapped(button:UIButton){
//        //判断
//        var pos:Int = button.tag
//        NSLog("indexPath is = %i",pos);
//        var zan:String = (fwitems[pos] as itemfwMess).zannum;
//        let defaults = NSUserDefaults.standardUserDefaults();
//        
//
//        var sqlitehelpInstance1=sqlitehelp.shareInstance()
//        var userid = defaults.objectForKey("userid") as! String;
//        var guid:String=(fwitems[pos] as itemfwMess).guid;
//        
//        var v:Bool=sqlitehelpInstance1.isexitzan(guid, userid: userid);
//        if(v)
//        {
//            var zann:Int = Int(zan)!
//            button.setTitle(String(zann-1), forState: UIControlState.Normal)
//            sqlitehelpInstance1.removezan(guid, userid: userid)
//            button.setBackgroundImage(UIImage(named: "tab_sub_sos"), forState: UIControlState.Normal)
//        }else
//        {
//            var zann:Int = Int(zan)!
//            button.setTitle(String(zann+1), forState: UIControlState.Normal)
//            
//            sqlitehelpInstance1.addzan(guid, userid: userid)
//            button.setBackgroundImage(UIImage(named: "tab_sub_sos_sel"), forState: UIControlState.Normal)
//        }
//        
//    }

    
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
//        if(buttonIndex==alertView.cancelButtonIndex){
//            
//        }
//        else
//        {
//            var url1 = NSURL(string: "tel://"+seltel)
//            UIApplication.sharedApplication().openURL(url1!)
//        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        
            
            
            let aa:itemMess=items[indexPath.row] as itemMess;
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
            //创建导航控制器
            //vc.message = aa.content;
            vc.guid=aa.guid
            vc.infoid=aa.guid
            //设置根视图
            self.navigationController?.pushViewController(vc, animated: true)

        
        

    }
    
    
    func querydata(Category:Int)
    {
        var url:String="";
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        //let lat = defaults.objectForKey("lat") as! String;
        //let lng = defaults.objectForKey("lng") as! String;
        let lat = String(39.974385);
        let lng = String(116.34777)
        if(Category==0)
        {
            url="http://api.bbxiaoqu.com/getinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&latitude=").stringByAppendingString(lat).stringByAppendingString("&longitude=").stringByAppendingString(lng).stringByAppendingString("&rang=xiaoqu&status=0&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        
        }else if(Category==1)
        {
            url="http://api.bbxiaoqu.com/getinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&latitude=").stringByAppendingString(lat).stringByAppendingString("&longitude=").stringByAppendingString(lng).stringByAppendingString("&rang=xiaoqu&status=1&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        }else if(Category==2)
        {
            url="http://api.bbxiaoqu.com/getinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&latitude=").stringByAppendingString(lat).stringByAppendingString("&longitude=").stringByAppendingString(lng).stringByAppendingString("&rang=self&status=1&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        }
            print("url: \(url)")
            Alamofire.request(.GET, url, parameters: nil)
                .responseJSON { response in
                    if(response.result.isSuccess)
                    {
                        
                        
                        if let jsonItem = response.result.value as? NSArray{
                            for data in jsonItem{
                                //print("data: \(data)")
                            
                            let content:String = data.objectForKey("content") as! String;
                            let senduserid:String = data.objectForKey("senduser") as! String;
                            
                            var sendnickname:String = "";
                            if(data.objectForKey("username")!.isKindOfClass(NSNull))
                            {
                                sendnickname="";
                            }else
                            {
                                sendnickname   = data.objectForKey("username") as! String;
                                
                            }
                            let guid:String = data.objectForKey("guid") as! String;
                            let sendtime:String;
                            var temptime:String=data.objectForKey("sendtime") as! String;
                                
                                
                                
                                //temptime	String	"2016-04-06 13:40:11"
                                
                                var date:NSDate = NSDate()
                                var formatter:NSDateFormatter = NSDateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                var dateString = formatter.stringFromDate(date)
                                
                              if(temptime.containsString(dateString))
                              {
                                sendtime = temptime.subStringFrom(11)
                                
                              }else
                              {
                                
                                sendtime = (temptime as NSString).substringWithRange(NSRange(location: 0,length: 10))
                              }
                                
                                
                                
                            //let address:String = data.objectForKey("address") as! String;
                                
                            let lng:String = data.objectForKey("lng") as! String;
                            let lat:String = data.objectForKey("lat") as! String;
                                
                                
                            var lat_1=(lat as NSString).doubleValue;
                            var lng_1=(lng as NSString).doubleValue;
                                
                            let defaults = NSUserDefaults.standardUserDefaults();
                            let userid = defaults.objectForKey("userid") as! String;
                            let mylat = defaults.objectForKey("lat") as! String;
                            let mylng = defaults.objectForKey("lng") as! String;
                                
                                
                            var lat_2=(mylat as NSString).doubleValue;
                            var lng_2=(mylng as NSString).doubleValue;
                            var address:String="";
     
                                if(false)
                                {
                                    var currentLocation:CLLocation = CLLocation(latitude:lat_1,longitude:lng_1);
                                    var targetLocation:CLLocation = CLLocation(latitude:lat_2,longitude:lng_2);
                                        
                                        
                                    var distance:CLLocationDistance=currentLocation.distanceFromLocation(targetLocation);
                                     address = ("\(distance)米");
                                }else
                                {
                                    var p1:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_1, longitude: lng_1))
                                    var p2:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2))
                                    //var a2:BMKMapPoint = CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2)
                                    
                                     var distance:CLLocationDistance = BMKMetersBetweenMapPoints(p1, p2);
                                    
                                    
                                    var one:UInt32 = UInt32(distance)
                                      address = ("\(one)米");
                                }
                                
                                
                                
                             let city:String = data.objectForKey("city") as! String;
                                let street:String = data.objectForKey("street") as! String;
                            let photo:String = data.objectForKey("photo") as! String;
                            var community:String = ""
                             if(data.objectForKey("community")!.isKindOfClass(NSNull))
                            {
                                community = "";
                            }else
                            {
                                community = data.objectForKey("community") as! String;
                                
                            }
                             let infocatagroy:String = data.objectForKey("infocatagroy") as! String;
                            let status:String = data.objectForKey("status") as! String;
                            let visit:String = data.objectForKey("visit") as! String;
                            let plnum:String = data.objectForKey("plnum") as! String;
                                 let headface:String = data.objectForKey("headface") as! String;
                                let sex:String = data.objectForKey("sex") as! String;

                                let item_obj:itemMess = itemMess(userid: senduserid, headface:headface,sex:sex,vname: sendnickname, vtime: sendtime, city: city,street: street,vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum)
                             self.items.append(item_obj)

                        }
                        self._tableView.reloadData()
                        self._tableView.doneRefresh()

                    }
                    }else
                    {
                        self.successNotice("网络请求错误")
                        print("网络请求错误")
                    }

             }
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    
}
