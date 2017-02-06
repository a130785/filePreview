//
//  KKFilePreViewController.m
//  filePreview
//
//  Created by 邬维 on 2016/12/20.
//  Copyright © 2016年 kook. All rights reserved.
//

#import "KKFilePreViewController.h"
#import "KK_QLPreviewController.h"

@interface KKFilePreViewController ()


@end

@implementation KKFilePreViewController{

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ui预览";
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}





- (IBAction)gotoPreview:(id)sender {
    KK_QLPreviewController *ql = [[KK_QLPreviewController alloc] init];
    
    [self.navigationController pushViewController:ql animated:YES];
    
}


@end
