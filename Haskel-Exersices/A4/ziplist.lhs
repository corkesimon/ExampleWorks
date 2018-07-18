Simon Corke 300261123 Comp304 Assignment 4

To implement ZipList I started by looking at the two functions that were hinted at, repeat and 
zipWith.
Repeat takes a value and creates an infinte list with that value. This is useful because one of the 
problems with the pure function is being able to create a ziplist from a function that can be 
applied to any length ZipList. So having an infinte list is useful because of how zipWith works.
zipWith takes a function and two lists and applies that function to the lists in each pair of 
elements untill one or both of the lists ends. This is what we want our ZipList to do. 
So pure takes a value and creates an infinte zipList of that value.
<*> takes two ZipLists and takes the functions from the first and applies them to the values of the 
second untill one or both ZipLists ends.

I also had to implement the Functor instance for ZipList as an applicative functor is also a 
functor. The Ziplist functor is identical to the list functor, it just maps the function to the 
list in the ZipList and returns it as a ZipList.

To testthe ZipList I ran the functions in terminal and checked the output was what I expected. I 
also checked to see if lists of different sizes gave a new ZipList of the correct size.

\begin{code}
newtype ZipList a = ZipList {getZipList :: [a]} deriving (Show)

instance Functor ZipList where
    fmap f (ZipList xs) = ZipList (map f xs)

instance Applicative ZipList where
    pure a = ZipList (repeat a)
    ZipList as <*> ZipList bs = ZipList (zipWith (\a b -> a b) as bs)


t1 = ZipList [(+1),(+2),(+3)] <*> ZipList [4,5,6] -- Should be [5,7,9]
t2 = ZipList [(+1),(+2),(+3)] <*> ZipList [4] -- Should be [5]
t3 = ZipList [(+1),(+2),(+3)] <*> ZipList [] -- Should be []
t4 = ZipList [(+1)] <*> ZipList [4,5,6] -- Should be [5]
t5 = ZipList [] <*> ZipList [4,5,6] -- Should be []
t6 = (+) <$> (ZipList [1,2,3]) <*> (ZipList [4,5,6]) -- Should be [5,7,9]
t7 = ZipList {getZipList = [5]} -- Should be [5]
t8 = (+) <$> (ZipList [1,2,3]) <*> (ZipList []) -- Should be []
t9 = (+) <$> (ZipList [1]) <*> (ZipList [4,5,6]) -- Should be [5]
t10 = (+) <$> (ZipList []) <*> (ZipList [4,5,6]) -- Should be []

\end{code}

