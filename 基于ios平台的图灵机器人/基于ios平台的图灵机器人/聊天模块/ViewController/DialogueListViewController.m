//
//  DialogueListViewController.m
//  基于ios平台的图灵机器人
//
//  Created by 王旭 on 2017/4/14.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "DialogueListViewController.h"
//聊天数据源
#import "MessageModel.h"
#import "CellFrameModel.h"
//cell
#import "TLMessageTableViewCell.h"

//语义分析
#import "TRRTuringRequestManager.h"

#define KToolBarH 44
#define KTextFieldH 30

@interface DialogueListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    //模型数据源
    NSMutableArray* _cellFrameDatas;
    
    //底部工具条
    UIImageView* _toolBar;
}

//图灵语音分析API配置接口类
@property(nonatomic,strong)TRRTuringAPIConfig* apiConfig;
//图灵语音分析API请求接口类
@property(nonatomic,strong)TRRTuringRequestManager* apiRequest;

//聊天列表
@property(nonatomic,strong)UITableView* chatTableView;

@end

@implementation DialogueListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图灵机器人";
    self.apiConfig = [[TRRTuringAPIConfig alloc]initWithAPIKey:TuringAPIKey];
    self.apiRequest = [[TRRTuringRequestManager alloc]initWithConfig:self.apiConfig];
    
    //设置监听键盘(键盘高度变化通知)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //1.加载数据
    [self loadChatTableViewData];
    //2.添加TableView
    [self addChatView];
    //3.添加工具条
    [self addToolBar];
    // Do any additional setup after loading the view.
}

-(void)loadChatTableViewData{
    _cellFrameDatas = [[NSMutableArray alloc]init];
    NSString* path = [[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil];
    NSArray* dataArray = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary* dict in dataArray) {
        MessageModel* message = [MessageModel messageModelWithDict:dict];
        
        CellFrameModel* lastFrame = [_cellFrameDatas lastObject];
        CellFrameModel* cellFrame = [[CellFrameModel alloc]init];
        message.showTime = ![message.time isEqualToString:lastFrame.message.time];
        cellFrame.message = message;
        [_cellFrameDatas addObject:cellFrame];
        
    }
}
//添加TableView
-(void)addChatView{
   self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    UITableView* chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-KToolBarH)];
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    chatTableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    //chatTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    chatTableView.separatorColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    chatTableView.allowsSelection = NO;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [chatTableView addGestureRecognizer:gesture];
    self.chatTableView = chatTableView;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.chatTableView];
}

