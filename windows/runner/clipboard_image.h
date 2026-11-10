#ifndef RUNNER_CLIPBOARD_IMAGE_H_
#define RUNNER_CLIPBOARD_IMAGE_H_

#include <flutter/binary_messenger.h>
#include <windows.h>

// The "psito/clipboard_image" channel: reads and writes images in the system
// clipboard, which Flutter itself only does with text. Images go as maps with
// "width", "height" and "rgba" (straight alpha, row after row, top first).
void RegisterClipboardImage(flutter::BinaryMessenger* messenger, HWND window);

#endif  // RUNNER_CLIPBOARD_IMAGE_H_
