//
//  CardsCollectionViewController.m
//  colourMemory
//
//  Created by marcosgn1 on 3/19/16.
//  Copyright © 2016 Marcos Garcia. All rights reserved.
//

#import "CardsCollectionViewController.h"

@interface CardsCollectionViewController ()
{
    NSMutableArray *cardsImages;
    NSMutableArray *hiddenCardImages;
    
    NSString *selectedCardID;
    
    BOOL cardsWereReseted;
    int numberOfSwipes;
    int attemptsCounts;
}

@end

@implementation CardsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    attemptsCounts = 0;
    
    numberOfSwipes = 0;
    
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UINib *cellCard = [UINib nibWithNibName:@"SingleCardCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellCard forCellWithReuseIdentifier:@"cell"];
    
    //Initializing cardsImages Array
    cardsImages = [NSMutableArray array];
    
    for (int numberOfRowsinGrid = 0; numberOfRowsinGrid < 4; numberOfRowsinGrid++)
    {
        for (int cardIndex = 1; cardIndex <= 4 ; cardIndex++)
        {
            NSString *cardColor = @"colour";
            NSString *extension = @".png";
            NSString *cardName = [NSString stringWithFormat:@"%@%d%@", cardColor, cardIndex, extension];
            
            [cardsImages addObject:cardName];
        }
    }
    
    
    //Initializing hiddenCardImages Array
    hiddenCardImages = [NSMutableArray array];
    
    for (int numberOfRowsinGrid = 0; numberOfRowsinGrid < 4; numberOfRowsinGrid++)
    {
        NSArray *colorIds = [self generateRandomUniqueColorIds];
        
        for (id colorID in colorIds)
        {
            NSString *cardColor = @"colour";
            NSString *extension = @".png";
            NSString *cardName = [NSString stringWithFormat:@"%@%@%@", cardColor, colorID, extension];
            
            [hiddenCardImages addObject:cardName];
        }
    }
}

-(NSArray *)generateRandomUniqueColorIds
{
    NSMutableArray *unqArray=[[NSMutableArray alloc] init];
    
    int randNum = 5 + arc4random() % (9 - 5);
    int counter=0;
    
    while (counter<4)
    {
        if (![unqArray containsObject:[NSNumber numberWithInt:randNum]])
        {
            [unqArray addObject:[NSNumber numberWithInt:randNum]];
            counter++;
        }else
        {
            randNum = 5 + arc4random() % (9 - 5);
        }
    }
    return [unqArray copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return cardsImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    SingleCardCollectionViewCell *singleCardCollectionCell = (SingleCardCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    singleCardCollectionCell.cardsImageView.image = [UIImage imageNamed:[cardsImages objectAtIndex:indexPath.row]];
    
    return singleCardCollectionCell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    numberOfSwipes ++;
    
    if (numberOfSwipes >= 17 && !cardsWereReseted)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Congratulations"
                                      message:@"You win!!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Accept"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handle accept button
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        cardsWereReseted = NO;
    }
    
    
    //Attempts count increased
    attemptsCounts ++;
    
    //get selected card id
    if (selectedCardID && [selectedCardID isEqualToString:hiddenCardImages[indexPath.row]])
    {
        //Keep playing
        //reset attemps count
        attemptsCounts = 0;
        selectedCardID = @"";
        
    }
    else if (attemptsCounts == 2)
    {
        //[self resetCards];
        [self performSelector:@selector(resetCards) withObject:self afterDelay:1.0];
        attemptsCounts = 0;
        
    }
    
    selectedCardID = hiddenCardImages[indexPath.row];
    [cardsImages replaceObjectAtIndex:indexPath.row withObject:hiddenCardImages[indexPath.row]];
    
    [collectionView reloadData];
}
     
    
     
-(void)resetCards
{
    //reset showed cardImages
    cardsImages = [NSMutableArray array];
    
    for (int numberOfRowsinGrid = 0; numberOfRowsinGrid < 4; numberOfRowsinGrid++)
    {
        for (int cardIndex = 1; cardIndex <= 4 ; cardIndex++)
        {
            NSString *cardColor = @"colour";
            NSString *extension = @".png";
            NSString *cardName = [NSString stringWithFormat:@"%@%d%@", cardColor, cardIndex, extension];
            
            [cardsImages addObject:cardName];
        }
    }
    
    
    [self.collectionView reloadData];
    
    cardsWereReseted = YES;
    numberOfSwipes = 0;
    
}

-(void)startAgain
{
    //randomize hidden cards
    hiddenCardImages = [NSMutableArray array];
    
    for (int numberOfRowsinGrid = 0; numberOfRowsinGrid < 4; numberOfRowsinGrid++)
    {
        NSArray *colorIds = [self generateRandomUniqueColorIds];
        
        for (id colorID in colorIds)
        {
            NSString *cardColor = @"colour";
            NSString *extension = @".png";
            NSString *cardName = [NSString stringWithFormat:@"%@%@%@", cardColor, colorID, extension];
            
            [hiddenCardImages addObject:cardName];
        }
    }
    
    [self.collectionView reloadData];
    
}


#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize mElementSize = CGSizeMake(80, 130);
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


@end
