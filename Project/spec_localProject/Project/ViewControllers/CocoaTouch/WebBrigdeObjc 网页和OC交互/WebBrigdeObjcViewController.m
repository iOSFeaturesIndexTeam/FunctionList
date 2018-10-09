//
//  WebBrigdeObjcViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/18.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "WebBrigdeObjcViewController.h"
#import "BGAlertView+BGAdd.h"
NSString * const JSHead = @"documentView.webView.mainFrame.javaScriptContext";
NSString * const JSOcModel = @"OCModel";
@interface WebBrigdeObjcViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation WebBrigdeObjcViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
    //  一个JSContext对象，就类似于Js中的window，只需要创建一次即可。
    //  self.jsContext = [[JSContext alloc] init];
    //
    //  // jscontext可以直接执行JS代码。
    //  [self.jsContext evaluateScript:@"var num = 10"];
    //  [self.jsContext evaluateScript:@"var squareFunc = function(value) { return value * 2 }"];
    //  // 计算正方形的面积
    //  JSValue *square = [self.jsContext evaluateScript:@"squareFunc(num)"];
    //
    //  // 也可以通过下标的方式获取到方法
    //  JSValue *squareFunc = self.jsContext[@"squareFunc"];
    //  JSValue *value = [squareFunc callWithArguments:@[@"20"]];
    //  KCLog(@"%@", square.toNumber);
    //  KCLog(@"%@", value.toNumber);
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:JSHead];
    // 通过模型调用方法，这种方式更好些。
    HYBJsObjCModel *model  = [[HYBJsObjCModel alloc] init];
    self.jsContext[JSOcModel] = model;
    model.jsContext = self.jsContext;
    model.webView = self.webView;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

#pragma mark - getter
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        _webView.delegate = self;
    }
    return _webView;
}
@end


@implementation HYBJsObjCModel
#pragma mark - JavaScriptObjectiveCDelegate
- (void)callWithDict:(NSDictionary *)params {
    KCLog(@"Js调用了OC的方法，参数为：%@", params);
}

// JS调用了callSystemCamera
- (void)callSystemCamera {
    KCLog(@"JS调用了OC的方法，调起系统相册");
    // JS调用后OC后，又通过OC调用JS，但是这个是没有传参数的
    JSValue *jsFunc = self.jsContext[@"jsFunc"];
    [jsFunc callWithArguments:nil];
}

- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params {
    NSLog(@"jsCallObjcAndObjcCallJsWithDict was called, params is %@", params);
    // 调用JS的方法
    JSValue *jsParamFunc = self.jsContext[@"jsParamFunc"];
    [jsParamFunc callWithArguments:@[@{@"age": @10, @"name": @"lili", @"height": @158}]];
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg a:(NSString *)a{
    dispatch_async(dispatch_get_main_queue(), ^{;
        [BGAlertView normalAlertWithTitle:title subBtnTitle:@[@"取消",msg] actionTapedHandler:nil];
    });
}
@end
