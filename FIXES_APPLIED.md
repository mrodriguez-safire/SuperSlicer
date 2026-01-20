# Build Fixes Applied

This document summarizes the build fixes applied during compilation, the issues they solved, and why they were needed.

## 1) CMake policy minimum for dependency builds

- **Change**: Added `-DCMAKE_POLICY_VERSION_MINIMUM=3.5` to dependency CMake options in `deps/CMakeLists.txt`.
- **Issue**: CMake failed to configure `dep_PNG` with the error “Compatibility with CMake < 3.5 has been removed.”
- **Why needed**: The bundled dependency uses an older `cmake_minimum_required` and requires an explicit policy minimum to build with modern CMake.

## 2) wxWidgets build on macOS 15+ SDK

- **Change**: Added a patch and applied it via `deps/+wxWidgets/wxWidgets.cmake` to avoid `CGDisplayCreateImage` in `src/osx/carbon/dcscreen.cpp` when building against macOS 15+ SDKs. For macOS 15+, the code now skips the deprecated call to avoid a hard compile error.
- **Issue**: wxWidgets failed to compile with `CGDisplayCreateImage` marked unavailable in the macOS 15 SDK.
- **Why needed**: The SDK deprecates and removes the symbol; without the patch, the build fails.

## 3) OpenVDB build with AppleClang

- **Change**: Patched OpenVDB’s `openvdb/openvdb/tree/NodeManager.h` via `deps/+OpenVDB/OpenVDB.cmake` to remove `OpT::template` qualifiers (using `OpT::eval` instead).
- **Issue**: AppleClang produced errors such as “a template argument list is expected after a name prefixed by the template keyword” in OpenVDB.
- **Why needed**: The compiler rejects the unnecessary `template` keyword in this context; the patch aligns the code with AppleClang’s parsing rules.

## Files Added/Modified

- `deps/CMakeLists.txt`
- `deps/+wxWidgets/wxWidgets.cmake`
- `deps/+wxWidgets/macos15-cgdisplay.patch`
- `deps/+OpenVDB/OpenVDB.cmake`
- `deps/+OpenVDB/macos-clang-template.patch`

## Notes

- The build completed with warnings related to deprecations and macOS version mismatch in some static libraries, but no hard errors.
- If you rebuild on a different SDK or toolchain, these patches may need to be revisited.
