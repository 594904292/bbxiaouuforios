//
//  GzInfosTableViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class GzInfosTableViewController: UITableViewController {

    var start:Int = 0
    var limit:Int = 10
    
    var items:[itemMess]=[]
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initnavbar("收藏信息")
        self.tableView.registerClass(OneTableViewCell.self, forCellReuseIdentifier: "cell")//注册自定义cell
        tableView.estimatedRowHeight = 250
        //setSeparatorInset:UIEdgeInsetsMake
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //设置分割线颜色
        self.tableView.separatorColor = UIColor.redColor()
        //设置分割线内边距
        self.tableView.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0)

        querydata()
        
        
    }
    
    func initnavbar(titlestr:String)
    {
        self.title=titlestr
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: #selector(GzInfosTableViewController.backClick))
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: #selector(GzInfosTableViewController.searchClick))
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4
    }
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchClick()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }
  
    
    
    //MARK: 加载数据
    func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            self.start=0;
            self.querydata()
            self.tableView.reloadData()
            self.tableView.headerView?.endRefreshing()
            
        }
        
    }
    
    func downPlullLoadData(){
        
        xwDelay(1) { () -> Void in
            self.start=self.limit;
            
            
            self.querydata()
            self.tableView.reloadData()
            self.tableView.footerView?.endRefreshing()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
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
        // let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        //  self.view.window!.rootViewController=nvc;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
                   return 250;
        
    }

    
    
    
    
    func querydata()
    {
         var sqlitehelpInstance1=sqlitehelp.shareInstance()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var userid = defaults.objectForKey("userid") as! String;
        
        var guids:String = sqlitehelpInstance1.getguids(userid)
        if(guids.characters.count==0)
        {
            self.successNotice("无收藏信息")
            print("无收藏信息")
            return;
        }
        var url:String="http://api.bbxiaoqu.com/getgzinfo.php?guid=".stringByAppendingString(guids);
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
                    self.tableView.reloadData()
                    self.tableView.doneRefresh()
                    
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
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
