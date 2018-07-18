Simon Corke, 300261123, Comp304 Assignment 2 Part 1 bst set

This time I used an algebraic data type because I'm not sure how you would implement bst as
a list unless you hust used an ordered linked list but I think that would defeat the purpose of
a bst ( 0(logn) search times). I also implemented my own instance of show so as to make printing
the set more readable and make debugging easier. Also the way show is implemented means that 
elements are printed in ascending order so if don't print this way then I know the tree is 
incorrect.
Another note about show is that Empty is represented as an empty String.

Also some of the tests don't compile which I believe is because the only parameter(s) is an 
empty list(s) so which some type variable it doen't know what to look for.

\begin{code}

module BSTSet (
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

data Set a = Empty | Node a (Set a) (Set a) deriving (Ord, Eq)

instance (Show a) => Show (Set a) where
  show Empty = ""
  show (Node v l r) = show l ++ "," ++ show v ++ show r
\end{code}

makeSet:
Once again I relied upon add to all the work in makeSet.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}  

makeSet :: (Ord a) => [a] -> Set a
makeSet list = foldr add Empty list

--Tests
--mT1 = makeSet [] -- Should be "" doesn't compile but works in console
mT2 = makeSet [1,2,3,4,5,6] -- Should be ,1,2,3,4,5,6
mT3 = makeSet [3,4,5,6,1,2] -- Should be ,1,2,3,4,5,6
mT4 = makeSet [3,4,5,6,1,2] -- Should be ,1,2,3,4,5,6

\end{code}

has:
has is pretty simple it just goes through the tree and if it finds the element it returns true and 
false otherwise. has also makes use of bst structure as it compares the current node to the item 
and goes down the appropriate tree based on the difference.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

has :: (Ord a) => a -> Set a -> Bool
has _ Empty = False
has a (Node v l r) 
  | a == v = True
  | a < v = has a l
  | a > v = has a r
--Tests
hT1 = has 7 (makeSet [1,2,3,4,5,6]) -- Should be False
hT2 = has 6 (makeSet [1,2,3,4,5,6]) -- Should be True
hT3 = has 1 (makeSet [1,2,3,4,5,6]) -- Should be True
hT4 = has 2 (makeSet [1,2,3,4,5,6]) -- Should be True
hT5 = has 3 (makeSet [1,2,3,4,5,6]) -- Should be True
hT6 = has 4 (makeSet [1,2,3,4,5,6]) -- Should be True

\end{code}

card:
card is also pretty straight foward as all I did was go through every node and count each step

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

card :: Set a -> Int
card Empty = 0
card (Node _ l r) = 1 + (card l) + (card r)

--Tests
--cT1 = card (makeSet []) -- Should be 0 doesn't compile but works fine in console
cT2 = card (makeSet [1]) -- Should be 1
cT3 = card (makeSet [1,2,3,4,5,6,7,8,9]) -- Should be 9
cT4 = card (makeSet [1,2,3,4,5,5,5,5,5,5,6,7,8,9]) -- Should be 9

\end{code}

add:
I had trouble implementing add. I wanted to make a self balancing bst but I couldn't figure out 
how to do it so as a result add does no balancing it just finds the spot for the element to go 
and (provided that spot is empty) it buts the item in the tree.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}  

add :: (Ord a) => a -> Set a -> Set a
add a Empty = Node a Empty Empty
add a (Node v l r)
  | a == v = Node v l r
  | a < v = Node v (add a l) r
  | a > v = Node v l (add a r)

--Tests
--add 1 (makeSet []) -- Shoule be ,1 doesn't compile but works in console
aT1 = add 1 (makeSet [1,2,3,4,5]) -- Should be ,1,2,3,4,5
aT2 = add 1 (makeSet [2,3,4,5]) -- Should be ,1,2,3,4,5
aT3 = add 1 (makeSet [2]) -- Should be ,1,2
aT4 = add 1 (makeSet [5,4,3,2]) -- Should be ,1,2,3,4,5
aT5 = add 1 (makeSet [2,4,3,5]) -- Should be ,1,2,3,4,5

\end{code}

