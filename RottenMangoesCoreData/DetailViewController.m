//
//  DetailViewController.m
//  RottenMangoesCoreData
//
//  Created by Adam Goldberg on 2015-10-23.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *yearLabel;

@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;


@property (strong, nonatomic) IBOutlet UILabel *runTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *review1Label;

@property (strong, nonatomic) IBOutlet UILabel *review2Label;


@property (strong, nonatomic) IBOutlet UILabel *review3Label;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *urlReview = [NSURL URLWithString:self.movie.reviewURL];
    
    NSURLSessionDataTask *reviewDataTask = [[NSURLSession sharedSession] dataTaskWithURL:urlReview completionHandler:^(NSData * _Nullable reviewData, NSURLResponse * _Nullable reviewResponse, NSError * _Nullable reviewError) {
        
        if (!reviewError) {
            NSError *jsonReviewError;
            NSDictionary *reviewInformation = [NSJSONSerialization JSONObjectWithData:reviewData options:0 error:&jsonReviewError];
            
            
            if (!jsonReviewError) {
                NSLog(@"review information: %@", reviewInformation);
                
                NSArray *reviewArray = reviewInformation[@"reviews"];
                
                
                if (reviewArray.count >= 3) {
                    NSDictionary *movieDict1 = reviewArray[0];
                    NSDictionary *movieDict2 = reviewArray[1];
                    NSDictionary *movieDict3 = reviewArray[2];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.review1Label.text = movieDict1[@"quote"];
                        self.review2Label.text = movieDict2[@"quote"];
                        self.review3Label.text = movieDict3[@"quote"];
                    });
                    
                    
                }
                
            }
            
            
            
            
        }
    }];
    
    [reviewDataTask resume];
    
    NSString *titleString = [@"Title:  " stringByAppendingString:self.movie.movieTitle];
    NSString *runString = [@"Runtime:  " stringByAppendingString:self.movie.movieRunTime];
    NSString *ratingString = [@"Rating:  " stringByAppendingString:self.movie.movieRating];
    NSString *stringYear = [@"Rating:  " stringByAppendingString:self.movie.movieYear];
    
    
    self.titleLabel.text = titleString;
    self.runTimeLabel.text = runString;
    self.ratingLabel.text = ratingString;
    self.yearLabel.text = stringYear;
    


    NSError *error;
    [self.detailMoc save:&error];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
