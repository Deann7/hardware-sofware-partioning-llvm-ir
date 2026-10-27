// Streaming line-buffer implementation: processes the whole image at one pixel per clock.
#include "op.h"
#define STREAM_TOP sobel_stream
#include "stencil_stream.inc"
