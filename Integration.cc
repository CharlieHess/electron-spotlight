#include <nan.h>
#include "spotlight.h" // NOLINT(build/include)

using v8::FunctionTemplate;
using v8::Local;
using v8::Object;
using v8::String;
using Nan::GetFunction;
using Nan::New;
using Nan::Set;

NAN_MODULE_INIT(InitAll) {
  Set(
    target,
    New<String>("addItems").ToLocalChecked(),
    GetFunction(New<FunctionTemplate>(AddItems)).ToLocalChecked()
  );
  Set(
    target,
    New<String>("removeItems").ToLocalChecked(),
    GetFunction(New<FunctionTemplate>(RemoveItems)).ToLocalChecked()
  );
  Set(
    target,
    New<String>("removeAllItems").ToLocalChecked(),
    GetFunction(New<FunctionTemplate>(RemoveAllItems)).ToLocalChecked()
  );
}

NODE_MODULE(addon, InitAll)