#import "MenubarController.h"
#import "StatusItemView.h"

@implementation MenubarController

@synthesize statusItemView = _statusItemView;
@synthesize statusItem = _statusItem;

#pragma mark -

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        // Install status item into the menu bar
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:_statusItem];
        _statusItemView.image = [NSImage imageNamed:@"Status"];
        _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
        _statusItemView.action = @selector(togglePanel:);

        [self startTicking];
    }
    return self;
}

- (void)changePrice:(float)price {
    
    [_statusItemView setBuyPrice:price];
    [_statusItem setLength:8*_statusItemView.buyPriceLength];
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

- (void)startTicking {
    [self tick];
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)tick {
    float newPrice = [self getBuyPrice];
    NSLog(@"tick: %f", newPrice);
    [self changePrice:newPrice];
}

- (float)getBuyPrice {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://coinbase.com/api/v1/prices/buy"]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *buyPriceString = [[json objectForKey:@"subtotal"] objectForKey:@"amount"];
    return [buyPriceString floatValue];
}

#pragma mark -
#pragma mark Public accessors

- (NSStatusItem *)statusItem
{
    return self.statusItemView.statusItem;
}

#pragma mark -

- (BOOL)hasActiveIcon
{
    return self.statusItemView.isHighlighted;
}

- (void)setHasActiveIcon:(BOOL)flag
{
    self.statusItemView.isHighlighted = flag;
}

@end
