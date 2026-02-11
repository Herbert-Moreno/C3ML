import os
import sys
import shutil

version = "0.0.0" # Default Value

for arg in sys.argv:
    if "version=" in arg:
        version = arg.split("=")[1]

Manifest = """{
  "provides": "C3ML",
  "authors": [ "Herbert-Moreno" ],
  "version": """+f'"{version}"'+""",

  "sources": [ "./**" ],
  "c_sources": [ "./image_processing/stb_image.c", "./image_processing/stb_image_write.c" ]
  "features": [ "ACTIVE_IMAGE_PROCESSING" ],
  "targets" : {
    "linux-x64" : {
      "linked-libraries" : [ "m" ],
    },
	"windows-x64" : {
      "linked-libraries" : [ "m" ],
    }
  }
}"""


def build_aero3():
    libPath = "./c3ml.c3l"
    srcPath = "./src"
    os.mkdir(libPath)
    print("\x1b[0;32m[INFO]\x1b[0m Making Dependency Diretory")

    shutil.copytree(srcPath, libPath, dirs_exist_ok=True)
    print("\x1b[0;32m[INFO]\x1b[0m Copy files to Dep Path")

    with open(f"{libPath}/manifest.json", "w") as manifestFile:
        manifestFile.write(Manifest)
        print("\x1b[0;32m[INFO]\x1b[0m Writing Manifest file")
        manifestFile.close()

if (__name__ == "__main__"):
    build_aero3()