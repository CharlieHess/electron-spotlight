#import <CoreSpotlight/CoreSpotlight.h>

#include <nan.h>
#include "spotlight.h"

NAN_METHOD(AddItem) {
  if (info.Length() < 2) {
    Nan::ThrowTypeError("Missing arguments");
    return;
  }

  if (!info[0]->IsString()) {
    Nan::ThrowTypeError("Id must be a string");
    return;
  }

  if (!info[1]->IsString()) {
    Nan::ThrowTypeError("Title must be a string");
    return;
  }

  if (![CSSearchableIndex isIndexingAvailable]) {
    Nan::ThrowTypeError("Spotlight indexing unavailable");
    return;
  }

  Nan::Utf8String idString(info[0]);
  Nan::Utf8String titleString(info[1]);

  NSString* title = [NSString stringWithUTF8String:*idString];
  NSString* identifier = [NSString stringWithUTF8String:*titleString];

  CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc]
    initWithItemContentType:(NSString *)kUTTypeData];

  attributeSet.title = title;

  CSSearchableItem *item = [[CSSearchableItem alloc]
    initWithUniqueIdentifier:identifier
    domainIdentifier:identifier
    attributeSet:attributeSet];

  [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item]
    completionHandler: ^(NSError * __nullable error) {
      if (!error) {
        NSLog(@"Search item indexed");
      }
  }];

  info.GetReturnValue().Set(Nan::True());
}
