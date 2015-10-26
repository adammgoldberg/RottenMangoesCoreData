//
//  DetailViewController.h
//  RottenMangoesCoreData
//
//  Created by Adam Goldberg on 2015-10-23.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface DetailViewController : UIViewController


@property (nonatomic, strong) Movie *movie;


@property (nonatomic, strong) NSManagedObjectContext *detailMoc;

@end
