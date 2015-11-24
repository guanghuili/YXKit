//
//  PageModel.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "PageModel.h"

@implementation PageModel



-(BOOL) isMoreData
{
    return _pagenow.intValue < _totalpage.intValue;
}

@end
