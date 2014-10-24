//
//  Note.m
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import "Note.h"

@implementation Note

-(id)initWithTitle:(NSString*)title andBody:(NSString*)body{
    if(self=[super init]){
        _title = title;
        _body = body;
        _date = [NSDate date];
        _imageURL = @"";
        _image = nil;
        _uniqueID = [self randomStringWithLength:5];
        return self;
    }
    return nil;    
}
#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        _title = [decoder decodeObjectForKey:@"title"];
        _body = [decoder decodeObjectForKey:@"body"];
        _date = [decoder decodeObjectForKey:@"date"];
        _imageURL = [decoder decodeObjectForKey:@"imageURL"];
        _image = [decoder decodeObjectForKey:@"image"];
        _uniqueID = [decoder decodeObjectForKey:@"uniqueID"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.body forKey:@"body"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.uniqueID forKey:@"uniqueID"];
}
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *)randomStringWithLength:(int)len{
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length]) % [letters length]]];
    }    
    return randomString;
}
-(NSURL*)audioURL{
    NSString *pathURL = [NSString stringWithFormat:@"%@.m4a",self.uniqueID];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               pathURL,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    return outputFileURL;
}
@end
