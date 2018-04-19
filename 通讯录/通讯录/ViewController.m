//
//  ViewController.m
//  通讯录
//
//  Created by 刘伟哲 on 16-1-11.
//  Copyright (c) 2016年 刘伟哲. All rights reserved.
//

#import "ViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refresh];
    
}
-(void)refresh
{
    [dataSource removeAllObjects];
    [self selectContactFromTable];
    [self getIndexs];
    [nameArr removeAllObjects];
    [myTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    datapath = [self copySqliteToDocument];
    
    nameArr =[NSMutableArray new];
    indexs =[NSMutableArray new];
    dataSource = [NSMutableArray new];
    
    [self getIndexs];
    [self createContactAtLeft];
    [self createTable];
}
//右上角添加添加按钮
-(void)createContactAtLeft
{
    UIBarButtonItem * right =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertContant:)];
    self.navigationItem.rightBarButtonItem = right;
}
//跳转到联系人页面
-(void)insertContant:(id)sender
{
    UIBarButtonItem * back =[[UIBarButtonItem alloc] init];
    back.title =@"返回";
    self.navigationItem.backBarButtonItem =back;
    EditViewController * newContact =[EditViewController new];
    newContact.dataPath =datapath;
    [self.navigationController pushViewController:newContact animated:YES];
}

//将数据库移到Document文件夹下
- (NSString *)copySqliteToDocument
{
    NSFileManager * file = [NSFileManager defaultManager];
    NSString * sourcePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"sqlite"];
    NSString * targetPath = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    targetPath = [targetPath stringByAppendingPathComponent:@"address.sqlite"];
    if(![file fileExistsAtPath:targetPath])
    {
        BOOL rst = [file copyItemAtPath:sourcePath toPath:targetPath error:nil];
        if(rst) NSLog(@"拷贝成功");
        else NSLog(@"拷贝失败");
    }
    return targetPath;
}
-(void)deleteDB:(NSString *)number
{
    database = [FMDatabase databaseWithPath:datapath];
    if([database open])
    {
        NSString * sql = @"delete from address where name = ? ";
        BOOL rst=[database executeUpdate:sql withArgumentsInArray:@[number]];
        if (rst) {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败");
        }
    }
    [database close];
}
//获取索引
-(void)getIndexs
{
    NSMutableArray *modelName =[NSMutableArray new];
    addressModel * model =[addressModel new];
    
    for (int i=0; i<nameArr.count; i++)
    {
        model =[nameArr objectAtIndex:i];
        NSString *name =model.name;
        [modelName addObject:name];
        NSString * FW =[PinYin getFirstLetter:name];
        if(![indexs containsObject:FW])
            [indexs addObject:FW];
    }
    [indexs sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    for (int i=0; i<indexs.count; i++) {
        NSString *key =[indexs objectAtIndex:i];
        NSMutableArray * obj =[NSMutableArray new];
        NSMutableDictionary * dic =[NSMutableDictionary new];
        
        for (int j=0; j<modelName.count; j++) {
            addressModel * model =[nameArr objectAtIndex:j];
            NSString *name =[PinYin getFirstLetter:model.name];
            if([key isEqualToString:name])
                [obj addObject:model];
        }
        [dic setObject:obj forKey:key];
        [dataSource addObject:dic];
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexs;
}
//查询数据库中的联系人
-(void)selectContactFromTable
{
    database=[FMDatabase databaseWithPath:datapath];
    if([database open])
    {
        NSString * sql =@"select number,name,address from address";
        FMResultSet * set =[database executeQuery:sql];
        while ([set next])
        {
            addressModel * model=[addressModel new];
            model.number=[set stringForColumn:@"number"];
            model.name = [set stringForColumn:@"name"];
            model.address = [set stringForColumn:@"address"];
            [nameArr addObject:model];
        }
    }[database close];
}
//table
- (void)createTable
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    myTable =tableView;
    [self.view addSubview:tableView];
}
//section标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic =[dataSource objectAtIndex:section];
    return [dic allKeys].firstObject;
}
//section数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}
//cell数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dic =[dataSource objectAtIndex:section];
    NSArray * arr =[dic allValues].firstObject;
    return arr.count;
}
//定义Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary * dic = [dataSource objectAtIndex:indexPath.section];
    NSArray * name = [dic allValues];
    NSArray * obj = name.firstObject;
    addressModel * model = [obj objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [dataSource objectAtIndex:indexPath.section];
    NSArray * arr = [dic allValues];
    NSArray * obj = arr.firstObject;
    addressModel * model = [obj objectAtIndex:indexPath.row];
    EndEditViewController * detail = [EndEditViewController new];
    detail.dataPath=datapath;
    detail.model=model;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSDictionary * dic = [dataSource objectAtIndex:indexPath.section];
        NSArray * arr = [dic allValues];
        NSArray * obj = arr.firstObject;
        addressModel * model = [obj objectAtIndex:indexPath.row];
        NSLog(@"%@",model.name);
        [self deleteDB:model.number];
        [dataSource removeAllObjects];
        [nameArr removeAllObjects];
        [indexs removeAllObjects];
        [self selectContactFromTable];
        [self getIndexs];
        [tableView reloadData];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
