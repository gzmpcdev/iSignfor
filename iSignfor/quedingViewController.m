//
//  quedingViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "quedingViewController.h"
#import "signidViewController.h"
#import "GDataXMLNode.h"
#import "takephotoViewController.h"
#import "networkcheckViewController.h"
#import "linkViewController.h"

@interface quedingViewController ()

@end

NSString *stra;

UIImage *chuanpic;

NSString *picname1;

static int picflag;//用于判断图片是那个页面照的

NSString *theXML4;

NSString *status,*remarks,*title;

NSString *getpiccount;//用于判断图片数量，来判断能否确定。
NSString *getsignstatus;//用于判断签收状态，来判断能否确定。
int getimgcount;//用于传输图片数量和比较，最后显示出来;///////////+++++++++++++++++++++++++

@implementation quedingViewController

@synthesize stuArray = _stuArray;
NSMutableArray *myMutableArray;


@synthesize webData4;
@synthesize soapResults4;
@synthesize xmlParser4;
@synthesize elementFound4;
@synthesize matchingElement4;
@synthesize conn4;
static int failpiccount;


- (void)viewDidLoad {
    
    
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    self.data = [NSMutableArray new];
    
    _chuanid.text = [signidViewController chuanqianshoudan];
    
    stra = [signidViewController chaxunchuanzhi];
    NSLog(@"%@",stra);
    
    NSData *b = [stra dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:b options:kNilOptions error:nil];
    
    //NSLog(@"111111");
    
    
    NSArray *json2 = [json objectForKey:@"signfordata"];
    
    NSDictionary *dic = [json2 objectAtIndex:0];
    NSString * lat = [dic objectForKey:@"consignor"];//货主
    NSString *bing = [@"货主：" stringByAppendingString:lat];
    NSLog(@"%@",lat);
    NSString * lat1 = [dic objectForKey:@"appsignforflag"];//是否签收了，1为已签收，0为未签收
    
    getsignstatus=lat1;
    NSLog(@"%@",getsignstatus);
    if ([lat1 isEqualToString:@"0"])
    {
        lat1=@"未签收";
    }
    else
    {
        lat1=@"已签收";
    }
    NSString *bing1 = [@"签收状态：" stringByAppendingString:lat1];
    NSLog(@"%@",lat1);
    NSString * lat2 = [dic objectForKey:@"signforid"];//签收单id
    NSLog(@"%@",lat2);
    NSString * lat3 = [dic objectForKey:@"printname"];//客户
    NSString *bing3 = [@"客户：：" stringByAppendingString:lat3];
    NSLog(@"%@",lat3);
    NSString * lat4 = [dic objectForKey:@"sopos"];//地址
    NSString *bing4 = [@"地址：" stringByAppendingString:lat4];
    NSLog(@"%@",lat4);
    NSString * lat5 = [dic objectForKey:@"totalcase"];//总件数
    NSString *bing5 = [@"总件数：" stringByAppendingString:lat5];
    NSLog(@"%@",lat5);
    NSString * lat6 = [dic objectForKey:@"coldcase"];//冷藏件数
    NSString *bing6 = [@"冷藏件数：" stringByAppendingString:lat6];
    NSLog(@"%@",lat6);
    NSString * lat7 = [dic objectForKey:@"mj2ffzjcase"];//二类件数
    NSString *bing7 = [@"二类件数：" stringByAppendingString:lat7];
    NSLog(@"%@",lat7);
    NSString * lat8 = [dic objectForKey:@"recmoney"];//货到收款金额，0为非货到收款，有数字的话，该数字就是收款金额
    if ([lat8 isEqualToString:@"0"])
    {
        lat8 = @"非货到收款";
    }
    NSString *bing8 = [@"货到收款金额：" stringByAppendingString:lat8];
    NSLog(@"%@",lat8);
    NSString * lat9 = [dic objectForKey:@"imgcnt"];//图片数
    getpiccount = lat9;
    
    getimgcount = [lat9 intValue];///////////+++++++++++++++++++++++++
    
    if ([signidViewController returnchushihua]==1)
    {
        NSLog(@"%d",[takephotoViewController chuanallimgcount]);
        
        if (getimgcount<[takephotoViewController chuanallimgcount])
        {
            NSLog(@"%d",[takephotoViewController chuanallimgcount]);
            getimgcount=[takephotoViewController chuanallimgcount];
            getpiccount = @"1";
        }
        
    }
    
    
    NSLog(@"%@",lat9);
    
    
    //NSNumber* lng = [locationDic objectForKey:@"lng"];
    
    
    
    //NSString *text = [NSString stringWithFormat:@"今天是 %@ ",[json2 objectForKey:@"consignor"]];
    // NSLog(@"weatherInfo：%@", json2[@"consignor"]);
    
    /*
     NSArray *c = [gen2 componentsSeparatedByString:@"{"];
     //NSLog(@"%@",[c objectAtIndex:0]);
     NSLog(@"%@",[c objectAtIndex:2]);
     */
    
    
    NSLog(@"-------------------");
    //}
    
    lat9 = [NSString stringWithFormat:@"%d",getimgcount];
    
    
    NSString *bing9 = [@"图片数：" stringByAppendingString:lat9];
    
    
    [self.data addObject:bing3];
    [self.data addObject:bing4];
    [self.data addObject:bing];
    [self.data addObject:bing5];
    [self.data addObject:bing6];
    [self.data addObject:bing7];
    [self.data addObject:bing8];
    [self.data addObject:bing1];
    [self.data addObject:bing9];
    
    NSLog(@"%@",self.data);

    
    NSDictionary *dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"consignor",lat1,@"appsignforflag",lat2,@"signforid",lat3,@"printname",lat4,@"sopos",lat5,@"totalcase",lat6,@"coldcase",lat7,@"mj2ffzjcase",lat8,@"recmoney",lat9,@"imgcnt", nil];
    
    //dic2 = [NSDictionary dictionaryWithObjectsAndKeys:latd,@"signforid",latd1,@"printname",latd2,@"appsignfordate", nil];
    
    NSLog(@"dic1%@",dic1);
    
    //[_stuArray arrayByAddingObject:dic1];
    //_stuArray=[NSArray arrayWithObject:dic1];
    
    //ar = [ NSArray arrayWithObject:dic1];
    
    //mutableArray = [NSMutableArray arrayWithObject:dic1];
    
    _stuArray = [[NSArray alloc]initWithObjects:dic1, nil];
    
     myMutableArray=[_stuArray mutableCopy];
    
    NSLog(@"%@",myMutableArray);
    
    
    
    //[self.tableview reloadData];
    
    
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





