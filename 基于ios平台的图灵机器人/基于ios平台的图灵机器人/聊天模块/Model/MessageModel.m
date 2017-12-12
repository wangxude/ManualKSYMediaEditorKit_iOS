//
//  MessageModel.m
//  基于ios平台的图灵机器人
//
//  Created by 王旭 on 2017/4/12.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(MessageModel*)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.text = dict[@"text"];
        self.time = dict[@"time"];
        self.type = [dict[@"type"]intValue];
    }
    return self;
}

+(MessageModel*)messageModelWithDict:(NSDictionary *)dict{
    MessageModel* model = [[self alloc]initWithDict:dict];
    return model;
}

@end
