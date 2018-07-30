//
//  ViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/6/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "ViewController.h"
#import "BGAlertView+BGAdd.h"
#import "Marco.h"
/**
 索引描述Cell
 */
#warning TODO - 18/7/29 索引描述
#pragma mark - IndexDesCell
@interface IndexDesCell : UITableViewCell

@end
@implementation IndexDesCell
@end

#pragma mark - DemoIndexModel
@interface DemoIndexModel ()
@end
@implementation DemoIndexModel
- (NSString *)vcName{
    return [_vcName stringByAppendingString:@"ViewController"];
}
@end

static inline DemoIndexModel * CreateDemoModel(NSString *title,NSString *vcName){
    DemoIndexModel *model = [DemoIndexModel new];
    model.title = title;
    model.vcName = vcName;
    return model;
}

static NSString * CELLID = @"cell_Id";


#pragma mark - ViewController 
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) NSArray <DemoIndexModel *>*data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubViews];
}

- (void)configureSubViews{
    [self.view addSubview:self.tableV];
    [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
}

- (IBAction)sheetL:(id)sender {
    [BGAlertView showSheetViewLevelWithEditingChangedHandler:^(NSString *a) {
        
    } actionTapedHandler:^(NSInteger index) {
    
    }];
}
- (IBAction)sheetV:(id)sender {
    [BGAlertView showSheetViewWithEditingChangedHandler:^(NSString *a) {
        
    } actionTapedHandler:^(NSInteger index) {
        
    }];
}
- (IBAction)click:(id)sender {

    [BGAlertView showAlertViewWithEditingChangedHandler:^(NSString *string) {
        
    } actionTapedHandler:^(NSInteger index) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class VC = NSClassFromString(self.data[indexPath.row].vcName);
    [self.navigationController pushViewController:(UIViewController *)VC.new animated:YES];
}

- (UITableView *)tableV {
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
        _tableV.delegate = self;
        _tableV.dataSource = self;
    }
    return _tableV;
}

- (NSArray <DemoIndexModel *>*)data{
    return @[CreateDemoModel(@"UIResponder", Responder_VC)];
}
@end
