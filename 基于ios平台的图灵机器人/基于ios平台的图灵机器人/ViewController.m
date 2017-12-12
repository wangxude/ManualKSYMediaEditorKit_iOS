//
//  ViewController.m
//  基于ios平台的图灵机器人
//
//  Created by 王旭 on 2017/4/10.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "ViewController.h"
//语义分析
#import "TRRTuringRequestManager.h"

#import "DialogueListViewController.h"

#import "MBProgressHUD.h"

@interface ViewController () <NSURLSessionDelegate>
//图灵语音分析API配置接口类
@property(nonatomic,strong)TRRTuringAPIConfig* apiConfig;
//图灵语音分析API请求接口类
@property(nonatomic,strong)TRRTuringRequestManager* apiRequest;

@property(nonatomic,strong)UIButton* determineButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self setUpContentView];
    [self setButton];
//    self.apiConfig = [[TRRTuringAPIConfig alloc]initWithAPIKey:TuringAPIKey];
//    self.apiRequest = [[TRRTuringRequestManager alloc]initWithConfig:self.apiConfig];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setButton{
    self.determineButton = [[UIButton alloc]init];
    self.determineButton.frame = CGRectMake(150, 200,100,40);
    [self.determineButton setTitle:@"开始分析" forState:UIControlStateNormal];
    [self.determineButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.determineButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.determineButton.tag = 1000;
    [self.view addSubview:self.determineButton];

    UIButton* analysisButton = [[UIButton alloc]init];
    analysisButton.frame = CGRectMake(150, 400,100,40);
    [analysisButton setTitle:@"测试加载框架" forState:UIControlStateNormal];
    [analysisButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [analysisButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    analysisButton.tag = 1001;
    [self.view addSubview:analysisButton];
}

//-(void)setUpContentView{
//    self.determineButton = [[UIButton alloc]init];
//    self.determineButton.frame = CGRectMake(0, 200,100,40);
//    [self.determineButton setTitle:@"开始分析" forState:UIControlStateNormal];
//    [self.determineButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.determineButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.determineButton];
//    
//    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth,100)];
//    _inputTextView.layer.borderColor = [UIColor blackColor].CGColor;
//    _inputTextView.layer.borderWidth = 1.0;
//    _inputTextView.layer.cornerRadius = 5.0f;
//    _inputTextView.text = @"";
//    [_inputTextView.layer setMasksToBounds:YES];
//    [self.view addSubview:_inputTextView];
//    
//     _outputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 300, ScreenWidth,100)];
//    _outputTextView.layer.borderColor = [[UIColor blackColor] CGColor];
//    _outputTextView.layer.borderWidth = 1.0;
//    _outputTextView.layer.cornerRadius = 5.0f;
//    _outputTextView.text = @"";
//    [_outputTextView.layer setMasksToBounds:YES];
//    [self.view addSubview:_outputTextView];
//    
//}
//
-(void)buttonClick:(UIButton*)sender{
//    [_inputTextView resignFirstResponder];
//    [self.apiConfig request_UserIDwithSuccessBlock:^(NSString *str) {
//        NSLog(@"result = %@", str);
//        [self.apiRequest request_OpenAPIWithInfo:self.inputTextView.text successBlock:^(NSDictionary *dict) {
//            NSLog(@"apiResult =%@",dict);
//            _outputTextView.text = [dict objectForKey:@"text"];
//        } failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
//            _outputTextView.text = infoStr;
//            NSLog(@"errorinfo = %@", infoStr);
//        }];
//    }
//                                    failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
//                                        _outputTextView.text = infoStr;
//                                        NSLog(@"erroresult = %@", infoStr);
//                                    }];
    
    if (sender.tag == 1000) {
        DialogueListViewController* dialogueVC = [[DialogueListViewController alloc]init];
        [self.navigationController pushViewController:dialogueVC animated:YES];
    }
    else if (sender.tag == 1001){
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"prepare";
        hud.minSize = CGSizeMake(150, 100);
        [self doSomeNetworkWorkWithProgress];
    }
   
//
}
- (void)doSomeNetworkWorkWithProgress {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
    [task resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // Do something with the data at location...
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = @"完成";
        //[hud hideAnimated:YES];
        [hud hideAnimated:YES afterDelay:0.5f];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.progress = progress;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
