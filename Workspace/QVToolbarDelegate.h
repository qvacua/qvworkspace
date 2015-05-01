/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>


@class QVToolbar;


@protocol QVToolbarDelegate <NSObject>

@optional
- (void)toolbarChangedDimension:(QVToolbar *)toolbar;

@end
