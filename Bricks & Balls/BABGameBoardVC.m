//
//  BABGameBoardVC.m
//  Bricks & Balls
//
//  Created by JOSH HENDERSHOT on 8/6/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

#import "BABGameBoardVC.h"
#import "BABHeaderVeiw.h"

// when gameover clear bricks and show start button
// create new class called "BABLevelData" as a subclass of NSObject
// make a method that will drop a uiview (gravity) from a broken brick like a powerup
//listen for it to collide with paddle
//randomly change size of paddle when powerup hit


@interface BABGameBoardVC ()<UICollisionBehaviorDelegate>
@property (nonatomic) BOOL ballPushed;

@end

@implementation BABGameBoardVC
{
    UIDynamicAnimator * animator;
    UIDynamicItemBehavior * ballItemBehavior;
    UIDynamicItemBehavior * powerupBehavior;
    UICollisionBehavior * powerupCollision;
    UIView * powerup;
    UICollisionBehavior * collisionBehavior;
    UIView * ball;
    UIGravityBehavior * gravityBehavior;
    
    
    NSMutableArray *bricks;
    UIView * paddle;
    UIDynamicItemBehavior * brickItemBehavior;
    UIAttachmentBehavior * attachmentBehavior ;
    
    UIButton * startButton;
    
    BABHeaderVeiw * headerView;
}

-(void)setBallPushed:(BOOL)ballPushed
{
    _ballPushed = ballPushed;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bricks = [@[]mutableCopy];
        
        headerView = [[BABHeaderVeiw alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [self.view addSubview:headerView];
        headerView.lives = 3;
        headerView.score = 0;
        
        
        
        animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
        ballItemBehavior = [[UIDynamicItemBehavior alloc]init];
        ballItemBehavior.friction = 0;
        ballItemBehavior.elasticity = 1;
        ballItemBehavior.resistance = 0;
        ballItemBehavior.allowsRotation = NO;
        [animator addBehavior:ballItemBehavior];
        
        
        powerupBehavior = [[UIDynamicItemBehavior alloc]init];
        //        powerupBehavior.friction = 1.0;
        powerupBehavior.allowsRotation = NO;
        [animator addBehavior:powerupBehavior];
        
        powerupCollision = [[UICollisionBehavior alloc]init];
        powerupCollision.collisionDelegate = self;
        [animator addBehavior:powerupCollision];
        
        
        gravityBehavior = [[UIGravityBehavior alloc]init];
        gravityBehavior.gravityDirection = CGVectorMake(0.0, 1.0);
        
        ///ask Jo why I have gravityDirection defined
        
        [animator addBehavior:gravityBehavior];
        
        
        
        brickItemBehavior = [[UIDynamicItemBehavior alloc]init];
        brickItemBehavior.density = 1000000;
        [animator addBehavior:brickItemBehavior];
        
        collisionBehavior = [[UICollisionBehavior alloc]init];
        collisionBehavior.collisionDelegate = self;
        //        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        
        [collisionBehavior addBoundaryWithIdentifier:@"floor" fromPoint:CGPointMake(0, SCREEN_HEIGHT) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        [collisionBehavior addBoundaryWithIdentifier:@"left Wall" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, SCREEN_HEIGHT)];
        [collisionBehavior addBoundaryWithIdentifier:@"right Wall" fromPoint:CGPointMake(SCREEN_WIDTH, 0) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        [collisionBehavior addBoundaryWithIdentifier:@"ceiling" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(SCREEN_WIDTH, 40)];
        
        [animator addBehavior:collisionBehavior];
        
        
    }
    return self;
}
-(void)powerups:(UIView*)brick
{
    powerup = [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y, 40, 40)];
    powerup.layer.cornerRadius = 20;
    powerup.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shape"]];
    [self.view addSubview:powerup];
    
    [powerupCollision addItem:powerup];
    [powerupCollision addItem:paddle];
    
    [gravityBehavior addItem:powerup];
}

-(void)resetBricks
{
    
    int colCount = 7;
    int rowCount = 4;
    int brickSpacing = 8;
    
    for (int col = 0 ; col < colCount; col++)
    {
        for (int row = 0 ; row < rowCount; row++)
        {
            float width = (SCREEN_WIDTH - (brickSpacing * (colCount +1)))/colCount;
            float height = ((SCREEN_HEIGHT/3) - (brickSpacing * rowCount ))/rowCount;
            float x = brickSpacing + ( width + brickSpacing)* col;
            float y = brickSpacing + ( height + brickSpacing)* row + 40;
            UIView * brick = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
            //            brick.backgroundColor = [UIColor colorWithRed:0.447f green:0.0384f blue:0.0306f alpha:1.0f];
            brick.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brick"]];
            [self.view addSubview:brick];
            [bricks addObject:brick];
            [collisionBehavior addItem: brick];
            [brickItemBehavior addItem:brick];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ballPushed = NO;
    
    [paddle removeFromSuperview];
    
    paddle = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100) /2,SCREEN_HEIGHT - 10 , 100, 8)];
    paddle.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:paddle];
    
    [self showStartButton];
    
}

