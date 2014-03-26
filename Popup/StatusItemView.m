#import "StatusItemView.h"

@implementation StatusItemView

@synthesize statusItem = _statusItem;
@synthesize image = _image;
@synthesize alternateImage = _alternateImage;
@synthesize isHighlighted = _isHighlighted;
@synthesize action = _action;
@synthesize target = _target;
@synthesize buyPrice = _buyPrice;
@synthesize priceField = _priceField;

#pragma mark -

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, -2, itemWidth, itemHeight);
    _priceField = [[NSTextField alloc] initWithFrame:itemRect];
    _priceField.drawsBackground = NO;
    _priceField.bezeled = NO;
    [_priceField setSelectable:NO];
    [_priceField setEditable:NO];
    [[_priceField cell] setBackgroundStyle:NSBackgroundStyleRaised];
    _priceField.font = [NSFont boldSystemFontOfSize:12];

    [_priceField setAlignment:kCTTextAlignmentCenter];
    
    self = [super initWithFrame:itemRect];
    
    [self addSubview:_priceField];
    
    if (self != nil) {
        _statusItem = statusItem;
        _statusItem.view = self;
    }
    return self;
}

#pragma mark -

- (void)setBuyPrice:(float)buyPrice {
    _buyPrice = buyPrice;
    
    NSString *formattedNumber = [NSString stringWithFormat:@"%.02f", _buyPrice];
    NSString *display = [NSString stringWithFormat:@"BTC ≈ %@", formattedNumber];
    _priceField.stringValue = display;
    NSUInteger length = [display length];
    _buyPriceLength = (int)length;
    [self needsDisplay];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.isHighlighted];
    _priceField.textColor = _isHighlighted ? [NSColor whiteColor] : [NSColor blackColor];
    _priceField.frame = NSRectFromCGRect(CGRectMake(0, -2, (8*_buyPriceLength), [[NSStatusBar systemStatusBar] thickness]));

}

#pragma mark -
#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp sendAction:self.action to:self.target from:self];
}

#pragma mark -
#pragma mark Accessors

- (void)setHighlighted:(BOOL)newFlag
{
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}

#pragma mark -

- (void)setImage:(NSImage *)newImage
{
    if (_image != newImage) {
        _image = newImage;
        [self setNeedsDisplay:YES];
    }
}

- (void)setAlternateImage:(NSImage *)newImage
{
    if (_alternateImage != newImage) {
        _alternateImage = newImage;
        if (self.isHighlighted) {
            [self setNeedsDisplay:YES];
        }
    }
}

#pragma mark -

- (NSRect)globalRect
{
    NSRect frame = [self frame];
    frame.origin = [self.window convertBaseToScreen:frame.origin];
    return frame;
}

@end
