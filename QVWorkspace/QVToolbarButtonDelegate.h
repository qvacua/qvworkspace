/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>


@class QVToolbarButton;


@protocol QVToolbarButtonDelegate <NSObject>

- (void)toolbarButton:(QVToolbarButton *)toolbarButton clickedWithEvent:(NSEvent *)event;

@end
