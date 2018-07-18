
Question 1a.

Disussion

One of the first problems I had was to determine what is and is not a valid characte. Since char is and ordered type
I wanted to check if the parameter character was in a range of characters. To do this I had to know what the ranges were. 
I used the console to see which characters were ranked higher eg 'a' > 'Z' '0' > 'a' the idea was to find the lowest 
and highest characters from the lowercase, uppercase and numbers. Then I checked what characters were in the ranges
combined using ['0'..'z'] using this list I saw that the three valid ranges were seperated by invalid characters so I knew 
that I would have to check each range indidually. Thus isAlpha simply checks to see if the parameter is within a valid range
and returns true if it is and false if not.

When it came to creating the lineToWords function I had a specific approach in mind which was to recurse through the given
String and whenever I found a valid charater I would find the rest of the word and then move on. The first problem was knowing
when I was at the start of a word or in the middle of finding a word. I sovled this by creating another function that I would 
pass the rest of the String as soon as I found a valid character. This way the outer function is always finding the first character
and the inner function is always going through a word.
My next problem was, upon finding a word, knowing how far forward to jump in the String so as not to repeat or miss characters. 
Initially I tried having my inner function count the number of characters it was processing but I found that to be overly 
complicated. I realised it would be easier to count the length of the returned word and jump forward that far in the String.

The general approach I took to test the code was to check the lower/inner functions first eg isAplha after being satisfied they 
were correct I moved into the higher/outer functions. This way if there was a bug in the higher/outer function it was easier to find
as the bug was most likely in the higer/outer function and not the lower/inner. For testing functions I used edge cases such as 
empty Strings or singeltons as well as different combinations of lowercase uppercase and numbers. I used the console to do the tests
as it was fast to just hit the up arrow and replace the variable with something else. I have included the tests I used as functions.

The final version of lineToWords works as follows:
If it is an empty String then it returns an empty String.
If it is a singleton it either returns that singleton is it is valid or an empty String if is not.
For Strings with more than one character it checks the head. If the head is not a valid character then skips it and recurses on the
tail of the String. If the head is a valid character then it passes the entire String to the findWord function. The findWord function
goes through the String and keeps returning characters untill it hits an invalid character at which point it stops. After a word has 
been found lineToWords returns that word and recurses on the rest of the String minus that word.

\begin{code}

isAlpha :: Char -> Bool
isAlpha a
    | (a >= '0' && a <= '9') || (a >= 'A' && a <= 'Z') || (a >= 'a' && a <= 'z') = True
    | otherwise = False

findWord :: String -> String
findWord (x:[])
    |  isAlpha x = [x]
    |  otherwise = []
findWord (x:xs)
    |  isAlpha x = [x] ++ findWord xs
    |  otherwise = []

lineToWords :: String -> [String]
lineToWords "" = []
lineToWords (x:[])
    |  isAlpha x = [[x]]
    |  otherwise = []
lineToWords (x:xs)
    |  isAlpha x = [word] ++ lineToWords (drop (length word) (x:xs))
    |  otherwise = lineToWords xs
    where word = findWord (x:xs)

--Tests
isAlphaT1 = isAlpha '0' 
isAlphaT2 = isAlpha '9' 
isAlphaT3 = isAlpha '5' 
isAlphaT4 = isAlpha 'a' 
isAlphaT5 = isAlpha 'z' 
isAlphaT6 = isAlpha 'g' 
isAlphaT7 = isAlpha 'A' 
isAlphaT8 = isAlpha 'Z' 
isAlphaT9 = isAlpha 'G' 
isAlphaT10 = isAlpha '!'
isAlphaT11 = isAlpha '-'
isAlphaT12 = isAlpha '/'

findWordT1 = findWord "abc  " 
findWordT2 = findWord "abc  a" 
findWordT3 = findWord "abc,a b" 
findWordT4 = findWord "DFG  " 
findWordT5 = findWord " abc  " 
findWordT6 = findWord "!@#$%^" 
findWordT7 = findWord "abcD  " 
findWordT8 = findWord "a"

lineToWordsT1 = "abc"
lineToWordsT2 = "a"
lineToWordsT3 = "aCD,fg,lk.l.)_+sa"
lineToWordsT4 = "aaaaaaaaaaaaaa"
lineToWordsT5 = "1"
lineToWordsT6 = "123 45 7.8.9.0.A b2 ad3"
lineToWordsT7 = ""
lineToWordsT8 = " "
lineToWordsT9 = "!@#$%^&*()_+"
lineToWordsT10 = "         a           "
lineToWordsT11 = "For example this sentence has 7 words!"

