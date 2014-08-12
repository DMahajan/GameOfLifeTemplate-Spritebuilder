//
//  Creature.m
//  GameOfLife
//
//  Created by Sanjay Mahajan on 8/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Creature.h"

@implementation Creature

- (void)setIsAlive:(BOOL)newState {
    // when you create an @property, and instance variable with a leading underscore is automatically created for you
    _isAlive = newState;
    
    // 'visible' is a property of any class that inherits from CCNode. CCSprite is a subclass of CCNode, and Creature is a subclass of CCSprite, so Creatures have a visible property
    self.visible = _isAlive;
}

- (instancetype)initCreature {
    // since we made Creature inherit from CCSprite, 'super' below refers to CCSprite
    
    // sets image of creature to 'bubble.png'
    self = [super initWithImageNamed:@"GameOfLifeAssets/Assets/bubble.png"];
    
    //initializes creature to not be alive
    if (self) {
        self.isAlive = NO;
    }
    
    return self;
}
@end
