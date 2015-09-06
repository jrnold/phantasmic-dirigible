import re
import sys
import shutil

EXT = '.bak'


fn = "bonds_and_battles.tex"
prefix = 'bonds'

regex = re.compile(r'\\(ref|label)\{([^}]+)\}')

shutil.copy(fn, fn + '.bak')

newtxt = []
with open(fn, 'r') as hdl:
    for i, line in enumerate(hdl):
        print(i, line)
        newln = regex.sub('\1{%s:\2}' % prefix, line)
        newtxt.append(newln)
newtxt = '\n'.join(newln)
with

    