//每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
    
}

//表的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Datasource asked for cell at index path (%ld, %ld)", (long)indexPath.section, (long)indexPath.row);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellIndentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomCellIndentifier"];
        //cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    
    
    cell.textLabel.numberOfLines=0;
    
    if (self.data!=NULL) {
        cell.textLabel.text = self.data[indexPath.row];
    }
    
    return cell;
}


/*
 //定义分区的标题
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 return @"签收单信息：";
 }
 */

/*////////////////////////////////-------------------------------////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [self customCellWithOutXib:tableView withIndexPath:indexPath];
    assert(cell != nil);
    return cell;
}

//修改行高度的位置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
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
        
        
        CGRect nameeTipRect = CGRectMake(10, 20, 60, 14);
        UILabel *nameeLabel = [[UILabel alloc]initWithFrame:nameeTipRect];
        nameeLabel.text = @"客户：";
        nameeLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:nameeLabel];
        
        
        //客户
        CGRect nameRect = CGRectMake(75, 15, 250, 25);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:nameRect];
        nameLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        nameLabel.tag = nameTag;
        //nameLabel.textColor = [UIColor brownColor];
        [cell.contentView addSubview:nameLabel];
        */////////////////////////////////-------------------------------////////////////////////////////////
        
        /*
        //地址
        CGRect classTipRect = CGRectMake(10, 55, 60, 14);
        UILabel *classTipLabel = [[UILabel alloc]initWithFrame:classTipRect];
        classTipLabel.text = @"地址：";
        classTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:classTipLabel];
        */

        /*////////////////////////////////-------------------------------////////////////////////////////////
        CGRect classRect = CGRectMake(9, 55, 300, 14);
        UILabel *classLabel = [[UILabel alloc]initWithFrame:classRect];
        classLabel.tag = adressTag;
        classLabel.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:classLabel];
        
        
        //货主
        CGRect stuNameTipRect = CGRectMake(10, 90, 300, 12);
        UILabel *stuNameTipLabel = [[UILabel alloc]initWithFrame:stuNameTipRect];
        stuNameTipLabel.text = @"货主：";
        stuNameTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:stuNameTipLabel];
        
        CGRect stuNameRect = CGRectMake(72, 90, 350, 14);
        UILabel *stuNameLabel = [[UILabel alloc]initWithFrame:stuNameRect];
        stuNameLabel.tag = consignorTag;
        stuNameLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [cell.contentView addSubview:stuNameLabel];
        
        
        //总件数
        CGRect totalcaseTipRect = CGRectMake(10, 125, 160, 12);
        UILabel *totalcaseTipLabel = [[UILabel alloc]initWithFrame:totalcaseTipRect];
        totalcaseTipLabel.text = @"总件数：";
        totalcaseTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:totalcaseTipLabel];
        
        CGRect totalcaseRect = CGRectMake(85, 125, 150, 14);
        UILabel *totalcaseLabel = [[UILabel alloc]initWithFrame:totalcaseRect];
        totalcaseLabel.tag = totalcaseTag;
        totalcaseLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        
        [cell.contentView addSubview:totalcaseLabel];
        
        
        //冷藏件数
        CGRect coldcaseTipRect = CGRectMake(10, 160, 160, 12);
        UILabel *coldcaseTipLabel = [[UILabel alloc]initWithFrame:coldcaseTipRect];
        coldcaseTipLabel.text = @"冷藏件数：";
        coldcaseTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:coldcaseTipLabel];
        
        CGRect coldcaseRect = CGRectMake(100, 160, 150, 14);
        UILabel *coldcaseLabel = [[UILabel alloc]initWithFrame:coldcaseRect];
        coldcaseLabel.tag = coldcaseTag;
        coldcaseLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        
        [cell.contentView addSubview:coldcaseLabel];
        
        
        
        //二类件数
        CGRect mj2ffzjcaseTipRect = CGRectMake(10, 195, 160, 12);
        UILabel *mj2ffzjcaseTipLabel = [[UILabel alloc]initWithFrame:mj2ffzjcaseTipRect];
        mj2ffzjcaseTipLabel.text = @"二类件数：";
        mj2ffzjcaseTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:mj2ffzjcaseTipLabel];
        
        CGRect mj2ffzjcaseRect = CGRectMake(100, 195, 150, 14);
        UILabel *mj2ffzjcaseLabel = [[UILabel alloc]initWithFrame:mj2ffzjcaseRect];
        mj2ffzjcaseLabel.tag = mj2ffzjcaseTag;
        mj2ffzjcaseLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        
        [cell.contentView addSubview:mj2ffzjcaseLabel];
        
        
        //货到收款金额
        CGRect recmoneyTipRect = CGRectMake(10, 230, 160, 12);
        UILabel *recmoneyTipLabel = [[UILabel alloc]initWithFrame:recmoneyTipRect];
        recmoneyTipLabel.text = @"货到收款金额：";
        recmoneyTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:recmoneyTipLabel];
        
        CGRect recmoneyRect = CGRectMake(150, 230, 150, 14);
        UILabel *recmoneyLabel = [[UILabel alloc]initWithFrame:recmoneyRect];
        recmoneyLabel.tag = recmoneyTag;
        recmoneyLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        
        [cell.contentView addSubview:recmoneyLabel];
        
        
        //签收状态
        CGRect appsignforflagTipRect = CGRectMake(10, 265, 160, 12);
        UILabel *appsignforflagTipLabel = [[UILabel alloc]initWithFrame:appsignforflagTipRect];
        appsignforflagTipLabel.text = @"签收状态：";
        appsignforflagTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:appsignforflagTipLabel];
        
        CGRect appsignforflagRect = CGRectMake(110, 265, 150, 14);
        UILabel *appsignforflagLabel = [[UILabel alloc]initWithFrame:appsignforflagRect];
        appsignforflagLabel.tag = appsignforflagTag;
        appsignforflagLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        
        [cell.contentView addSubview:appsignforflagLabel];
        
        
        //图片数
        CGRect imgcntTipRect = CGRectMake(10, 300, 160, 12);
        UILabel *imgcntTipLabel = [[UILabel alloc]initWithFrame:imgcntTipRect];
        imgcntTipLabel.text = @"图片数：";
        imgcntTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:imgcntTipLabel];
        
        CGRect imgcntRect = CGRectMake(85, 300, 150, 14);
        UILabel *imgcntLabel = [[UILabel alloc]initWithFrame:imgcntRect];
        imgcntLabel.tag = imgcntTag;
        imgcntLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        
        [cell.contentView addSubview:imgcntLabel];
        
    }
    //获得行数
    NSUInteger row = [indexPath row];
    
    
    
    //取得相应行数的数据（NSDictionary类型，包括姓名、班级、学号、图片名称）
    NSDictionary *dic = [_stuArray objectAtIndex:row];
    
    NSLog(@"%@",dic);
    
    
    //设置客户
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:nameTag];
    name.text = [dic objectForKey:@"printname"];
    
    
    //设置地址
    UILabel *adress = (UILabel *)[cell.contentView viewWithTag:adressTag];
    adress.text = [dic objectForKey:@"sopos"];
    
    //设置货主
    UILabel *consignor = (UILabel *)[cell.contentView viewWithTag:consignorTag];
    consignor.text = [dic objectForKey:@"consignor"];
    
    //设置总件数
    UILabel *totalcase = (UILabel *)[cell.contentView viewWithTag:totalcaseTag];
    totalcase.text = [dic objectForKey:@"totalcase"];
    
    
    //设置冷藏件数
    UILabel *coldcase = (UILabel *)[cell.contentView viewWithTag:coldcaseTag];
    coldcase.text = [dic objectForKey:@"coldcase"];
    
    
    //设置二类件数
    UILabel *mj2ffzjcase = (UILabel *)[cell.contentView viewWithTag:mj2ffzjcaseTag];
    mj2ffzjcase.text = [dic objectForKey:@"mj2ffzjcase"];
    
    
    //设置货到收款金额
    UILabel *recmoney = (UILabel *)[cell.contentView viewWithTag:recmoneyTag];
    recmoney.text = [dic objectForKey:@"recmoney"];
    
    
    //设置签收状态
    UILabel *appsignforflag = (UILabel *)[cell.contentView viewWithTag:appsignforflagTag];
    appsignforflag.text = [dic objectForKey:@"appsignforflag"];
    
    
    //设置图片数
    UILabel *imgcnt = (UILabel *)[cell.contentView viewWithTag:imgcntTag];
    imgcnt.text = [dic objectForKey:@"imgcnt"];
    
    //自动换行，这里最重要
    //cell.textLabel.numberOfLines = 0;
    
    //设置右侧箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
*/////////////////////////////////-------------------------------////////////////////////////////////

