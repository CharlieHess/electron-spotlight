#include <nan.h>
#include "spotlight.h" // NOLINT(build/include)

using v8::FunctionTemplate;
using v8::Handle;
using v8::Object;
using v8::String;
using Nan::GetFunction;
using Nan::New;
using Nan::Set;

NAN_MODULE_INIT(InitAll) {
  Set(target, New<String>("addItem").ToLocalChecked(), GetFunction(New<FunctionTemplate>(AddItem)).ToLocalChecked());
}

NODE_MODULE(addon, InitAll)