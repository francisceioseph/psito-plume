#include "clipboard_image.h"

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include <cstdint>
#include <cstring>
#include <memory>
#include <vector>

namespace {

using flutter::EncodableMap;
using flutter::EncodableValue;

std::unique_ptr<flutter::MethodChannel<EncodableValue>> channel;
HWND owner = nullptr;

// Reads a CF_DIB: 24 or 32 bits, bottom-up or top-down.
EncodableValue ReadImage() {
  if (!OpenClipboard(owner)) return EncodableValue();
  EncodableValue result;
  HANDLE handle = GetClipboardData(CF_DIB);
  if (handle != nullptr) {
    const auto* header = static_cast<const BITMAPINFOHEADER*>(GlobalLock(handle));
    if (header != nullptr) {
      const int width = header->biWidth;
      const bool top_down = header->biHeight < 0;
      const int height = top_down ? -header->biHeight : header->biHeight;
      const int bits = header->biBitCount;
      const bool supported =
          width > 0 && height > 0 && (bits == 24 || bits == 32) &&
          (header->biCompression == BI_RGB ||
           header->biCompression == BI_BITFIELDS);
      if (supported) {
        const auto* base = reinterpret_cast<const uint8_t*>(header);
        size_t offset = header->biSize;
        if (header->biCompression == BI_BITFIELDS &&
            header->biSize == sizeof(BITMAPINFOHEADER)) {
          offset += 3 * sizeof(DWORD);
        }
        const uint8_t* pixels = base + offset;
        const size_t stride = ((static_cast<size_t>(width) * bits + 31) / 32) * 4;
        const int step = bits / 8;
        std::vector<uint8_t> rgba(static_cast<size_t>(width) * height * 4);
        for (int y = 0; y < height; y++) {
          const int source_row = top_down ? y : height - 1 - y;
          const uint8_t* row = pixels + source_row * stride;
          uint8_t* out = rgba.data() + static_cast<size_t>(y) * width * 4;
          for (int x = 0; x < width; x++) {
            out[x * 4] = row[x * step + 2];
            out[x * 4 + 1] = row[x * step + 1];
            out[x * 4 + 2] = row[x * step];
            // Most programs leave the alpha of a copied picture at zero.
            out[x * 4 + 3] = 255;
          }
        }
        EncodableMap map;
        map[EncodableValue("width")] = EncodableValue(width);
        map[EncodableValue("height")] = EncodableValue(height);
        map[EncodableValue("rgba")] = EncodableValue(rgba);
        result = EncodableValue(map);
      }
      GlobalUnlock(handle);
    }
  }
  CloseClipboard();
  return result;
}

// Writes a 32 bit bottom-up CF_DIB.
bool WriteImage(int width, int height, const std::vector<uint8_t>& rgba) {
  const size_t stride = static_cast<size_t>(width) * 4;
  const size_t size = sizeof(BITMAPINFOHEADER) + stride * height;
  HGLOBAL memory = GlobalAlloc(GMEM_MOVEABLE, size);
  if (memory == nullptr) return false;
  auto* header = static_cast<BITMAPINFOHEADER*>(GlobalLock(memory));
  std::memset(header, 0, sizeof(BITMAPINFOHEADER));
  header->biSize = sizeof(BITMAPINFOHEADER);
  header->biWidth = width;
  header->biHeight = height;
  header->biPlanes = 1;
  header->biBitCount = 32;
  header->biCompression = BI_RGB;
  header->biSizeImage = static_cast<DWORD>(stride * height);
  auto* pixels = reinterpret_cast<uint8_t*>(header + 1);
  for (int y = 0; y < height; y++) {
    const uint8_t* row = rgba.data() + static_cast<size_t>(y) * stride;
    uint8_t* out = pixels + static_cast<size_t>(height - 1 - y) * stride;
    for (int x = 0; x < width; x++) {
      out[x * 4] = row[x * 4 + 2];
      out[x * 4 + 1] = row[x * 4 + 1];
      out[x * 4 + 2] = row[x * 4];
      out[x * 4 + 3] = row[x * 4 + 3];
    }
  }
  GlobalUnlock(memory);
  if (!OpenClipboard(owner)) {
    GlobalFree(memory);
    return false;
  }
  EmptyClipboard();
  const bool done = SetClipboardData(CF_DIB, memory) != nullptr;
  CloseClipboard();
  if (!done) GlobalFree(memory);
  return done;
}

const EncodableValue* Field(const EncodableMap& map, const char* name) {
  auto found = map.find(EncodableValue(name));
  return found == map.end() ? nullptr : &found->second;
}

}  // namespace

void RegisterClipboardImage(flutter::BinaryMessenger* messenger, HWND window) {
  owner = window;
  channel = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      messenger, "psito/clipboard_image",
      &flutter::StandardMethodCodec::GetInstance());
  channel->SetMethodCallHandler(
      [](const flutter::MethodCall<EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
        if (call.method_name() == "read") {
          result->Success(ReadImage());
          return;
        }
        if (call.method_name() == "write") {
          const auto* map = std::get_if<EncodableMap>(call.arguments());
          const EncodableValue* width = map ? Field(*map, "width") : nullptr;
          const EncodableValue* height = map ? Field(*map, "height") : nullptr;
          const EncodableValue* rgba = map ? Field(*map, "rgba") : nullptr;
          const auto* w = width ? std::get_if<int32_t>(width) : nullptr;
          const auto* h = height ? std::get_if<int32_t>(height) : nullptr;
          const auto* bytes =
              rgba ? std::get_if<std::vector<uint8_t>>(rgba) : nullptr;
          if (!w || !h || !bytes || *w <= 0 || *h <= 0 ||
              bytes->size() != static_cast<size_t>(*w) * *h * 4) {
            result->Error("bad-args", "width, height and rgba are needed");
            return;
          }
          if (WriteImage(*w, *h, *bytes)) {
            result->Success();
          } else {
            result->Error("clipboard", "the clipboard could not be written");
          }
          return;
        }
        result->NotImplemented();
      });
}