- (IBAction)chaxuncamera:(id)sender
{
    
    
    //------------------------------------------------------------------------------------
    
    //获取当前时间
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"hh:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
    NSArray *jiequ;
    
    NSString *shijian;
    
    jiequ = [locationString componentsSeparatedByString:@":"];//nsarray
    //NSString *com = [cutresult objectAtIndex:0];
    
    //NSData *arry2data = [NSKeyedArchiver archivedDataWithRootObject:cutresult];
    
    //NSLog(@"%@",[jiequ objectAtIndex:0]);
    
    shijian = [[jiequ objectAtIndex:0] stringByAppendingString:[jiequ objectAtIndex:1]];
    
    shijian = [shijian stringByAppendingString:[jiequ objectAtIndex:2]];
    
    NSLog(@"%@",shijian);
    
    
    //-------------------------------------------------------------------------------------
    
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //获取照片名称
    NSString *signidd;
    NSString *fuhao;
    NSString *fuhao1;
    signidd = [signidViewController chuanqianshoudan];
    fuhao=@"_";
    fuhao1=@".jpg";
    picname1 = [signidd stringByAppendingString:fuhao];
    picname1 = [picname1 stringByAppendingString:shijian];
    picname1 = [picname1 stringByAppendingString:fuhao1];
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    

    
    
     UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
     UIImagePickerController *picker = [[UIImagePickerController alloc]init];
     picker.delegate = self;
     picker.allowsEditing = NO;
     picker.sourceType = sourceType;
     //[self presentModalViewController:picker animated:YES];
     [self presentViewController:picker animated:YES completion:^{
     NSLog(@"OK");
     }];
     
     //[picker release];
     }
     else {
     NSLog(@"模拟其中无法打开照相机，请在真机中使用");
     UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
     message:@"Device has no camera"
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles: nil];
     
     [myAlertView show];
     
     }
     
    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
     */
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];///////////////++++++++++//////////////
    chuanpic = chosenImage;
    
    picflag=1;
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"image"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
    
    
        
    
    //-------------------------------------------------------------------------------------
    //保存进沙盒
    
    chosenImage = [self rotateImage:chosenImage];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:picname1];   // 保存文件的名称
    [UIImagePNGRepresentation(chosenImage)writeToFile: filePath    atomically:YES];
    
    [self savetosandbox];
    
    NSLog(@"%@",filePath);
    
    //-------------------------------------------------------------------------------------
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




