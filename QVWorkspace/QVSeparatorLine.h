/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>


extern const CGFloat qSeparatorDimension;


@interface QVSeparatorLine : NSBox

@property NSSize intrinsicContentSize;

@end


extern QVSeparatorLine *vertical_separator_line();
extern QVSeparatorLine *horizontal_separator_line();

