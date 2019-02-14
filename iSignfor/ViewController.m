//
//  ViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "ViewController.h"
#import "GDataXMLNode.h"
#import "networkcheckViewController.h"
#import "linkViewController.h"
#import "AppDelegate.h"


#define kScreenHeightt [[UIScreen mainScreen] bounds].size.height      //屏幕高度
#define kScreenWidthh [[UIScreen mainScreen] bounds].size.width      //屏幕宽度

@interface ViewController ()

@end

NSString *theXML;

NSString *nametext;
NSString *passwordtext;
NSString *chuanzhimingchen;
NSString *chuanuserid;

UITextField *namee;
UITextField *passwordd;

int version = 7;

@implementation ViewController

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (version < [AppDelegate sendversion])
    {
        if ([[AppDelegate sendneeds] isEqualToString:@"yes"])
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[AppDelegate sendmemo]
            delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            alter.tag=1;
        }
        
        else
        {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[AppDelegate sendmemo]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        
        [self.view addSubview:alter];
        
        alter.delegate  = self;
        [alter show];
        alter.tag=1;
        }
    }
    
    
    
    //初始化textfield并设置位置及大小
    namee = [[UITextField alloc]initWithFrame:CGRectMake((kScreenWidthh/2)-140, (kScreenHeightt/4)+15, 280, 50)];
    //设置边框样式，只有设置了才会显示边框样式
    namee.borderStyle = UITextBorderStyleRoundedRect;
    //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
    namee.backgroundColor = [UIColor whiteColor];
    //当输入框没有内容时，水印提示 提示内容为password
    namee.placeholder = @"账号";
    //设置输入框内容的字体样式和大小
    namee.font = [UIFont fontWithName:@"Arial" size:45.0f];
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    namee.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:namee];
    
    
    //初始化textfield并设置位置及大小
    passwordd = [[UITextField alloc]initWithFrame:CGRectMake((kScreenWidthh/2)-140, (kScreenHeightt/4)+70, 280, 50)];
    //设置边框样式，只有设置了才会显示边框样式
    passwordd.borderStyle = UITextBorderStyleRoundedRect;
    //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
    passwordd.backgroundColor = [UIColor whiteColor];
    //当输入框没有内容时，水印提示 提示内容为password
    passwordd.placeholder = @"密码";
    //设置输入框内容的字体样式和大小
    passwordd.font = [UIFont fontWithName:@"Arial" size:45.0f];
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    passwordd.clearButtonMode = UITextFieldViewModeAlways;
    //每输入一个字符就变成点 用语密码输入
    passwordd.secureTextEntry = YES;
    [self.view addSubview:passwordd];

    UIButton *denglu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    denglu.frame = CGRectMake((kScreenWidthh/2)-50, (kScreenHeightt/4)+130, 100, 45);
    [denglu setTitle:@"登陆" forState:UIControlStateNormal];
    denglu.titleLabel.font = [UIFont systemFontOfSize: 40.0f];
    [denglu addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:denglu];
    
    
    
    /////////////账号密码//////////////////
    
    //_password.secureTextEntry = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name"];
    NSString *password = [defaults objectForKey:@"password"];
    //int age = [defaults integerForKey:@"age"];
    //NSString *ageString = [NSString stringWithFormat:@"%i", age];
    
    namee.text = name;
    passwordd.text = password;
    
    /////////////账号密码//////////////////
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    // the user clicked OK
    if(alertView.tag==1)
    {
        if (buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://www.gzmpc.com/phoneapp/ios/iSignfor.plist"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)login
{
    if ([[networkcheckViewController network] isEqualToString:@"yes"])
    {
        //_name.text=@"16233";
        //_password.text=@"16233";
        
        if (version < [AppDelegate sendversion]&&[[AppDelegate sendneeds] isEqualToString:@"yes"])
        {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"版本过低，请务必更新后再用！"
                                                               delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                [self.view addSubview:alter];
                
                alter.delegate  = self;
                [alter show];
                alter.tag=1;
        }
        else
        {
        nametext = namee.text;
        //NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaa%@",namee.text);
        passwordtext = passwordd.text;
        //NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaa%@",passwordd.text);
        // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
        matchingElement = @"getMobileCodeInfoResult";
        // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分
        NSString *soapMsg = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             // "<soap12:Envelope "
                             
                             "<soapenv:Envelope "
                             "xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" "
                             "xmlns:log=\"http://login.czl.com/\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<log:s2login>"
                             "<arg0>%@</arg0>"
                             "<arg1>%@</arg1>"
                             "</log:s2login>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>",nametext,passwordtext];
        
        // 将这个XML字符串打印出来
        NSLog(@"%@", soapMsg);
        // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
        NSURL *url = [NSURL URLWithString: [linkViewController viewcontrollerlogin]];//@"http://125.88.8.30:8887/AndroidWebservice/signforLoginPort"
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
        conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        if (conn) {
            webData = [NSMutableData data];
            NSLog(@"HELLO");
        }
        
    }

}
}

// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData setLength: 0];
    NSLog(@"connection didReceiveResponse");
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    //[webData appendData:data];
    NSLog(@"connection didReceiveData");
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", str);//得到想要的XML字符串然后解析
    //_textview.text=str;
    theXML = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    theXML = str;
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn = nil;
    webData = nil;
    NSLog(@"connection didFailWithError");
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败，请重新连接！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    // NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
    //    length:[webData length]
    // encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML);
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    NSLog(@"connectionDidFinishLoading");
    [self jiexi];
}