- (IBAction)backqian:(id)sender {
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signid"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}




+(UIImage *)chuanpics//图片
{
    
    return chuanpic;
}


-(void)savetosandbox
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *filePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:picname1];   // 保存文件的名称
    
    NSLog(@"%@",filePath);
    [info setObject:filePath forKey:@"img"];
    
}




+(NSString *)chuanpicname
{
    return picname1;
}

+(int)chuanpicflag
{
    return picflag;
}




// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData4 setLength: 0];
    NSLog(@"connection didReceiveResponse");
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    //[webData appendData:data];
    NSLog(@"connection didReceiveData");
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"4444444444444444444444%@", str);//得到想要的XML字符串然后解析
    //_textview.text=str;
    theXML4 = [[NSString alloc] initWithBytes:[webData4 mutableBytes] length:[webData4 length] encoding:NSUTF8StringEncoding];
    theXML4 = str;
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn4 = nil;
    webData4 = nil;
    NSLog(@"connection didFailWithError");
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败，请再试一次！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    // NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
    //    length:[webData length]
    // encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML4);
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser4 = [[NSXMLParser alloc] initWithData: webData4];
    [xmlParser4 setDelegate: self];
    [xmlParser4 setShouldResolveExternalEntities: YES];
    [xmlParser4 parse];
    NSLog(@"connectionDidFinishLoading");
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    /**
     创建本地通知对象
     */
    
    //UILocalNotification *localnotification = [[UILocalNotification alloc]init];
    /**
     *  设置推送的相关属性
     */
    //localnotification.fireDate = [NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]];//通知触发时间
    //localnotification.alertBody = @"确定成功！";//通知具体内容
    //localnotification.alertTitle = @"notice";//谁发出的通知
    //localnotification.soundName = UILocalNotificationDefaultSoundName;//通知时的音效
    //localnotification.alertAction = @"滑动并查看";//默认为 滑动来 +查看;锁屏时显示底部提示
    /**
     *  调度本地通知,通知会在特定时间发出
     */
    //[[UIApplication sharedApplication] scheduleLocalNotification:localnotification];//在系统Notification处理队列中登记已设置完的UILocalNotification对象
    //[[UIApplication sharedApplication] presentLocalNotificationNow:localnotification];//立即发出本通知
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signid"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];

}


