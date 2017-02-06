//
//  kkTableViewController.m
//  filePreview
//
//  Created by 邬维 on 2016/12/20.
//  Copyright © 2016年 kook. All rights reserved.
//

#import "kkTableViewController.h"
#import "kkTableViewCell.h"
#import <QuickLook/QuickLook.h>
#import "KKFilePreViewController.h"

@interface kkTableViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (strong, nonatomic) IBOutlet UITableView *kkTableview;
@property (strong, nonatomic) QLPreviewController *kkpreview;

@end

@implementation kkTableViewController{
    NSArray *fileArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统文件预览模式";
    [self.kkTableview registerNib:[UINib nibWithNibName:@"kkTableViewCell" bundle:nil] forCellReuseIdentifier:@"kktableCell"];
    fileArray = @[@"AppCoda-PDF.pdf", @"AppCoda-Pages.pages", @"AppCoda-Word.docx", @"AppCoda-Keynote.key",@"AppCoda-Text.txt",@"AppCoda-Image.jpeg"];
    
    _kkpreview = [[QLPreviewController alloc] init];
    _kkpreview.delegate = self;
    _kkpreview.dataSource = self;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 40);
    [btn setTitle:@"微信模式" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(previewDocumentInteraction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

     [self.navigationController.toolbar setHidden:YES];
}

- (void)previewDocumentInteraction{
    KKFilePreViewController *preview = [[KKFilePreViewController alloc] init];
    preview.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:preview animated:YES];
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    
    return 6;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSArray *Arr = [fileArray[index] componentsSeparatedByString:@"."];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:Arr[0] withExtension:Arr[1]];
    
    return  url;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    kkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kktableCell" forIndexPath:indexPath];
    cell.lable.text = fileArray[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *Arr = [fileArray[indexPath.row] componentsSeparatedByString:@"."];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:Arr[0] withExtension:Arr[1]];
    
    if ([QLPreviewController canPreviewItem:url]) {
        _kkpreview.currentPreviewItemIndex = indexPath.row;
        [self.navigationController pushViewController:_kkpreview animated:YES];
    }

}

@end