\end{code}


Question 1b.

Discussion

LinesToWords was exremely straight forwad since lineToWords took a single String and returned all the words in it I knew
that I could just recurse through each String, pass it to lineToWords and concatanate the results.

To test it I used edge cases such as empty Strings and singleton as well as cases I thought might break it such as empty Strings in the middle
of the list. I used the console to run the function and manually checked the results as I found this simpler and faster than trying to write auto tests.
\begin{code}

linesToWords :: [String] -> [String]
linesToWords [] = []
linesToWords (x:[]) = lineToWords x
linesToWords (x:xs) = lineToWords x ++ linesToWords xs

--Tests
linesToWordsT1 = linesToWords ["For example this"," sentence has 7 words!"]
linesToWordsT2 = linesToWords ["For","example"," this"," sentence"," has"," 7"," words!"]
linesToWordsT3 = linesToWords [""]
linesToWordsT4 = linesToWords ["a"]
linesToWordsT5 = linesToWords ["For example this","!@#$%^&*()_+"]
linesToWordsT6 = linesToWords []
linesToWordsT7 = linesToWords ["For example this","","!@#$%^&*()_+","adf"]
\end{code}

--question 1 c

Discussion

PosOfWords was trickier to figure out untill I realised that each recurse through linesToWords corresponds to a different line and that I could use that
to easily find the indexes. My initial approach was to pass the current line index to lineOfWords so that it could return tuple with the current line index
as well as the index of each found word. This meant writing a revised function for lineToWords which would return a tuple and take some extra variables to store 
working indices. A problem I had with posOfWords was how to initiate the index variable as the the function only takes a list of Strings and not a starting index.
To sovle this I created new function posOfWords1 and I passed it the String as well as the starting value of 1. Another bug was that initially I was sending lineToWords
the index of the current line only. This meant that it would start counting the index of the current line from 1 or more instead of one. To fix this I sent it 1 so that
it would always start counting from 1.

posOfWords works as follows:
It returns an empty list if the initial list is empty otherwise it sends the list to posOfWords1 with the inital index of 1. posOfWords1 goes through each String in
the list and returns the result of passing the String to lineToWords1 along with the current index of the list. lineToWords1 works in a similar way to linesToWords except 
in records the index of the current character and returns a word along with the index of the line it is on and the index of how far along it is on the line.

For testing I only tested the highest function as this function and posOfWords1 were both very simple functions so any bugs would probably come 
from lineToWords1 as this one was more complicated and it used already tested functions. I used the console to manualy check the results. While testing I noticed 
that empty Strings, or Strings with no valid characters, in the initial list inbetween Strings that contained words would be counted as lines eg ["a","-","b"].
I decided this was not a bug as technically there are still 3 lines even one of the lines is empty/invlaid.

\begin{code}

posOfWords :: [String] -> [(String, Int, Int)]
posOfWords [] = []
posOfWords lines = posOfWords1 lines 1

posOfWords1 :: [String] -> Int -> [(String, Int, Int)]
posOfWords1 (x:[]) n = lineToWords1 x n 1
posOfWords1 (x:xs) n = lineToWords1 x n 1 ++ posOfWords1 xs (n+1)

lineToWords1 :: String -> Int -> Int -> [(String, Int, Int)]
lineToWords1 "" n m = []
lineToWords1 (x:[]) n m
    |  isAlpha x = [([x], n, m)]
    |  otherwise = []
lineToWords1 (x:xs) n m
    |  isAlpha x = [(word, n, m)] ++ lineToWords1 (drop ln (x:xs)) n (m+ln)
    |  otherwise = lineToWords1 xs n (m+1)
    where word = findWord (x:xs)
          ln = length word

--Tests
posOfWordsT1 = posOfWords ["For example", "in this sentence","ther are 9 words."]
posOfWordsT2 = posOfWords ["For example"]
posOfWordsT3 = posOfWords [""]
posOfWordsT4 = posOfWords []
posOfWordsT5 = posOfWords ["For example" ,""]
posOfWordsT6 = posOfWords ["For example", "","this"]
posOfWordsT7 = posOfWords ["For"," example","in","this","sentence","there","are","9","words."]
posOfWordsT8 = posOfWords ["For example", "$$^ss23"]
posOfWordsT9 = posOfWords ["",""]
posOfWordsT10 = posOfWords ["-","","+"]
posOfWordsT11 = posOfWords ["a","-","b"]

