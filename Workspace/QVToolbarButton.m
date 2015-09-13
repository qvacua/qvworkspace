/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <PureLayout/PureLayout.h>
#import "QVToolbarButton.h"
#import "NSString+QVWorkspace.h"
#import "QVToolbarButtonDelegate.h"
#import "QVTool.h"


static const CGFloat qButtonHorizontalPadding = 5;
static const CGFloat qButtonVerticalPadding = 3;
static const CGFloat qMaxButtonWidth = 200;
static const CGFloat qMaxButtonHeight = 30;


@implementation QVToolbarButton {
  NSColor *_backgroundColor;
  NSTrackingArea *_trackingArea;
  CGSize _size;
}

- (instancetype)initWithTitle:(NSString *)title {
  self = [super initForAutoLayout];
  if (self == nil) {return nil;}

  _title = title;
  _active = NO;
  _backgroundColor = [NSColor windowBackgroundColor];

  _size = [_title sizeWithAttributes:@{
      NSFontAttributeName : [NSFont systemFontOfSize:11]
  }];
  _size.width = MIN(2 * qButtonHorizontalPadding + ceil(_size.width), qMaxButtonWidth);
  _size.height = MIN(2 * qButtonVerticalPadding + ceil(_size.height), qMaxButtonHeight);

  return self;
}

- (void)setActive:(BOOL)active {
  _active = active;

  _backgroundColor = _active ? [NSColor controlShadowColor] : [NSColor windowBackgroundColor];
  self.needsDisplay = YES;
}

- (CGSize)size {
  if (_orientation == QVToolbarButtonOrientationHorizontal) {
    return _size;
  } else {
    return CGSizeMake(_size.height, _size.width);
  }
}

#pragma mark NSResponder
- (void)mouseUp:(NSEvent *)event {
  NSPoint convertedPoint = [self.superview convertPoint:event.locationInWindow fromView:nil];
  if (!NSPointInRect(convertedPoint, self.frame)) {
    return;
  }

  [_delegate toolbarButton:self clickedWithEvent:event];
}

- (void)mouseEntered:(NSEvent *)theEvent {
  [super mouseEntered:theEvent];

  _backgroundColor = [NSColor controlShadowColor];
  self.needsDisplay = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
  [super mouseExited:theEvent];

  _backgroundColor = _active ? [NSColor controlShadowColor] : [NSColor windowBackgroundColor];
  self.needsDisplay = YES;
}

#pragma mark NSView
- (void)updateTrackingAreas {
  [self removeTrackingArea:_trackingArea];

  _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                               options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp
                                                 owner:self
                                              userInfo:nil];
  [self addTrackingArea:_trackingArea];

  [super updateTrackingAreas];
}

- (void)drawRect:(NSRect)dirtyRect {
  [_backgroundColor set];
  NSRectFill(self.bounds);

  NSDictionary *attrs = @{NSFontAttributeName : [NSFont systemFontOfSize:11]};
  switch (_orientation) {
    case QVToolbarButtonOrientationHorizontal:
      [_title drawAtPoint:CGPointMake(qButtonHorizontalPadding, qButtonVerticalPadding) withAttributes:attrs];
      break;
    case QVToolbarButtonOrientationVerticalLeft:
      [_title drawAtBasePoint:CGPointMake(self.size.width / 2, self.size.height / 2) angle:M_PI_2 attributes:attrs];
      break;
    case QVToolbarButtonOrientationVerticalRight:
      [_title drawAtBasePoint:CGPointMake(self.size.width / 2, self.size.height / 2) angle:-M_PI_2 attributes:attrs];
      break;
  }
}

@end
