/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>


@protocol QVToolbarButtonDelegate;
@class QVTool;


typedef enum {
  QVToolbarButtonOrientationHorizontal = 0,
  QVToolbarButtonOrientationVerticalLeft,
  QVToolbarButtonOrientationVerticalRight,
} QVToolbarButtonOrientation;


@interface QVToolbarButton : NSView

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, weak) QVTool *tool;
@property (nonatomic, getter=isActive) BOOL active;
@property (nonatomic, weak) id<QVToolbarButtonDelegate> delegate;
@property (nonatomic, readonly) CGSize size;

@property QVToolbarButtonOrientation orientation;

- (instancetype)initWithTitle:(NSString *)title;

#pragma mark NSResponder
- (void)mouseUp:(NSEvent *)theEvent;

#pragma mark NSView
- (void)drawRect:(NSRect)dirtyRect;

@end