\end{code}

--question 2 a

Discussion

When planning wrapLines I knew that I would want to parese the entire text to a list of Strings. This is where linesToWords is useful
however lineToWords uses a different rule for valid characters than wrapLines. This meant I would have to use a differnt rule
for the isAlpha function and therfore the lineToWords function and linesToWords function. The new isAlpha function isAlpha1 just checks if a
character is a space, if it is then it returns true, if not then it returns false.
The next step was deciding how the formating would actually work. I decided to recurse throught the list of words and add them to lines based 
on rules from the handout. I ran into the problem of not knowing what was on the latest line I was working on. To sovle this I made a new function
formatLines that I could give the list of words as well as the current working line. This would allow me to recursively send the line so far or a
new line based on the handout rules. Another problem was how to handle adding spaces to my lines. The rules state that lines cannot start or end
with a space. This meant that adding a space before adding a word might produce lines that start with a space and adding a space at the end might
produce lines with a space on the end. I decided to just add the space after adding a word to the line and trim all lines after I was finished with them.
Another big issue I had working out all the conditions upon adding a word to the line. I was going to pattern match to include patterns for empty and non
empty lines changed it so as only to pattern match against the list of words left. This made the function a lot smaller and easier to code.

wrapLines works as follows:
It returns an empty list String if the parameter list of Strings is also empty. Otherwise it finds all the valid words and sends them as a list of Strings
to formatLines along with a starting empty String. formatLines recurses through the list of words to add and adds them based on the handout rules.

If formatLines is sent an empty list of words then it returns an empty list as well.

For the base case(a single word): 
if the word will fit on the line then add it to the line and return it. 
If the word is bigger than than the maximum length of a line then split over the remaining spaces and send the rest to formatLines with a new line. 
If the word wont fit and it is smaller than the maximum length then return the current line and send the word to formatLines with a new line.
If the word will fit and it is smaller than the remaining length of the line then add it to the line and return the line.

For a list with multiple elements:
if the word will fit exactly on the line then add it to the line, return it and send formatLines the rest of the list and a new line.
If the word is bigger than than the maximum length of a line then split over the remaining spaces and add the rest to the front of the list of words, then send the new list to formatLines with a new line.
If the word wont fit and it is smaller than the maximum length then return the current and send the whole list of words to a formatLines with an empty String.
If the word will fit and it is smaller than the remaining length of the line then add it to the line, return the line and send the tail of the list of words to formatLines along with the current line.

For testing I used the console to manually check results I used the sample input ouput to check the rules and then I checked a different max number as well.
The isAlpha1 function was simple so I just checked some obvious cases and since it was the only change to the parsing of words. I only tested linesToWords2 
to see if the new rule was being applied.

\begin{code}

wrapLines :: Int -> [String] -> [String]
wrapLines _ [] = []
wrapLines n x = formatLines (linesToWords2 x) "" n 

formatLines :: [String] -> String -> Int -> [String]
formatLines [] _ _  = []
formatLines (x:[]) currentLine maxN
    |  lnx == remaining = [currentLine++x]
    |  lnx > maxN = [ currentLine++(take (remaining-1) x) ++ "-"] ++ formatLines [drop (remaining-1) x] "" maxN
    |  (lnx <= maxN) && (lnx > remaining) = [(trimEnd currentLine)] ++ formatLines [x] "" maxN
    |  (lnx <= maxN) && (lnx < remaining) = [currentLine ++ x]
    where remaining = maxN - (length currentLine)
          lnx = length x
formatLines (x:xs) currentLine maxN
    |  lnx == remaining = [currentLine++x] ++ formatLines xs "" maxN
    |  lnx > maxN = [currentLine++(take (remaining-1) x) ++ "-"] ++ formatLines ((drop (remaining-1) x):xs) "" maxN
    |  (lnx <= maxN) && (lnx > remaining) = [trimEnd(currentLine)] ++ formatLines (x:xs) "" maxN
    |  (lnx <= maxN) && (lnx < remaining) = formatLines xs (currentLine ++ x ++ " ") maxN
    where remaining = maxN - (length currentLine)
          lnx = length x