-(void)jiexi
{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:theXML options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
    NSString *gen = [ rootElement stringValue];
    //NSLog(@"%@",gen);
    //GDataXMLElement *users = [rootElement elementsForName:@"S:Envelope"];
    GDataXMLElement *third = [[rootElement elementsForName:@"S:Body"]objectAtIndex:0];
    NSString *gen2 = [ third stringValue];
    //NSLog(@"%@",gen2);
    //NSLog(@"1");
    
    GDataXMLElement *forth = [[third elementsForName:@"ns2:s2loginResponse"]objectAtIndex:0];
    NSString *b=[forth stringValue];
    //NSLog(@"%@",b);
    //NSLog(@"qian");
    
    //for (GDataXMLElement *user in forth)
    //{
    //User节点的id属性
    GDataXMLElement *name = [[forth elementsForName:@"return"] objectAtIndex:0];
    NSString *a=[name stringValue];
    //NSLog(@"%@",a);
    //NSLog(a);
    //NSLog(@"print");
    NSArray *c = [a componentsSeparatedByString:@","];
    NSString *com = [c objectAtIndex:0];
    NSLog(@"%@",com);
    
    if ([com isEqualToString:nametext])
    {
        /////////////账号密码//////////////////
        
        [namee resignFirstResponder];
        [passwordd resignFirstResponder];
        
        NSString *name1 = namee.text;
        NSString *password1 = passwordd.text;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:name1 forKey:@"name"];
        [defaults setObject:password1 forKey:@"password"];
        //[defaults setInteger:age forKey:@"age"];
        
        [defaults synchronize];

        /////////////账号密码//////////////////
        
        chuanzhimingchen = [c objectAtIndex:1];
        chuanuserid = [c objectAtIndex:0];
        
       // NSLog(@"%@",chuanzhimingchen);
       // NSLog(@"%@",chuanuserid);
        
        
        [self jump];
    }
    
    else if ([com isEqualToString:@"without permission"])
    {
        UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此账号没有权限，请联系管理员！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alter1 show];
    }
    
    else
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息有误，请重新登陆！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alter show];
    }
    
    //NSLog(@"%@",[c objectAtIndex:0]);
    //NSLog(@"%@",[c objectAtIndex:1]);
    
    
    //NSLog(@"-------------------");
    //}
    
    
}

-(void)jump
{
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shouye"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}

+(NSString *)chuanzhi
{
    NSString *chuan = chuanzhimingchen;//传姓名
    return chuan;
}

+(NSString *)chuanuserid
{
    return chuanuserid;//传用户id
}


@end
