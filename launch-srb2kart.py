# Kurzov's SRB2Kart Launcher
# Launcher Copyright (C)      2020 by James 'Kurzov' Mills
# SRB2Kart Copyright (C) 1998-2018 by Kart Krew & Sonic Team Junior
# THIS PROGRAM COMES WITH NO WARRANTY, BE IT IMPLIED OR EXPLICIT. USE AT YOUR OWN RISK.

# Default options, will be externally read when I figure out how to read files.
searchmode = "LEGACY"
# searchmode help:
#	LEGACY: Manual lookup
#	LOOKUP: Search in defined directories
#	ENUMERATE: Enumerate all found .EXEs
hyuuseekerenabled = False
# hyuuseekerenabled help:
#	False: HyuuSeeker support is disabled
#	True: HyuuSeeker support is enabled
vanillax86path = ""
# definition of x86 vanilla build, used if searchmode is 0
vanillax64path = ""
# definition of x64 vanilla build, used if searchmode is 0
fkartx86path = ""
# definition of x86 fkart build, used if searchmode is 0
fkartx64path = ""
# definition of x64 fkart build, used if searchmode is 0
shadersx86path = ""
# definition of x86 shader fix build, used if searchmode is 0
shadersx64path = ""
# definition of x64 shader fix build, used if searchmode is 0
battleroyalex86path = ""
# definition of x86 battle royale build, used if searchmode is 0
battleroyalex64path = ""
# definition of x64 battle royale build, used if searchmode is 0
x32bitdir = "C:/USERS/KURZOV/DOWNLOADS/KART-X86"
# definition of directory where 32bit executables are located, used if searchmode is 1
x64bitdir = ""
# definition of directory where 64bit executables are located, used if searchmode is 1
md5path = "MD5DEEP.EXE"
# Custom path to MD5DEEP (used in the ENUMERATION search mode).

# Hey CLIde, this is my Kart build(s). Don't mess it up, please!
class KartKnownBuild:
    def __init__(self, bits, nameoffile, checksum, builddate, sourcemods):
        self.bits = bits
        self.nameoffile = nameoffile
        self.checksum = checksum
        self.builddate = builddate
        self.sourcemods = sourcemods
    
    def sendbuildinfo(self, parameter_list):
        raise NotImplementedError
        # TODO: IMPLEMENTATION

    def getbuildinfo(self):
        raise NotImplementedError
        # TODO: IMPLEMENTATION

class buildNumIterator:
    def __iter__(self):
        self.a = 0
        return self

    def __next__(self):
        x = self.a
        self.a += 1
        return x

buildNumber = buildNumIterator()
buildNumberIterator = iter(buildNumber)

EXEnum = 0
EXEcount = 0
available32exes = []
available32filenames = []
unknownexes = {}

def gimme_my_build_info(chksm, filepath):
    if chksm=="65d0acd26180a9b3d784c889a199900f":
        print("found v1.1 vanilla x86 EXE")
        vanilla32 = KartKnownBuild(32,filepath,chksm,"05-29-2019",None)
    else:
        print("found unknown executable")
        unknownexes.add(filepath)


        

# MAIN PROGRAM


import os
import subprocess

for filename in os.listdir(x32bitdir):
    if filename.endswith(".exe"):
        available32exes.append(x32bitdir + "/" + filename)
        available32filenames.append(filename)
        EXEnum += 1
        continue
    else:
        continue
# adds .exe file names to AVAILABLEEXES list

for x in available32exes:
    if EXEnum < EXEcount:
        EXEcount += 1
        subprocess.run('md5deep.exe -W TEMPHASHDEEP.TXT ' + x,shell=True)
        htempf = open("TEMPHASHDEEP.TXT")
        tempchecksum = (htempf.read(32))
        gimme_my_build_info(tempchecksum,x)
        continue
    else:
        continue
else:
    print("Completed enumerating EXEs")
