//
//  TTParseModel.h
//  extParse
//
//  Created by Sumeru Chatterjee on 11/13/11.
//  Copyright (c) 2011 Sumeru Chatterjee. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@protocol TTParseModelSearchDelegate;
/**
 * An implementation of TTModel which is built to work with Parse.
 */
@interface TTParseModel : TTModel  {
    
    NSDate* _loadedTime;
    PFQuery* _query;
    NSMutableArray* _objects;
    BOOL _isLoading;
    BOOL _alwaysLoading;
}

- (id)initWithQuery:(PFQuery*)query;
-(id) initAsLoadingModel ;

/**
 * Valid upon loading the Parse Model at least once. Represents the timestamp of the last time the parse model was loaded.
 */
@property (nonatomic, retain) NSDate*   loadedTime;
@property (nonatomic, readonly) PFQuery* query;
@property (nonatomic, retain) NSMutableArray* objects;

@property (nonatomic, assign) NSInteger queryLimit;
@end

@interface TTParseSearchModel : TTParseModel {
    id<TTParseModelSearchDelegate> _searchDelegate;
    TTParseModel* _parseModel;
    NSArray* _filteredObjects;
}

- (id)initWithParseModel:(TTParseModel*)parseModel;
- (void)search:(NSString*)text;

@property (nonatomic, retain) NSArray* filteredObjects;
@property (nonatomic, assign) id<TTParseModelSearchDelegate> searchDelegate;
@end


@protocol TTParseModelSearchDelegate <NSObject>
-(BOOL)isObject:(PFObject*)object validForSearchQuery:(NSString*)query;
@end