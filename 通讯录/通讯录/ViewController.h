//
//  ViewController.h
//  通讯录
//
//  Created by 刘伟哲 on 16-1-11.
//  Copyright (c) 2016年 刘伟哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "PinYin.h"
#import "CXAlertView.h"
#import "addressModel.h"
#import "EditViewController.h"
#import "EndEditViewController.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * dataSource;
    
    FMDatabase * database;
    NSString * datapath;
    
    UITextField * numberTF;
    UITextField * addressTF;
    UITextField * nameTF;
    
    UITableView * myTable;
    NSMutableArray * nameArr;
    NSMutableArray * indexs;
}
@end

