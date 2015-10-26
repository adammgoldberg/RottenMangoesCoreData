//
//  ViewController.m
//  RottenMangoesCoreData
//
//  Created by Adam Goldberg on 2015-10-23.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "CustomCollectionCell.h"
#import "DetailViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *movieCollectionView;

@property (nonatomic, strong) NSMutableArray *movies;




@end

@implementation ViewController



//-(void)clearDatabase
//{
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Movie"];
//    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
//    
//    NSError *deleteError = nil;
//    [self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.movies = [[NSMutableArray alloc] init];
    [self.view addSubview: self.movieCollectionView];

    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"movieTitle" ascending:YES]];
  
    NSError *error;
    
    
    [self.movies addObjectsFromArray:[self.moc executeFetchRequest:fetchRequest error:&error]];
    
    if (self.movies.count > 0) {
        NSLog(@"the amount of data is %lu", (unsigned long)self.movies.count);
        [self.movieCollectionView reloadData];
    } else {
        // load from network
        [self downloadMovies];
    }
}

- (void)downloadMovies {
    NSError *error;
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=50";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSError *jsonError;
            NSDictionary *movieInformation = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            
            if (!jsonError) {
                //                NSLog(@"movie information: %@", movieInformation);
                
                NSArray *movieArray = movieInformation[@"movies"];
                
                for (NSDictionary *dictionary in movieArray) {
                    Movie *aMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.moc];
                    NSString *imageString = dictionary[@"posters"][@"thumbnail"];
                    
                    
                    
                    NSURL *imageURL = [NSURL URLWithString:imageString];
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    aMovie.movieImage = imageData;
                    aMovie.movieTitle = dictionary[@"title"];
                    aMovie.movieRating = dictionary[@"mpaa_rating"];
                    NSInteger year = [dictionary[@"year"] integerValue];
                    NSString *yearString = [NSString stringWithFormat:@"%ld", (long)year];
                    aMovie.movieYear = yearString;
                    NSInteger runtime = [dictionary[@"runtime"] integerValue];
                    NSString *runtimeString = [NSString stringWithFormat:@"%ld", (long)runtime];
                    aMovie.movieRunTime = runtimeString;
                    
                    NSString *partReviewString = dictionary[@"links"][@"reviews"];
                    NSString *reviewString = [partReviewString stringByAppendingString:@"?apikey=sr9tdu3checdyayjz85mff8j&page_limit=3"];
                    aMovie.reviewURL = reviewString;
                    
                    
                    
                     [self.movies addObject:aMovie];
                    
                    
                }
                // sort array
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.movieCollectionView reloadData];
                });
                
            }
        }
    }];
    
    [dataTask resume];
    
    
    [self.moc save:&error];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.movieCollectionView indexPathForCell:sender];
        Movie *theMovie = self.movies[indexPath.row];
        NSLog(@"%@", [theMovie class]);
        DetailViewController *detailController = (DetailViewController*)[segue destinationViewController];
        [detailController setMovie:theMovie];
        detailController.detailMoc = self.moc;
        
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionCell" forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.row];
    cell.movieCoverImage.image = [UIImage imageWithData:movie.movieImage];

    
    return cell;
}

@end
