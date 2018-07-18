Simon Corke, 300261123, Comp304 Assignment 2 Part 1 ordered set

I decided to implement Set a as a type synonym instead of a data type mostly because
printing out a list looks a lot better than printing out a data type and I thought this would
help make debugging easier.

I've realised entirely too late to make changes that an ordered set can be in ascending or
descending order but when I wrote all these functions I assumed they would be in ascending order.

Also some of the tests don't compile which I believe is because the only parameter(s) is an 
empty list(s) so which some type variable it doen't know what to look for.

\begin{code}

module OLSet (
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

makeSet:
makeSet is the same as unordered where I just relied on my add function to do all the work.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

makeSet ::(Ord a) => [a] -> Set a
makeSet list = foldr add [] list

--Tests
--mT1 = makeSet [] -- Should be [] won't compile but works in console
mT2 = makeSet [1] -- Should be [1]
mT3 = makeSet [1,2,3,4,5,6] -- Should be [1,2,3,4,5,6]
mT4 = makeSet [12,3,4,5,6] -- Should be [3,4,5,6,12]
mT5 = makeSet [6,5,4,3,2,1] -- Should be [1,2,3,4,5,6]
mT6 = makeSet [1,3,2,5,4] -- Should be [1,2,3,4,5]

\end{code}

has:
has is different from a list or unordered set as knowing that the items are in order implies that, 
finding an element smaller than the one we are searching for, means the set does not contain the 
item. So has goes through a list and if it finds an equivalent item it returns true or if it finds 
an item bigger than the one we are looking for it returns false.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

has :: (Ord a) => a -> Set a -> Bool
has _ [] = False
has a (x:xs)
  | x == a = True
  | a < x = False
  | otherwise = has a xs

--Tests
hT1 = has 1 [] -- Should be False
hT2 = has 1 [1,2,3,4,5] -- Should be True
hT3 = has 1 [2,3,4,5] -- Should be False
hT4 = has 5 [2,3,4,5] -- Should be True

\end{code}

add:
This time add needs to check for duplicates and it needs to put the item in the correct position.
add goes through the list and if it finds an equivalent item it returns the unchanged list. If it
finds an element larger than the item to be added then it adds it in front of the element and 
returns the new list.
Also I thought about using binary search to find where an item should go but this would require
me knowing the length of the set and to do that would mean going through the whole set anyway.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}
add :: (Ord a) => a -> Set a -> Set a
add a [] = [a]
add a (x:xs)
  | a == x = (x:xs)
  | a < x = a:(x:xs)
  | otherwise = x:(add a xs)

--Tests
aT1 = add 1 [] -- Should be [1]
aT2 = add 1 [1] -- Should be [1]
aT3 = add 1 [1,2,3,4,5] -- Should be [1,2,3,4,5]
aT4 = add 6 [1,2,3,4,5] -- Should be [1,2,3,4,5,6]
aT5 = add 3 [1,2,4,5] -- Should be [1,2,3,4,5]
aT6 = add 1 [2,3,4,5] -- Should be [1,2,3,4,5]

\end{code}

card:
card is no different from unordered set as having the elements ordered doesn't help.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}
card :: Set a -> Int
card set = foldl (\l x-> 1+l) 0 set

--Tests
cT1 = card [] -- Should be 0
cT2 = card [1] -- Should be 1
cT3 = card [1,2,3,4,5,6,7,8,9] -- Should be 9

\end{code}

del:
del is similar to unordered del but this time I made use of the fact that the set is ordered by 
checking to see if the element is bigger than the item we are trying to find, If it is then we 
don't need to check the rest of the set.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

del :: (Ord a) => a -> Set a -> Set a
del _ [] = []
del a (x:xs)
  | a == x = xs
  | a < x = x:xs
  | otherwise = x:(del a xs)

--Tests
dT1 = del 1 [] -- Should be []
dT2 = del 3 [1,2,3,4,6] -- Should be [1,2,4,6]
dT3 = del 6 [1,2,3,4,6] -- Should be [1,2,3,4]
dT4 = del 60 [1,2,3,4,6] -- Should be [1,2,3,4,6]
dT5 = del 7 [1,2,3,4,5] -- Should be [1,2,3,4,5]

\end{code}

union:
For union I took advantage of the fact that the the two sets are ordered. union searches through 
both sets and if two elements are equals then the search space is adjusted to not look through 
those elements again. If the one is smaller than the other then we can adjust our search space so 
to not look through that element or its precending elements again.

To test this I manually ran the function using different lists and checked the output was what
I expected. Checking for duplicates, missing elements and making sure the final set is in order.

\begin{code}

