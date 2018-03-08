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
      if (!error) {
        NSLog(@"Search item indexed");
      } else {
        NSLog(@"Indexing item failed: %@", error);
      }
  }];

  info.GetReturnValue().Set(Nan::Undefined());
}

NAN_METHOD(RemoveItems) {
  if (info.Length() < 1) {
    Nan::ThrowTypeError("Missing arguments");
    return;
  }

  if (!info[0]->IsArray()) {
    Nan::ThrowTypeError("Items must be an array");
    return;
  }

  v8::Local<v8::Array> inputIds = v8::Local<v8::Array>::Cast(info[0]);
  NSMutableArray *ids = [[NSMutableArray alloc] init];

  for (unsigned int i = 0; i < inputIds->Length(); i++ ) {
    if (!Nan::Has(inputIds, i).FromJust()) continue;

    Nan::Utf8String identifier(Nan::Get(inputIds, i).ToLocalChecked());
    NSString* nsIdentifier = [NSString stringWithUTF8String:*identifier];
    [ids addObject:nsIdentifier];
  }

  [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:ids
    completionHandler: ^(NSError * __nullable error) {
      if (!error) {
        NSLog(@"Removed items successfully");
      } else {
        NSLog(@"Removing item failed: %@", error);
      }
  }];
}