trimEnd :: String -> String
trimEnd x
    |  not (isAlpha1 (last x)) = init x
    |  otherwise = x

linesToWords2 :: [String] -> [String]
linesToWords2 [] = []
linesToWords2 (x:[]) = lineToWords2 x
linesToWords2 (x:xs) = lineToWords2 x ++ linesToWords2 xs

lineToWords2 :: String -> [String]
lineToWords2 "" = []
lineToWords2 (x:[])
    |  isAlpha1 x = [[x]]
    |  otherwise = []
lineToWords2 (x:xs)
    |  isAlpha1 x = [word] ++ lineToWords2 (drop (length word) (x:xs))
    |  otherwise = lineToWords2 xs
    where word = findWord1 (x:xs)

findWord1 :: String -> String
findWord1 (x:[])
    |  isAlpha1 x = [x]
    |  otherwise = []
findWord1 (x:xs)
    |  isAlpha1 x = [x] ++ findWord1 xs
    |  otherwise = []

isAlpha1 :: Char -> Bool
isAlpha1 a
    |  a == ' ' = False
    |  otherwise = True

--tests
wrapLinesT1 = wrapLines 11 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words.","Thoough we have yet to try the","maximization of this example!"]
wrapLinesT2 = wrapLines 11 [""]
wrapLinesT3 = wrapLines 11 []
wrapLinesT4 = wrapLines 11 ["","Thoough we have yet to try the","maximization of this example!"]
wrapLinesT5 = wrapLines 11 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words.","","Thoough we have yet to try the","maximization of this example!"]
wrapLinesT6 = wrapLines 11 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words.",""]
wrapLinesT7 = wrapLines 11 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words."]
wrapLinesT8 = wrapLines 2 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words.","Thoough we have yet to try the","maximization of this example!"]

isAlpha1T1 = isAlpha1 ' '
isAlpha1T2 = isAlpha1 'a'
isAlpha1T3 = isAlpha1 '1'
isAlpha1T4 = isAlpha1 '+'

linesToWords2T1 = linesToWords2 ["For example,","in this sentence","there are 9 words!"]

\end{code}

Question 2 b.

Discussion

For justifyLines I knew that it would just use a variant of the wrapLines code but edit a finished line. The tricky problem was figuring out
how to pad lines with extra spaces in an evenish way. The best solution I could come with was to repeatedly go through the line and add an extra
space where there was already a space. This evenly spread out the spaces but meant I might have to go through the line many times. Another tricky thing
was making sure that there was at least one space before padding spaces. This was because I was getting infinite loops when I tried to pad spaces on a 
String with no spaces in it. My fix was to added a wrapper function that would check for a space before trying to add more spaces. JustifyLines basically 
does the same thing as wrapLines but instead of trimming the ends of lines it pads them out so they are right and left aligned.

justifyLines works as follows:
It returns an empty set if given an empty set.
Oherwise it sends formatLinesJ a list of the words and an empty String.

formatLinesJ recurses through the list of words and adds them to lines based of the handout rules.

formatLinesJ returns an empty list if given an empty list.

for the singleton case:
if the word will exactly fit in the remaining space then add it to the line and return it.
if the word is larger than the maximum allowed then fill out the line and recurse on the remainder.
if the word is smaller than the maximum and it wont fit on the line then pad the current line out, return it and recurse on the word with a new line.
if the word is smaller than the maximum and it will fit on the line then add to the line and return it.(this line isnt padded as the hadout states the last line is exempt from the padding rule)

for multiple words:
if the word will exactly fit in the remaining space then add it to the line and return it and recurse on the rest of the list with a new line.
if the word is larger than the maximum allowed then fill out the line and recurse on the remainder concatenated to the front of the list with a new line.
if the word is smaller than the maximum and it wont fit on the line then pad the current line out, return it and recurse on the current list with a new line.
if the word is smaller than the maximum and it will fit on the line then add to the line and recurse on the rest of the list with the current line.

For testing I used the console to manually check results I used the sample input ouput to check the rules and then I checked a different max number as well. I also
tested the hasSpace and padSpace functions indivdually as well.

\begin{code}

