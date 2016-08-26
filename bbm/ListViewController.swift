//
//  ListViewController.swift
//  bbm
//
//  Created by songgc on 16/8/16.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UITabBarDelegate,UINavigationControllerDelegate,ApnsDelegate{
    var _tableView:UITableView!
    
    var start:Int = 0
    var limit:Int = 10

     var selectedTabNumber:Int = 0;
    //添加Tab Bar控件
    var tabBar:UITabBar!
    //Tab Bar Item的名称数组
    var tabs = ["待解决","全部","我的"]
    var activityIndicatorView: UIActivityIndicatorView!
    
    
    var items:[itemMess]=[]
    func NewMessage(string:String){
        if(selectedTabNumber==0)
        {
            
            querydata(0)
        }else if(selectedTabNumber==1)
        {
            
            querydata(1)
        }else if(selectedTabNumber==2)
        {
            
            querydata(2)
        }
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.navigationItem.title="我能帮"
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        var item2 = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Done, target: self, action: "addClick")
        item2.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem=item2
        
        
       
        
        addtabbar()
        var w:CGFloat = UIScreen.mainScreen().bounds.width
        var posx=w/CGFloat(3);
        addline(posx);
        addline(posx*2);
        
        
        tabBar.selectedItem=tabBar.items![selectedTabNumber] as! UITabBarItem
        
        
        
        
        
        //var rect  = self.view.frame
        var rect  =  UIScreen.mainScreen().applicationFrame
        rect.origin.y += tabBar.frame.origin.y+tabBar.frame.size.height-1
        _tableView = UITableView(frame: rect)
        _tableView.registerClass(OneTableViewCell.self, forCellReuseIdentifier: "cell")//注册自定义cell
        
        self.view.addSubview(_tableView)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        
        self._tableView.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")
        self._tableView.headerView?.beginRefreshing()
        self._tableView.headerView?.endRefreshing()
        self._tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
        
        
        _tableView.estimatedRowHeight = 250
        //setSeparatorInset:UIEdgeInsetsMake
        _tableView.rowHeight = UITableViewAutomaticDimension
        
        self._tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //设置分割线颜色
        self._tableView.separatorColor = UIColor.redColor()
        //设置分割线内边距
        self._tableView.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0)
        
        
        // 定义一个 activityIndicatorView
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - 50, 250, 100, 100)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.blackColor()
        self.view.addSubview(activityIndicatorView)
        querydata(selectedTabNumber)


        
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
        
        tabItem1.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -6)
        tabItem2.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -6)
        tabItem3.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -6)

        
        var items:[UITabBarItem] = [tabItem1,tabItem2,tabItem3]
        tabBar.tintColor=UIColor.redColor()
        
        let image = UIImage(named: "xz_you_icon")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 50), resizingMode: UIImageResizingMode.Stretch)
        tabBar.selectionIndicatorImage=image
        let meiimage1 = UIImage(named: "xz_mei_icon")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 50), resizingMode: UIImageResizingMode.Stretch)
        
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
        
        let posy=CGFloat(tabBar.frame.origin.y+15);
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
        if(item.title=="待解决")
        {
            selectedTabNumber=0
            self.items.removeAll()
            querydata(0)
        }else if(item.title=="全部")
        {
            selectedTabNumber=1
            self.items.removeAll()
            querydata(1)
        }else if(item.title=="我的")
        {
            selectedTabNumber=2
            self.items.removeAll()
            querydata(2)
        }
        self._tableView.reloadData()
        
    }
   
    //MARK: 加载数据
    func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            self.start=0;
            if(self.selectedTabNumber==0)
            {
                self.querydata(0)
            }else if(self.selectedTabNumber==1)
            {
                self.querydata(1)
            }else if(self.selectedTabNumber==2)
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
            if(self.selectedTabNumber==0)
            {
                
                self.querydata(0)
            }else if(self.selectedTabNumber==1)
            {
                
                self.querydata(1)
            }else if(self.selectedTabNumber==2)
            {
                
                self.querydata(2)
            }
            self._tableView.reloadData()
            self._tableView.footerView?.endRefreshing()
        }
        
    }
    
    

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return array.count
        return self.items.count;

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var str:String = "cell"
        
        var cell:OneTableViewCell = tableView.dequeueReusableCellWithIdentifier(str, forIndexPath: indexPath) as! OneTableViewCell
        
        if cell.isEqual(nil) {
            cell = OneTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: str)
        }
        //var senduser=(items[indexPath.row] as itemMess).username
        var namestr:String=(items[indexPath.row] as itemMess).username

        cell.username.text = namestr//array[indexPath.row]//(items[indexPath.row] as itemMess).username
        
        
        let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
        //let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
        
        let boundingRect = namestr.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:cell.username.font], context: nil)
        
        if((items[indexPath.row] as itemMess).sex == "0")
        {
            cell.seximg.image=UIImage(named: "xz_nan_icon")
            
        }else
        {
            cell.seximg.image=UIImage(named: "xz_nv_icon")
        }
        cell.seximg.frame=CGRectMake(boundingRect.width+70, 25, 10, 15)
        
        
        
        
        if (items[indexPath.row] as itemMess).street.characters.count > 0
        {
            cell.street.text=(items[indexPath.row] as itemMess).street
        }else
        {
            cell.street.text="未知"
        }
        
        
        let streettr:String = cell.street.text!
        
        
        let distanceboundingRect = streettr.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:cell.street.font], context: nil)
         cell.distance.frame=CGRectMake(distanceboundingRect.width+70, 43, distanceboundingRect.width*2, 30)
        cell.distance.text=(items[indexPath.row] as itemMess).address
        
        cell.timesgo.text=(items[indexPath.row] as itemMess).time
        
        
        
    
  
        
        cell.content.text=(items[indexPath.row] as itemMess).content
        
        if((items[indexPath.row] as itemMess).headface.characters.count>0)
        {
            var myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString((items[indexPath.row] as itemMess).headface)
            
            let myheadnsd = NSData(contentsOfURL:NSURL(string: myhead)!)
            cell.headface.image=UIImage(data: myheadnsd!);

            cell.headface.layer.cornerRadius = cell.headface.frame.width / 2
            // image还需要加上这一句, 不然无效
            cell.headface.layer.masksToBounds = true
        }
        let bw:CGFloat = UIScreen.mainScreen().bounds.width-20
        var index=0

        var photoArr:[String] = (items[indexPath.row] as itemMess).photo.characters.split{$0 == ","}.map{String($0)}
        
        
        var picnum=photoArr.count
        if(picnum>4)
        {
        picnum=4
        }
        
        let count = 4;
        for(var j:Int=0;j<picnum;j++)
        {
            let imageView:UIImageView = UIImageView();
            let sw=bw/4;
            var x:CGFloat = sw * CGFloat(j);
            imageView.frame=CGRectMake(x+5, 5, sw-10, sw-10);
            imageView.tag=indexPath.row*100+j
            let picname:String = photoArr[j]
            var imgurl = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(picname)
            let nsd = NSData(contentsOfURL:NSURL(string: imgurl)!)
            //var img = UIImage(data: nsd!,scale:1.5);  //在这里对图片显示进行比例缩放
            imageView.image=UIImage(data: nsd!);
            //添加边框
            var layer:CALayer = imageView.layer
            layer.borderColor=UIColor.lightGrayColor().CGColor
            layer.opacity=1
            layer.borderWidth = 1.0;
            
            cell.imgview.addSubview(imageView);
        }
        let defaults = NSUserDefaults.standardUserDefaults();
        
        var userid = defaults.objectForKey("userid") as! String;
        
        if((items[indexPath.row] as itemMess).userid==userid)
        {
        
            cell.delimg.hidden=false
            cell.clickBtn.hidden = false
            cell.clickBtn.userInteractionEnabled=true
            cell.clickBtn.tag = indexPath.row
            //点击事件
            let tap = UITapGestureRecognizer.init(target: self, action: Selector.init("tapLabel:"))
            //绑定tap
            cell.clickBtn.addGestureRecognizer(tap)
        }else
        {
            cell.delimg.hidden=true
            cell.clickBtn.hidden = true
        }

        
        
            cell.tag1.text="浏览:".stringByAppendingString((items[indexPath.row] as itemMess).visnum).stringByAppendingString("次")
            cell.tag2.text="评论:".stringByAppendingString((items[indexPath.row] as itemMess).plnum).stringByAppendingString("次")
            
            if ((items[indexPath.row] as itemMess).status == "0")
            {
                cell.statusimg.image =  UIImage(named: "xz_qiuzhu_icon")
            }else if ((items[indexPath.row] as itemMess).status == "1")
            {
                cell.statusimg.image = UIImage(named: "xz_qiuzhu_icon")
            }else if ((items[indexPath.row] as itemMess).status == "2")
            {
                cell.statusimg.image = UIImage(named: "xz_yijiejue_icon")
            }
            

        
  
        return cell
    }
    
    
    var sel_guid:String="";
        func tapLabel(recognizer:UITapGestureRecognizer){
            let labelView:UIView = recognizer.view!;
            let tapTag:NSInteger = labelView.tag;
            
            print(tapTag)
            sel_guid=(items[tapTag] as itemMess).guid as! String
        let alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定要删除吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
        
        
    }
    
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
        }
        else
        {
            print("点击了确认")
            var url:String="http://api.bbxiaoqu.com/delinfoforguid.php?_guid=".stringByAppendingString(sel_guid);
            Alamofire.request(.GET, url, parameters: nil)
                .response { (request, response, data, error) in
                    let tn:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    print(tn);
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                      self.querydata(self.selectedTabNumber)
                    });
                    
            }

        }
    }
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("clicked at \(indexPath.row)")
        let aa:itemMess=items[indexPath.row] as itemMess;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
        //创建导航控制器
        //vc.message = aa.content;
        vc.guid=aa.guid
        vc.infoid=aa.guid
        //设置根视图
        self.navigationController?.pushViewController(vc, animated: true)
        
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))); dispatch_after(delay, dispatch_get_main_queue()) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        // 仔细想一想..
        // 还是取消为妙..
        //cancel(task)

    }
    
   

