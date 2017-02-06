//
//  KK_QLPreviewController.m
//  filePreview
//
//  Created by 邬维 on 2016/12/22.
//  Copyright © 2016年 kook. All rights reserved.
//

#import "KK_QLPreviewController.h"
#import <Masonry.h>

@interface KKPreviewObject : NSObject <QLPreviewItem>
@property (nonatomic, strong) NSURL *remoteUrl;
@property (nonatomic, strong, readwrite) NSURL *previewItemURL;
@property (nonatomic, strong, readwrite) NSString *previewItemTitle;
@end

@implementation KKPreviewObject

@end

//*********************************************************************************

@interface KK_QLPreviewController ()<QLPreviewControllerDataSource>

@property(nonatomic,strong)UIToolbar *qlToolBar;
@property(nonatomic,strong)UIDocumentInteractionController *documentController;
@property (nonatomic, strong) KKPreviewObject *previewItem;

@end

@implementation KK_QLPreviewController{
    UIButton *downLoadBtn;
    UIImageView *imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    _previewItem = [KKPreviewObject new];
    _previewItem.previewItemTitle = @"AppCoda-PDF";
    _previewItem.previewItemURL = nil;
    
    [self addBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"..." forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(previewDocumentInteraction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)addBtn{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ww2"]];
    imgView.backgroundColor = [UIColor redColor];
    [imgView setFrame:CGRectMake(size.width/2 - 50, 250, 100, 100)];
    [self.view addSubview:imgView];
    
    downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downLoadBtn.layer.masksToBounds = YES;
    downLoadBtn.layer.cornerRadius = 5;
    downLoadBtn.backgroundColor = [UIColor grayColor];
    downLoadBtn.contentMode = UIViewContentModeCenter;
    [downLoadBtn setTitle:@"开始下载" forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downLoadBtn addTarget:self action:@selector(wDownload) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:downLoadBtn];
    
    [downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgView).with.offset(120);
        make.centerX.equalTo(self.view);
    }];
}

- (void)wDownload{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"AppCoda-PDF" withExtension:@"pdf"];
    _previewItem.previewItemURL = url;
    [downLoadBtn removeFromSuperview];
    [imgView removeFromSuperview];
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self reloadData];
}


- (void)previewDocumentInteraction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"转发" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"用其他应用打开" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
    }];
    
    
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:otherAction];
    [alertController addAction:okAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //隐藏toolBar
    self.qlToolBar = [self getToolBarFromView:self.view];
    self.qlToolBar.hidden = YES;
    
    [self.navigationController.toolbar setHidden:YES];
    

}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
   
}

- (UIToolbar *)getToolBarFromView:(UIView *)view {
    // Find the QL ToolBar
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UIToolbar class]]) {
            return (UIToolbar *)v;
        } else {
            UIToolbar *toolBar = [self getToolBarFromView:v];
            if (toolBar) {
                return toolBar;
            }
        }
    }
    return nil;
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    return  _previewItem;
}


@end
