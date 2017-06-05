//
//  APIDataFetcher.h
//  Telstra
//
//  Created by LION-2 on 6/5/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIDataFetcher : NSObject

+(void)loadDataFromAPI: (NSString *)url parameter:(NSString *)params callback:(void(^)(NSDictionary *result, NSError *error))callback ;


@end
