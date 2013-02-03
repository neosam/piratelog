#!/usr/bin/python

import re
import sys

global header, footer, lineTypes, parserSwitches
global transformFunctions

header = r""" \documentclass{protokoll}
\renewcommand {\Sitzungstermin} {##date##}
\begin{document}
\Ueberschrift
"""
footer = r"""
\end{document}
"""

## Regular expressions pattern to detect the line type
lineTypes = {
	# bullets
	'bullet': re.compile(r"^\*+ (.*)$"),
	# to detect header
	'header': re.compile(r"^==[^=](.*)==$"),
	# to detect sub header
	'subHeader': re.compile(r"^===[^=](.*)===$"),
	# sub sub header
	'subSubHeader': re.compile(r"^====[^=](.*)====$"),
	# empty line
	'empty': re.compile(r'^\w*$')
}

## Parser switches (also regexp)
parserSwitches = {
	# switch to default text mode
	'switchToDefaultPattern': re.compile(r"<!--\s*default\s*-->"),
	# switch to participant mode
	'switchToParticipantPattern': re.compile(r"<!--\s*participant\s*-->"),
	# switch to activityReport mode
	'switchToActivityReportPattern': re.compile(r"<!--\s*activity-report\s*-->"),
	# check for the beginning tag
	'beginning': re.compile(r"<!--\s*begin\s+(\d{2}\.\d{2}\.\d{4}))\s*-->"),
	# check for the end tag
	'end': re.compile(r"<!--\s*end\s*-->")
}

def transformHeader(line, matcher, attributes):
	return r'\section{' + matcher.group(1) + '}'
def transformSubHeader(line, matcher, attributes):
	return r'\subsection{' + matcher.group(1) + '}'
def transformSubSubHeader(line, matcher, attributes):
	return r'\subsubsection{' + matcher.group(1) + '}'
def transformBullet(line, matcher, attributes):
	return r'\item ' + matcher.group(1)
def transformText(line, matcher, attributes):
	return line

transformFunctions = {
	'header': transformHeader,
	'subHeader': transformSubHeader,
	'subSubHeader': transformSubSubHeader,
	'bullet': transformBullet,
	'text': transformText,
}


def checkLineType(line, lineTypes):
	"""Check the type of the line.

	Parameter list:
	- line:  the line as simple string
	- lineTypes:  dictionary which maps type name to pattern

	"""
	for typeKey in lineTypes:
		typePattern = lineTypes[typeKey]
		matcher = typePattern.match(line)
		if matcher != None:
			return {
				'matcher': matcher,
				'type': typeKey,
			}
	return None


def parseInput(inputFile, outFile, parserDict):
	""" Parses the input file
	parses the inputFile.  ParserDict defines the
	different parser modes.
	"""
	attributes = {}
	for line in inputFile:
		line = line.strip()
		lineType = checkLineType(line, lineTypes)
		if lineType != None:
			if parserDict.has_key(lineType['type']):
				outLineFunc = parserDict[lineType['type']]
				outLine = outLineFunc(line, lineType['matcher'], attributes)
				outFile.write(outLine + '\n')
		else:
			outFile.write(line + '\n')

parseInput(sys.stdin, sys.stdout, transformFunctions)