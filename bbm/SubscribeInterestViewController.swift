//
//  SubscribeInterestViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/13.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class SubscribeInterestViewController: UIViewController ,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var _grid: UICollectionView!
    
    //课程名称和图片，每一门课程用字典来表示
    var courses = [
        ["name":"体育","pic":""],
        ["name":"足球","pic":""],
        ["name":"运动","pic":""],
        ["name":"家教","pic":""],
        ["name":"房产","pic":""],
        ["name":"兼职","pic":""],
        ["name":"促销","pic":""],
        ["name":"培训","pic":""]
    ]
     var db: SQLiteDB!
    var w:CGFloat = 0.0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        
//        var aaa:NSDictionary = courses[1] as NSDictionary
//        
//       
//        courses[1]["pic"]="add.png"
//      
//         aaa.setValue("add.png", forKey: "pic");
        w=self.view.frame.width;
        self.navigationItem.title="兴趣"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        // Do any additional setup after loading the view.
        _grid.delegate=self;
        _grid.dataSource=self;
        
         self._grid?.backgroundColor = UIColor.whiteColor()
//        
//        var mib:NSArray = NSBundle.mainBundle().loadNibNamed("tag", owner: nil , options: nil)
//        var xibBView:tagUIView = (mib.firstObject as? tagUIView)!
//        xibBView.name.text="aa"
//        xibBView.sel.image=UIImage(named: "add")
////        xibBVie.text="ydz"
////        xibBView.btn.setTitle("哈哈", forState: .Normal)
////        
//        xibBView.frame = CGRectMake(0, 200, 100,50)
//        xibBView.backgroundColor = UIColor.greenColor()
//        self.view.addSubview(xibBView)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("homeController") as! HomeViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // CollectionView行数
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int {
            return courses.count;
            //return 100;
    }
    
    // 获取单元格
     func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            // storyboard里设计的单元格
            let identify:String = "DesignViewCell"
            // 获取设计的单元格，不需要再动态添加界面元素
            let cell = self._grid.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath) as UICollectionViewCell
            // 从界面查找到控件元素并设置属性
            
            if isexitinterest(courses[indexPath.item]["name"]!)
            {
                (cell.contentView.viewWithTag(1) as! UIImageView).hidden = false
                 courses[indexPath.item]["pic"]="city_checkbox_selected.png";
                
                (cell.contentView.viewWithTag(1) as! UIImageView).image = UIImage(named:"city_checkbox_selected.png")
            }else
            {
                
                (cell.contentView.viewWithTag(1) as! UIImageView).hidden = true
                courses[indexPath.item]["pic"]=""
            }
            (cell.contentView.viewWithTag(2) as! UILabel).text = courses[indexPath.item]["name"]
 
            return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(self.w/2, 30)
    }
//    
//    func collectionView(collectionView: UICollectionView!, ayout collectionViewLayout: UICollectionViewLayout!, nsetForSectionAtIndex section: Int) -> UIEdgeInsets{
//        return UIEdgeInsetsMake(10, 10, 10, 10);
//    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("\(indexPath.row)")
        
        NSLog("\(courses.count)")

        var name=courses[indexPath.row]["pic"];
        if(name=="city_checkbox_selected.png")
        {
            courses[indexPath.row]["pic"]=""
            removeinterest(courses[indexPath.row]["name"]!)
        }else
        {
            courses[indexPath.row]["pic"]="city_checkbox_selected.png"
             addinterest(courses[indexPath.row]["name"]!)
        }
        self._grid.reloadData();
        
    }
    
    
    
    func addinterest(interestname: String)  {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "insert into interest(interestname) values('\(interestname)')"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        db.execute(sql)
        
    }
    
    
    func removeinterest(interestname: String)  {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "delete from interest where interestname ='\(interestname)'"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        db.execute(sql)
    }
    
    
    func isexitinterest(interestname: String) ->Bool  {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "select  * from  interest where interestname ='\(interestname)'"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        let row = db.query(sql)
        if row.count > 0 {
            return true;
        }else
        {
            return false;
        }
    }


}
