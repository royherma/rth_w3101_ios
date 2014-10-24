//
//  NoteCollection.h
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
@interface NoteCollection : NSObject <NSCoding>

@property (readonly) NSMutableArray *collection;

+(NoteCollection*)sharedNotes;
-(NSUInteger)count;
-(void)addNote:(Note*)note;
-(void)removeNote:(Note*)note;
-(Note*)noteAtIndex:(int)index;
-(void)createTestNotes;
+(NSString*)pathForArchive;

@end
