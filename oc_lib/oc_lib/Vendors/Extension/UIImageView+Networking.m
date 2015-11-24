//
//  UIImageView+Networking.m
//  EKS
//
//  Created by ligh on 15/10/13.
//
//

#import "UIImageView+Networking.h"
#import "GradientProgressView.h"

@implementation UIImageView (Networking)

-(void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder {
  
    [self setImageWithURLString:urlString placeholderImage:placeholder progress:nil];
    
}

-(void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder progress:(void (^)(float))block {
    
    
        //显示下载进度
    GradientProgressView *hudView = (GradientProgressView *)[self viewWithTag:1000];
    if (!hudView) {
    
        hudView = [[GradientProgressView alloc] initWithFrame:CGRectMake(0,0, self.width, 2.5f)];
        hudView.tag = 1000;
        [self addSubview:hudView];
    }
    
    hudView.top = (0 > self.top) ? fabs(self.top) : 0;
   [hudView startAnimating];
    
    self.backgroundColor = UIColorFromRGB(232,232,232);
    self.image = placeholder;
    self.contentMode = UIViewContentModeCenter;
    
    
    
    __weak __typeof(self)weakSelf = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    
    [self setImageWithURLRequest:request placeholderImage:placeholder success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        weakSelf.image = image;
        
        
        [hudView stopAnimating];
        weakSelf.contentMode = UIViewContentModeScaleAspectFill;
        
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        [hudView stopAnimating];
        
    }];
    
    [self.af_imageRequestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        float receivedSizeF = totalBytesRead;
        float expectedSizeF = totalBytesExpectedToRead;
        float progressSizeF = receivedSizeF / expectedSizeF;
        
        [hudView setProgress:progressSizeF];
        
        if (block) {
            block(progressSizeF);
        }
        
    }];
  
    
}

@end