-(void)addToolBar{
    UIImageView* bgView = [[UIImageView alloc]init];
    bgView.frame = CGRectMake(0, ScreenHeight-KToolBarH, ScreenWidth, KToolBarH);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
     _toolBar = bgView;
    
    UIButton* sendSecondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSecondBtn.frame = CGRectMake(0, 0, KToolBarH, KToolBarH);
    [sendSecondBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [bgView addSubview:sendSecondBtn];
    
    UIButton* addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addMoreBtn.frame = CGRectMake(ScreenWidth-KToolBarH, 0, KToolBarH, KToolBarH);
    [addMoreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [bgView addSubview:addMoreBtn];
    
    UIButton* expressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expressBtn.frame = CGRectMake(ScreenWidth-KToolBarH*2, 0, KToolBarH, KToolBarH);
    [expressBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [bgView addSubview:expressBtn];
    
    UITextField* textField = [[UITextField alloc]init];
    // //设置按键类型
    textField.returnKeyType = UIReturnKeySend;
    //这里设置为无文字就灰色不可点
    textField.enablesReturnKeyAutomatically = YES;
    textField.frame = CGRectMake(KToolBarH,(KToolBarH-KTextFieldH)/2,ScreenWidth-3*KToolBarH, KTextFieldH);
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.delegate = self;
    [bgView addSubview:textField];
}
#pragma mark - tableView的数据源和代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellFrameDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cell";
    
    TLMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[TLMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cellFrame = _cellFrameDatas[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellFrameModel* cellFrame = _cellFrameDatas[indexPath.row];
    return cellFrame.cellHeight;
}
/**
 结束编辑
 */
- (void)endEdit
{
    [self.view endEditing:YES];
}

/**
 键盘发生改变执行

 @param note <#note description#>
 */
-(void)keyboardWillChange:(NSNotification*)note{
    //UIKeyboardWillChangeFrameNotification; //键盘将要改变 frame
//    UIKeyboardFrameBeginUserInfoKey //初始的 frame
//    UIKeyboardFrameEndUserInfoKey   //结束的 frame
//    UIKeyboardAnimationDurationUserInfoKey  //持续的时间
//    UIKeyboardAnimationCurveUserInfoKey  //UIViewAnimationCurve
//    UIKeyboardIsLocalUserInfoKey  //是否是当前 App的键盘
    NSLog(@"%@",note.userInfo);
    NSDictionary* wxUserInfo = note.userInfo;
    CGFloat duration = [wxUserInfo[@"UIKeyboardAnimationDurationUserInfoKey"]doubleValue];
    
   // CGRect keyFrameBegin = [wxUserInfo[@"UIKeyboardFrameBeginUserInfoKey"]CGRectValue];
    CGRect keyFrameEnd = [wxUserInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    CGFloat moveY = keyFrameEnd.origin.y - ScreenHeight;
    NSLog(@"%f",moveY);
    
    [UIView animateWithDuration:duration animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
    }];

}


//释放内存今天来学习一下Dealloc方法的使用。

//它的作用是,当对象的引用计数为0,系统会自动调用dealloc方法,回收内存。(移除键盘事件的通知)
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//开始拖拽视图
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma mark - UITextField的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //获得时间
    NSDate* sendDate = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString* locationString = [dateFormatter stringFromDate:sendDate];
    
    MessageModel* message = [[MessageModel alloc]init];
    message.text = textField.text;
    message.time = locationString;
    message.type = 0;
    
    
    //创建一个MessageModel类
    CellFrameModel* cellFrame = [[CellFrameModel alloc]init];
    CellFrameModel* lastCellFrame = [_cellFrameDatas lastObject];
    message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
    cellFrame.message = message;
    
    //添加数据进去，并且刷新数据
    
    [_cellFrameDatas addObject:cellFrame];
    [self.chatTableView reloadData];
    
    //自动滚动到最后一行
    NSIndexPath* lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self.apiConfig request_UserIDwithSuccessBlock:^(NSString *str) {
        NSLog(@"result = %@", str);
       
        
        [self.apiRequest request_OpenAPIWithInfo:textField.text successBlock:^(NSDictionary *dict) {
            NSLog(@"apiResult =%@",dict);
            //_outputTextView.text = [dict objectForKey:@"text"];
            
           
            
            MessageModel* messageOther = [[MessageModel alloc]init];
            messageOther.text = [dict objectForKey:@"text"];
            messageOther.time = locationString;
            messageOther.type = 1;
           
            
            //创建一个MessageModel类
            CellFrameModel* cellFrameOther = [[CellFrameModel alloc]init];
            CellFrameModel* lastCellFrameOther = [_cellFrameDatas lastObject];
            messageOther.showTime = ![lastCellFrameOther.message.time isEqualToString:messageOther.time];
            cellFrameOther.message = messageOther;
            
            //添加数据进去，并且刷新数据
          
            [_cellFrameDatas addObject:cellFrameOther];
            [self.chatTableView reloadData];
            
            //自动滚动到最后一行
            NSIndexPath* lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count-1 inSection:0];
            [self.chatTableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            textField.text = @"";

            
            
            
        } failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
//            _outputTextView.text = infoStr;
            NSLog(@"errorinfo = %@", infoStr);
        }];
    }
                                    failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
                                       // _outputTextView.text = infoStr;
                                        NSLog(@"erroresult = %@", infoStr);
                                    }];
    
    
    return YES;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
