/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import "QVTool.h"
#import "QVToolbar.h"
#import "QVToolbarButton.h"


@implementation QVTool {
  QVToolbarButton *_button;
}

#pragma mark Public
- (instancetype)initWithToolView:(NSView *)toolView displayName:(NSString *)displayName {
  self = [super init];
  if (self == nil) {return nil;}

  _toolView = toolView;
  _displayName = [displayName copy];
  _dimension = 50;

  return self;
}

- (QVToolbarButton *)button {
  if (_button == nil) {
    _button = [[QVToolbarButton alloc] initWithTitle:_displayName];
    _button.tool = self;
  }

  return _button;
}

#pragma mark NSObject
- (BOOL)isEqual:(id)other {
  if (other == self)
    return YES;
  if (!other || ![[other class] isEqual:[self class]])
    return NO;

  return [self isEqualToTool:other];
}

- (BOOL)isEqualToTool:(QVTool *)tool {
  if (self == tool)
    return YES;
  if (tool == nil)
    return NO;
  if (self.toolView != tool.toolView && ![self.toolView isEqual:tool.toolView])
    return NO;
  return YES;
}

- (NSUInteger)hash {
  return [self.toolView hash];
}

@end
