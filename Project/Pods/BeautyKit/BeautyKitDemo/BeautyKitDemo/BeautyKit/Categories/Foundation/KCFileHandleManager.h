//
//  KCFileHandleManager.h
//  KidsCamera
//
//  Created by 王文震 on 2018/5/11.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KCFileHandleManager : NSObject
+ (void)syncFileHandleRename:(NSString *)sourceFile
                    destFile:(NSString *)destFile
               processHandle:(void(^)(CGFloat progress))processHandle
            completionHandle:(void(^)())completionHandle;
@end
