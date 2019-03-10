//
//  LiveCell.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
+ (NSString *)cellID;
@end
