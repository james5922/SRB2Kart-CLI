# Kurzov's SRB2Kart Launcher - PRERELEASE 1
# Launcher Copyright (C)      2020 by James 'Kurzov' Mills
# SRB2Kart Copyright (C) 1998-2018 by Kart Krew & Sonic Team Junior
# THIS PROGRAM COMES WITH NO WARRANTY, BE IT IMPLIED OR EXPLICIT. USE AT YOUR OWN RISK.

import os
import subprocess

from configparser import ConfigParser
config = ConfigParser()

config.read('settings.ini')
hyuuseekerenabled = config['settings']['hyuuseekersupport']
kartinstall1 = config['paths']['kartinstall1']
kartinstall2 = config['paths']['kartinstall2']
kartinstall3 = config['paths']['kartinstall3']
kartinstall4 = config['paths']['kartinstall4']
kartinstall5 = config['paths']['kartinstall5']
print("ready")


EXEnum = 0 # global var
EXEcount = 0 # global var
menuLoadedCount = 1 # global var
availableexes = []
availablefilenames = []
allbuilds = {}

def i_am_a_build(chksm, filepath):
    allbuilds[chksm] = filepath



def lookforexecutables():
    if kartinstall1 != '':
        for filename in os.listdir(kartinstall1):
            if filename.endswith(".exe"):
                global EXEnum
                availableexes.append(kartinstall1 + "/" + filename)
                availablefilenames.append(filename)
                EXEnum += 1
                continue
            else:
                continue
    if kartinstall2 != '':
        for filename in os.listdir(kartinstall2):
            if filename.endswith(".exe"):
                availableexes.append(kartinstall2 + "/" + filename)
                availablefilenames.append(filename)
                EXEnum += 1
                continue
            else:
                continue
    if kartinstall3 != '':
        for filename in os.listdir(kartinstall3):
            if filename.endswith(".exe"):
                availableexes.append(kartinstall3 + "/" + filename)
                availablefilenames.append(filename)
                EXEnum += 1
                continue
            else:
                continue
    if kartinstall4 != '':
        for filename in os.listdir(kartinstall4):
            if filename.endswith(".exe"):
                availableexes.append(kartinstall4 + "/" + filename)
                availablefilenames.append(filename)
                EXEnum += 1
                continue
            else:
                continue
    if kartinstall5 != '':
        for filename in os.listdir(kartinstall5):
            if filename.endswith(".exe"):
                availableexes.append(kartinstall5 + "/" + filename)
                availablefilenames.append(filename)
                EXEnum += 1
                continue
            else:
                continue

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
    if selectedBuild not in available5exes:
        os.chdir(kartinstall4)
    elif selectedBuild not in available4exes:
        os.chdir(kartinstall3)
    elif selectedBuild not in available3exes:
        os.chdir(kartinstall2)
    elif selectedBuild not in available2exes:
        os.chdir(kartinstall1)
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