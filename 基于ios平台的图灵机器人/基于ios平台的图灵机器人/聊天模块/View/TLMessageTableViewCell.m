//
//  TLMessageTableViewCell.m
//  基于ios平台的图灵机器人
//
//  Created by 王旭 on 2017/4/12.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "TLMessageTableViewCell.h"

#import "CellFrameModel.h"
#import "MessageModel.h"
#import "UIImage+ResizeImage.h"

@interface TLMessageTableViewCell (){

    UILabel* _timeLabel;
    UIImageView* _iconImageView;
    UIButton* _textViewBtn;
}

@end

@implementation TLMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
        _iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconImageView];
        
        _textViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textViewBtn.titleLabel.numberOfLines = 0;
        _textViewBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _textViewBtn.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self.contentView addSubview:_textViewBtn];
        
    }
    
    return self;
}

-(void)setCellFrame:(CellFrameModel *)cellFrame{
    
    MessageModel* messageModel = cellFrame.message;
    
    _timeLabel.frame = cellFrame.timeFrame;
    _timeLabel.text = messageModel.time;
    
    _iconImageView.frame = cellFrame.iconFrame;
    NSString* iconStr = messageModel.type ? @"other": @"me";
    _iconImageView.image = [UIImage imageNamed:iconStr];
    
    _textViewBtn.frame = cellFrame.textFrame;
    NSString* textBg = messageModel.type ?@"chat_recive_nor":@"chat_send_nor";
    UIColor * textColor = messageModel.type ?[UIColor blackColor]:[UIColor whiteColor];
    [_textViewBtn setTitleColor:textColor forState:UIControlStateNormal];
    [_textViewBtn setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
    [_textViewBtn setTitle:messageModel.text forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
