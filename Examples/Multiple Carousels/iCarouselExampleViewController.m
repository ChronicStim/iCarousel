//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "iCarouselExampleViewController.h"

#define kCarouselID @"kCarouselID"
#define kCarouselOptionType @"kCarouselOptionType"
#define kCarouselOptionArc @"kCarouselOptionArc"
#define kCarouselOptionRadius @"kCarouselOptionRadius"
#define kCarouselOptionTilt @"kCarouselOptionTilt"
#define kCarouselOptionSpacing @"kCarouselOptionSpacing"
#define kCarouselOptionWrapOn @"kCarouselOptionWrapOn"
#define kCarouselOptionFadeMin @"kCarouselOptionFadeMin"
#define kCarouselOptionFadeMinAlpha @"kCarouselOptionFadeMinAlpha"
#define kCarouselOptionFadeMax @"kCarouselOptionFadeMax"
#define kCarouselOptionFadeRange @"kCarouselOptionFadeRange"
#define kCarouselOptionBounce @"kCarouselOptionBounce"

#define kiCarouselCurrentItemIndexChangedNotification @"kiCarouselCurrentItemIndexChangedNotification"

@interface iCarouselExampleViewController ()
{
    NSInteger _carouselBeingTouched;
}
@property (nonatomic, strong) NSArray *items1;
@property (nonatomic, strong) NSArray *items2;
@property (nonatomic, strong) NSDictionary *carousel1Info;
@property (nonatomic, strong) NSDictionary *carousel2Info;
@property (nonatomic, strong) NSDictionary *carousel3Info;

@end


@implementation iCarouselExampleViewController

@synthesize carousel1 = _carousel1;
@synthesize carousel2 = _carousel2;
@synthesize carousel3 = _carousel3;
@synthesize items1 = _items1;
@synthesize items2 = _items2;

- (void)awakeFromNib
{
    [super awakeFromNib];

    //set up data sources
    self.items1 = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *prefix in self.items1) {
        for (int i = 0; i < 10; i++)
        {
            [tempArray addObject:[NSString stringWithFormat:@"%@.%li",prefix,(long)i]];
        }
    }
    self.items2 = [NSArray arrayWithArray:tempArray];
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    self.carousel1.delegate = nil;
    self.carousel1.dataSource = nil;
    self.carousel2.delegate = nil;
    self.carousel2.dataSource = nil;
    self.carousel3.delegate = nil;
    self.carousel3.dataSource = nil;

}

-(NSDictionary *)carousel1Info;
{
    if (nil != _carousel1Info) {
        return _carousel1Info;
    }
    
    _carousel1Info = @{ kCarouselID : @(1),
                                  kCarouselOptionType : @(iCarouselTypeInvertedWheel),
                                  kCarouselOptionArc : @(0.01f),
                                  kCarouselOptionRadius : @(1.16f),
                                  kCarouselOptionTilt : @(0.9),
                                  kCarouselOptionSpacing: @(0.9f),
                                  kCarouselOptionWrapOn : @(NO),
                                  kCarouselOptionFadeMin: @(-2.0f),
                                  kCarouselOptionFadeMinAlpha: @(0.0f),
                                  kCarouselOptionFadeMax: @(2.0f),
                                  kCarouselOptionFadeRange: @(2.0f),
                                  kCarouselOptionBounce : @(NO)
    };
    return _carousel1Info;
}

-(NSDictionary *)carousel2Info;
{
    if (nil != _carousel2Info) {
        return _carousel2Info;
    }
    
    _carousel2Info = @{ kCarouselID : @(2),
                                    kCarouselOptionType : @(iCarouselTypeCoverFlow2),
                                    kCarouselOptionArc : @(0.13f),
                                    kCarouselOptionRadius : @(0.1f),
                                    kCarouselOptionTilt : @(1.0f),
                                    kCarouselOptionSpacing: @(0.98f),
                                    kCarouselOptionWrapOn : @(NO),
                                    kCarouselOptionFadeMin: @(-0.2f),
                                    kCarouselOptionFadeMinAlpha: @(0.0f),
                                    kCarouselOptionFadeMax: @(0.2f),
                                    kCarouselOptionFadeRange: @(2.0f),
                                    kCarouselOptionBounce : @(NO)
    };
    return _carousel2Info;
}

