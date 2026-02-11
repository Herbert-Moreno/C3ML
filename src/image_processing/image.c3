module c3ml::image_processing @if($feature(ACTIVE_IMAGE_PROCESSING));
import c3ml::image_processing::enums;
import stbi;

struct Pixel(Printable) {
    float r, g, b, a;
}
fn usz~ Pixel.to_format(&self, Formatter* formatter)
{
    usz n = formatter.printf("(R: %s, G: %s, B: %s, A: %s)", self.r, self.g, self.b, self.a)!;
    return n;
}

struct C3mlImage {
    CInt width, height;
    ImageFormat fmt;
    ImageExtension ext;
    ZString filename;
    char* data;
    Pixel* pixels;
}

fn Pixel hex_to_pixel(int hex, ImageExtension ext) {

}

fn C3mlImage~ load_file(ZString filename) {
    CInt w, h, channels, desired_channels;
    ImageExtension extension;
    ImageFormat format;
    char* data = (char*)stbi::stbi_load(filename. &w, &h, &channels, stbi::STBI_DEFAULT);

    if (data) {
        logging::c3ml_error("Error ocurred: %s", enums::IMAGE_ERROR);
        return enums::IMAGE_ERROR;
    }

    String filestr = filename.str_view();
    if (filestr.ends_with(PNG.ext)) {
        extension = PNG;
    } else if (filestr.ends_with(BMP.ext)) {
        extension = BMP;
    } else if (filestr.ends_with(PPM.ext)) {
        extension = PPM;
    }

    return {
        .width = w;
        .height = h;
        .fmt = format;
        .ext = extension;
        .filename = filename
    }
}

fn void C3mlImage.write_image(&self, ZString filename = "") {
    ZString finalname = self.filename;
    if (filename != "") {
        finalname = filename
    }

    switch (self.ext) {
        case PNG:
            stbi_write_png(filename, self.widht, self.height, CInt comp, self.data, CInt stride);
            break;
        case BMP:
            stbi_write_bmp(self.filename, CInt w, CInt h, CInt comp, void* data);
            break;
    }

}
fn bool C3mlImage.free_image(&self) {
    stbi::stbi_image_free(self.data);
}
/*
fn bool C3mlImage.convert_format(&self, ImageFormat tofmt);
fn bool C3mlImage.quantize(&self, int maxcol, ImageDither dither);
fn void C3mlImage.v_flip(&self);
fn void C3mlImage.h_flip(&self);

fn C3ML_Image deepcopy_image(C3ML_Image *original);*/

fn void write_ppm(ZString filename, CInt width, CInt height, CInt channels, char* data) {
    CFile ppm_descriptor;
    if (channels != 3) {
        logging::c3ml_error("Only 3 channels (RGB) are supported for this PPM writer.");
        return;
    }

    ppm_descriptor = libc::fopen(filename, "w");
    if (ppm_descriptor) {
        logging::c3ml_error("Can't open file");
        return;
    }

    libc::fprintf(ppm_descriptor, "P6\n");
    libc::fprintf(ppm_descriptor, "%d %d\n", width, height);
    libc::fprintf(ppm_descriptor, "%d\n", 255);
    libc::fprintf(ppm_descriptor, "%s\n", data);

    libc::fclose(ppm_descriptor);
}