//
//  DraggableLogo.h
//  Fubu
//
//  Created by Remote on 26/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlaceableItemDelegate.h"

@interface DraggableLogo : UIImageView {
    NSString *name;
    id<PlaceableItemDelegate> delegate;
}
@property (nonatomic, retain) id<PlaceableItemDelegate> delegate;
@property (nonatomic, retain) NSString *name;

- (void)floatTo:(CGPoint)location;
- (void)placeAt:(CGPoint)location;

@end
