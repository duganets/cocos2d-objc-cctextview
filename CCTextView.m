//
//  CCTextView.m
//
//  Created by Mike Duganets on 12/10/15.
//

#import "CCTextView.h"
#import "CCDirector.h"

@implementation CCTextView

- (id) init
{
    self = [super init];
    if (!self)
        return nil;
    
    _scaleMultiplier = [CCDirector sharedDirector].contentScaleFactor/[UIScreen mainScreen].scale;
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.editable = NO;
    _textView.userInteractionEnabled = NO;
    _textView.scrollEnabled = NO;
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    
    return self;
}
-(void)setVisible:(BOOL)visible
{
    BOOL isChanged = (visible != self.visible);
    [super setVisible:visible];
    if (isChanged) {
        if (self.visible) {
            [self addUITextView];
        } else {
            [self removeUITextView];
        }
    }
}
-(void)setAttributedString:(NSAttributedString*)str
{
    _textView.contentSize = CGSizeMake(self.contentSize.width, MAXFLOAT);
    _textView.attributedText = str;
    CGFloat fixedWidth = self.contentSize.width;
    CGSize newSize = [_textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = _textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    _textView.frame = newFrame;
    self.contentSize = newFrame.size;
}
-(void) onEnter
{
    [super onEnter];
}
- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    [self addUITextView];
    [self p_positionInControl];
}
- (void) onExitTransitionDidStart
{
    [super onExitTransitionDidStart];
    [self removeUITextView];
    
}
- (void) update:(CCTime)delta
{
    BOOL isVisible = self.visible;
    if (isVisible) {
        // run through ancestors and see if we are visible
        for (CCNode *parent = self.parent; parent && isVisible; parent = parent.parent)
            isVisible &= parent.visible;
    }
    if (isVisible)  [self p_positionInControl];
}

-(void) p_positionInControl {
    CGPoint worldPos = [self convertToWorldSpace:CGPointZero];
    CGPoint viewPos = [[CCDirector sharedDirector] convertToUI:worldPos];
    
    CGSize size = self.contentSizeInPoints;
    size.width *= _scaleMultiplier;
    size.height *= _scaleMultiplier;
    
    viewPos.y -= size.height;
    
    CGRect frame = CGRectZero;
    frame.origin = viewPos;
    frame.size = size;
    
    _textView.frame = frame;
}
- (void) addUITextView
{
    [[[CCDirector sharedDirector] view] addSubview:_textView];
}
- (void) removeUITextView
{
    [_textView removeFromSuperview];
}


@end
