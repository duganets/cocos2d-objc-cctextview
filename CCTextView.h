//
//  CCTextView.h
//
//  Created by Mike Duganets on 12/10/15.
//

#import "CCNode.h"

@interface CCTextView : CCNode<UITextViewDelegate> {
    CGFloat _scaleMultiplier;
}

@property(nonatomic,readonly) UITextView *textView;

-(void)setAttributedString:(NSAttributedString*)str;

@end
