Simon Corke, 300261123, Comp304 Assignment 2 Part 1 unordered set

I decided to implement Set a as a type synonym instead of a data type mostly because
printing out a list looks a lot better than printing out a data type and I thought this would
help make debugging easier.

\begin{code}

module ULSet (
  makeSet,
  has,
  card,
  add,
  del,
  union,
  intersect,
  equals,
  subset,
  select
  ) where


type Set a = [a]

\end{code}

has:
For this function I could have used the elem function but I wasn't sure exactly what it does.
I also could have used a fold but that would mean that the function would always go through n
times. Using this recursion means that as soon as we find the element then the function stops
and returns True.

I choose to do this function first as I figured I would use it in my add function.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

has :: (Eq a) => a -> Set a -> Bool
has _ [] = False
has a (x:xs)
  | x == a = True
  | otherwise = has a xs

--Tests
hasT1 = elem 1 [] -- Should be False
hasT2 = elem 1 [1] -- Should be True
hasT3 = elem 1 [2,3,4,5,6,7] -- Should be False
hasT4 = elem 1 [1,2,3,4,5,6,7] -- Should be True

\end{code}

add:
This function is a matter of checking if a set has the element, if it does not then just stick it
on the the front of the list. Since this is an unordered set we can just put the element anywhere.

I decided to do this funstion before makeSet as I thought makeSet could just use this function.

To test this I manually ran the function using different lists and checked the output was what
I expected. 

\begin{code}  

add :: (Eq a) => a -> Set a -> Set a
add a set
  | has a set = set
  | otherwise = a:set 

--Tests
addT1 = add 1 [] -- Should give [1]
addT2 = add 1 [1] -- Should give [1]
addT3 = add 1 [1,2,3,4,5] -- Should give [1,2,3,4,5]
addT4 = add 1 [3,4,1] -- Should give [3,4,1]
addT5 = add 7 [1,2,3,4,5] -- Should give [1,2,3,4,5]

\end{code}

makeSet:
For this function I could have used nub but it has an O(n^2) running time and I wanted to practice 
using folds. I used a right fold to call the add on every element in the listand the set it was 
producing.

To test this I manually ran the function using different lists and checked the output was what
I expected. One thing I needed to check was that duplicates weren't in the resulting set.

\begin{code}  

makeSet :: (Eq a) => [a] -> Set a
makeSet list = foldr add [] list

--Tests
--msT1 = makeSet [] -- Should produce [] This test won't compile but running makeSet [] in the console works fine
msT2 = makeSet [1] -- Should produce [1]
msT3 = makeSet [1,1,1,1,1,11,1,1,1] -- Should produce [1,11]
msT4 = makeSet [1,2,3,4,5,5] -- Should produce [1,2,3,4,5]
msT5 = makeSet [1,1,2,2,3,3,4,4,5,5] -- Should produce [1,2,3,4,5]

\end{code}

card:
Once again I could have just used length for this but I wanted more practice with folds. I used
a left fold starting from 0 and incrementing by ine for every element of the set.

To test this I manually ran the function using different lists and checked the output was what
I expected. 

\begin{code}  

card :: Set a -> Int
card set = foldl (\l x-> 1+l) 0 set

--Tests
cardT1 = card [] -- Should give 0
cardT2 = card [1] -- Should give 1
cardT4 = card [1,2,3,4,5,6,7,8,9,0] -- Should give 10

\end{code}

del:
I thought about trying to use a fold or a map for this function but I wasn't sure how to 
get them to remove an element. Instead del goes through a list and skips an element if it's to
be deleted.

To test this I manually ran the function using different lists and checked the output was what
I expected. 

\begin{code}  

del :: (Eq a) => a -> Set a -> Set a
del _ [] = []
del a (x:xs)
  | a == x = xs
  | otherwise = x:(del a xs)


--Tests
delT1 = del 1 [] -- Should give []
delT2 = del 1 [1] -- Should give []
delT3 = del 1 [1,2,3,4,5] -- Should give [2,3,4,5]
delT4 = del 1 [2,3,4,5,1] -- Should give [2,3,4,5]
delT5 = del 1 [2,1,4,5] -- Should give [2,4,5]
delT6 = del 7 [1,2,3,4,5] -- Should give [1,2,3,4,5]

\end{code}

union:
union goes through the second list and adds every element missing from the first list to the 
first list. The result is everything in both lists but because it uses the add function duplicates aren't kept.

To test this I manually ran the function using different lists and checked the output was what
I expected. Checking for duplicates and making sure there are no mising elements.

\begin{code}  

union :: (Eq a) => Set a -> Set a -> Set a
union set1 [] = set1
union set1 (x:xs) = (add x (union set1 xs))

