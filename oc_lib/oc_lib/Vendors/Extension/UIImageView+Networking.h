//
//  UIImageView+Networking.h
//  EKS
//
//  Created by ligh on 15/10/13.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView (Networking)

- (void) setImageWithURLString:(NSString *) urlString placeholderImage:(UIImage *)placeholder;

- (void) setImageWithURLString:(NSString *) urlString placeholderImage:(UIImage *)placeholder progress:(void (^)(float bytesRead)) block;



+ (NSOperationQueue *)af_sharedImageRequestOperationQueue;
- (AFHTTPRequestOperation *)af_imageRequestOperation;

@end
