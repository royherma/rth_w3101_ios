//
//  Note.h
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Note : NSObject <NSCoding>

@property NSString *title;
@property NSString *body;
@property NSDate *date;
@property NSString *imageURL;
@property UIImage *image;
@property (readonly) NSString *uniqueID;

-(id)initWithTitle:(NSString*)title andBody:(NSString*)body;
-(NSURL*)audioURL;
@end
