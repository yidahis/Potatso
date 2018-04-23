//
//  ViewController.m
//  ShadowPathDemo
//
//  Created by LEI on 5/17/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#import "ViewController.h"
#import <ShadowPath/ShadowPath.h>

void shadowsocks_handler(int fd, void *udata) {
    
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    NSString *host = @"13.124.84.92";
    NSString *host = @"192.168.3.146";
    //        NSString *host = @"192.168.2.94";
    NSNumber *port = @443;
    NSString *password = @"SzkqwV";
    NSString *authscheme = @"aes-256-cfb";
    NSString *protocol = @"auth_aes128_sha1";
    NSString *protocol_param = @"1:W8qsSn";
    NSString *obfs = @"plain";
    NSString *obfs_param = @"4a8a41.baidu.com";

    if (host && port && password && authscheme) {
        profile_t profile;
        memset(&profile, 0, sizeof(profile_t));
        profile.remote_host = strdup([host UTF8String]);
        profile.remote_port = [port intValue];
        profile.password = strdup([password UTF8String]);
        profile.method = strdup([authscheme UTF8String]);
        profile.local_addr = "127.0.0.1";
        profile.local_port = 0;
        profile.timeout = 600;

        if (protocol.length > 0) {
            profile.protocol = strdup([protocol UTF8String]);
        }
        if (protocol_param.length > 0) {
            profile.protocol_param = strdup([protocol_param UTF8String]);
        }
        if (obfs.length > 0) {
            profile.obfs = strdup([obfs UTF8String]);
        }
        if (obfs_param.length > 0) {
            profile.obfs_param = strdup([obfs_param UTF8String]);
        }
        start_ss_local_server(profile, shadowsocks_handler, (__bridge void *)self);
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