del:
del was another tricky one to implement because deleting an item form a tree means replacing it 
with something else. To do this whenever an item is deleted I check to see if the node has two 
non-Empty sub trees. In this situation I use the smallect element in the right subtree as the new 
value and remove said item from the right subtree. 
delHelper checks to see if the node has children and adjusts the tree accordingly. 
minNode finds the smallest node in a given tree.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

del :: (Ord a) => a -> Set a -> Set a
del _ Empty = Empty
del a (Node v l r)
  | a == v = delHelper (Node v l r)
  | a < v = Node v (del a l) r
  | a > v = Node v l (del a r)
  
delHelper ::(Ord a) => Set a -> Set a
delHelper (Node _ l Empty) = l
delHelper (Node _ Empty r) = r
delHelper (Node v l r) = Node min l (del min r)
  where min = minNode r

minNode :: Set a -> a
minNode (Node v Empty r) = v
minNode (Node v l r) = minNode l

--Tests
--dT1 = del 1 (makeSet []) -- Should be "" doesn't compile but works in console
dT2 = del 1 (makeSet [1,2,3,4,5]) -- Should be ,2,3,4,5
dT3 = del 1 (makeSet [2,3,1,4,5]) -- Should be ,2,3,4,5
dT4 = del 1 (makeSet [2,3,4,5]) -- Should be ,2,3,4,5
dT5 = del 5 (makeSet [2,3,4,5]) -- Should be ,2,3,4

\end{code}

union:
union was tricky to implement as recursion but i did figure it out. It does the same thing as 
other unions. It tries to add everything in the second tree to the first tree relying on the add 
function to reject duplicates. It does this by adding the current value to the first tree then 
taking the new tree and calling union on the new tree and the left subtree of the second tree. 
finally it calls union on this new tree and the second trees right subtree.

To test this I manually ran the function using different lists and checked the output was what
I expected. Checking for duplicates and missing elements.

\begin{code}

union :: (Ord a) => Set a -> Set a -> Set a
union Empty Empty = Empty
union Empty node2 = node2
union node1 Empty = node1
union node1 (Node v2 l2 r2) = union (union (add  v2 node1) l2) r2 

--Tests
--uT1 = union (makeSet []) (makeSet []) -- Should be "" doesn't compile but works in console
--uT2 = union (makeSet [1]) (makeSet []) -- Should be ,1 doesn't compile but works in console
uT3 = union (makeSet [1]) (makeSet [1]) -- Should be ,1
uT4 = union (makeSet [1,2,3,4]) (makeSet [1]) -- Should be ,1,2,3,4
uT5 = union (makeSet [1,2,3,4]) (makeSet [1,5,6,7,8,9]) -- Should be ,1,2,3,4,5,6,7,8,9

\end{code}

intesect:
One of the things I did with union was I just added elements I wanted to one of the trees but 
this doesn't make sense with intsect so I made a helper function wich keeps track of a third tree 
which is the final tree that I return.
intersect goes through the second tree and looks for a matching element in the first tree. It adds 
any matches it finds to the third tree and returns this when it's done.

To test this I manually ran the function using different lists and checked the output was what
I expected. Checking for duplicates and missing elements.

\begin{code}

intersect :: (Ord a) => Set a -> Set a -> Set a
intersect Empty Empty = Empty
intersect Empty _ = Empty
intersect _ Empty = Empty
intersect node1 node2 = intersectHelper node1 node2 Empty

intersectHelper :: (Ord a) => Set a -> Set a -> Set a -> Set a
intersectHelper _ Empty node3 = node3
intersectHelper node1 (Node v2 l2 r2) node3
  | has v2 node1 = intersectHelper node1 r2 (intersectHelper node1 l2 (add v2 (node3)))
  | otherwise = intersectHelper node1 r2 (intersectHelper node1 l2 (node3))

--Tests
--iT1 = intersect (makeSet []) (makeSet []) -- Should be "" doesn't compile but works in console
--iT2 = intersect (makeSet [1]) (makeSet []) -- Should be "" doesn't compile but works in console
iT3 = intersect (makeSet [1]) (makeSet [1]) -- Should be ,1
--iT4 = intersect (makeSet []) (makeSet [1]) -- Should be "" doesn't compile but works in console
--iT5 = intersect (makeSet []) (makeSet [1,2,3,4,5]) -- Should be "" doesn't compile but works in console
iT6 = intersect (makeSet [1,3,5]) (makeSet [1,2,3,4,5]) -- Should be ,1,3,5
iT7 = intersect (makeSet [6,7,8,9]) (makeSet [1,2,3,4,5]) -- Should be ""

