//
//  UserInfoViewController.swift
//  bbm
//
//  Created by songgc on 16/4/1.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class UserInfoViewController: UIViewController ,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{

    
    @IBOutlet weak var headface: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var telphone: UILabel!
    
    @IBOutlet weak var gz_btn: UIButton!
    @IBOutlet weak var _tableview: UITableView!
    var userid:String = "";
    var start:Int = 0
    var limit:Int = 10
    

    
    @IBOutlet weak var navcontain: UIView!
    
    //////////////
    var tabBar:UITabBar!
    //Tab Bar Item的名称数组
    var tabs = ["收到的感谢","求助"]
    
    func addtabbar()
    {
        //在底部创建Tab Bar
        tabBar = UITabBar(frame:
            CGRectMake(0,0,CGRectGetWidth(self.view.bounds),30))
        let tabItem1 = UITabBarItem(title: tabs[0], image: nil, tag: 0)
        var tabItem2 = UITabBarItem(title: tabs[1], image: nil, tag: 1)
        var attributes =  [NSForegroundColorAttributeName: UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        var selattributes =  [NSForegroundColorAttributeName: UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        tabItem1.setTitleTextAttributes(attributes , forState: UIControlState.Selected)
        tabItem1.setTitleTextAttributes(attributes , forState: UIControlState.Normal)
        tabItem1.setTitleTextAttributes(selattributes , forState: UIControlState.Highlighted)
        tabItem1.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -10)
        tabItem2.setTitleTextAttributes(attributes , forState: UIControlState.Selected)
        tabItem2.setTitleTextAttributes(attributes , forState: UIControlState.Normal)
        tabItem2.setTitleTextAttributes(selattributes , forState: UIControlState.Highlighted)
        tabItem2.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -10)
        
         var items:[UITabBarItem] = [tabItem1,tabItem2]
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
        
       
        self.navcontain.addSubview(tabBar);
    }
    
    // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //通过tag查询到上方容器的label，并设置为当前选择的标签页的名称
        if(item.title=="收到的感谢")
        {
            currentpage=0
            queryevaluatedata();
           
        }else if(item.title=="求助")
        {
            currentpage=1
            queryhelpdata();
        }
        print( item.title);
        
        
    }

     override func viewDidLayoutSubviews() {
        headface.layer.cornerRadius = (headface.frame.width) / 2
        headface.layer.masksToBounds = true
    }
    
    var currentpage:Int=0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="好友信息"
        self.view.backgroundColor=UIColor.whiteColor()
        var item1 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        item1.tintColor=UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem=item1
 
        _tableview.delegate=self
        _tableview.dataSource=self
        loaduserinfo(userid);
        
        loadisfriend(userid);
        
        addtabbar()
        tabBar.selectedItem=tabBar.items![currentpage] as! UITabBarItem
        self._tableview.registerClass(OneTableViewCell.self, forCellReuseIdentifier: "helpcell")//注册自定义cell
