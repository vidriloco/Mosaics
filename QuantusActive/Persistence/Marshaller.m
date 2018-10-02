//
//  Marshaller.m
//  QuantusActive
//
//  Created by Alejandro on 3/21/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "Marshaller.h"
#import "Model.h"

@implementation Marshaller
@synthesize title, items, categories, type, answers;


- (id) initWithQuestionMetaData:(NSDictionary *)metaData
{
    if(self=[super init]) {
        self.answers = [NSMutableDictionary dictionary];
        [self setTitle:[metaData objectForKey:@"title"]];
        [self setType:[metaData objectForKey:@"type"]];
        [self setItems:[metaData objectForKey:@"items"]];
        [self setCategories:[metaData objectForKey:@"options"]];
    }
    return self;
}

- (void) pushItem:(NSString *)item onCategory:(NSString *)category
{
    NSMutableArray *list = [answers objectForKey:category];
    if (list == NULL) {
        list = [NSMutableArray array];
    }
    [list addObject:item];
    
    [self setAnswerList:list forCategory:category];
}

- (void) setAnswerList:(NSArray *)list forCategory:(NSString *)category
{
    [answers setObject:list forKey:category];
}




@end
