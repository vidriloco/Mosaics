//
//  Marshaller.h
//  QuantusActive
//
//  Created by Alejandro on 3/21/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Marshaller : NSObject {
    NSString *title;
    NSArray  *items;
    NSArray  *categories;
    NSString *type;
    NSMutableDictionary* answers;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray  *items;
@property (nonatomic, strong) NSArray  *categories;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableDictionary* answers;

- (id) initWithQuestionMetaData:(NSDictionary*)metaData;
- (void) pushItem:(NSString*)item onCategory:(NSString*)category; 
- (void) setAnswerList:(NSArray *)list forCategory:(NSString *)category;

@end
