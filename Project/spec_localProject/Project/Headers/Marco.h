//
//  Marco.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/7/29.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#ifndef Marco_h
#define Marco_h

#define kBaseTabViewDelegate    UITableViewDelegate,UITableViewDataSource
#define kBaseCollectionViewDelegate     UICollectionViewDelegate,UICollectionViewDataSource

static inline BOOL StrIsEqual(NSString *front,NSString *empress){
    return [front isEqualToString:empress];
}

static inline NSString * IntToStr(NSInteger i){
    return [NSString stringWithFormat:@"%ld",(long)i];
}


//static NSString * const aaa = @"Responder";
#endif /* Marco_h */
