//
//  OneTableViewCell.swift
//  bbm
//
//  Created by songgc on 16/8/16.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class OneTableViewCell: UITableViewCell {
    var headface:UIImageView!
    var username:UILabel!
    var seximg:UIImageView!
    var statusimg:UIImageView!
    var street:UILabel!
    var distance:UILabel!
    var timesgo:UILabel!
    
    var content:UILabel!
    
    
    var fgview:UIView!
    var imgview:UIView!

    
    var clickBtn:UILabel!
    var tag1:UILabel!
    var tag2:UILabel!
    
     var delimg:UIImageView!
    var tag1img:UIImageView!
    var tag2img:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            var toph=CGFloat(15);
            var topfgview:UIView=UIView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().applicationFrame.width, toph))
            topfgview.backgroundColor=UIColor(colorLiteralRed: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)

            
            self.contentView.addSubview(topfgview)

            
            headface = UIImageView.init(frame: CGRectMake(10, toph+5, 45, 45))
            headface.image=UIImage(named: "xz_xiang_icon")
            self.contentView.addSubview(headface)
           

            
            username = UILabel.init(frame: CGRectMake(65, toph+5, 200, 30))
            self.contentView.addSubview(username)
            
            seximg = UIImageView.init(frame: CGRectMake(100, toph+5, 10, 15))
            seximg.image=UIImage(named: "xz_nan_icon")
            self.contentView.addSubview(seximg)
            
            
            
            
            //var w=self.superview?.frame.size.width
            var a=UIScreen.mainScreen().applicationFrame.width
            let aa  = a-70
            statusimg = UIImageView.init(frame: CGRectMake(aa, toph+5, 70, 70))
            statusimg.image=UIImage(named: "xz_qiuzhu_icon")
            self.contentView.addSubview(statusimg)
            
            
            
            street = UILabel.init(frame: CGRectMake(65, toph+28, 200, 30))
            street.font = UIFont.systemFontOfSize(14)
            street.text="东三旗"
            street.textColor=UIColor.lightGrayColor()
            

            self.contentView.addSubview(street)
            
            
            let options1:NSStringDrawingOptions = .UsesLineFragmentOrigin
            let streetRect = street.text!.boundingRectWithSize(CGSizeMake(100, 0), options: options1, attributes:[NSFontAttributeName:street.font], context: nil)
            
            
            distance = UILabel.init(frame: CGRectMake(streetRect.size.width+65, toph+28, 80, 30))
            distance.text="三公里"
            distance.font = UIFont.systemFontOfSize(14)
            distance.textColor=UIColor.lightGrayColor()

            self.contentView.addSubview(distance)
            
            timesgo = UILabel.init(frame: CGRectMake(202, toph+28, 120, 30))
            timesgo.text="2小时前"
            timesgo.font = UIFont.systemFontOfSize(14)
            timesgo.textColor=UIColor.lightGrayColor()
            self.contentView.addSubview(timesgo)
            
            fgview=UIView.init(frame: CGRectMake(10, toph+65, UIScreen.mainScreen().applicationFrame.width-20, 1))
            fgview.backgroundColor=UIColor(colorLiteralRed: 215/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
            self.contentView.addSubview(fgview)
            

            
            
            
            content = UILabel.init()
            //content.backgroundColor = UIColor.grayColor()
            content.text = "1234567890edfdgddffgfgfggfggddfbyfru6y6r7iuymgnjnrtfugyu57t6injyunjokn89uilmghbjl,hknjlllllllllllllllllllllllllllllllllllllmimomomkjnijunbuygbtyfrtdrxcresxweaswa"
            
            content.font = UIFont.systemFontOfSize(14)
            //content.textColor = UIColor.redColor()
            let string:NSString = content.text!
            let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
            let boundingRect = string.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:content.font], context: nil)
            content.frame = CGRectMake(10, toph+33, UIScreen.mainScreen().applicationFrame.width-20, boundingRect.height)
            content.numberOfLines = 2;
            //content.lineBreakMode = NSLineBreakMode.ByWordWrapping
            content.lineBreakMode=NSLineBreakMode.ByTruncatingTail

            
            
            self.contentView.addSubview(content)
            
            var img_posy = CGFloat(toph+105);
            imgview=UIView.init(frame: CGRectMake(10, img_posy, UIScreen.mainScreen().applicationFrame.width-20, UIScreen.mainScreen().applicationFrame.width/4))
            //imgview.backgroundColor=UIColor.greenColor()
            self.contentView.addSubview(imgview)

            
            var bottom_posy = img_posy+UIScreen.mainScreen().applicationFrame.width/4;
            
            delimg = UIImageView.init(frame: CGRectMake(10, bottom_posy+10, 10, 10))
            delimg.image=UIImage(named: "xz_la_icon")
            self.contentView.addSubview(delimg)
            
            clickBtn = UILabel.init(frame: CGRectMake(20, bottom_posy, 60, 30))
                //UILabel(frame: CGRectMake(20, bottom_posy, 60, 30))
            //用户交互功能打开状态
            clickBtn.text="删除"

           
            
            clickBtn?.font = UIFont.systemFontOfSize(14)
            clickBtn.textColor=UIColor.blackColor()
            self.contentView.addSubview(clickBtn)
            
            tag1img = UIImageView.init(frame: CGRectMake(UIScreen.mainScreen().applicationFrame.width-193, bottom_posy+10, 18, 10))
            tag1img.image=UIImage(named: "xz_yan_icon")
            self.contentView.addSubview(tag1img)
            

            tag1 = UILabel.init(frame: CGRectMake(UIScreen.mainScreen().applicationFrame.width-175, bottom_posy, 80, 30))
            tag1.text="浏览:67次"
            tag1.font = UIFont.systemFontOfSize(14)
            self.contentView.addSubview(tag1)
            
            
            tag2 = UILabel.init(frame: CGRectMake(UIScreen.mainScreen().applicationFrame.width-80, bottom_posy, 80, 30))
            tag2.text="评价:12次"
            tag2.font = UIFont.systemFontOfSize(14)
            
            self.contentView.addSubview(tag2)
            
            
            tag2img = UIImageView.init(frame: CGRectMake(UIScreen.mainScreen().applicationFrame.width-100, bottom_posy+10, 20, 15))
            tag2img.image=UIImage(named: "xz_xin_icon")
            self.contentView.addSubview(tag2img)

            
        }
    }
    
    
//    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGRect{
//        var size = CGRect();
//        var size2 = CGSize(width: 100, height: 0);//设置label的最大宽度
//        size = text.boundingRectWithSize(size2, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes , context: nil);
//        return size
//    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
