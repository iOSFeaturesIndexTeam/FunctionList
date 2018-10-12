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
#import "NSData+Extend.h"
#import "BaseViewController.h"
/**
 索引描述Cell
 */

#pragma mark - IndexDesCell
@interface IndexDesCell : UITableViewCell 
@property (nonatomic,strong) UILabel *prefixLb;
@property (nonatomic,strong) UIImageView *help;
@property (nonatomic,copy) NSString *des;
@end
@implementation IndexDesCell
+ (NSString *)cellID{
    return NSStringFromClass([self class]);
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubViews];
        [self configureGesture];
    }
    return self;
}

- (void)configureSubViews{
    _prefixLb = [UILabel lw_createView:^(__kindof UILabel *lb) {
        lb.textColor = [UIColor blackColor];
        [self.contentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(20.);
        }];
    }];
    
    _help = [UIImageView lw_createView:^(__kindof UIImageView *img) {
        img.image = [UIImage imageNamed:@"index_help"];
        [self.contentView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20.f);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }];
    _help.image = [UIImage imageNamed:@"index_help"];
}

- (void)configureGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_help addGestureRecognizer:tap];
}

- (void)tap:(UIGestureRecognizer *)sender{
    NSString *tip = [@"索引介绍\n\n" stringByAppendingString:_des];
    [BGAlertView titleTip:tip];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    CGPoint event_clip_point = [self convertPoint:point toView:_help];
    if ([_help pointInside:event_clip_point withEvent:event]) {
        view = _help;
    }
    return view;
}
@end

#pragma mark - DemoIndexModel
@interface DemoIndexModel ()
@end
@implementation DemoIndexModel
- (NSString *)vcName{
    if (!_vcName) {
        return nil;
    }
    return [_vcName stringByAppendingString:@"ViewController"];
}

+ (NSArray <DemoIndexModel *>*)initListDataWithJSON:(NSDictionary *)JSONDic{
    NSArray *arr = [JSONDic valueForKey:@"functionList"];
    
    return  [DemoIndexModel transformJSON:arr];
}

+ (NSArray *)transformJSON:(NSArray *)arr{
    NSMutableArray *marr = [NSMutableArray array];
    for (NSDictionary *d in arr) {
        DemoIndexModel *model = [DemoIndexModel new];
        for (NSString *key in d.allKeys) {
            NSDictionary *sub = d[key];
            model.title = sub[@"title"];
            model.vcName = sub[@"vcName"];
            model.des = sub[@"des"];
            NSArray *subList = sub[@"subList"];
            if (subList && subList.count > 0) {
               NSArray *arr = [DemoIndexModel transformJSON:subList];
               model.subList = arr.mutableCopy;
            } else if ([model.vcName isEqualToString:@"ViewController"]) {
                model.vcName = nil;
            }
        }
        [marr addObject:model];
    }
    return marr.copy;
}
@end

static NSString * CELLID = @"cell_Id";


#pragma mark - ViewController 
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    IndexDesCell *cell = [tableView dequeueReusableCellWithIdentifier:[IndexDesCell cellID] forIndexPath:indexPath];
    cell.prefixLb.text = self.data[indexPath.row].title;
    cell.des = self.data[indexPath.row].des;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DemoIndexModel *model = self.data[indexPath.row];
    if (model.vcName) {
        Class VC = NSClassFromString(model.vcName);
        UIViewController *vc = [VC new];
        if ([vc isKindOfClass:[ViewController class]]) {//说明是索引VC
            [(ViewController *)vc setData:model.subList];
        } else {
            [(BaseViewController *)vc setIndexTitle:model.title];
        }
        //没有走if 表示是 演示VC
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [BGAlertView titleTip:@"暂无 内容"];
    }
}

- (UITableView *)tableV {
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableV registerClass:[IndexDesCell class] forCellReuseIdentifier:[IndexDesCell cellID]];
        _tableV.rowHeight = 60.f;
        _tableV.delegate = self;
        _tableV.dataSource = self;
    }
    return _tableV;
}

- (NSArray <DemoIndexModel *>*)data{
    if (!_data) {
        NSURL *list_url = [[NSBundle mainBundle] URLForResource:@"Resource/FoundtionList.json" withExtension:nil];
        NSData *listData = [NSData dataWithContentsOfURL:list_url];
        NSDictionary *data = [NSData jsonDataToDic:listData];
        NSArray *temp_data = [DemoIndexModel initListDataWithJSON:data];
        return temp_data;
    }
    return _data;
}
@end
