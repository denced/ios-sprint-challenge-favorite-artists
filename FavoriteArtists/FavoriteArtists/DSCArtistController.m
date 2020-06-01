//
//  DSCArtistController.m
//  FavoriteArtists
//
//  Created by denis cedeno on 5/31/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

#import "DSCArtistController.h"
#import "DSCArtist.h"
#import "DSCArtist+_NSJSONSerialization.h"
#import "DSCAddArtistViewController.h"

@implementation DSCArtistController

-(instancetype)init {
    if (self = [super init]) {
        _artistArray = [[NSMutableArray alloc]init];
     }
     return self;
}

-(void)saveArtist:(DSCArtist *)artist
{
    NSLog(@"from saveArtist");
    [self loadFromPersistentStore];
    [self.artistArray addObject:artist];
    [self saveToPersistentStore];
}

-(void)deleteArtist:(DSCArtist *)artist
{
    [self.artistArray removeObject:artist];
    [self saveToPersistentStore];
}

- (NSArray *)returnArtistArray 
{
    return [self.artistArray copy];
}

- (NSURL *)persistentFileURL
{
    NSURL *directory = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *fileName = @"artists.json";
    return [directory URLByAppendingPathComponent:fileName];
}

-(void)saveToPersistentStore
{
     NSURL *url = [self persistentFileURL];
    //artist -> innerDictionary -> middleArray -> outerDictionary -> writeTo URL
    NSMutableArray *middleArray = [[NSMutableArray alloc]init];
    
    for (DSCArtist *artist in self.artistArray)
    {
        NSDictionary *innerDictionary = [artist toDictionary];
        [middleArray addObject:innerDictionary];
    }
    NSDictionary *outerDictionary = @{ @"artists" : middleArray};
    [outerDictionary writeToURL:url atomically:YES];
    return;
}

- (void)loadFromPersistentStore
{
    NSURL *url = [self persistentFileURL];
    //loadingDictionary -> middleArray -> innerDictionary -> artist -> artistArray
    NSDictionary *loadingDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    NSArray *middleArray = loadingDictionary[@"artists"];
    for (NSDictionary *innerDictionary in middleArray) {
        DSCArtist *artist = [[DSCArtist alloc]initWithDictionary:innerDictionary];
        [self.artistArray addObject:artist];
    }
}

@end
