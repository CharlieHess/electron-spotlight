#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

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

  Nan::Utf8String id(info[0]);
  Nan::Utf8String title(info[1]);

  info.GetReturnValue().Set(Nan::New("Hello from Objective-C").ToLocalChecked());
}