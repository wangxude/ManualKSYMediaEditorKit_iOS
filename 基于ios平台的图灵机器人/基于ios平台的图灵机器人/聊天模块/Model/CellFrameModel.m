//
//  CellFrameModel.m
//  基于ios平台的图灵机器人
//
//  Created by 王旭 on 2017/4/12.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "CellFrameModel.h"
#import "MessageModel.h"
#import "NSString+Extension.h"

#define timeH 40
#define padding 10
#define iconW 40
#define iconH 40
#define textW 150

@implementation CellFrameModel

-(void)setMessage:(MessageModel *)message{
    _message = message;
   CGRect frame = [UIScreen mainScreen].bounds;
    //时间的Frame
    if (message.showTime) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX, timeFrameY, timeFrameW, timeFrameH);
    }
    
    //头像的Frame
    CGFloat iconFrameX = message.type ?padding:(frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame);
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //内容Frame
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:15]};
    CGSize textSize = [message.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:textMaxSize];
    
    CGSize textRealSize = CGSizeMake(textSize.width + textPadding*2, textSize.height + textPadding*2);
    CGFloat textFrameY = iconFrameY;
    
    CGFloat textFrameX = message.type ?(2*padding + iconFrameW):(frame.size.width - (padding*2 + iconFrameW + textRealSize.width));
    _textFrame = CGRectMake(textFrameX, textFrameY, textRealSize.width, textRealSize.height);
    
    //cell的高度
     _cellHeight = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;
    
  }

//-(CGSize)GetSizeFromString:(NSString *)string
//{
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:15]};
//    // 计算文本的大小
//    CGSize textSize = [string boundingRectWithSize:CGSizeMake(320-60, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
//                                           options: NSStringDrawingUsesLineFragmentOrigin // 文本绘制时的附加选项
//                                        attributes:attributes        // 文字的属性
//                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
//    return textSize;
//}
//

@end
