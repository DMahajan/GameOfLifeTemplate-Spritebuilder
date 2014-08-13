//
//  Grid.m
//  GameOfLife
//
//  Created by Sanjay Mahajan on 8/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {
    // 2D array to store all the creatures in the grid
    NSMutableArray *_gridArray;
    
    // used to place creatures correctly on the grid
    float _cellWidth;
    float _cellHeight;
} // it seems that the variables in the implementation go inside curly brackets

- (void)onEnter{
    [super onEnter];
    
    [self setupGrid];
    
    // accept touches on the grid
    self.userInteractionEnabled = YES;
}
 
- (void)setupGrid {
    // divide the grid's size by the number of columns/rows to figure out the width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
    // initialize Creatures
    for (int i = 0; i < GRID_ROWS; i++) {
        // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0,0);
            creature.position = ccp(x,y);
            [self addChild: creature];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            x += _cellWidth;
        }
        
        y += _cellHeight;
    }
    
}

// touchBegan is automatically created in Cocos2D 3.0 because we set userInteractionEnabled to YES earlier
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    // get the Creature at that location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    // invert its state - kill it if it's alive, bring it to life if it's dead.
    creature.IsAlive = !creature.isAlive;
    // when property isAlive is accessed, setIsAlive is automatically called
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition {
    // get the row and column that was touched, return the Creature inside the corresponding cell
    int row = touchPosition.y / _cellHeight;
    int column = touchPosition.x / _cellWidth;
    
    // (i think) okay to use int above because it's only used as an index
    return _gridArray[row][column];
}

- (void)evolveStep {
    // update each Creature's neighbor count
    [self countNeighbors];
    
    // update each Creature's state
    [self updateCreatures];
    
    // update the generation so the label's text will display the current generation
    _generation++;
    
}

- (void)countNeighbors {
    // iterate through the rows
    // note that NSArray has a method called 'count' that will return the number of elements in the array
    for (int i = 0; i < [_gridArray count]; i++) {
        // iterate through the columns in a given row
        for (int j = 0; j < [_gridArray[i] count]; j++) {
            // access the creature in the cell that corresponds to the current row/column
            Creature *currentCreature = _gridArray[i][j];
            
            // remember that every creature has a 'livingNeighbors' property that we created earlier
            currentCreature.livingNeighbors = 0;
            
            // now examine every cell around the current one
            
            // go through the top row of the current cell, the row the cell is in , and the bottom row
            for (int x = (i-1); x <= (i+1); x++) {
                // go through the left, middle, and right columns
                for (int y = (j-1); y <= (j+1); y++) {
                    // check that the cell we're checking isn't off screen
                    BOOL isIndexValid;
                    isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    // skip over all cells that are off screen and the cell that contains the current creature
                    if (isIndexValid && !((x == i) && (y == j)) && isIndexValid) {
                        Creature *neighbor = _gridArray[x][y];
                        if (neighbor.isAlive) {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                }
            }
        }
    }
}

-(BOOL)isIndexValidForX:(int)x andY:(int)y {
    
    BOOL isIndexValid = YES;
    if (x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS) {
        isIndexValid = NO;
    }
    return isIndexValid;
}

- (void)updateCreatures {
    int numAlive = 0;
    
    for (int i = 0; i < [_gridArray count]; i++) {
        for (int j = 0; j < [_gridArray[i] count]; j++) {
            Creature *currentCreature = _gridArray[i][j];
            if (currentCreature.livingNeighbors == 3) {
                currentCreature.isAlive = YES;
            } else if (currentCreature.livingNeighbors <= 1) {
                currentCreature.isAlive = NO;
            } else if (currentCreature.livingNeighbors >= 4) {
                currentCreature.isAlive = NO;
            }
            
            // note: if a creature has 2 neighbors, it stays in its current state
            
            if (currentCreature.isAlive) {
                numAlive++;
            }
        }
    }
    
    _totalAlive = numAlive;
}

@end