--Tests
--uT1 = union [] [] -- Should give [] This test won't compile but running union [] [] in the console works fine
uT2 = union [] [1] -- Should give [1]
uT3 = union [1] [] -- Should give [1]
uT4 = union [1] [1] -- Should give [1]
uT5 = union [1,2,3,4,5] [3,4,5,6,7,8,9] 
-- Should give [1,2,3,4,5,6,7,8,9] actual ouput is [6,7,8,9,1,2,3,4,5]
-- however these two sets are equivalent given our definition of a set
uT6 = union [1,2,3,4,5] [1,2,3,4,5] -- Should give [1,2,3,4,5]

\end{code}

intersect:
intersect goes through the second list and adds every element that's in both lists to the base 
case list which is an Empty list. Checking for duplicates and making sure there are no mising 
elements.

To test this I manually ran the function using different lists and checked the output was what
I expected. Checking for duplicates and making sure there are no mising elements.

\begin{code}  
intersect :: (Ord a) => Set a -> Set a -> Set a
intersect _ [] = []
intersect set1 (x:xs)
  | has x set1 = add x (intersect set1 xs)
  | otherwise = intersect set1 xs

--iT1 = intersect [] [] -- Should give [] This test won't compile but running intersect [] [] in the console works fine
iT2 = intersect [] [1] -- Should give [1]
iT3 = intersect [1] [] -- Should give [1]
iT4 = intersect [1,2,3,4,5] [1] -- Should give [1] 
iT5 = intersect [1,2,3,4,5] [1,2,3] -- Should give [1,2,3]
iT6 = intersect [1,2,3,4,5] [1,2,3,5] -- Should give [1,2,3,5]
iT7 = intersect [1,2,3] [3,4,5] -- Should give [3]

\end{code}

equals:
The normal == for lists doesn't return true if the lists are in different orders. However 
our definition of a set does. This means we have to check each of one set with every element 
of the other set. I did this by first checking the cardinality of the two sets. If they equal 
then a helper function is used that which checks if everything in the second set is also in the 
first set.

This function could be called == but you would need to either use a algebraic data type or a 
new type decleration, then you would not derive Eq and instead implement your own instance of Eq.

To test this I manually ran the function using different sets and checked the output was what
I expected. 

\begin{code}  

equals :: (Eq a) => Set a -> Set a -> Bool
equals [] [] = True
equals [] _ = False
equals _ [] = False
equals set1 set2
  | (card set1) /= (card set2) = False
  | otherwise = equalsHelper set1 set2
  
equalsHelper :: (Eq a) => Set a -> Set a -> Bool
equalsHelper _ [] = True
equalsHelper set1 (x:xs)
  | not (has x set1) = False
  | otherwise = equalsHelper set1 xs

--eT1 = equals [] [] -- Should be True This test won't compile but running equals [] [] in the console works fine
eT2 = equals [] [1] -- Should be False
eT3 = equals [1] [] -- Should be False
eT4 = equals [1] [1] -- Should be True
eT5 = equals [1,2] [1] -- Should be False
eT6 = equals [1,2] [1,2] -- Should be True
eT7 = equals [1,2] [2,1] -- Should be True
eT8 = equals [5,3,7,1,2] [2,1,3,5,7] -- Should be True
eT9 = equals [5,3,7,1,2] [2,1,3,5,8] -- Should be False

\end{code}

subset:
<= for lists just checks size and not if the elements are the same. So subset needs to check both.
It first checks the sizes of each list then it just uses the equalsHelper function as this checks 
if everything in the second list is in the first list. This also means I have to pass the lists through in the opposite order.

This function could be called <= but you would need to either use a algebraic data type or a 
new type decleration, then you would not derive Ord and instead implement your own instance of Ord.

To test this I manually ran the function using different sets and checked the output was what
I expected. 

\begin{code}  

subset :: (Eq a) => Set a -> Set a -> Bool
subset [] [] = True
subset set1 set2
  | (card set1) > (card set2) = False
  | otherwise = equalsHelper set2 set1

--Tests
--sT1 = subset [] [] -- Should be True This test won't compile but subset [] [] runs fine in the console
sT2 = subset [] [1] -- Should be True
sT3 = subset [] [1,2,3,4,5] -- Should be True
sT4 = subset [1,2,3,4,5] [1,2,3,4,5] -- Should be True
sT5 = subset [1,3,5] [1,2,3,4,5] -- Should be True
sT6 = subset [1,3,5] [1,2] -- Should be False
sT7 = subset [1,3,5] [] -- Should be False
sT8 = subset [1,3,5] [1,2,3,4] -- Should be False

\end{code}

filter:
A function that returns the set of elements stisfying a given property is just a filter so
select just returns the filter of the given function on the set.

To test this I manually ran the function using different sets and checked the output was what
I expected.

\begin{code}    

select :: (a -> Bool) -> Set a -> Set a
select f set = filter f set

selT1 = select (>3) [] -- Should give []
selT2 = select (>3) [1,2,3,4,5,6,7,8,9] -- Should give [4,5,6,7,8,9]
selT3 = select (>3) [1,2,-3,-4] -- Should give []
selT4 = select odd [1,2,3,4,5,6,7,8,9] -- Should give [1,3,5,7,9]

\end{code}