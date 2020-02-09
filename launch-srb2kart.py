# Kurzov's SRB2Kart Launcher
# Launcher Copyright (C)      2020 by James 'Kurzov' Mills
# SRB2Kart Copyright (C) 1998-2018 by Kart Krew & Sonic Team Junior
# THIS PROGRAM COMES WITH NO WARRANTY, BE IT IMPLIED OR EXPLICIT. USE AT YOUR OWN RISK.

import os
import subprocess

# Default options, will be externally read when I figure out how to read files.
hyuuseekerenabled = False
# hyuuseekerenabled help:
#	False: HyuuSeeker support is disabled
#	True: HyuuSeeker support is enabled
x32bitdir = "C:/USERS/KURZOV/DOWNLOADS/KART-X86"
# definition of directory where 32bit executables are located
x64bitdir = "C:/USERS/KURZOV/DOWNLOADS/KART-X64"
# definition of directory where 64bit executables are located

EXEnum = 0 # global var
EXEcount = 0 # global var
menuLoadedCount = 1 # global var
availableexes = []
availablefilenames = []
available64exes = []
available64filenames = []
allbuilds = {}

def i_am_a_build(chksm, filepath):
    allbuilds[chksm] = filepath

def lookforexecutables():
    for filename in os.listdir(x32bitdir):
        if filename.endswith(".exe"):
            global EXEnum
            availableexes.append(x32bitdir + "/" + filename)
            availablefilenames.append(filename)
            EXEnum += 1
            continue
        else:
            continue
    for filename in os.listdir(x64bitdir):
        if filename.endswith(".exe"):
            available64exes.append(x64bitdir + "/" + filename)
            available64filenames.append(filename)
            EXEnum += 1
            continue
        else:
            continue
    else:    
        availableexes.extend(available64exes)
        availablefilenames.extend(available64filenames)

def definemybuilds():
    for x in availableexes:
        global EXEnum
        global EXEcount
        EXEcount += 1
        subprocess.run('md5deep64.exe -W TEMPHASHDEEP.TXT ' + x,shell=True)
        htempf = open("TEMPHASHDEEP.TXT")
        tempchecksum = (htempf.read(32))
        i_am_a_build(tempchecksum,x)
        continue
    else:
        print("COMPLETED ENUMERATING EXES")

# MAIN PROGRAM

lookforexecutables()
definemybuilds()

print("Kurzov\'s SRB2Kart Command-Line Launcher")
for x, y in allbuilds.items():
    print(str(menuLoadedCount) + ": " + y + " (checksum " + x + ")")
    menuLoadedCount += 1
else:
    menuSelection = input("Enter a build. ")
    if int(menuSelection) < 0 or int(menuSelection) >= menuLoadedCount:
        raise TypeError("Not a valid selection.")
    print("Build selected was: " + menuSelection)
    selectedBuild = availableexes[(int(menuSelection) - 1)]
    print("Selected build was: " + selectedBuild)
    if selectedBuild not in available64exes:
        os.chdir(x32bitdir)
    else:
        os.chdir(x64bitdir)
    OGLSelection = input("Would you like to use OpenGL? [y/n] ")
    if OGLSelection[0] == 'y':
        renderMode = "OPENGL"
    elif OGLSelection[0] == 'n':
        renderMode = "SOFTWARE"
    else:
        raise TypeError("Not a valid option.")
    DirectConnect = input("Would you like to directly connect to a server? If so, please type its IP or web address here. ")
    if DirectConnect == '' and renderMode == "OPENGL":
        try:
            subprocess.run(selectedBuild +' -opengl')
        except OSError:
            print("Something went wrong. Please submit a bug report.")
    elif DirectConnect != '' and renderMode == "OPENGL":
        try:
            subprocess.run(selectedBuild +' -connect ' + DirectConnect + ' -opengl')
        except OSError:
            print("Something went wrong. Please submit a bug report.")
    elif DirectConnect == '' and renderMode == "SOFTWARE":
        try:
            subprocess.run(selectedBuild)
        except OSError:
            print("Something went wrong. Please submit a bug report.")
    elif DirectConnect != '' and renderMode == "SOFTWARE":
        try:
            subprocess.run(selectedBuild +' -connect ' + DirectConnect)
        except OSError:
            print("Something went wrong. Please submit a bug report.")