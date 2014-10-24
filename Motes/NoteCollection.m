//
//  NoteCollection.m
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import "NoteCollection.h"

@interface NoteCollection ()

@end

@implementation NoteCollection
#pragma private init and singleton
-(instancetype)initPrivate{
    if(self=[super init]){
        _collection = [NSKeyedUnarchiver unarchiveObjectWithFile:[NoteCollection pathForArchive]];
        if(!_collection)
            _collection = [NSMutableArray new];
        return self;
    }
    return nil;
}
+(NoteCollection*)sharedNotes{
    static NoteCollection *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    
    return sharedInstance;
}
#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        _collection = [decoder decodeObjectForKey:@"collection"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.collection forKey:@"collection"];
}

#pragma logic methods
-(NSUInteger)count{
    return _collection.count;
}
-(void)addNote:(Note*)note{
    [_collection addObject:note];
}
-(void)removeNote:(Note*)note{
    [_collection removeObject:note];
}
-(Note*)noteAtIndex:(int)index{
    return _collection[index];
}
-(void)createTestNotes{
    for (int i=0; i<3; i++) {
        Note *n = [[Note alloc]initWithTitle:@"Test" andBody:@"aksjdaskjasdadadasdaddaskdja"];
        [self addNote:n];
    }
}
+(NSString*)pathForArchive{
    NSArray *documentDirectories  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"noteCollection.archive"];
}
@end
