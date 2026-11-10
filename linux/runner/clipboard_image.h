#ifndef RUNNER_CLIPBOARD_IMAGE_H_
#define RUNNER_CLIPBOARD_IMAGE_H_

#include <flutter_linux/flutter_linux.h>

// The "psito/clipboard_image" channel: reads and writes images in the system
// clipboard, which Flutter itself only does with text. Images go as maps with
// "width", "height" and "rgba" (straight alpha, row after row).
void clipboard_image_register(FlBinaryMessenger* messenger);

#endif  // RUNNER_CLIPBOARD_IMAGE_H_
