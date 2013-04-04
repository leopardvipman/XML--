//
//  ViewController.h
//  XML解析
//
//  Created by wang yongfeng on 13-3-7.
//  Copyright (c) 2013年 wang yongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>{
    NSString *value;
    int start;
}


@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,strong)NSMutableArray *contentArr;

@end
