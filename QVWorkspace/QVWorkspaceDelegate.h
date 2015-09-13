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


@protocol QVWorkspaceDelegate <NSObject>

@optional
- (CGFloat)toolbar:(QVToolbar *)toolbar willResizeToDimension:(CGFloat)dimension;
- (void)toolbarWillResize:(QVToolbar *)toolbar;
- (void)toolbarDidResize:(QVToolbar *)toolbar;

@end
