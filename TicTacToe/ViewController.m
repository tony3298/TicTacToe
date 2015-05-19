//
//  ViewController.m
//  TicTacToe
//
//  Created by Tony Dakhoul on 5/17/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *boardLabels;

@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;

@property CGPoint whichPlayerLabelStartPoint;

@property NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.whichPlayerLabel.text = @"X";
    [self setColor:self.whichPlayerLabel];

//    self.whichPlayerLabel.textColor = [UIColor blueColor];

}

-(void)viewDidAppear:(BOOL)animated {

    self.whichPlayerLabelStartPoint = self.whichPlayerLabel.center;
    NSLog(@"%@", NSStringFromCGPoint(self.whichPlayerLabelStartPoint));

    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(switchPlayers) userInfo:nil repeats:YES];

}

-(UILabel *)findLabelUsingPoint:(CGPoint)point {

    UILabel *label;

    for (label in self.boardLabels) {
        if(CGRectContainsPoint(label.frame, point)) {

            break;
        }
    }

    return label;
}

-(IBAction)onLabelTapped:(UITapGestureRecognizer *)sender {

    CGPoint point = [sender locationInView:self.view];

    UILabel *label = [self findLabelUsingPoint:point];

    NSString *winner;

    if (label != nil && [label.text isEqualToString:@""]) {
        label.text = self.whichPlayerLabel.text;
        [self setColor:label];

        winner = [self whoWon];
        if (![winner isEqualToString:@""]) {

            [self.timer invalidate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:winner message:@"Would you like to play again?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Play Again", nil];

            [alert show];
        } else {

            [self switchPlayers];
        }
    }

}

-(IBAction)onLabelDragged:(UIPanGestureRecognizer *)sender {

    CGPoint point = [sender locationInView:self.view];

    if(CGRectContainsPoint(self.whichPlayerLabel.frame, point)) {

        self.whichPlayerLabel.center = point;

        if (sender.state == UIGestureRecognizerStateEnded) {

            UILabel *label = [self findLabelUsingPoint:point];

            [UIView animateWithDuration:0.5f animations:^{
                self.whichPlayerLabel.center = self.whichPlayerLabelStartPoint;
            }];

            NSString *winner;

            if (label != nil && [label.text isEqualToString:@""]) {
                label.text = self.whichPlayerLabel.text;
                [self setColor:label];
                winner = [self whoWon];
                
                if (![winner isEqualToString:@""]) {

                    [self.timer invalidate];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:winner message:@"Would you like to play again?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Play Again", nil];

                    [alert show];
                } else {
                
                    [self switchPlayers];
                }
            }
        }
    }
}


-(void)switchPlayers{

    self.whichPlayerLabel.text = ([self.whichPlayerLabel.text isEqualToString:@"X"]) ? @"O" : @"X";
    [self setColor:self.whichPlayerLabel];

    [self.timer invalidate];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(switchPlayers) userInfo:nil repeats:YES];
}

-(void)setColor:(UILabel *)label{

    label.textColor = ([label.text isEqualToString:@"X"]) ? [UIColor blueColor] : [UIColor redColor];

}

-(NSString *)whoWon{

    NSString *winner = @"";

    NSString *boardString = [NSString new];
    for (UILabel *label in self.boardLabels) {
        if (![label.text isEqualToString:@""]) {

            boardString = [boardString stringByAppendingString:label.text];

        } else {

            boardString = [boardString stringByAppendingString:@"-"];
        }
    }

    NSLog(@"%@", boardString);

    NSError *error = NULL;
    NSString *currentPlayer = self.whichPlayerLabel.text;

    NSString *regexString = @"QQQ......|...QQQ...|......QQQ|Q..Q..Q..|.Q..Q..Q.|..Q..Q..Q|Q...Q...Q|..Q.Q.Q..";

    regexString = [regexString stringByReplacingOccurrencesOfString:@"Q" withString:currentPlayer];

//    NSString *regexString1 = [NSString stringWithFormat:@"%@%@%@......", currentPlayer, currentPlayer, currentPlayer];
//    NSString *regexString2 = [NSString stringWithFormat:@"...%@%@%@...", currentPlayer, currentPlayer, currentPlayer];
//    NSString *regexString3 = [NSString stringWithFormat:@"......%@%@%@", currentPlayer, currentPlayer, currentPlayer];
//    NSString *regexString4 = [NSString stringWithFormat:@"%@..%@..%@..", currentPlayer, currentPlayer, currentPlayer];
//    NSString *regexString5 = [NSString stringWithFormat:@".%@..%@..%@.", currentPlayer, currentPlayer, currentPlayer];
//    NSString *regexString6 = [NSString stringWithFormat:@"..%@..%@..%@", currentPlayer, currentPlayer, currentPlayer];
//    NSString *regexString7 = [NSString stringWithFormat:@"%@...%@...%@", currentPlayer, currentPlayer, currentPlayer];
//    NSString *regexString8 = [NSString stringWithFormat:@"..%@.%@.%@..", currentPlayer, currentPlayer, currentPlayer];
//
//    NSArray *regexStrings = [NSArray arrayWithObjects:regexString1, regexString2, regexString3, regexString4, regexString5, regexString6, regexString7, regexString8, nil];

//    for (NSString *regexString in regexStrings) {

        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];

        NSTextCheckingResult *match = [regex firstMatchInString:boardString options:0 range:NSMakeRange(0, boardString.length)];

        if(match) {

            winner = [NSString stringWithFormat:@"%@ wins!", currentPlayer];
        }
//    }

    return winner;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {

        [self restartGame];
    }
}

-(void)restartGame{

    for (UILabel *label in self.boardLabels) {
        label.text = @"";
    }

    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(switchPlayers) userInfo:nil repeats:YES];

}


- (IBAction)onStartOverTapped:(UIButton *)sender {

    [self.timer invalidate];
    [self restartGame];
}

@end
