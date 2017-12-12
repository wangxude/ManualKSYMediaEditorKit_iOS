//
//  MessageModel.h
//  基于ios平台的图灵机器人
//
//  Created by 王旭 on 2017/4/12.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义一个结构体
typedef enum{
    kMessageModelTypeOther,
    kMessageModelTypeMe
} MessageModelType;

@interface MessageModel : NSObject

@property(nonatomic,copy)NSString* text;

@property(nonatomic,copy)NSString* time;

@property(nonatomic,assign)MessageModelType type;

@property(nonatomic,assign)BOOL showTime;

+(MessageModel*)messageModelWithDict:(NSDictionary*)dict;

-(MessageModel*)initWithDict:(NSDictionary*)dict;


@end