\end{code}

equals:
equals uses the same logic as equals from the unordered set in that it goes through the second set 
and tries to find a matchng element in the first set. It does this by first checking some base 
cases such as one or more tree being Empty. Next it compares the sizes of the two sets. After 
checking the sizes it goes through the seconf set looking for a matching element in the first set.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}  

equals :: (Ord a) => Set a -> Set a -> Bool
equals Empty Empty = True
equals _ Empty = False
equals Empty _ = False
equals set1 set2
  | (card set1) /= (card set2) = False
  | otherwise = equalsHelper set1 set2
  
equalsHelper :: (Ord a) => Set a -> Set a -> Bool
equalsHelper _ Empty = True
equalsHelper node1 (Node v2 l2 r2)
  | not (has v2 node1) = False
  | equalsHelper node1 l2 = equalsHelper node1 r2
  | otherwise = False

--Tests
--eT1 = equals (makeSet []) (makeSet []) -- Should be True doesn't compile but works in console
--eT2 = equals (makeSet [1]) (makeSet []) -- Should be False doesn't compile but works in console
eT3 = equals (makeSet [1]) (makeSet [1]) -- Should be True
eT4 = equals (makeSet [1,2,3,4]) (makeSet [1]) -- Should be False
eT5 = equals (makeSet [1,2,3,4]) (makeSet [1,2,3,4]) -- Should be True
eT6 = equals (makeSet [1,2,3,4]) (makeSet [1,2,3,4,5]) -- Should be False
eT7 = equals (makeSet [1,2,3,4]) (makeSet [1,2,3,5]) -- Should be False

\end{code}

subset:
subset follows the same logic as unordered set and once again it uses the equalsHelper method.
It checks the base case of an Empty first set then compares the sizes of the two sets. After this 
it compares everything in the first set with everything in the second set trying to find a match 
for each item in the first set.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

subset :: (Ord a) => Set a -> Set a -> Bool
subset Empty _ = True
subset set1 set2
  | (card set1) > (card set2) = False
  | otherwise = equalsHelper set2 set1

--Tests
--sT1 = subset (makeSet []) (makeSet []) -- Should be True doesn't compile but works in console
--sT2 = subset (makeSet [1]) (makeSet []) -- Should be False doesn't compile but works in console
--sT3 = subset (makeSet []) (makeSet [1]) -- Should be True doesn't compile but works in console
sT4 = subset (makeSet [1]) (makeSet [1]) -- Should be True
sT5 = subset (makeSet [1,2,3,4]) (makeSet [1]) -- Should be False
sT6 = subset (makeSet [1,2,3,4]) (makeSet [1,2,3,4]) -- Should be True
sT7 = subset (makeSet [1,2,3,4]) (makeSet [1,2,3,4,5,6,7,8]) -- Should be True
sT8 = subset (makeSet [1,2,3,4]) (makeSet [1,2]) -- Should be False

\end{code}

select:
select is like a filter in which it aplies the given method to each element in the list.
select goes through each element in the tree and if the current value is false for the given 
function then it deletes this value from the tree, then calls select on the new left subtree and 
finally on the right subtree. If a value is true for the given function then it is left alone and 
function goes down the left and right subtress.

To test this I manually ran the function using different lists and checked the output was what
I expected.

\begin{code}

select :: (Ord a) => (a -> Bool) -> Set a -> Set a
select _ Empty = Empty
select f (Node v l r)
  | f v = Node v (select f l) (select f r)
  | otherwise = select f (del v (Node v l r))

--Tests
--selT1 = select (>3) (makeSet []) -- Should be "" doesn't compile but works in console
selT2 = select (>3) (makeSet [1,2,3,4,5,6,7,8,9]) -- Should be ,4,5,6,7,8,9
selT3 = select (odd) (makeSet [1,2,3,4,5,6,7,8,9]) -- Should be ,1,3,5,7,9
selT4 = select (>3) (makeSet [-4,-3,1,2]) -- Should be ""

\end{code}