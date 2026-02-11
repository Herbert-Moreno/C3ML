module c3ml::image_processing::enums @if($feature(ACTIVE_IMAGE_PROCESSING));

faultdef TYPE_MISS_MATCH,
    MEMORY_ALLOC_FAILED,
    OUT_OF_RANGE,
    SIZE_MISS_MATCH,
    IMAGE_ERROR;

enum ImageExtension {
    PNG = ".png",
    BMP = ".bmp",
    PPM = ".ppm",
}

enum ImageFormat {
	IMG_FMT_GREY,
	IMG_FMT_GREYA,
	IMG_FMT_RGB,
	IMG_FMT_RGBA,
}

enum ImageDither {
	IMG_DITHER_NONE,
	IMG_DITHER_ORDERED,
	IMG_DITHER_FLOYD_STEINBERG
}