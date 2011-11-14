//
//  TTParseModel.m
//  extParse
//
//  Created by Sumeru Chatterjee on 11/13/11.
//  Copyright (c) 2011 Sumeru Chatterjee. All rights reserved.
//

#import "TTParseModel.h"
#import "NSArrayAdditions.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTParseModel

@synthesize loadedTime  = _loadedTime;
@synthesize query = _query;
@synthesize objects = _objects;

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithQuery:(PFQuery*)query {
    
    if(self=[super init]) {
        _query = [query retain];
        _query.cachePolicy  = kPFCachePolicyNetworkOnly;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    
    TT_RELEASE_SAFELY(_loadedTime);
    TT_RELEASE_SAFELY(_query);
    
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return !!_loadedTime;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return _isLoading;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
 
    [self.query findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
    _isLoading = YES;
    [self didStartLoad];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancel {
    //To be implemented
    [self didCancelLoad];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Parse CallBackSelector

-(void)callbackWithResult:(NSArray*)result error:(NSError*)error {         
   
    _isLoading = NO;
    if (error) {
        [self didFailLoadWithError:error]; 
        return;
    } 
    
    [_loadedTime release];
    _loadedTime = [[NSDate date] retain];    
    
    [_objects release];
    _objects = [[NSArray arrayWithParseObjectArray:result] retain];
    
    [self didFinishLoad];     
}

@end