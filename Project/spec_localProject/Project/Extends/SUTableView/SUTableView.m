//
//  SUTableView.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/16.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "SUTableView.h"
#import "SUTableViewInterceptor.h"

@interface SUTableView ()

@property (nonatomic, strong) SUTableViewInterceptor * dataSourceInterceptor;
@property (nonatomic, assign) NSInteger actualRows;

@end

@implementation SUTableView

#pragma mark - LayoutSubviews Override
- (void)layoutSubviews {
    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];
}

- (void)resetContentOffsetIfNeeded {
    CGPoint contentOffset  = self.contentOffset;
    //scroll over top
    if (contentOffset.y <= 0.0) {
        contentOffset.y = self.contentSize.height / 3.0;
    }
    //scroll over bottom
    else if (contentOffset.y >= (self.contentSize.height - self.bounds.size.height)) {
        contentOffset.y = self.contentSize.height / 3.0 - self.bounds.size.height;
    }
    [self setContentOffset: contentOffset];
}

#pragma mark - DataSource Delegate Setter/Getter Override 
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.dataSourceInterceptor.receiver = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self.dataSourceInterceptor];
}

- (SUTableViewInterceptor *)dataSourceInterceptor {
    if (!_dataSourceInterceptor) {
        _dataSourceInterceptor = [[SUTableViewInterceptor alloc]init];
        _dataSourceInterceptor.middleMan = self;
    }
    return _dataSourceInterceptor;
}

#pragma mark - Delegate Method Override
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    self.actualRows = [self.dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section];
    return self.actualRows * 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * actualIndexPath = [NSIndexPath indexPathForRow:indexPath.row % self.actualRows inSection:indexPath.section];
    return [self.dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:actualIndexPath];
}
@end