//    func leftCall(sender:AnyObject) {
//        _tableView.setEditing(!_tableView.editing, animated: true)
//        var btn:UIBarButtonItem = sender as! UIBarButtonItem
//        btn.title = "Done"
//        print("leftButton pressed")
//    }
//    func rightCall(sender:AnyObject) {
//        array.append("新建cell")
//        _tableView.reloadData()
//        print("rightButton pressed")
//    }
    func tableViewCellClicked(sender:AnyObject) {
        print("tableViewCell appButton at \((sender as! UIButton).tag) clicked")
    }

    func roundoff(x:Double)->Int
    {
        var a:Int = Int(x)
        var b:Double = Double(a)+0.5
        if(x>b)
        { return a+1 }
        else
        { return a}
    }
    
    func querydata(Category:Int)
    {
        var url:String="";
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        var lat = defaults.objectForKey("lat") as! String;
        var lng = defaults.objectForKey("lng") as! String;
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
        activityIndicatorView.startAnimating()
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    
                    
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            //print("data: \(data)")
                            
                            let content:String = data.objectForKey("content") as! String;
                            let senduserid:String = data.objectForKey("senduser") as! String;
                             var sex:String=data.objectForKey("sex") as! String;
                            
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
                            
                            var infolng:String = data.objectForKey("lng") as! String;
                            var infolat:String = data.objectForKey("lat") as! String;
                            
                            
                            var lat_1=(infolat as NSString).doubleValue;
                            var lng_1=(infolng as NSString).doubleValue;
                            
                            let defaults = NSUserDefaults.standardUserDefaults();
                            var userid = defaults.objectForKey("userid") as! String;
                            var mylat = defaults.objectForKey("lat") as! String;
                            var mylng = defaults.objectForKey("lng") as! String;
                            
                            
                            var lat_2=(lat as NSString).doubleValue;
                            var lng_2=(lng as NSString).doubleValue;
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
                                
                                print("距离: %0.2f米", distance);
                                
                                var one:UInt32 = UInt32(distance)
                                
                                if(one>1000)
                                {
                                    address = ("\(self.roundoff(Double(one)/1000))千米");
                                }else
                                {
                                    address = ("\(one)米");
                                }
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
                            let item_obj:itemMess = itemMess(userid: senduserid,headface:headface,sex:sex, vname: sendnickname, vtime: sendtime, city: city,street: street,vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum)
                            self.items.append(item_obj)
                            
                        }
                        self._tableView.reloadData()
                        self._tableView.doneRefresh()
                        self.activityIndicatorView.stopAnimating()
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                    self.activityIndicatorView.stopAnimating()
                }
                
        }
        
    }
}