-(NSDictionary *)carousel3Info;
{
    if (nil != _carousel3Info) {
        return _carousel3Info;
    }
    
    _carousel3Info = @{ kCarouselID : @(3),
                                  kCarouselOptionType : @(iCarouselTypeCoverFlow2),
                                  kCarouselOptionArc : @(0.37f),
                                  kCarouselOptionRadius : @(1.16f),
                                  kCarouselOptionTilt : @(0.9),
                                  kCarouselOptionSpacing: @(1.5f),
                                  kCarouselOptionWrapOn : @(NO),
                                  kCarouselOptionFadeMin: @(-CGFLOAT_MAX),
                                  kCarouselOptionFadeMinAlpha: @(1.0f),
                                  kCarouselOptionFadeMax: @(CGFLOAT_MAX),
                                  kCarouselOptionFadeRange: @(1.0f),
                                  kCarouselOptionBounce : @(NO)
    };
    return _carousel3Info;
}

-(id)optionForCarouselID:(NSInteger)carouselID forKey:(NSString *)optionKey;
{
    id option = nil;
    iCarousel *carousel = nil;
    NSDictionary *carouselInfo = nil;
    switch (carouselID) {
        case 1: {
            carousel = self.carousel1;
            carouselInfo = self.carousel1Info;
        }     break;
        case 2: {
            carousel = self.carousel2;
            carouselInfo = self.carousel2Info;
        }    break;
        case 3: {
            carousel = self.carousel3;
            carouselInfo = self.carousel3Info;
        }    break;
        default:
            break;
    }
    if (nil != carousel && nil != optionKey) {
        option = [carouselInfo objectForKey:optionKey];
    }
    return option;
}

#pragma mark - Sync Carousels

-(void)carouselID:(NSInteger)carouselID didScrollToIndex:(NSInteger)index;
{
    NSTimeInterval duration = 0.05;
    switch (carouselID) {
        case 1: {
            // Update 2 & 3
            NSInteger adjustedIndex = [self matchingIndexInArray2ForIndexInArray1:index];
            [self.carousel2 scrollToOffset:(CGFloat)adjustedIndex duration:duration];
            [self.carousel3 scrollToOffset:(CGFloat)adjustedIndex duration:duration];
        }   break;
        case 2: {
            // Update 1 & 3
            [self.carousel3 scrollToOffset:(CGFloat)index duration:duration];
            NSInteger adjustedIndex = [self matchingIndexInArray1ForIndexInArray2:index];
            [self.carousel1 scrollToOffset:(CGFloat)adjustedIndex duration:duration];
        }  break;
        case 3: {
            // Update 1 & 2
            [self.carousel2 scrollToOffset:(CGFloat)index duration:duration];
            NSInteger adjustedIndex = [self matchingIndexInArray1ForIndexInArray2:index];
            [self.carousel1 scrollToOffset:(CGFloat)adjustedIndex duration:duration];
        } break;
        default:
            break;
    }
}

#pragma mark - Array to Array Conversion

-(NSInteger)matchingIndexInArray1ForIndexInArray2:(NSInteger)array2Index;
{
    NSInteger array1Index = NSNotFound;
    if (0 <= array2Index) {
        array1Index = array2Index / 10;
    }
    return array1Index;
}

-(NSInteger)matchingIndexInArray2ForIndexInArray1:(NSInteger)array1Index;
{
    NSInteger array2Index = NSNotFound;
    if (0 <= array1Index) {
        array2Index = array1Index * 10;
    }
    return array2Index;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    _carousel1 = nil;
    _carousel2 = nil;
    _carousel3 = nil;
}

-(void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    [self configCarousels];
}

-(void)configCarousels;
{
    self.carousel1.backgroundColor = [UIColor yellowColor];
    self.carousel1.tag = [self.carousel1Info[kCarouselID] intValue];
    self.carousel1.type = (iCarouselType)[self.carousel1Info[kCarouselOptionType] intValue];
    self.carousel1.bounces = (BOOL)[self.carousel1Info[kCarouselOptionBounce] boolValue];
    [self.carousel1 reloadData];
    
    self.carousel2.backgroundColor = [UIColor blueColor];
    self.carousel2.tag = [self.carousel2Info[kCarouselID] intValue];
    self.carousel2.type = (iCarouselType)[self.carousel2Info[kCarouselOptionType] intValue];
    self.carousel2.bounces = (BOOL)[self.carousel2Info[kCarouselOptionBounce] boolValue];
    [self.carousel2 reloadData];

    self.carousel3.backgroundColor = [UIColor orangeColor];
    self.carousel3.tag = [self.carousel3Info[kCarouselID] intValue];
    self.carousel3.type = (iCarouselType)[self.carousel3Info[kCarouselOptionType] intValue];
    self.carousel3.bounces = (BOOL)[self.carousel3Info[kCarouselOptionBounce] boolValue];
    [self.carousel3 reloadData];
}

