import std/terminal
import std/math

var
   termWidth*: int = terminalWidth()
   termHeight*: int = terminalHeight()
   termChars*: int = terminalWidth() * terminalHeight()

type textFormat* = enum
   fgBlack = "\e[30m",
   fgRed = "\e[31m",
   fgGreen = "\e[32m",
   fgYellow = "\e[33m",
   fgBlue = "\e[34m",
   fgMagenta = "\e[35m",
   fgCyan = "\e[36m",
   fgWhite = "\e[37m",
   fgBlackStrong = "\e[90m",
   fgRedStrong = "\e[91m",
   fgGreenStrong = "\e[92m",
   fgYellowStrong = "\e[99m",
   fgBlueStrong = "\e[94m",
   fgMagentaStrong ="\e[95m",
   fgCyanStrong = "\e[96m",
   fgWhiteStrong = "\e[97m",
   bgBlack = "\e[40m",
   bgRed = "\e[41m",
   bgGreen = "\e[42m",
   bgYellow = "\e[44m",
   bgBlue = "\e[44m",
   bgMagenta = "\e[45m",
   bgCyan = "\e[46m",
   bgWhite = "\e[47m",
   bgBlackStrong = "\e[100m",
   bgRedStrong = "\e[101m",
   bgGreenStrong = "\e[102m",
   bgYellowStrong = "\e[103m",
   bgBlueStrong = "\e[104m",
   bgMagentaStrong = "\e[105m",
   bgCyanStrong = "\e[106m",
   bgWhiteStrong = "\e[107m",
   resetColors = "\e[0m",
   boldTextEnable = "\e[1m",
   boldTextDisable = "\e[22m",
   underlineTextEnable = "\e[4m",
   underlineTextDisable = "\e[24m",
   negativeTextEnable = "\e[7m",
   negativeTextDisable = "\e[27m"
   errorColors = "\e[37m\e[41m"

var defaultAttributes: seq[textFormat]

var errorAmount: int = 0

proc resetAttributes() =
   for attribute in defaultAttributes:
      stdout.write attribute
   stdout.write textFormat.boldTextDisable
   stdout.write textFormat.underlineTextDisable
   stdout.write textFormat.negativeTextDisable

proc applyAttributes(textAttributes: seq[textFormat]) =
      for attribute in textAttributes:
         stdout.write attribute

proc initProgram*(textAttributes: seq[textFormat]) = 
   eraseScreen()
   hideCursor()
   defaultAttributes = textAttributes
   
   applyAttributes(textAttributes)
   for count in 1 .. termChars:
      stdout.write " "

proc setCursorXYPos(xpos, ypos: int) = 
   var
      xposinc = xpos + 1
      yposinc = ypos + 1
   stdout.write "\e[", yposinc, ";", xposinc, "H"

proc quitProgram*() = 
   stdout.write textFormat.resetColors
   eraseScreen()
   showCursor()
   setCursorXYPos(0,0)

proc drawText*(xpos, ypos: int, text: string, textAttributes: seq[textFormat]) =
   applyAttributes(textAttributes)
   setCursorXYPos(xpos, ypos)
   stdout.write text
   resetAttributes()

   setCursorXYPos(1,1)

proc drawRectangle*(xpos, ypos, width, height: int, textAttributes:seq[textFormat]) = 
   if xpos+width > termWidth or ypos+height > termHeight:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawRectangle` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   if width < 2 or height < 2:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawRectangle` has been specified a size too small."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return

   
   setCursorXYPos(xpos, ypos)

   applyAttributes(textAttributes)
   
   stdout.write "┌" 
   for xCounter in 3 .. width:
      stdout.write "─"
   stdout.write "┐"

   for yCounter in 3 .. height:
      setCursorXYPos(xpos, ypos+yCounter-2)
      stdout.write "│"
      for xCounter in 3 .. width:
         stdout.write " "
      stdout.write "│"
   
   setCursorXYPos(xpos,ypos+height-1)
   stdout.write "└" 
   for xCounter in 3 .. width:
      stdout.write "─"
   stdout.write "┘"

   resetAttributes()
   setCursorXYPos(1,1)

