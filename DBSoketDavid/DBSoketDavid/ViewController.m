//
//  ViewController.m
//  DBSoketDavid
//
//  Created by 崔曦 on 2018/10/26.
//  Copyright © 2018 崔曦. All rights reserved.
//

#import "ViewController.h"
#import "DBSoket_DavManager.h"
@interface ViewController ()
{
    DBSoket_DavManager * _DavManager;
}

@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    _DavManager=[DBSoket_DavManager shareManager];
    
    [_DavManager setDataFromSeverReponse:^(id data) {
         NSLog(@"xin服务器返回的信息:%@",data);
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self startSocket];
}

-(void)sendMsg
{
    //[DBSoket_DavManager sendMsg:textField.text];
}
-(void)startSocket
{
    [_DavManager connect];
}
-(void)stopSocket
{
    [_DavManager disConnect];
}
-(void)sendPing
{
    [_DavManager ping];
}

@end
