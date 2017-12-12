//
//  CellFrameModel.h
//  基于ios平台的图灵机器人
//
//  Created by 王旭 on 2017/4/12.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageModel;

//文字填充
#define textPadding 15

@interface CellFrameModel : NSObject

@property(nonatomic,strong)MessageModel* message;

@property(nonatomic,assign,readonly)CGRect timeFrame;
@property(nonatomic,assign,readonly)CGRect iconFrame;
@property(nonatomic,assign,readonly)CGRect textFrame;
@property(nonatomic,assign,readonly)CGFloat cellHeight;

@end
