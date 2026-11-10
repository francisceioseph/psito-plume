#include "clipboard_image.h"

#include <gtk/gtk.h>

#include <cstring>

static FlMethodChannel* channel = nullptr;

static FlValue* image_to_value(GdkPixbuf* pixbuf) {
  const int width = gdk_pixbuf_get_width(pixbuf);
  const int height = gdk_pixbuf_get_height(pixbuf);
  const int channels = gdk_pixbuf_get_n_channels(pixbuf);
  const int stride = gdk_pixbuf_get_rowstride(pixbuf);
  const guchar* pixels = gdk_pixbuf_read_pixels(pixbuf);
  const gsize size = static_cast<gsize>(width) * height * 4;
  g_autofree guint8* rgba = static_cast<guint8*>(g_malloc(size));
  for (int y = 0; y < height; y++) {
    const guchar* row = pixels + static_cast<gsize>(y) * stride;
    guint8* out = rgba + static_cast<gsize>(y) * width * 4;
    for (int x = 0; x < width; x++) {
      out[x * 4] = row[x * channels];
      out[x * 4 + 1] = row[x * channels + 1];
      out[x * 4 + 2] = row[x * channels + 2];
      out[x * 4 + 3] = channels == 4 ? row[x * channels + 3] : 255;
    }
  }
  FlValue* result = fl_value_new_map();
  fl_value_set_string_take(result, "width", fl_value_new_int(width));
  fl_value_set_string_take(result, "height", fl_value_new_int(height));
  fl_value_set_string_take(result, "rgba", fl_value_new_uint8_list(rgba, size));
  return result;
}

static void image_received(GtkClipboard* clipboard, GdkPixbuf* pixbuf,
                           gpointer data) {
  g_autoptr(FlMethodCall) call = FL_METHOD_CALL(data);
  g_autoptr(FlValue) result =
      pixbuf == nullptr ? fl_value_new_null() : image_to_value(pixbuf);
  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond_success(call, result, &error)) {
    g_warning("clipboard image: %s", error->message);
  }
}

static FlMethodResponse* write_image(FlValue* args) {
  if (fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
    return FL_METHOD_RESPONSE(
        fl_method_error_response_new("bad-args", "expected a map", nullptr));
  }
  FlValue* width_value = fl_value_lookup_string(args, "width");
  FlValue* height_value = fl_value_lookup_string(args, "height");
  FlValue* rgba_value = fl_value_lookup_string(args, "rgba");
  if (width_value == nullptr || height_value == nullptr ||
      rgba_value == nullptr ||
      fl_value_get_type(rgba_value) != FL_VALUE_TYPE_UINT8_LIST) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "bad-args", "width, height and rgba are needed", nullptr));
  }
  const int width = fl_value_get_int(width_value);
  const int height = fl_value_get_int(height_value);
  const gsize size = static_cast<gsize>(width) * height * 4;
  if (width <= 0 || height <= 0 || fl_value_get_length(rgba_value) != size) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "bad-args", "the pixels do not match the size", nullptr));
  }
  g_autoptr(GBytes) bytes =
      g_bytes_new(fl_value_get_uint8_list(rgba_value), size);
  g_autoptr(GdkPixbuf) pixbuf = gdk_pixbuf_new_from_bytes(
      bytes, GDK_COLORSPACE_RGB, TRUE, 8, width, height, width * 4);
  gtk_clipboard_set_image(gtk_clipboard_get(GDK_SELECTION_CLIPBOARD), pixbuf);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* call,
                           gpointer user_data) {
  const gchar* method = fl_method_call_get_name(call);
  if (strcmp(method, "read") == 0) {
    gtk_clipboard_request_image(gtk_clipboard_get(GDK_SELECTION_CLIPBOARD),
                                image_received, g_object_ref(call));
    return;
  }
  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(method, "write") == 0) {
    response = write_image(fl_method_call_get_args(call));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(call, response, &error)) {
    g_warning("clipboard image: %s", error->message);
  }
}

void clipboard_image_register(FlBinaryMessenger* messenger) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  channel = fl_method_channel_new(messenger, "psito/clipboard_image",
                                  FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb, nullptr,
                                            nullptr);
}