//        self._tableview.estimatedRowHeight=100
//        self._tableview.rowHeight=UITableViewAutomaticDimension
        queryevaluatedata();
        //queryhelpdata();


    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//       
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
//    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    @IBAction func gz_btn_action(sender: UIButton) {
        var sqlitehelpInstance1=sqlitehelp.shareInstance()
        let defaults = NSUserDefaults.standardUserDefaults();
        var myuserid = defaults.objectForKey("userid") as! String;
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        var  dic:Dictionary<String,String> =  ["mid1":myuserid,"mid2":userid]
        
        dic["addtime"] = strNowTime
        if(sender.tag==1)
        {
            dic["action"] = "del"
        }else
        {
            dic["action"] = "add"
        }
        
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/addfriends.php", parameters: dic)
            
            .response { (request, response, data, error) in
                
                let tn:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(tn)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(sender.tag==1)
                    {
                        
                        self.successNotice("取消成功")
                        self.gz_btn.setTitle("关注", forState: UIControlState.Normal)
                        self.gz_btn.tag=0

                    }else
                    {
                         self.successNotice("关注成功")
                        self.gz_btn.setTitle("取消关注", forState: UIControlState.Normal)
                        self.gz_btn.tag=1

                    }
                   
                    
                });
        }

        
    }
    
    @IBAction func chat(sender: UIButton) {
        var sqlitehelpInstance1=sqlitehelp.shareInstance()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var myuserid = defaults.objectForKey("userid") as! String;
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
        vc.from=userid
        vc.myself=myuserid;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func loaduserinfo(userid:String)
    {
        var url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=".stringByAppendingString(userid)
        Alamofire.request(.POST,url_str, parameters:nil)
            .responseJSON { response in
                print(response.result.value)
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count>0)
                    {
                        let telphone:String = JSON[0].objectForKey("telphone") as! String;
                       
                        let username:String = JSON[0].objectForKey("username") as! String;
                        self.username.text=username;
                        if(telphone.characters.count>10)
                        {
                            var ns1=(telphone as NSString).substringToIndex(3)
                        
                            var ns2=(telphone as NSString).substringFromIndex(7)
                            var ns3=ns1.stringByAppendingString("****").stringByAppendingString(ns2)
                            
                            self.telphone.text=ns3;

                        }else
                        {
                            self.telphone.text=telphone;
                        }
                        let headfaceurl:String = JSON[0].objectForKey("headface") as! String;
                        if(headfaceurl.characters.count>0)
                        {
                            let url="http://api.bbxiaoqu.com/uploads/"+headfaceurl;
                            Alamofire.request(.GET, url).response { (_, _, data, _) -> Void in
                                if let d = data as? NSData!
                                {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.headface?.image = UIImage(data: d)
                                    })
                                }
                            }
                        }else
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                //self.headface?.image = UIImage(named: "logo"))
                                
                                self.headface?.image = UIImage(named: "logo")
                            })
                        }
                        self.headface?.layer.cornerRadius = 5.0
                        self.headface?.layer.masksToBounds = true
                    }
                    
                    
                }
        }
    }
    
    func loadisfriend(userid:String)
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        var myuserid = defaults.objectForKey("userid") as! String;
        var url_str:String = "http://api.bbxiaoqu.com/getisfriends.php?mid1=".stringByAppendingString(myuserid).stringByAppendingString("&mid2=").stringByAppendingString(userid)
        Alamofire.request(.POST,url_str, parameters:nil)
            .responseJSON { response in
                print(response.result.value)
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count>0)
                    {
                        let isfriend:String = JSON.objectForKey("isfriend") as! String;
                        print("JSisfriendON1: \(isfriend)")

                        if(isfriend=="yes")
                        {
                            self.gz_btn.setTitle("取消关注", forState: UIControlState.Normal)
                            self.gz_btn.tag=1
                        }else
                        {
                            self.gz_btn.setTitle("关注", forState: UIControlState.Normal)
                            self.gz_btn.tag=0
                        }
                        
                    }
                    
                    
                }
        }
    }


    var evaluateitems:[ItemEvaluate]=[]
    var items:[itemMess]=[]
    func queryevaluatedata()
    {
        var url:String="http://api.bbxiaoqu.com/getmemberevaluates_v1.php?userid=".stringByAppendingString(userid);
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            print("data: \(data)")
                            let id:String = data.objectForKey("id") as! String;
                            let guid:String = data.objectForKey("guid") as! String;
                            let infouser:String = data.objectForKey("infouser") as! String;
                            let username:String = data.objectForKey("username") as! String;
                            let userid:String = data.objectForKey("userid") as! String;
                            let sex:String = data.objectForKey("sex") as! String;
                            let headface:String = data.objectForKey("headface") as! String;
                            let score:String = data.objectForKey("score") as! String;
                            var evaluatetag:String = "";
                           // if((data.objectForKey("evaluatetag")) != NSNull)
                            //{
                             evaluatetag = data.objectForKey("evaluatetag") as! String;
                           // }
                            let evaluate:String = data.objectForKey("evaluate") as! String;

                            let addtime:String = data.objectForKey("addtime") as! String;
                            
                            let item_obj:ItemEvaluate = ItemEvaluate(id: id, guid: guid, infouser: infouser,username:username,userid: userid, sex:sex,headface:headface,score: score, evalute: evaluate, evalutetag:evaluatetag,addtime: addtime)
                            self.evaluateitems.append(item_obj)
                            
                        }
                        self._tableview.reloadData()
                        self._tableview.doneRefresh()
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
    }
    
    
    func queryhelpdata()
    {

        let defaults = NSUserDefaults.standardUserDefaults();
        let lat = defaults.objectForKey("lat") as! String;
        let lng = defaults.objectForKey("lng") as! String;
        
       // var url:String="http://api.bbxiaoqu.com/getgzinfo.php?guid=".stringByAppendingString(guids);
        var url:String="http://api.bbxiaoqu.com/getinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&latitude=").stringByAppendingString(lat).stringByAppendingString("&longitude=").stringByAppendingString(lng).stringByAppendingString("&rang=self&status=1&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        
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
                            //                            let mylat = defaults.objectForKey("lat") as! String;
                            //                            let mylng = defaults.objectForKey("lng") as! String;
                            
                            
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
                            let sex:String = data.objectForKey("sex") as! String;

                            let item_obj:itemMess = itemMess(userid: senduserid,headface:headface,sex:sex, vname: sendnickname, vtime: sendtime, city: city,street: street,vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum)
                            self.items.append(item_obj)
                            
                        }
                        self._tableview.reloadData()
                        self._tableview.doneRefresh()
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
        //计算行高，返回，textview根据数据计算高度
        if(currentpage==0)
        {
            var fixedWidth:CGFloat = 260;
            var contextLab:UITextView=UITextView()
            contextLab.text=(evaluateitems[indexPath.row] as ItemEvaluate).evalute
            var newSize:CGSize = contextLab.sizeThatFits(CGSizeMake(fixedWidth, 123));
            var height=(newSize.height)
            print("height---\(height)")
            return height+120
        }else
        {
            return 250;
        }
    }
    
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rownum:Int=0
        if(currentpage==0)
        {
            rownum = self.evaluateitems.count;
        }else
        {
            rownum = self.items.count;
        }
        return rownum
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(currentpage==0)
        {
            //var ppp:String = (items[indexPath.row] as itemMess).photo;
            let cellId="evaluatecell"
            var cell:EvaluateTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! EvaluateTableViewCell?
            if(cell == nil)
            {
                cell = EvaluateTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            }
            //cell?.infouser.text=(items[indexPath.row] as ItemEvaluate).infouser
            
            var myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString((evaluateitems[indexPath.row] as ItemEvaluate).headface)
            
            let myheadnsd = NSData(contentsOfURL:NSURL(string: myhead)!)
            cell!.headface.image=UIImage(data: myheadnsd!);

            
            
            cell?.infouser.text=(evaluateitems[indexPath.row] as ItemEvaluate).username
            

            
            var f  =  CGFloat ( ( (evaluateitems[indexPath.row] as ItemEvaluate).score as NSString).floatValue)
            
            cell?.ratingbar.rating = f
             cell?.ratingbar.isIndicator=true
            cell?.eveluate.text=(evaluateitems[indexPath.row] as ItemEvaluate).evalute
            cell?.addtime.text=(evaluateitems[indexPath.row] as ItemEvaluate).addtime
            
            let tags=(evaluateitems[indexPath.row] as ItemEvaluate).evalutetag
            if(tags.characters.count>0)
            {
                let screenWidth = UIScreen.mainScreen().bounds.size;
                
                let evalueTag = EvalueTagLabel(frame: CGRectMake(10, 64, screenWidth.width-20, 60));
                
                
                

                          //let tempArray = ["2016","天气","风景"];
                let tempArray = tags.componentsSeparatedByString("|")
                //let tempArray = tags.characters.split($0=="|").map(String.init())
                
                evalueTag.setTags(tempArray);
                
                
                evalueTag.frame = CGRectMake(10, 0, screenWidth.width/2, evalueTag.totalHeight!);
                
                
                
                cell?.tagsview.addSubview(evalueTag)
            }
            
            
            return cell!
        }else
        {
            var str:String = "helpcell"
            
            
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
            cell.delimg.hidden=true
            cell.clickBtn.tag = indexPath.row
            cell.clickBtn.hidden = true
            //let tap = UITapGestureRecognizer.init(target: self, action: Selector.init("tapped:"))
            //cell.clickBtn.addGestureRecognizer(tap)
            
            
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
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("clicked at \(indexPath.row)")
        
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))); dispatch_after(delay, dispatch_get_main_queue()) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if(currentpage==0)
        {
//            let sb = UIStoryboard(name:"Main", bundle: nil)
//            
//            let vc = sb.instantiateViewControllerWithIdentifier("userinfoviewcontroller") as! UserInfoViewController
//            //创建导航控制器var evaluateitems:[ItemEvaluate]=[]
//
//            vc.userid=(evaluateitems[indexPath.row] as ItemEvaluate).userid
//            self.navigationController?.pushViewController(vc, animated: true)
            

        }else
        {
            NSLog("select \(indexPath.row)")
            
            let aa:itemMess=items[indexPath.row] as itemMess;
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
               vc.guid=aa.guid
            vc.infoid=aa.guid
              self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
//    {
//        NSLog("select \(indexPath.row)")
//        //NSLog("select \(items[indexPath.row])")
//        
//    }


}
