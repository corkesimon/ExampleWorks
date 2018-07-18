Simon Corke, 300261123, Comp304 Assignment 2 Part 1 bst set

asc:
asc is pretty straightforward it just goes through a list and checks that each element is smaller 
or equal to the next element. I did need to pattern match for a single element as you can't call 
head on an emtpty list.
I made the assumption that an empty is in ascending order.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

asc :: (Ord a) => [a] -> Bool
asc [] = True
asc (x:[]) = True
asc (x:xs)
  | x > (head xs) = False
  | otherwise = asc xs

--Tests
aT1 = asc [1] -- Should be True
aT2 = asc [1,2,3,4] -- Should be True
aT3 = asc [1,2,3,0] -- Should be False
--aT4 = asc [] -- Should be true doesn't compile but works in console
\end{code}

perms:
perms was a lot harder to implement. I started out by trying to implement perms for list with no 
duplucates. This involved me writing down how I would get the permutations then converting this 
process to code. 
perms essentially keeps track of three lists, the first is the permutation that is currently being 
built. Second is the elements that we can choose to add to the currently building list. Third is 
the elements that we have already chosen to create a premutaion for.
There are two recursive calls one goes downwards and adds a new element to the currently building 
list. The other goes sideways and doesn't change the currently building list but does change what 
values the next function call can choose to add to the currently building list.
Once the function finishes a permutation it wraps the list in another lists and returns it.
All the finished permutations are concatanated together for the final result.
To solve the duplicates problem I added a check so that if a element is in the list of elements 
to add the the currently building list and also in the already chosen list then do nothing and do a 
sideways recursion.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

perms :: (Eq a) => [a] -> [[a]]
perms [] = []
perms (x:[]) = [[x]]
perms (x:xs) = permsHelper [x] xs [] ++ permsHelper [] xs [x]

permsHelper :: (Eq a) => [a] -> [a] -> [a] -> [[a]]
permsHelper listX [] _ = [listX]
permsHelper listX (y:[]) listZ
  | elem y listZ = []
  | otherwise = permsHelper (listX ++ [y]) listZ []
permsHelper listX (y:ys) listZ
  | elem y listZ = permsHelper listX ys (listZ ++ [y])
  | otherwise = permsHelper (listX ++ [y]) (ys ++ listZ) [] ++ permsHelper listX ys (listZ ++ [y])

--Tests
pT1 = perms [1] -- Should be [[1]]
--pT2 = perms [] -- Should be [] doesn't compile but works in console
pT3 = perms [1,2] -- Should be [[1,2],[2,1]]
pT4 = perms [1,2,3] -- Should be [[1,2,3],[1,3,2],[2,3,1],[2,1,3],[3,1,2],[3,2,1]]

\end{code}

To get a rough idea of how the time to use perms scaled with its input I used the call:
length (perms l)
on vairous sized lists and timed the results.
It wasn't until size 9 that I could actually perceive a diiference and that was about 1.5secs
for size 10: 11s
for size 11: 120s
so the time costs grows exponentially with the input size

Lazy evaluation helps cut the time cost of the sort function compared to eager evaluation. This is 
because as soon as perms l creates a premutation the is in ascending order this result is returned 
by sort and the other permutations are not calculated.
Eager evaluation would first find all the permutations , then run all of them through asc and then 
finally take the head of the returned list.

\begin{code}
sort l = head [ s | s <- perms l, asc s]

\end{code}