+(int)chuanfailpiccount
{
    return failpiccount;
}





- (IBAction)queding:(id)sender
{
    
    if ([[networkcheckViewController network] isEqualToString:@"yes"])
    {
        if ([getpiccount isEqualToString: @"0"])
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"请先拍照！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
            [self.view addSubview:alter];
        
            alter.delegate  = self;
            [alter show];
        
        }
        else
        {
            NSLog(@"%@",getsignstatus);
            if ([getsignstatus isEqualToString:@"0"])
            {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请选择收获情况" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"全部签收",@"部分拒收",@"全部拒收",@"不能送达",nil];
            
                [self.view addSubview:alter];
            
                alter.delegate  = self;
                [alter show];
                alter.tag=1;
            }
        
        }
        }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    // the user clicked OK
    if(alertView.tag==1)
    {
        
        if (buttonIndex == 1)
            
        {
            
            //do something here...
            status = @"suc";
            remarks = @"";
            title = @"全部签收";
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=2;
            
        }
        
        if (buttonIndex == 2)
        {
            status = @"partsuc";
            remarks=@"";
            title = @"部分拒收";
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=2;
            
        }
        
        if (buttonIndex == 3)
        {
            status = @"fial";
            remarks=@"";
            title = @"全部拒收";
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=2;
        }
        
        if (buttonIndex == 4)
        {
            status = @"cant";
            title = @"不能送达";
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"时间原因",@"无人收货",@"地址不符",@"仓库原因",@"其他",nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=3;
        }
        
        
        
    }
    
    if(alertView.tag==2)
    {
        if (buttonIndex == 0)
        {
            [self signqueding];
            
        }
        
    }
    
    if(alertView.tag==3)
    {
        if (buttonIndex == 1)
        {
            remarks = @"时间原因";
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"由于时间原因而不能送达？" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=2;
            
        }
        if (buttonIndex == 2)
        {
            remarks = @"无人收货";
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"由于无人收货而不能送达？" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=2;
        }
        if (buttonIndex == 3)
        {
            remarks = @"地址不符";
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"由于地址不符而不能送达？" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=2;
        }
        if (buttonIndex == 4)
        {
            remarks = @"仓库原因";
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"由于仓库原因而不能送达？" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=2;
        }
        if (buttonIndex == 5)
        {
            //自己定义一个UITextField添加上去，后来发现ios5自带了此功能
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入其他原因" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * txt = [[UITextField alloc] init];
            txt.backgroundColor = [UIColor whiteColor];
            txt.frame = CGRectMake(alert.center.x+65,alert.center.y+48, 150,23);
            //txt.frame = CGRectMake(1,1, 150,23);
            alert.delegate = self;
            [alert addSubview:txt];
            [alert show];
            
            alert.tag=4;
        }
        
        
    }
    
    if(alertView.tag==4)
    {
        if (buttonIndex == 0)
        {
            //得到输入框
            UITextField *tf=[alertView textFieldAtIndex:0];
            remarks = tf.text;
            NSLog(@"%@",remarks);
            [self signqueding];//UIAlertController
            
            
        }
    }
    
    
}




