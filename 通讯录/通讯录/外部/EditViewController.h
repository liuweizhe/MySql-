//
//  EditViewController.h
//  通讯录
//
//  Created by 刘伟哲 on 16-1-11.
//  Copyright (c) 2016年 刘伟哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface EditViewController : UIViewController
{
    FMDatabase * database;
    UITextField * nameTF;
    UITextField * numberTF;
    UITextField * addressTF;
    UIButton * doneBtn;
}
@property(nonatomic,strong)NSString * dataPath;
@end
