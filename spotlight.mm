#import <CoreSpotlight/CoreSpotlight.h>

#include <nan.h>
#include "spotlight.h"

NAN_METHOD(AddItem) {
  if (info.Length() < 3) {
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

  if (!info[2]->IsFunction()) {
    Nan::ThrowTypeError("Callback must be a function");
    return;
  }

  if (![CSSearchableIndex isIndexingAvailable]) {
    Nan::ThrowTypeError("Spotlight indexing unavailable");
    return;
  }

  Nan::Utf8String idString(info[0]);
  Nan::Utf8String titleString(info[1]);
  // Nan::Callback* successCallback = new Nan::Callback(info[2].As<v8::Function>());

  NSString* identifier = [NSString stringWithUTF8String:*idString];
  NSString* title = [NSString stringWithUTF8String:*titleString];

  CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc]
    initWithItemContentType:(NSString *)kUTTypeData];

  attributeSet.title = title;

  NSLog(@"Created attribute set %@", attributeSet.title);

  CSSearchableItem *item = [[CSSearchableItem alloc]
    initWithUniqueIdentifier:identifier
    domainIdentifier:identifier
    attributeSet:attributeSet];

  NSLog(@"Created searchable item %@", item.domainIdentifier);

  [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item]
    completionHandler: ^(NSError * __nullable error) {
      if (error) {
        Nan::ThrowTypeError("Unable to index item");
        return;
      }

      // successCallback->Call(0, 0);
      NSLog(@"Search item indexed");
  }];

  info.GetReturnValue().Set(Nan::Undefined());
}
