#import <CoreSpotlight/CoreSpotlight.h>

#include <nan.h>
#include "spotlight.h"

NAN_METHOD(AddItems) {
  if (info.Length() < 1) {
    Nan::ThrowTypeError("Missing arguments");
    return;
  }

  if (!info[0]->IsArray()) {
    Nan::ThrowTypeError("Items must be an array");
    return;
  }

  v8::Local<v8::Array> inputItems = v8::Local<v8::Array>::Cast(info[0]);
  NSMutableArray *items = [[NSMutableArray alloc] init];

  for (unsigned int i = 0; i < inputItems->Length(); i++ ) {
    if (!Nan::Has(inputItems, i).FromJust()) continue;

    v8::Local<v8::Object> inputItem = Nan::Get(inputItems, i)
      .ToLocalChecked()
      .As<v8::Object>();

    Nan::Utf8String idString(
      Nan::Get(inputItem, Nan::New("id").ToLocalChecked()
    ).ToLocalChecked());

    Nan::Utf8String titleString(
      Nan::Get(inputItem, Nan::New("title").ToLocalChecked()
    ).ToLocalChecked());

    NSString* identifier = [NSString stringWithUTF8String:*idString];
    NSString* title = [NSString stringWithUTF8String:*titleString];

    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc]
    initWithItemContentType:(NSString *)kUTTypeData];
    attributeSet.title = title;

    CSSearchableItem *item = [[CSSearchableItem alloc]
      initWithUniqueIdentifier:identifier
      domainIdentifier:identifier
      attributeSet:attributeSet];

    [items addObject:item];
  }

  [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:items
    completionHandler: ^(NSError * __nullable error) {
      if (!error) {
        NSLog(@"Search items indexed");
      } else {
        NSLog(@"Indexing items failed: %@", error);
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
