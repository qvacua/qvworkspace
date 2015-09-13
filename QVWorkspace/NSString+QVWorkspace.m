/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import "NSString+QVWorkspace.h"


@implementation NSString (QVWorkspace)

- (void)drawAtBasePoint:(CGPoint)base angle:(CGFloat)radian attributes:(NSDictionary *)attr {
  CGSize textSize = [self sizeWithAttributes:attr];

  NSAffineTransform *translation = [[NSAffineTransform alloc] init];
  [translation translateXBy:base.x yBy:base.y];
  NSAffineTransform *rotation = [[NSAffineTransform alloc] init];
  [rotation rotateByRadians:radian];

  [translation concat];
  [rotation concat];

  [self drawAtPoint:CGPointMake(-1 * textSize.width / 2, -1 * textSize.height / 2) withAttributes:attr];

  [rotation invert];
  [translation invert];

  [rotation concat];
  [translation concat];
}

@end