-(CGSize)cellTargetSizeForCarousel:(iCarousel *)carousel;
{
    CGSize cellTargetSize = CGSizeZero;
    CGSize carouselViewSize = CGSizeZero;
    if (carousel) {
        carouselViewSize = carousel.bounds.size;
        CGFloat chartHeight = floorf(carouselViewSize.height * 0.85f);
        CGFloat chartWidth = floorf(fminf(carouselViewSize.width * 0.9f,chartHeight));
        cellTargetSize = CGSizeMake(chartWidth, chartHeight);
    }
    
    return cellTargetSize;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    NSInteger numberOfItems = 0;
    switch (carousel.tag) {
        case 1:
            numberOfItems = [self.items1 count];
            break;
        case 2:
            numberOfItems = [self.items2 count];
            break;
        case 3:
            numberOfItems = [self.items2 count];
            break;
        default:
            break;
    }
    return numberOfItems;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        CGSize cellSize = [self cellTargetSizeForCarousel:carousel];
        CGRect cellRect = CGRectMake(0.0f, 0.0f, cellSize.width, cellSize.height);
        view = [[UIView alloc] initWithFrame:cellRect];
        view.backgroundColor = [UIColor whiteColor];
        label = [[UILabel alloc] initWithFrame:cellRect];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:30];
        [view addSubview:label];
    }
    else
    {
        label = [[view subviews] lastObject];
    }

    // Set Border according to carousel currentItemIndex
    BOOL isViewCurrentView = (index == carousel.currentItemIndex);
    if (isViewCurrentView) {
        view.layer.borderColor = [UIColor redColor].CGColor;
        view.layer.borderWidth = 2.0f;
    }
    else {
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.borderWidth = 1.0f;
    }
    
    switch (carousel.tag) {
        case 1:
            //items in this array are strings
            label.text = [self.items1 objectAtIndex:index];
            break;
        case 2:
        case 3:
            //items in this array are strings
            label.text = [self.items2 objectAtIndex:index];
            break;

        default:
            break;
    }
    
    return view;
}

/*
- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel;
{
    //return the total number of items in the carousel
    NSInteger numberOfItems = 0;
    switch (carousel.tag) {
        case 1:
            numberOfItems = [self.items1 count];
            break;
        case 2:
            numberOfItems = [self.items2 count];
            break;
        case 3:
            numberOfItems = [self.items2 count];
            break;
        default:
            break;
    }
    return numberOfItems;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        CGSize cellSize = [self cellTargetSizeForCarousel:carousel];
        CGRect cellRect = CGRectMake(0.0f, 0.0f, cellSize.width, cellSize.height);
        view = [[UIView alloc] initWithFrame:cellRect];
        view.backgroundColor = [UIColor grayColor];
        label = [[UILabel alloc] initWithFrame:cellRect];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:30];
        [view addSubview:label];
    }
    else
    {
        label = [[view subviews] lastObject];
    }
    
    switch (carousel.tag) {
        case 1:
            //items in this array are strings
            label.text = [NSString stringWithFormat:@"PH.%@",[self.items1 objectAtIndex:index]];
            break;
        case 2:
        case 3:
            //items in this array are strings
            label.text = [NSString stringWithFormat:@"PH.%@",[self.items2 objectAtIndex:index]];
            break;
        default:
            break;
    }
    return view;
}
*/

#pragma mark - iCarouselDelegate

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionWrapOn] boolValue];
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionSpacing] floatValue];
        }
        case iCarouselOptionRadius:
        {
            return value * [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionRadius] floatValue];
        }
        case iCarouselOptionArc:
        {
            return value * 2 * M_PI * [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionArc] floatValue];
        }
        case iCarouselOptionTilt:
        {
            return value * [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionTilt] floatValue];
        }
        case iCarouselOptionFadeMin:
        {
            return [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionFadeMin] floatValue];
        }
        case iCarouselOptionFadeMinAlpha:
        {
            return [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionFadeMinAlpha] floatValue];
        }
        case iCarouselOptionFadeMax:
        {
            return [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionFadeMax] floatValue];
        }
        case iCarouselOptionFadeRange:
        {
            return [[self optionForCarouselID:carousel.tag forKey:kCarouselOptionFadeRange] floatValue];
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionAngle:
        case iCarouselOptionCount:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    if (_carouselBeingTouched == carousel.tag) {
        [self carouselID:carousel.tag didScrollToIndex:carousel.currentItemIndex];
    }
    
    [carousel reloadItemAtIndex:carousel.previousItemIndex animated:NO];
    [carousel reloadItemAtIndex:carousel.currentItemIndex animated:NO];
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    _carouselBeingTouched = carousel.tag;
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel;
{
    _carouselBeingTouched = carousel.tag;
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate;
{
    if (!decelerate) {
        _carouselBeingTouched = 0;
    }
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel;
{

}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel;
{
    _carouselBeingTouched = 0;
}

@end
