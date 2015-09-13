/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import "NSView+QVWorkspace.h"


@implementation NSView (QVWorkspace)

- (void)_qvworkspace_removeAllSubviews {
  NSArray *allSubViews = self.subviews.copy;

  for (NSView *view in allSubViews) {
    [view removeFromSuperview];
  }
}

@end
