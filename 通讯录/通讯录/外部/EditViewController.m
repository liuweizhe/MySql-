//
//  EditViewController.m
//  通讯录
//
//  Created by 刘伟哲 on 16-1-11.
//  Copyright (c) 2016年 刘伟哲. All rights reserved.
//

#import "EditViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface EditViewController ()

@end

@implementation EditViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor=[UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBtn];
    [self  createTF];
}
-(void)createBtn
{
    doneBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.tag=2;
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    doneBtn.backgroundColor =[UIColor clearColor];
    doneBtn.frame =CGRectMake(0, 0, 44, 44);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(insertBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * doneItem =[[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    self.navigationItem.leftBarButtonItem =doneItem;
}
-(void)insertBtn:(id)sender
{

    [self.navigationController popToRootViewControllerAnimated:YES];
    [self insertContact];
}
-(void)insertContact
{
    if([nameTF.text isEqualToString:@""]||[numberTF.text isEqualToString:@""])
    {
        NSLog(@"请重新输入");
    }
    else
    {
        database =[FMDatabase databaseWithPath:self.dataPath];
        if([database open])
        {
            NSString * sql =@"insert into address(number,name,address) values (?,?,?)";
            BOOL rst =[database executeUpdate:sql withArgumentsInArray:@[numberTF.text,nameTF.text,addressTF.text]];
            if(rst)
            {
                NSLog(@"新增成功");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                NSLog(@"新增实效");
            }
        }
        [database close];
    }
}
-(void)createTF
{
    nameTF = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH*0.05, WIDTH*0.05+64, WIDTH*0.9, 40)];
    nameTF.placeholder=@"联系人姓名";
    nameTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:nameTF];
    numberTF = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH*0.05, WIDTH*.05*2+40+64, WIDTH*0.9, 40)];
    numberTF.placeholder=@"联系人号码";
    numberTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:numberTF];
    addressTF = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH*0.05, WIDTH*0.05*3+80+64, WIDTH*0.9, 40)];
    addressTF.placeholder=@"联系人地址，可为空";
    addressTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:addressTF];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
