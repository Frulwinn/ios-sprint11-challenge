//
//  FCCArtistController.m
//  Lyric Finder
//
//  Created by Lambda_School_Loaner_34 on 4/5/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

#import "FCCArtistController.h"
#import "FCCArtist.h"
#import "FCCArtist+NSJSONSerialization.h"

@interface FCCArtistController()
@property (nonatomic) NSMutableArray *internalArtists;

@end

@implementation FCCArtistController

- (instancetype)init {
    self = [super init];
    if (self) {
        _internalArtists = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)createFavoriteWithArtist:(NSString *)artist year:(NSInteger)year biography:(NSString *)biography {
    
    FCCArtist *favorite = [[FCCArtist alloc] initWithArtist:artist year:year biography:biography];
    [self.internalArtists addObject:favorite];
    
}

- (void)fetchWithArtist:(NSString *)artist completion:(void (^)(NSError * _Nonnull))completion {
    
    NSURL *baseURL = [NSURL URLWithString: baseURLString];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:YES];
    
    NSURLQueryItem *artistItem = [[NSURLQueryItem alloc] initWithName:@"strArtist" value:artist];
    [components setQueryItems:@[artistItem]];
    
    NSURL *requestURL = components.URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"error fetching data: %@", error);
            completion(error);
            return;
        }
        
        if (data == nil) {
            NSLog(@"No data returned form data task");
            completion(error);
            return;
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (![jsonDictionary isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON was not a dictionary");
            completion(error);
            return;
        }
        
        NSMutableArray *artists = [[NSMutableArray alloc] init];

        self.internalArtists = artists;
        completion(nil);
    }];
    
    [dataTask resume];

}




static NSString * const baseURLString = @"https://www.theaudiodb.com/api/v1/json/1/search.php?s";
static NSString * const apiKey = @"1";

@end
