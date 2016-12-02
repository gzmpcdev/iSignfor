//
//  picmanagementViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "picmanagementViewController.h"

@interface picmanagementViewController ()

@end

NSMutableArray *mutableArray1;
NSString *cutby;
NSArray *cutresult;
NSInteger count;

NSString *openpicname;

NSIndexPath *zuobiao;

@implementation picmanagementViewController

@synthesize stuArray1 = _stuArray1;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mutableArray1 = [[NSMutableArray alloc]init];
    NSString *path;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    path = [paths objectAtIndex:0];
    NSArray *filename = [self getFilenamelistOfType:@"jpg"
                                        fromDirPath:path];
    
    cutby = [filename componentsJoinedByString:@","];//nsstring
    
    cutresult = [cutby componentsSeparatedByString:@","];//nsarray
    //NSString *com = [cutresult objectAtIndex:0];
    
    //NSData *arry2data = [NSKeyedArchiver archivedDataWithRootObject:cutresult];
    
    NSLog(@"%@",[cutresult objectAtIndex:0]);
    
    //NSLog(@"%@",filename);
    count = filename.count;
    NSLog(@"I have %d books in DocumentsDir",count);
    for (int i = 0; i<count; i++) {
        
        
        NSDictionary *dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:[cutresult objectAtIndex:i],@"signforid", nil];
        //NSLog(@"%@",dic1);
        [mutableArray1 insertObject:dic1 atIndex:i];
        NSLog(@"NO.%d is %@",i+1,[filename objectAtIndex:i]);
    }
    
    //NSLog(@"%@",mutableArray1);
    _stuArray1 = [mutableArray1 copy];
    
    //NSLog(@"%@",_stuArray1);
    
    [self.listphoto reloadData];

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

- (IBAction)backtoshouye:(id)sender {
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shouye"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}

-(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}

-(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}


//每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return count;
    
}

//表的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//定义分区的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"图片管理器";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [self customCellWithOutXib:tableView withIndexPath:indexPath];
    assert(cell != nil);
    return cell;
}

//修改行高度的位置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//通过代码自定义cell
-(UITableViewCell *)customCellWithOutXib:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    //定义标识符
    static NSString *customCellIndentifier = @"CustomCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellIndentifier];
    
    //定义新的cell
    if(cell == nil){
        //使用默认的UITableViewCell,但是不使用默认的image与text，改为添加自定义的控件
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellIndentifier];
        
        /*
         CGRect nameeTipRect = CGRectMake(35, 20, 60, 14);
         UILabel *nameeLabel = [[UILabel alloc]initWithFrame:nameeTipRect];
         nameeLabel.text = @"公司号码：";
         nameeLabel.font = [UIFont boldSystemFontOfSize:fontSize];
         [cell.contentView addSubview:nameeLabel];
         */
        
        //姓名
        CGRect nameRect = CGRectMake(20, 10, 300, 25);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:nameRect];
        nameLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        nameLabel.tag = nameTag;
        nameLabel.textColor = [UIColor brownColor];
        [cell.contentView addSubview:nameLabel];
        
        
        //按钮
        UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button4.frame = CGRectMake(300, 3, 60,50);
        [button4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button4.backgroundColor = [UIColor yellowColor];
        [button4 setTitle:@"删除" forState:UIControlStateNormal];
        [button4 addTarget:self action:@selector(myBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button4];
        
    }
    //获得行数
    NSUInteger row = [indexPath row];
    
    
    
    //取得相应行数的数据（NSDictionary类型，包括姓名、班级、学号、图片名称）
    NSDictionary *dic = [_stuArray1 objectAtIndex:row];
    
    NSLog(@"%@",dic);
    
    
    //设置图片
    //UIImageView *imageV = (UIImageView *)[cell.contentView viewWithTag:imageTag];
    //imageV.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    
    //设置姓名
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:nameTag];
    name.text = [dic objectForKey:@"signforid"];
    
    
    
    //设置右侧箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)erweima
{
    NSLog(@"shangchuan");
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        [self btnActionForUserSetting: self.listphoto];
        
    }
}
- (void)btnActionForUserSetting:(id) sender {
    
    NSIndexPath *indexPath = [self.listphoto indexPathForSelectedRow];
    
    UITableViewCell *cell = [self.listphoto cellForRowAtIndexPath: indexPath];
    
    UIView *dddd;
    dddd = [cell viewWithTag:1];
    UILabel *label = (UILabel *)dddd;
    openpicname = label.text;
    //cell.textLabel.text;
    //cell.textLabel.text = @"abc";
    NSLog(@"%@",openpicname);
    
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"openpic"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
    
    
}

