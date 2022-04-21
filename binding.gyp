{
  "targets": [{
    "target_name": "Spotlight",
    "sources": [
      "Integration.cc",
      "spotlight.mm"
    ],
    "include_dirs": [
      "<!(node -e \"require('nan')\")"
    ],
    "xcode_settings": {
      "OTHER_CPLUSPLUSFLAGS": ["-std=c++14", "-stdlib=libc++", "-mmacosx-version-min=10.13"],
      "OTHER_LDFLAGS": ["-framework CoreFoundation -framework CoreSpotlight -framework AppKit"]
    }
  }]
}