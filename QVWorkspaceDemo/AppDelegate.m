/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import "AppDelegate.h"
#import <QVWorkspace/QVWorkspace.h>
#import <PureLayout/PureLayout.h>


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  QVWorkspace *workspace = [[QVWorkspace alloc] initForAutoLayout];
  [[self.window contentView] addSubview:workspace];

  [workspace autoPinEdgeToSuperviewEdge:ALEdgeLeft];
  [workspace autoPinEdgeToSuperviewEdge:ALEdgeRight];
  [workspace autoPinEdgeToSuperviewEdge:ALEdgeTop];
  [workspace autoPinEdgeToSuperviewEdge:ALEdgeBottom];

  NSView *projectView = [self dummyViewWithColor:[NSColor whiteColor]];

  [workspace addToolView:projectView displayName:@"Project" location:QVToolbarLocationLeft];
  [workspace addToolView:[self dummyViewWithColor:[NSColor brownColor]] displayName:@"Run" location:QVToolbarLocationLeft];
  [workspace addToolView:[self dummyViewWithColor:[NSColor cyanColor]] displayName:@"Structure" location:QVToolbarLocationRight];
  [workspace addToolView:[self dummyViewWithColor:[NSColor greenColor]] displayName:@"TODO" location:QVToolbarLocationBottom];
  //[workspace addToolView:[self dummyViewWithColor:[NSColor magentaColor]] displayName:@"Changes" location:QVToolbarLocationTop];

  [workspace showToolView:projectView];
  
  [workspace setDimension:200 toolView:projectView];
}

- (NSView *)dummyViewWithColor:(NSColor *)color {
  NSView *view = [[NSView alloc] initForAutoLayout];

  view.wantsLayer = YES;
  view.layer.backgroundColor = color.CGColor;

  return view;
}

@end