proc drawRectangleSeperatorX*(xpos, ypos, width: int, textAttributes: seq[textFormat]) = 
   if xpos+width > termWidth or ypos > termHeight:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawRectangleSeperatorX` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   if width < 2:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawRectangleSeperatorX` has been specified a size too small."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   
   setCursorXYPos(xpos, ypos)
   
   applyAttributes(textAttributes)
   
   stdout.write "├"
   for xCounter in 3 .. width:
      stdout.write "─"
   stdout.write "┤"

   resetAttributes()
   
   setCursorXYPos(1,1)


proc drawRectangleSeperatorY*(xpos, ypos, height: int, textAttributes: seq[textFormat]) = 
   if ypos+height > termHeight or xpos > termWidth:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawRectangleSeperatorY` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   if height < 2:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawRectangleSeperatorY` has been specified a size too small."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return

   setCursorXYPos(xpos, ypos)
   
   applyAttributes(textAttributes)
   
   stdout.write "┬" 
   for yCounter in 3 .. height:
      setCursorXYPos(xpos, ypos+yCounter-2)
      stdout.write "│" 
   setCursorXYPos(xpos,ypos+height-1)
   stdout.write "┴"

   resetAttributes()
   
   setCursorXYPos(1,1)

proc drawDoubleRectangleSeperatorX*(xpos, ypos, width, lenBeforeSeperator: int, textAttributes: seq[textFormat]) = 
   if xpos+width > termWidth or ypos > termHeight:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawDoubleRectangleSeperatorX` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   if width < 2:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawDoubleRectangleSeperatorX` has been specified a size too small."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   
   setCursorXYPos(xpos, ypos)

   var newWidth:int = width - lenBeforeSeperator - 1
   
   applyAttributes(textAttributes)
   
   stdout.write "├"
   for xCounter in 1 .. lenBeforeSeperator:
      stdout.write "─"
   stdout.write "┼"
   for xCounter in 3 .. newWidth:
      stdout.write "─"
   stdout.write "┤"

   resetAttributes()

   setCursorXYPos(1,1)
   

proc drawDoubleRectangleSeperatorY*(xpos, ypos, height, lenBeforeSeperator: int, textAttributes: seq[textFormat]) = 
   if ypos+height > termHeight:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawDoubleRectangleSeperatorY` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   if height < 2:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawDoubleRectangleSeperatorY` has been specified a size too small."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   
   setCursorXYPos(xpos, ypos)
   
   var newHeight = height - lenBeforeSeperator

   applyAttributes(textAttributes)
   
   stdout.write "┬" 
   for yCounter in 3 .. lenBeforeSeperator+2:
      setCursorXYPos(xpos, ypos+yCounter-2)
      stdout.write "│" 
   setCursorXYPos(xpos, ypos+lenBeforeSeperator+1)
   stdout.write "┼"
   for yCounter in lenBeforeSeperator+4 .. height:
      setCursorXYPos(xpos, ypos+yCounter-2)
      stdout.write "│" 
   setCursorXYPos(xpos,ypos+height-1)
   stdout.write "┴"

   resetAttributes()

   setCursorXYPos(1,1)

