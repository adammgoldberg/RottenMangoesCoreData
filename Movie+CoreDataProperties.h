//
//  Movie+CoreDataProperties.h
//  RottenMangoesCoreData
//
//  Created by Adam Goldberg on 2015-10-23.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *movieTitle;
@property (nullable, nonatomic, retain) NSString *movieRating;
@property (nullable, nonatomic, retain) NSString *movieRunTime;
@property (nullable, nonatomic, retain) NSData *movieImage;
@property (nullable, nonatomic, retain) NSString *movieYear;
@property (nullable, nonatomic, retain) NSString *reviewURL;
@property (nullable, nonatomic, retain) NSString *movieReview;

@end

NS_ASSUME_NONNULL_END
