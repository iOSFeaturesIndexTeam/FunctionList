//
//  GLViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"
@interface GLViewController (){
    EAGLContext * m_context;
    GLView *m_view;
}

@end

@implementation GLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureOpenGLESArrow];
}

- (void)configureOpenGLESArrow {
    m_view = [[GLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:m_view];
}
@end
