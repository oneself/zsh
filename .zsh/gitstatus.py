#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Print out current status of the git repo.  This includes the branch name and number of commits
# ahead/behind.

import sys
import re
from subprocess import Popen, PIPE, STDOUT

BEHEAD_RE = re.compile(r"Your branch is (ahead of|behind) '(.*)' by (\d+) commit")
DIVERGE_RE = re.compile(r"and have (\d+) and (\d+) different")

#output = Popen(['/usr/bin/git','status', '^/dev/null'], stdout=PIPE, stderr=STDOUT).communicate()[0]
output = Popen(['/usr/bin/git','status'], stdout=PIPE, stderr=STDOUT).communicate()[0]
lines = output.splitlines()
symbols = {'ahead of': '↑', 'behind': '↓'}

if len(lines) == 0 or lines[0].find("fatal") == 0:
  sys.exit(0)
bline = lines[0]
if bline.find('Not currently on any branch') != -1:
  branch = Popen(['/usr/bin/git','rev-parse','--short','HEAD'], stdout=PIPE).communicate()[0][:-1]
else:
  branch = bline.split(' ')[-1]
  #if branch == 'master':
  #  branch = '♦'
  match = BEHEAD_RE.match(lines[1])
  if match:
    branch += symbols[match.groups()[0]]
    branch += match.groups()[2]
  elif len(lines) > 3 and lines[3].find('nothing to commit, working directory clean') != -1:
    branch += '⚡'
  else:
    if len(lines) > 2:
      div_match = DIVERGE_RE.match(lines[2])
      if div_match:
        branch += "|{1}↕{0}".format(*div_match.groups())
print branch