union :: (Ord a) => Set a -> Set a -> Set a
union [] set2 = set2
union set1 [] = set1
union (x:xs) (y:ys)
  | x == y = x:(union xs ys)
  | y < x = y:(union (x:xs) ys)
  | otherwise = x:(union xs (y:ys))


--Tests
--uT1 = union [] [] -- Should be [] This test doesn't compile but works fine in console
uT2 = union [] [1] -- Should be [1]
uT3 = union [1] [] -- Should be [1]
uT4 = union [] [1,2,3] -- Should be [1,2,3]
uT5 = union [1,2,3] [2,3,4,5] -- Should be [1,2,3,4,5]
uT6 = union [1,2,3] [4,5] -- Should be [1,2,3,4,5]
uT7 = union [1,2,3] [1,2,3] -- Should be [1,2,3]

\end{code}

intersect:
For intersect I used the fact that the set is ordered to reduce the search space as I searched 
through the lists. If two elements are equal then I don't need to search through them or their 
preceding elements. If one is smaller than the other then I don't need to check the smaller 
element or its preceding elements again.

To test this I manually ran the function using different lists and checked the output was what
I expected. Checking for duplicates, missing elements and making sure the final set is in order.

\begin{code}

intersect :: (Ord a) => Set a -> Set a -> Set a
intersect _ [] = []
intersect [] _ = []
intersect (x:xs) (y:ys)
  | x == y = x:(intersect xs ys)
  | x < y = intersect xs (y:ys)
  | otherwise = intersect(x:xs) ys

--Tests
--iT1 = intersect [] [] -- Should be [] This test doesn't compile but works fine in console
iT2 = intersect [1] [] -- Should be [1]
iT3 = intersect [] [1] -- Should be [1]
iT4 = intersect [1] [1] -- Should be [1]
iT5 = intersect [1,2,3,4,5] [1] -- Should be [1]
iT6 = intersect [1,2,3,4,5] [1,2,3] -- Should be [1,2,3]
iT7 = intersect [1,2,3,4,5] [1,2,3,4,5] -- Should be [1,2,3,4,5]
iT8 = intersect [1,9] [1,2,3,4,5,6,7,8,9] -- Should be [1,9]

\end{code}

equals:
equals is a lot simpler than in an unordered set as we can just go through both sets at once
and if we find a non match or one set runs out of elements then we can return false. This saves 
time as we don't have to do a pass over of both sets using card.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

equals :: (Ord a) => Set a -> Set a -> Bool
equals [] [] = True
equals [] _ = False
equals _ [] = False
equals (x:xs) (y:ys)
  | x /= y = False
  | x == y = equals xs ys

--Tests
--eT1 = equals [] [] -- Should be True This test doesn't compile but works fine in console
eT2 = equals [] [1] -- Should be False
eT3 = equals [1] [1] -- Should be True
eT4 = equals [1] [] -- Should be True
eT5 = equals [1] [1,2,3,4,5] -- Should be False
eT6 = equals [1,2,3,4,5] [1,2,3,4,5] -- Should be True
eT7 = equals [1,2,4,5] [1,2,3,4,5] -- Should be False

\end{code}

subset:
subset takes advantage of the fact that the sets are ordered. Firstly if an element in the first 
set is smaller than an element in the second set then it is not in the second set and we can 
return false without having to check the rest of the set. Also everytime we check an element of 
the second set and its a match or is smaller than the element in the first set we don't need to 
check that element or its preceding elements again.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

subset ::(Ord a) => Set a -> Set a -> Bool
subset [] _ = True
subset _ [] = False
subset (x:xs) (y:ys)
  | x < y = False
  | x > y = subset (x:xs) ys
  | otherwise = subset xs ys

--Tests
--sT1 = subset [] [] -- Should be True Doesn't compile but works in console
sT2 = subset [] [1] -- Should be True
sT3 = subset [] [1,2,3] -- Should be True
sT4 = subset [1] [1,2,3] -- Should be True
sT5 = subset [1,2,3] [1,2,3] -- Should be True
sT6 = subset [4] [1,2,3] -- Should be fasle
sT7 = subset [1,2,4] [1,2,3] -- Should be False

\end{code}

select:
Without knowing what the function actually does select is the same select in unordered so I've 
just used a filter again.

To test this I manually ran the function using different lists and checked the output was what
I expected. Checking for duplicates, missing elements and making sure the final set is in order.

\begin{code}

select :: (a -> Bool) -> Set a -> Set a
select f set = filter f set

selT1 = select (>3) [] -- Should give []
selT2 = select (>3) [1,2,3,4,5,6,7,8,9] -- Should give [4,5,6,7,8,9]
selT3 = select odd [1,2,3,4,5,6,7,8,9] -- Should give [1,3,5,7,9]
selT4 = select (>3) [-4,-3,1,2,] -- Should give []

\end{code}