proc drawProgressBar*(xpos, ypos, width, currentProgress, maxProgress: int, charSet: array[4, char], textAttributesForFrames, textAttributesForProgress: seq[textFormat]) = 

   var decWidth = width - 2

   if xpos+decWidth > termWidth or ypos > termHeight:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawProgressBar` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   if width < 3:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `drawProgressBar` has been specified a size too small."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return

   var
      temp = (currentProgress * decWidth) / maxProgress
      progressChars: int = round(temp).toInt()
      remainingChars: int = decWidth - progressChars
      progressBar: string

   for count in 1 .. progressChars:
      progressBar &= charSet[2]
   for count in 1 .. remainingChars:
      progressBar &= charSet[3]

   setCursorXYPos(xpos,ypos)

   applyAttributes(textAttributesForFrames)
   stdout.write charSet[0]
   applyAttributes(textAttributesForProgress)
   stdout.write progressBar
   applyAttributes(textAttributesForFrames)
   stdout.write charSet[1]
   resetAttributes()

   setCursorXYPos(1,1)

proc menuSelectX*(xpos, ypos: int, options: seq[string], controlChars: array[3, char], includeNumbers: int, formatting, afterFormatting: string, textAttributes, textAttributesForHover: seq[textFormat],finalChoice: var int) = 
   
   var
      temp1: int = 0
      temp2: int = formatting.len
      temp3: int = afterFormatting.len
   for item in options:
      temp1 += item.len

   if xpos+temp1+temp2+temp3 > termWidth or ypos > termHeight:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `menuSelectX` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
  
   var
      maxOption: int = options.len
      currentOption: int = 1
      choice: int = 0
      key: char

   while choice == 0:
      setCursorXYPos(xpos, ypos)
      for counter in 1 .. maxOption:  
         
         if counter == currentOption:
            applyAttributes(textAttributesForHover)
         else:
            applyAttributes(textAttributes)


         
         if includeNumbers == 0:
            stdout.write formatting, options[counter-1], afterFormatting 
         else:
            stdout.write counter, formatting, options[counter-1], afterFormatting 
      key = getch()
      if key == controlChars[0] and currentOption > 1:
         dec currentOption
      if key == controlChars[1] and currentOption < maxOption:
         inc currentOption
      if key == controlChars[2]:
         choice = currentOption
         finalChoice = currentOption

   resetAttributes()
   
   setCursorXYPos(1,1)

proc menuSelectY*(xpos, ypos: int, options: seq[string], controlChars: array[3, char], includeNumbers: int, formatting, afterFormatting: string, textAttributes, textAttributesForHover: seq[textFormat],finalChoice: var int) = 
   
   var
      temp1: int = 0
      temp2: int = formatting.len
      temp3: int = afterFormatting.len
   for item in options:
      if item.len > temp1: 
         temp1 = item.len

   if xpos+temp1+temp2+temp3 > termWidth or ypos+options.len > termHeight:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `menuSelectY` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return

   var
      maxOption: int = options.len
      currentOption: int = 1
      choice: int = 0
      key: char

   while choice == 0:
      for counter in 1 .. maxOption:
         setCursorXYPos(xpos,ypos+counter-1)
         
         if counter == currentOption:
            applyAttributes(textAttributesForHover)
         else:
            applyAttributes(textAttributes)

         if includeNumbers == 0:
            stdout.write formatting, options[counter-1], afterFormatting 
         else:
            stdout.write counter, formatting, options[counter-1], afterFormatting 
      key = getch()
      if key == controlChars[0] and currentOption > 1: 
         dec currentOption
      if key == controlChars[1] and currentOption < maxOption:
         inc currentOption
      if key == controlChars[2]:
         choice = currentOption
         finalChoice = currentOption

   resetAttributes()
   
   setCursorXYPos(1,1)

proc textBox*(xpos, ypos, width: int, defaultInput: string, typeChar: char, resultVar: var string, textAttributes, textAttributesForDefaultInput: seq[textFormat]) = 
   
   if xpos+width > termWidth or ypos > termHeight:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `textBox` is too big for the terminal size and/or is placed at an invalid place."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return
   if defaultInput.len() + 1 > width:
      setCursorXYPos(2,errorAmount+1)
      inc errorAmount
      var err: string = "Widget `textBox` has an invalid parameter. More specifically, the length of the parameter `defaultInput` is greater than the width of the `textBox` widget."
      if err.len() > termWidth:
         inc errorAmount
      stdout.write textFormat.errorColors, err
      return

   setCursorXYPos(xpos, ypos)
   applyAttributes(textAttributes)
   for counter in 1 .. width:
      stdout.write " "
   setCursorXYPos(xpos,ypos)
   applyAttributes(textAttributesForDefaultInput)
   stdout.write defaultInput
   applyAttributes(textAttributes)
   setCursorXYPos(xpos,ypos)
   stdout.write typeChar

   var typingState: bool = true
   var inputChar: char
   var inputStr: string = ""
   
   while typingState:
      inputChar = getch()
      case inputChar
      of 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','1','2','3','4','5','6','7','8','9','0':
         if inputStr.len() < width:
            inputStr &= inputChar
            setCursorXYPos(xpos,ypos)
            if inputStr.len() < width:
               stdout.write inputStr, typeChar
            else:
               stdout.write inputStr
      of '\r':
         typingState = false
         resultVar = inputStr
      else:
         discard
   
proc pause*() = 
   var temp: char = getch()
