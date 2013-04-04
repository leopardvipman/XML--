//
//  ViewController.m
//  XML解析
//
//  Created by wang yongfeng on 13-3-7.
//  Copyright (c) 2013年 wang yongfeng. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize tabView,titleArr,contentArr;

//xml解析
static NSString *feedURLString = @"http://rss.news.sohu.com/rss/guonei.xml";
//static NSString *feedURLString = @"http://rss.sina.com.cn/news/allnews/auto.xml";


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    // 解析开始时的处理
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    // 解析完成时的处理
    [self.view addSubview:tabView];
}

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError *)error
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        
    }
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    // 元素开始句柄
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"item"]) {
        // 输出属性值
        start=1;
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    // 元素终了句柄
    if (qName) {
        elementName = qName;
        
    }
    if (start==1) {
        if ([elementName isEqualToString:@"title"]) {
            // 输出属性值
            value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [titleArr addObject:value];
            value=@"";
        }
        if ([elementName isEqualToString:@"link"]) {
            value=@"";
        }
        if ([elementName isEqualToString:@"description"]) {
            value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [contentArr addObject:value];
            value=@"";
        }
        if ([elementName isEqualToString:@"category"]) {
            value=@"";
        }
        if ([elementName isEqualToString:@"author"]) {
            value=@"";
        }
        if ([elementName isEqualToString:@"pubDate"]) {
            value=@"";
        }
        if ([elementName isEqualToString:@"comments"]) {
            value=@"";
        }



    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // 取得元素的text
    if (start==1) {
        value=[NSString stringWithFormat:@"%@%@",value,string];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:232.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.navigationItem.title=@"汽车资讯";
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
    } completion:^(BOOL finished) {
        [self Resolve];
    }];
}
-(void)Resolve{
    titleArr=[[NSMutableArray alloc]init];
    contentArr=[[NSMutableArray alloc]init];
    tabView=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tabView.frame=self.view.frame;
    //UITableViewStyleGrouped,UITableViewStylePlain
    //设置cell边框的样式
    //    tabView.separatorStyle=UITableViewCellSeparatorStyleSingleLineEtched;
    //设置cell边框的颜色
    tabView.separatorColor=[UIColor whiteColor];
    tabView.backgroundColor=[UIColor clearColor];
    tabView.dataSource=self;
    tabView.delegate=self;
    //开始解析
    start=0;
    value=@"";
    NSError *parseError = nil;
    [self parseXMLFileAtURL:[NSURL URLWithString:feedURLString] parseError:parseError];
}

//设置每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//每一个分组有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//每一行里面显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.text=[self.titleArr objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}
//进入下一级菜单
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *v=[[UIViewController alloc]init];
    v.view.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:232.0/255.0 blue:220.0/255.0 alpha:1.0];
    v.view.frame=CGRectMake(0, 0, 320, 460);
    //主标题
    v.navigationItem.title=[titleArr objectAtIndex:indexPath.row];
    //内容
    UITextView *textview=[[UITextView alloc]init];
    textview.editable=NO;
    textview.backgroundColor=[UIColor clearColor];
    textview.text=[contentArr objectAtIndex:indexPath.row];
    textview.frame=v.view.frame;
    textview.textColor=[UIColor blackColor];
    textview.textAlignment=NSTextAlignmentLeft;
    [v.view addSubview:textview];
    
    [[self navigationController] pushViewController:v animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