justifyLines :: Int -> [String] -> [String]
justifyLines _ [] = []
justifyLines n x = formatLinesJ (linesToWords2 x) "" n 

formatLinesJ :: [String] -> String -> Int -> [String]
formatLinesJ [] _ _  = []
formatLinesJ (x:[]) currentLine maxN
    |  lnx == remaining = [currentLine++x]
    |  lnx > maxN = [ currentLine++(take (remaining-1) x) ++ "-"] ++ formatLinesJ [drop (remaining-1) x] "" maxN
    |  (lnx <= maxN) && (lnx > remaining) = [padSpace currentLine maxN] ++ formatLinesJ [x] "" maxN
    |  (lnx <= maxN) && (lnx < remaining) = [currentLine ++ x]
    where remaining = maxN - (length currentLine)
          lnx = length x
formatLinesJ (x:xs) currentLine maxN
    |  lnx == remaining = [currentLine++x] ++ formatLinesJ xs "" maxN
    |  lnx > maxN = [currentLine++(take (remaining-1) x) ++ "-"] ++ formatLinesJ ((drop (remaining-1) x):xs) "" maxN
    |  (lnx <= maxN) && (lnx > remaining) = [padSpace currentLine maxN] ++ formatLinesJ (x:xs) "" maxN
    |  (lnx <= maxN) && (lnx < remaining) = formatLinesJ xs (currentLine ++ x ++ " ") maxN
    where remaining = maxN - (length currentLine)
          lnx = length x

padSpace :: String -> Int -> String
padSpace x n
    |  not (isAlpha1 (last x)) = padSpace (init x) n
    |  not (hasSpace x) = padSpace1 (" "++x) n
    |  otherwise = padSpace1 x n

padSpace1 :: String -> Int -> String
padSpace1 x maxN
    |  lnx == maxN = x
    |  lnx < maxN = padSpace1 (addSpaces x maxN lnx) maxN
    where lnx = length x

addSpaces :: String -> Int -> Int -> String
addSpaces (x:[]) maxN ln
    |  ln == maxN = [x]
    |  not (isAlpha1 x) = [x] ++ " "
    |  otherwise = [x]
addSpaces (x:xs) maxN ln
    |  ln == maxN = (x:xs)  
    |  not (isAlpha1 x) = [x]++" "++(addSpaces xs maxN (ln+1))
    |  otherwise = [x] ++ (addSpaces xs maxN (ln))

hasSpace :: String -> Bool
hasSpace [] = False
hasSpace (x:[])
    |  isAlpha1 x = False
    |  otherwise = True
hasSpace (x:xs)
    |  isAlpha1 x = hasSpace xs
    |  otherwise = True

--tests
hasSpaceT1 = hasSpace " "
hasSpaceT2 = hasSpace ""
hasSpaceT3 = hasSpace "a"
hasSpaceT4 = hasSpace "a b"

padSPaceT1 = padSpace "abc cd" 11
padSPaceT2 = padSpace "abc cd " 11
padSPaceT3 = padSpace "abc cd" 11

justifyLinesT1 = justifyLines 11 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words.","Thoough we have yet to try the","maximization of this example!"]
justifyLinesT2 = justifyLines 11 [""]
justifyLinesT3 = justifyLines 11 []
justifyLinesT4 = justifyLines 11 ["","Thoough we have yet to try the","maximization of this example!"]
justifyLinesT5 = justifyLines 11 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words.","","Thoough we have yet to try the","maximization of this example!"]
justifyLinesT6 = justifyLines 11 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words.",""]
justifyLinesT7 = justifyLines 11 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words."]
justifyLinesT8 = justifyLines 2 ["###########","1234567890","For 12345678901 example, in this sentence, ther are 9 words.","Thoough we have yet to try the","maximization of this example!"]

\end{code}

Question 3 a

My approach to this function was to once again parse the list using linesToWords2 then send this and empty sets that would be my lexigon of words and numbers to a new function.
This function would simply go through the list of words and add words that were missing in the lexigon and then also add the index of the word being processed. I wrote this by
using wishful programming writing using functions checkLex and findIndex before I had implemented them. This helped to finish the main function first instead of leaving it and
coming back to it. One problem was when to return the finished lexigon. Because I felt it would be easier to just put the list together at the end I decided to do this in the
final case.

encode works as follows:
if given an empty list then return an tuple of empty lists.
Otherwise parse the list into a list of words and send this with two emtpy lists to buildLex.