+(NSString *)chuanpicname
{
    return openpicname;
}


-(void)myBtnClick:(id)sender event:(id)event//删除按钮
{
    NSSet *touches = [event allTouches];   // 把触摸的事件放到集合里
    
    UITouch *touch = [touches anyObject];   //把事件放到触摸的对象了
    
    CGPoint currentTouchPosition = [touch locationInView:self.listphoto]; //把触发的这个点转成二位坐标
    
    NSIndexPath *indexPath = [self.listphoto indexPathForRowAtPoint:currentTouchPosition]; //匹配坐标点
    if(indexPath !=nil)
    {
        //[selftableView:self.tableviewaccessoryButtonTappedForRowWithIndexPath:indexPath];
        //NSLog(@"shangchuan");
        
        zuobiao = indexPath;
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除照片吗？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        
        [self.view addSubview:alter];
        
        alter.delegate  = self;
        [alter show];
        
        alter.tag=1;
        
        //[self deletepic:indexPath];
    }
    /*
     UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"picmanage"];
     childVC.hidesBottomBarWhenPushed = YES;
     [self presentViewController:childVC animated:YES completion:nil];
     */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    
    // the user clicked OK
    if(alertView.tag==1)
    {
        
        if (buttonIndex == 0)
            
        {
            
            //do something here...
            [self deletepic:zuobiao];
            
            UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"picmanage"];
            childVC.hidesBottomBarWhenPushed = YES;
            [self presentViewController:childVC animated:NO completion:nil];
            
        }
    }
    else
    {
        if (buttonIndex == 0)
            
        {
            
            //do something here...
            [self deleteallpic];
            
            UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"picmanage"];
            childVC.hidesBottomBarWhenPushed = YES;
            [self presentViewController:childVC animated:NO completion:nil];
            
        }
        
    }
    
}




-(void)deletepic:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *deletecell = [self.listphoto cellForRowAtIndexPath: indexPath];
    
    UIView *deleteview;
    deleteview = [deletecell viewWithTag:1];
    UILabel *deletelabel = (UILabel *)deleteview;
    NSString *deletepicname = deletelabel.text;
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:
                          deletepicname];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
            
            UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"picmanage"];
            childVC.hidesBottomBarWhenPushed = YES;
            [self presentViewController:childVC animated:NO completion:nil];
            
        }else {
            NSLog(@"dele fail");
        }
        
    }
    
    
}

- (IBAction)deleteall:(id)sender {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除所有照片吗？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    
    [self.view addSubview:alter];
    
    alter.delegate  = self;
    [alter show];
    alter.tag=2;
}




-(void)deleteallpic
{
    
    
    for (NSIndexPath *cellIndex in [self.listphoto indexPathsForVisibleRows])
    {
        UITableViewCell *otherCell = [self.listphoto cellForRowAtIndexPath:cellIndex];
        UIView *deleteview;
        deleteview = [otherCell viewWithTag:1];
        UILabel *deletelabel = (UILabel *)deleteview;
        NSString *deletepicname = deletelabel.text;
        
        NSFileManager* fileManager=[NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        
        
        //文件名
        NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:
                              deletepicname];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (!blHave) {
            NSLog(@"no  have");
            return ;
        }else
        {
            NSLog(@" have");
            BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
            if (blDele)
            {
                NSLog(@"dele success");
            }else
            {
                NSLog(@"dele fail");
            }
        }
    }
    
}





@end