-(void)signqueding
{
    // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
    matchingElement4 = @"getMobileCodeInfoResult";
    // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soapenv:Envelope "
                         "xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" "
                         "xmlns:sig=\"http://signfor.czl.com/\">"
                         "<soapenv:Header/>"
                         "<soapenv:Body>"
                         "<sig:signfordealHasReaon>"
                         //<!--Optional:-->
                         "<arg0>%@</arg0>"//签收单列表，以逗号分隔
                         //<!--Optional:-->
                         "<arg1>%@</arg1>"//确认操作码（suc-签收成功,fial-签收失败,partsuc-签收部分成功,cant-不能送达）
                         //<!--Optional:-->
                         "<arg2>%@</arg2>"//用户ID
                         //<!--Optional:-->
                         "<arg3>%@</arg3>"//用户名
                         //<!--Optional:-->
                         "<arg4>%@</arg4>"//失败的原因，成功的置“”
                         "</sig:signfordealHasReaon>"
                         "</soapenv:Body>"
                         "</soapenv:Envelope>",[signidViewController chuanqianshoudan],status,[ViewController chuanuserid],[ViewController chuanzhi],remarks];
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMsg);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString: [linkViewController quedingviewcontroller]];//@"http://125.88.8.30:8887/AndroidWebservice/SingforBAPort"
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    // 创建连接
    conn4 = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn4) {
        webData4 = [NSMutableData data];
        NSLog(@"HELLO");
    }
    
}


+(int)chuanimgcount///////////+++++++++++++++++++++++++
{
    return getimgcount;
}


- (int)panduanimg:(UIImage *)imgSrc//判断
{
    
    CGSize imageSize = imgSrc.size;
    CGFloat width  = imageSize.width;
    CGFloat height = imageSize.height;
    if (width<height)
    {
        return 1;
    }

    else
    {
        return 0;
    }
}

- (UIImage*)rotateImage:(UIImage *)image//旋转
{
    int kMaxResolution = 960; // Or whatever
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


@end
