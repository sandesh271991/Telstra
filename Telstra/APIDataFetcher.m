//
//  APIDataFetcher.m
//  Telstra
//
//  Created by LION-2 on 6/5/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import "APIDataFetcher.h"

@implementation APIDataFetcher


 +(void)loadDataFromAPI: (NSString *)url parameter:(NSString *)params callback:(void(^)(NSDictionary *result, NSError *error))callback {
    
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"]];
     [request setHTTPMethod:@"GET"];
     [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
     [request addValue:@"text/plain" forHTTPHeaderField:@"Accept"];
     
     NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
     [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
         NSData * responseData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
         if (responseData != nil) {
             
             NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
             if (error == nil) {
                 callback(jsonDict,nil);
             }
             else {
                 callback(nil,error);
             }
         }
         
     }] resume];
}

@end
