//
//  RecentTableViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
import AudioToolbox
class RecentTableViewController: UITableViewController,XxRecentDL {

    var dataSource = NSMutableArray()
    var currentIndexPath: NSIndexPath?
    var items:[itemRecent]=[]
    var db: SQLiteDB!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title="会话列表"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        db = SQLiteDB.sharedInstance()
        querydata()
        
        zdl().xxrecentdl = self


    }
    
    
       //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    
    //收到消息
    func newRecentMsg(aMsg: WXMessage) {
        db = SQLiteDB.sharedInstance()
        querydata()
        
       
    }

//
//    //获取总代理
//    func zdl() -> AppDelegate {
//        return UIApplication.sharedApplication().delegate as! AppDelegate
//    }
//    
//    
//    func newMsg(aMsg: WXMessage) {
//        systemVibration();
//        //viewDidLoad()
//  
//    }
    

    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func querydata()
    {
        //let sql="select userid,nickname,usericon,lastinfo,lasttime,messnu,lastnickname　from friend";
        if self.items.count>0
        {
            self.items.removeAll()
        }
        
        let sql="select * from friend order by lasttime desc";
        NSLog(sql)
        let mess = db.query(sql)
        if mess.count > 0 {
            //获取最后一行数据显示
            for i in 0...mess.count-1
            {
                let item = mess[i] as SQLRow
                let userid = item["userid"]!.asString()
                //let nickname = item["nickname"]!.asString()
                //let usericon = item["usericon"]!.asString()
                
                let usericon = sqlitehelp.shareInstance().loadheadface(userid)
                let nickname = sqlitehelp.shareInstance().loadusername(userid)
                
                let lastinfo = item["lastinfo"]!.asString()
                var lasttime = item["lasttime"]!.asString()
               
                
                var date:NSDate = NSDate()
                var formatter:NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                var dateString = formatter.stringFromDate(date)
                
                if(lasttime.containsString(dateString))
                {
                    lasttime = lasttime.subStringFrom(11)
                    
                }else
                {
                    
                    lasttime = (lasttime as NSString).substringWithRange(NSRange(location: 0,length: 10))
                }

                let messnum = item["messnum"]!.asString()
                var lastnickname = item["lastuserid"]!.asString()
                if(loadusername(item["lastuserid"]!.asString()).characters.count>0)
                {
                    lastnickname=loadusername(item["lastuserid"]!.asString())
                }
                let item_obj:itemRecent=itemRecent(userid: userid, username: nickname, usericon: usericon, lastinfo: lastinfo, lastchattimer: lasttime, messnum: messnum, lastnickname: lastnickname)
                 self.items.append(item_obj)
            }
             self.tableView.reloadData();
        }else
        {   self.successNotice("会话列表为空")
            print("会话列表为空")
            return;

        
        }
        
        
    }
    
    
    func loadusername(userid:String)->String
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from users where userid='"+userid+"'";
        NSLog(sql)
        let mess = db.query(sql)
        if( mess.count>0)
        {
            NSLog("ok")
            let item = mess[0] as SQLRow
            return item["nickname"]!.asString()
        }
        else
        {
            NSLog("fail")
            
            return ""
        }
    }


    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        
        
        
        let cellId = "recentcell"
        
        //无需强制转换
        
        var cell:RecentTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? RecentTableViewCell
        
        if(cell == nil)
            
        {
            
            cell = RecentTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            
        }
        cell?.name!.text = (self.items[indexPath.row] as itemRecent).username
        
        
        cell?.content!.text = (self.items[indexPath.row] as itemRecent).lastnickname.stringByAppendingString(":").stringByAppendingString((self.items[indexPath.row] as itemRecent).lastinfo)
        
        
        cell?.lasttime!.text = (self.items[indexPath.row] as itemRecent).lastchattimer


        var avatar:String = (self.items[indexPath.row] as itemRecent).usericon
        
        if(avatar.characters.count>0)
        {
            var head = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(avatar)
            
            Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
                if let d = data as? NSData!
                {
                    cell?.lastuericon.image=UIImage(data: d)
                }
            }
        }else
        {
            cell?.lastuericon.image=UIImage(named: "logo")

        }

        cell?.lastuericon.layer.cornerRadius = 5.0
        cell?.lastuericon.layer.masksToBounds = true
        //cell?.messnum.value=(self.items[indexPath.row] as itemRecent).messnum
        var anum:String = (self.items[indexPath.row] as itemRecent).messnum
       
        var aanum:Int = Int(anum)!
         cell?.messnum.value=aanum
        if aanum>0
        {
            cell?.messnum.hidden=false;
        }else
        {
            cell?.messnum.hidden=true;
        }
       
        //messnum: BadgeView!
        return cell!
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let senduserid = defaults.objectForKey("userid") as! String;
        var seluserid:String = (self.items[indexPath.row] as itemRecent).userid
        
        let sql = "update friend set messnum=0 where userid='\(seluserid)'"
        db.execute(sql)
        
        let sql1 = "update chat set readed=1 where senduserid='\(seluserid)' or touserid='\(seluserid)'"
        db.execute(sql1)
        
        (self.items[indexPath.row] as itemRecent).messnum = "0";
        self.tableView.reloadData()
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
        //创建导航控制器
        vc.from=(self.items[indexPath.row] as itemRecent).userid
        vc.myself=senduserid;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
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
