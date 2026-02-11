module stbi;

const CInt STBI_DEFAULT	= 0;
const CInt STBI_GREY = 1;
const CInt STBI_GREY_ALPHA	= 2;
const CInt STBI_RGB = 3;
const CInt STBI_RGB_ALPHA = 4;

alias Sbi_uc = char;
alias Sbi_us = ushort;

extern fn Stbi_uc* stbi_load(ZString filename, CInt* x, CInt* y, CInt* channels, CInt desired_channels);
extern fn Stbi_uc* stbi_load_from_memory(Stbi_uc* buffer, CInt len, CInt* x, CInt* y, CInt* channels, CInt desired_channels);
extern fn Stbi_uc* stbi_load_from_file(CFile f, CInt* x, CInt* y, CInt* channels, CInt desired_channels);
extern fn Stbi_us* stbi_load_16(ZString filename, CInt* x, CInt* y, CInt* channels, CInt desired_channels);
extern fn CFloat* stbi_loadf(ZString filename, CInt* x, CInt* y, CInt* channels, CInt desired_channels);
extern fn CFloat* stbi_loadf_from_memory(Stbi_uc* buffer, CInt len, CInt* x, CInt* y, CInt* channels, CInt desired_channels);

extern fn CInt stbi_info(ZString filename, CInt* x, CInt* y, CInt* channels);
extern fn CInt stbi_info_from_memory(Stbi_uc* buffer, CInt len, CInt* x, CInt* y, CInt* channels);
extern fn CInt stbi_is_16_bit(ZString filename);
extern fn CInt stbi_is_hdr(ZString filename);

extern fn void stbi_image_free(void* retval_from_stbi_load);

extern fn void stbi_set_flip_vertically_on_load(CInt flag_true_if_should_flip);
extern fn void stbi_set_unpremultiply_on_load(CInt flag_true_if_should_unpremult);

extern fn ZString stbi_failure_reason(void);

extern fn CInt stbi_write_png(ZString filename, CInt w, CInt h, CInt comp, void* data, CInt stride);
extern fn CInt stbi_write_bmp(ZString filename, CInt w, CInt h, CInt comp, void* data);
extern fn CInt stbi_write_tga(ZString filename, CInt w, CInt h, CInt comp, void* data);
extern fn CInt stbi_write_jpg(ZString filename, CInt w, CInt h, CInt comp, void* data, CInt quality);
extern fn CInt stbi_write_hdr(ZString filename, CInt w, CInt h, CInt comp, float* data);