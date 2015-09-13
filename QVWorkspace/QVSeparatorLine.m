/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import "QVSeparatorLine.h"
#import <PureLayout/PureLayout.h>


const CGFloat qSeparatorDimension = 1;


QVSeparatorLine *vertical_separator_line() {
  QVSeparatorLine *line = [[QVSeparatorLine alloc] initForAutoLayout];

  line.intrinsicContentSize = CGSizeMake(qSeparatorDimension, NSViewNoInstrinsicMetric);
  [line setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationHorizontal];

  return line;
}

QVSeparatorLine *horizontal_separator_line() {
  QVSeparatorLine *line = [[QVSeparatorLine alloc] initForAutoLayout];

  line.intrinsicContentSize = CGSizeMake(NSViewNoInstrinsicMetric, qSeparatorDimension);
  [line setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];

  return line;
}


@implementation QVSeparatorLine

- (instancetype)initForAutoLayout {
  self = [super initForAutoLayout];
  if (self == nil) {return nil;}

  self.boxType = NSBoxCustom;
  self.borderType = NSLineBorder;
  self.borderColor = [NSColor controlShadowColor];

  return self;
}

- (BOOL)isOpaque {
  return YES;
}

@end
