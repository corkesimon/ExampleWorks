Simon Corke 300261123 Comp304 Assignment 4

\begin{code}
import Control.Monad.State
\end{code}

Implemetning Box was straight forward, return should just wrap the value in a Box and >>=
should extract the value from a Box and apply the function to it. The instances for Applicative
and Functor Box also had to be implemented as every Monad is an applicative functor and every 
applicative functor is a functor.

Monad Box obeys the left identity as the defintion for >>= for Monad Box is exactly:
(Box a) >>= f = f a.
The tests left and left' show each side of this equation and both give the same result.

Right identity:
Box a >>= return,
return a = Box a,
Box a >>= return = return a == Box a.
The test right shows the result of Box a >>= return is Box a.

Associativity:
The tests acc and acc' show that Monad Box obeys associativity as the rder that the functions are 
nested is changed but the outcome is still the same.

To test this I used the terminal to run the functions and compare the results to see if they are 
what I expected. I also used the terminal to check that the Monad laws where being obeyed.

\begin{code}


data Box a = Box a deriving (Show, Eq)

instance Functor Box where
    fmap f (Box a) = Box (f a)

instance Applicative Box where
    pure a = Box a
    (Box f) <*> box = fmap f box

instance Monad Box where
    return a = Box a
    (Box a) >>= f = f a
--Tests

t1 = return 3 :: Box Int -- Should be Box 3
t2 = return "3" :: Box String -- Should be Box "3"
t3 = Box 3 >>= (\x -> return (x*2)) -- Should be Box 6
t4 = Box "3" >>= (\x -> return (x++"2")) -- Should be Box "32"
left = return 3 >>= (\x -> return (x*2)) :: Box Int-- = Box 6
left' = (\x -> return (x*2)) 3 :: Box Int -- = Box 6
right = Box 3 >>= return -- = Box 3
f1 = (\x -> return (x*2))
f2 = (\x -> return (x*4))
acc = Box 3 >>= f1 >>= f2 -- = 24
acc' = Box 3 >>= (\x -> f1 x >>= f2) -- = 24
\end{code}

For implementing unlockable box I wanted to make any interaction with a lockedBox (aside from 
unlocking it) do nothing. So fmap on a Locked Box returns the lockedbox untouched and binding a
lockedbox to a function also returns the lockedbox. However I couldn't get the same functionalilty 
for applicative because <*> has to return an altered applicative. If couldn't just return the 
applicative I started with so instead an error is thrown when LockedBox * UnlockableBox is used.

I tested this by running the functions in the terminal and checking to see if the output was what I
expected.

\begin{code}
data LockableBox b a = UnlockedBox a | LockedBox b deriving (Show, Eq)

instance Functor (LockableBox b) where
    fmap f (UnlockedBox a) = UnlockedBox(f a)
    fmap f (LockedBox b) = LockedBox b

instance Applicative (LockableBox b) where
    pure a = UnlockedBox a
    (UnlockedBox a) <*> box = fmap a box
    (LockedBox b) <*> box =  undefined

instance Monad (LockableBox b) where
    return a = UnlockedBox a
    (UnlockedBox a) >>= f = f a
    (LockedBox b) >>= f = LockedBox b

lock :: LockableBox b a -> LockableBox a a
lock (UnlockedBox a) = LockedBox a
unlock :: LockableBox b a -> LockableBox b b
unlock (LockedBox b) = UnlockedBox b

u = UnlockedBox 3
l = LockedBox 3
l1 = fmap (*2) u -- Should be UnlockedBox 6
l2 = fmap (*2) l -- Should be LockedBox 3
l3 = UnlockedBox (+3) <*> u -- SHould be UnlockedBox 6
l4 = UnlockedBox (+3) <*> l -- Should be LockedBox 3
l5 = (+) <$> UnlockedBox (3) <*> u -- SHould be UnlockedBox 6
l6 = (+) <$> UnlockedBox (3) <*> l -- Should be LockedBox 3
l7 = (+) <$> u <*> u -- SHould be UnlockedBox 6
l8 = (+) <$> u <*> l -- Should be LockedBox 3
l9 = return 3 :: LockableBox a Int -- Should be UnlockedBox 3
l10 = u >>= (\x -> return (x*2)) -- Should be UnlockedBox 6
l11 = l >>= (\x -> return (x*2)) -- Should be LockedBox 3
l12 = lock u -- Should be LockedBox 3
l13 = unlock l -- Should be UnlockedBox 3
\end{code}

I decided to use do notation to make writing the functions easier. For dup it was a case of simply 
taking the first item on the stack and pushing back on twice. For swap I popped the first two 
items and then pushed them back on one after the other.

I'm not sure if my system is concanative or not, on the one hand you could chain the state 
functions together using the output of one as input to another but for my implementation I've used 
variables to store the output of functions before using them as input to other functions.

I tested this by running the functions in the terminal and checking to see if the output was what I
expected.

\begin{code}

pop :: State [Int] Int
pop = state $ \(x:xs) -> (x,xs)

push :: Int -> State [Int] ()
push a = state $ \xs -> ((),a:xs)

dup :: State [Int] ()
dup = do
    a <- pop
    push a
    push a

swap :: State [Int] ()
swap = do
    a <- pop
    b <- pop
    push a
    push b

s1 = flip runState [] $ do push 3; push 5; push 7; swap; pop; dup -- ((), [7,7,3])
s2 = flip runState [] $ do push 3; dup; dup -- ((),[3,3,3])
s3 = flip runState [] $ do push 3; push 5; swap; dup; dup; pop -- (3,[3,3,5])

\end{code}