- (void)showStartButton
{
    
    for (UIView * brick in bricks)
    {
        [brick removeFromSuperview];
        [collisionBehavior removeItem:brick];
        [brickItemBehavior removeItem:brick];
    }
    
    [bricks removeAllObjects];
    
    startButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2.0, (SCREEN_HEIGHT - 100) / 2.0, 100, 100)];
    [startButton setTitle:@"START" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    startButton.backgroundColor = [UIColor grayColor];
    startButton.layer.cornerRadius = 50;
    [self.view addSubview:startButton];
}

-(void)startGame
{
    [startButton removeFromSuperview];
    [self resetBricks];
    [self resetGame];
}
-(void)resetGame
{
    
    headerView.lives = 3;
    
    headerView.score = 0;
    
    ball = [[UIView alloc] initWithFrame:CGRectMake((paddle.center.x),SCREEN_HEIGHT - 50, 20,20)];
    ball.layer.cornerRadius = ball.frame.size.width / 2.0;
    ball.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:ball];
    self.ballPushed = NO;
    
    UITapGestureRecognizer *tripleTap =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(ballMovement:)];
    
    [tripleTap setNumberOfTapsRequired:3];
    [[self view] addGestureRecognizer:tripleTap];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    attachmentBehavior= [[UIAttachmentBehavior alloc]initWithItem:paddle attachedToAnchor:paddle.center];
    [animator addBehavior:attachmentBehavior];
    [brickItemBehavior addItem:paddle];
    [collisionBehavior addItem:paddle];
    
}
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if ([@"floor" isEqualToString:(NSString*)identifier])
    {
        UIView * ballItem = (UIView * )item;
        [collisionBehavior removeItem:ballItem];
        [ballItem removeFromSuperview];
        headerView.lives--;
        
        if (headerView.lives > 0 )
        {
            ball = [[UIView alloc] initWithFrame:CGRectMake((paddle.center.x),SCREEN_HEIGHT - 50, 20,20)];
            ball.layer.cornerRadius = ball.frame.size.width / 2.0;
            ball.backgroundColor = [UIColor purpleColor];
            [self.view addSubview:ball];
            self.ballPushed = NO;
            
            
            
            UITapGestureRecognizer *tripleTap =
            [[UITapGestureRecognizer alloc]
             initWithTarget:self action:@selector(ballMovement:)];
            
            [tripleTap setNumberOfTapsRequired:3];
            [[self view] addGestureRecognizer:tripleTap];
            
        } else {
            
            [self showStartButton];
        }
        
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    for ( UIView * brick in [bricks copy])
    {
        if ([item1 isEqual:brick] || [item2 isEqual:brick])
        {
            [collisionBehavior removeItem:brick];
            [gravityBehavior addItem:brick];
            [bricks removeObjectIdenticalTo:brick];
            
            
            int random = arc4random_uniform(8);
            if (random == 2)
            {
                [self powerups:(UIView*)brick];
                
            }
            
            
            headerView.score++;
            
            
            
            [UIView animateWithDuration:0.3 animations:^{
                brick.alpha = 0;
            } completion:^(BOOL finished) {
                [brick removeFromSuperview];
            }];
        }
    }
    
    if ([item1 isEqual:powerup] || [item2 isEqual:powerup])
    {
        [powerupCollision removeItem:powerup];
        
        [powerup removeFromSuperview];
        
        powerup = nil;
        
        if (powerup == nil)
        {
            CGRect frame = paddle.frame;
            
            frame.size.width = arc4random_uniform(100) + 40;
            
            paddle.frame = frame;
        }
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self movePaddleWithTouches:touches];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self movePaddleWithTouches:touches];
}


-(void)ballMovement:(NSSet*)touches
{
    self.ballPushed = YES;
    [collisionBehavior addItem:ball];
    UIPushBehavior * pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(0.1, - 0.1);
    [animator addBehavior:pushBehavior];
    [ballItemBehavior addItem:ball];
    
}
-(void)movePaddleWithTouches:(NSSet*)touches
{
    
    UITouch * touch = [touches allObjects][0];
    CGPoint location = [touch locationInView:self.view];
    float guard = paddle.frame.size.width /2.0 + 10;
    float dragX = location.x;
    if (dragX < guard) dragX = guard;
    if (dragX > SCREEN_WIDTH - guard)
    {
        dragX = SCREEN_WIDTH - guard;
    }
    
    attachmentBehavior.anchorPoint = CGPointMake (dragX, paddle.center.y);
    
    // only do this line when ball is not pushed
    
    if (self.ballPushed == NO)
    {
        ball.center = CGPointMake (location.x, ball.center.y);
    }
    
}

-(BOOL)prefersStatusBarHidden
{
    return  YES;
}


@end