buldLex returns an empty tuple if given an empty list.

for the singleton:
if the lexigon already has the word then find the index and added to the list of indices, then return a tuple of the two lists.
if the lexigon does not contain the word then add it to the end of the lexigon and add the new length of the lexigon to the indeces list, finally return a tuple of the two lists.

for multiple words:
if the lexigon already has the current word then find the index and added to the list of indices and recurse on the rest of the list with the updated lexigon.
if the lexigon does not contain the word then add it to the end of the lexigon and add the new length of the lexigon to the indeces list and recurse on the rest of the list with the updated lexigon.

checkLex returns true if the list of Strings contains the given String, false otherwise.

findIndex goes through the list untill it finds a matching String then returns the index.(If it fails then it gives an obviously wrong number)

To test the code I used the console to manually check the results. I checked checkLex then findIndex and then encode afterwards. This made debugging easier when
I was confident of the lower/inner functions.

\begin{code}

encode :: [String] -> ([String],[Int])
encode [] = ([],[])
encode x = buildLex (linesToWords2 x) [] []

buildLex :: [String] -> [String] -> [Int] -> ([String],[Int])
buildLex [] _ _ = ([],[])
buildLex (x:[]) lexWords lexNums
    |  lexHasX = (lexWords, (lexNums ++ [findIndex lexWords x]))
    |  otherwise = ((lexWords ++ [x]), (lexNums ++ [lnW + 1]))
    where lexHasX = checkLex lexWords x
          lnW = length lexWords
buildLex (x:xs) lexWords lexNums
    |  lexHasX = buildLex xs lexWords (lexNums ++ [findIndex lexWords x])
    |  otherwise = buildLex xs (lexWords ++ [x]) (lexNums ++ [lnW + 1])
    where lexHasX = checkLex lexWords x
          lnW = length lexWords

checkLex :: [String] -> String -> Bool
checkLex [] _ = False
checkLex (x:[]) word
    |  x == word = True
    |  otherwise = False
checkLex (x:xs) word
    |  x == word = True
    |  otherwise = checkLex xs word

findIndex :: [String] -> String -> Int
findIndex (x:[]) word
    |  x == word = 1
    |  otherwise = -10000
findIndex (x:xs) word
    |  x == word = 1
    |  otherwise = 1 + (findIndex xs word)

--tests
checkLexT1 = checkLex ["abc","a","b","c",""] "abc"
checkLexT2 = checkLex ["abc","a","b","c",""] "a"
checkLexT3 = checkLex ["abc","a","b","c",""] "b"
checkLexT4 = checkLex ["abc","a","b","c",""] "c"
checkLexT5 = checkLex ["abc","a","b","c",""] "z"

findIndexT1 = findIndex ["abc","a","b","c",""] "abc"
findIndexT2 = findIndex ["abc","a","b","c",""] "b"
findIndexT3 = findIndex ["abc","a","b","c",""] "c"
findIndexT4 = findIndex ["abc","a","b","c",""] "a"
findIndexT5 = findIndex ["abc","a","b","c",""] ""

encodeT1 = encode ["The more I learn, the more I know.", "The more I know, the more I forget."]
encodeT2 = encode ["The more I learn, the more I know."]
encodeT3 = encode [""]
encodeT4 = encode []

\end{code}

Question 3 b

Discussion

This function was the easiest to implement as all the hard work had been done in encode. I knew all I had to do was go through
the indeces list and get the currentth element from the the String list. However as list start at 0 index and the lexigon 
started at 1 I had to adjust this accordingly

decode goes through the Int list fron the lexigon and gets the current Int - 1 element from the String list.

to test it I just encode something then deecoded it to see if I go the same words in the same order. I did this using the console.

\begin{code}

decode :: ([String],[Int]) -> String
decode ([],_) = []
decode (_,[]) = []
decode (lexWords, (x:[])) = lexWords!!(x-1)
decode (lexWords, (x:xs)) = lexWords!!(x-1) ++ " " ++ decode (lexWords, xs)

--Tests

dencodeT1 = decode (encode ["The more I learn, the more I know.", "The more I know, the more I forget."])
dencodeT2 = decode (encode ["The more I learn, the more I know."])
dencodeT3 = decode (encode [""])
dencodeT4 = decode (encode [])

\end{code}