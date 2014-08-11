//
//  BABGameBoardVC.m
//  Bricks & Balls
//
//  Created by JOSH HENDERSHOT on 8/6/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

#import "BABGameBoardVC.h"
#import "BABHeaderVeiw.h"
#import "BABLevelData.h"


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
    UIView * powerup1;
    UIView * powerup2;
    UIView * powerup3;
    UIView * powerup4;
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
    // // create 5 different types of power ups (paddle size big, paddle size small, multi ball, ball size big, ball size small) - the power ups should look different
    int random = arc4random_uniform(10);
    
    if (random == 2)
    {
    powerup = [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y, 40, 40)];
    powerup.layer.cornerRadius = 20;
    powerup.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plank"]];
    [self.view addSubview:powerup];
    [powerupCollision addItem:powerup];
    [powerupCollision addItem:paddle];
    [gravityBehavior addItem:powerup];
    }
    if (random == 3)
    {
        powerup1 = [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y, 20, 20)];
        powerup1.layer.cornerRadius = 50;
        powerup1.backgroundColor = [UIColor redColor];
//        powerup1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plank"]];
        [self.view addSubview:powerup1];
        [powerupCollision addItem:powerup1];
        [powerupCollision addItem:paddle];
        [gravityBehavior addItem:powerup1];
    }
    if (random == 4)
    {
        powerup2 = [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y, 20, 20)];
        powerup2.layer.cornerRadius = 50;
        powerup2.backgroundColor = [UIColor purpleColor];
        //        powerup1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plank"]];
        [self.view addSubview:powerup2];
        [powerupCollision addItem:powerup2];
        [powerupCollision addItem:paddle];
        [gravityBehavior addItem:powerup2];
    }
    if (random == 5)
    {
        powerup3 = [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y, 20, 20)];
        powerup3.layer.cornerRadius = 50;
        powerup3.backgroundColor = [UIColor whiteColor];
        //        powerup1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plank"]];
        [self.view addSubview:powerup3];
        [powerupCollision addItem:powerup3];
        [powerupCollision addItem:paddle];
        [gravityBehavior addItem:powerup3];
    }
    if (random == 6)
    {
        powerup4 = [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y, 20, 20)];
        powerup4.layer.cornerRadius = 50;
        powerup4.backgroundColor = [UIColor magentaColor];
        //        powerup1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plank"]];
        [self.view addSubview:powerup4];
        [powerupCollision addItem:powerup4];
        [powerupCollision addItem:paddle];
        [gravityBehavior addItem:powerup4];
    }
}

-(void)resetBricks
{
    
    int colCount = [[[BABLevelData mainData] levelInfo][@"cols"]intValue];
    int rowCount = [[[BABLevelData mainData] levelInfo][@"rows"]intValue];
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
            [BABLevelData mainData].currentLevel = 0;

            
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
            
    
            [self powerups:(UIView*)brick];
            
            
            
            
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
            
            frame.size.width = 150;
            
            paddle.frame = frame;
        }
    }
    if ([item1 isEqual:powerup1] || [item2 isEqual:powerup1])
    {
        [powerupCollision removeItem:powerup1];
        [collisionBehavior removeItem:paddle];
        [powerup1 removeFromSuperview];
        
        powerup1 = nil;
        
        if (powerup1 == nil)
        {
            CGRect frame = paddle.frame;
            
            frame.size.width = 40;
            
            paddle.frame = frame;
        }
        [collisionBehavior addItem:paddle];
    }
    if ([item1 isEqual:powerup2] || [item2 isEqual:powerup2])
    {
        [powerupCollision removeItem:powerup2];
        
        [powerup2 removeFromSuperview];
        
        powerup2 = nil;
        
        if (powerup2 == nil)
        {
            ball = [[UIView alloc] initWithFrame:CGRectMake((paddle.center.x),SCREEN_HEIGHT - 50, 20,20)];
            ball.layer.cornerRadius = ball.frame.size.width / 2.0;
            ball.backgroundColor = [UIColor purpleColor];
            [self.view addSubview:ball];
            [collisionBehavior addItem:ball];
            UIPushBehavior * pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];
            pushBehavior.pushDirection = CGVectorMake(0.08, - 0.08);
            [animator addBehavior:pushBehavior];
            [ballItemBehavior addItem:ball];
        }
    }
    if ([item1 isEqual:powerup3] || [item2 isEqual:powerup3])
    {
        [powerupCollision removeItem:powerup3];
        
        [powerup3 removeFromSuperview];
        
        powerup3 = nil;
        
        if (powerup3 == nil)
        {
            CGRect frame = ball.frame;
            
            frame.size.width = 10;
            frame.size.height = 10;
            ball.layer.cornerRadius = 5;
            
            ball.frame = frame;
        }
    }
    if ([item1 isEqual:powerup4] || [item2 isEqual:powerup4])
    {
        [powerupCollision removeItem:powerup4];
        
        [powerup4 removeFromSuperview];
        
        powerup4 = nil;
        
        if (powerup4 == nil)
        {
            CGRect frame = ball.frame;
            
            frame.size.width = 80;
            frame.size.height = 80;
            ball.layer.cornerRadius = 40;

            ball.frame = frame;
        }
    }
    
    if (bricks.count == 0)
    {
        [collisionBehavior removeItem:ball];
        [ball removeFromSuperview];
        [BABLevelData mainData].currentLevel++;
        [self showStartButton];
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
    pushBehavior.pushDirection = CGVectorMake(0.08, - 0.08);
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
