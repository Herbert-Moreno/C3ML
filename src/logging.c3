module c3ml::logging;
import std;

macro c3ml_info(args...) {
    io::printf("\033[36m[INFO] ");
    io::printf(args);
    io::printf("\033[0m\n");
}

macro c3ml_warn(args...) {
    io::printf("\033[33m[WARNING] ");
    io::printf(args);
    io::printf("\033[0m\n");
}

macro c3ml_error(args...) {
    io::printf("\033[31m[ERROR] ");
    io::printf(args);
    io::printf("\033[0m\n");
}