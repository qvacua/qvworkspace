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
- (void)toolView:(nonnull NSView *)toolView didResize:(CGFloat)dimension;

@end
