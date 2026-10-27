// Streaming line-buffer implementation: processes the whole image at one pixel per clock.
#include "op.h"
#define STREAM_TOP gauss_stream
#include "stencil_stream.inc"
