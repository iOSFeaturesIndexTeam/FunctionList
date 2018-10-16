//
//  ComponentViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/9.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "ComponentViewController.h"
#import "LWPageControl.h"
#import "SUTableView.h"
#import "LiveCell.h"

@interface ComponentViewController ()<kBaseTabViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation ComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LWPageControl lw_createView:^(__kindof LWPageControl *pageControl) {
        pageControl.sizeForPageIndicator = CGSizeMake(10, 10);
        pageControl.itemsPadding = 8;
        pageControl.currentPage = 2;
        pageControl.itemsPage = 5;
        
        [self.view addSubview:pageControl];
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
    }];
    
    [UIButton lw_createView:^(__kindof UIButton *btn) {
        [btn setTitle:@"无限滚动TabV" forState:UIControlStateNormal];
        [UIButton defaultType:btn];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.centerX.mas_equalTo(0);
            make.centerY.equalTo(self.view.mas_top).offset(20);
        }];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            btn.selected = !btn.selected;
            if (btn.isSelected) {
                [self displayForeverScroTableView];
                [self.view insertSubview:btn aboveSubview:self.tableView];
            } else {
                [self.tableView removeFromSuperview];
            }
        }];
    }];
}

#pragma mark - custome Method
- (void)displayForeverScroTableView{
    _tableView = [[SUTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 150.0;
    [_tableView registerNib:[UINib nibWithNibName:@"LiveCell" bundle:nil] forCellReuseIdentifier:[LiveCell cellID]];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[LiveCell cellID]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.descLabel.text = [NSString stringWithFormat:@"第 %ld 个主播频道", indexPath.row + 1];
    return cell;
}
@end
