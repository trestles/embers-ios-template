// MenuItem.h
// 
// Copyright (c) 2012年 Trestles
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// a test for you
// jtjt
#import "EmbersRecord.h"

//@class Venue;
//@class Menu;

@interface MenuItem : EmbersRecord

@property (nonatomic, assign) NSUInteger menuItemID;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *layout;
@property (nonatomic) BOOL hasInstoreImage;
@property (nonatomic) BOOL hasTastingNotes;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *processedPrice;
@property (nonatomic) BOOL isTopView;
@property (nonatomic, strong) NSString *binNumber;
@property (nonatomic, strong) NSString *miSeparator;
@property (nonatomic, strong) NSString *whichPrice;
@property (nonatomic, strong) NSString *instoreImageURL;
@property (nonatomic, strong) NSString *instoreImage;
@property (nonatomic, strong) NSMutableArray  *tastingNotes;
@property (nonatomic, strong) NSMutableArray  *referencedTastingNotes;
@end
