//
//  EndEditViewController.m
//  通讯录
//
//  Created by 刘伟哲 on 16-1-11.
//  Copyright (c) 2016年 刘伟哲. All rights reserved.
//

#import "EndEditViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface EndEditViewController ()

@end

@implementation EndEditViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor =[UIColor greenColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBtn];
    [self createTextField];
    self.view.backgroundColor=[UIColor greenColor];
    // Do any additional setup after loading the view.
}
-(void)createBtn
{
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag=1;
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = back;
    
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.tag=2;
    doneBtn.frame = CGRectMake(0, 0, 44, 44);
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem = done;
}
-(void)createTextField
{
    numberTF = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH*.05, WIDTH*.05*2+40+64, WIDTH*0.9, 40)];
    numberTF.text=self.model.number;
    numberTF.enabled=NO;
    numberTF.placeholder=@"联系人号码";
    numberTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:numberTF];
    
    nameTF = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH*.05, WIDTH*.05+64, WIDTH*0.9, 40)];
    nameTF.text=self.model.name;
    nameTF.enabled=NO;
    nameTF.placeholder=@"联系人姓名";
    nameTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:nameTF];

    addressTF = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH*.05, WIDTH*.05*3+80+64, WIDTH*0.9, 40)];
    addressTF.text=self.model.address;
    addressTF.enabled=NO;
    addressTF.placeholder=@"联系人地址，可为空";
    addressTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:addressTF];
}
-(void)click:(UIButton *)sender
{
    if(sender.tag==1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(sender.tag==2)
    {
        if(nameTF.enabled)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self endEdit];
        }
        else
        {
            [sender setTitle:@"完成" forState:UIControlStateNormal];
            [self editTextChange];
        }
    }
}
-(void)editTextChange
{
    numberTF.enabled=YES;
    nameTF.enabled =YES;
    addressTF.enabled=YES;
}
-(void)endEdit
{
    NSString * number=self.model.number;
    database =[FMDatabase databaseWithPath:self.dataPath];
    if([database open])
    {
        NSString *sql=@"update address set number=?,name=?,address=? where number=?";
        BOOL rst =[database executeUpdate:sql withArgumentsInArray:@[numberTF.text,nameTF.text,addressTF.text,number]];
    if(rst)
    {
        NSLog(@"修改成功");
    }
    else
    {
        NSLog(@"修改失败");
    }}[database close];
    NSLog(@"编辑完成");
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
