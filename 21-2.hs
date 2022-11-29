import System.IO
import Data.List


type Square = [String]


indexOfSubstr :: String -> String -> Maybe Int
indexOfSubstr sub s
    | s == [] = Nothing
    | length sub > length s = Nothing
    | isPrefixOf sub s = Just 0
    | otherwise = (+1) <$> indexOfSubstr sub (tail s)


splitOn :: String -> String -> [String]
splitOn delim [] = []
splitOn delim s =
    case indexOfSubstr delim s of
        Nothing -> [s]
        Just i -> left : splitOn delim right
            where
                left = take i s
                right = drop (i + length delim) s


readSq :: String -> Square
readSq = splitOn "/"


readRule :: String -> (Square, Square)
readRule s = (fromSq, toSq)
    where [fromSq, toSq] = map readSq $ splitOn " => " s


countPixels :: Square -> Int
countPixels [] = 0
countPixels sq = sum [1 | r <- sq, ch <- r, ch == '#']


rot90 :: Square -> Square
rot90 [[a,b],[c,d]] = [[c,a],[d,b]]
rot90 [[a,b,c],[d,e,f],[g,h,i]] = [[g,d,a],[h,e,b],[i,f,c]]
rot90 x = error "not a valid square"


isSame :: Square -> Square -> Bool
isSame fromSq toSq
    | length fromSq /= length toSq = False
    | fromSq == toSq = True
    | rot90 fromSq == toSq = True
    | (rot90 . rot90) fromSq == toSq = True
    | (rot90 . rot90 . rot90) fromSq == toSq = True
    | flipped == toSq = True
    | rot90 flipped == toSq = True
    | (rot90 . rot90) flipped == toSq = True
    | (rot90 . rot90 . rot90) flipped == toSq = True
    | otherwise = False
    where flipped = reverse fromSq


squaresOfSize :: Int -> Square -> [[Square]]
squaresOfSize n sq =
    [[map (take n . drop c) $ take n $ drop r sq
     | c <- [0,n..sz-1]]
     | r <- [0,n..sz-1]]
        where sz = length sq


combineSquares :: [[Square]] -> Square
combineSquares sqGrid = concatMap combineRow sqGrid
    where
        sz = length $ head $ head sqGrid
        combineRow sqRow = [concatMap (!!i) sqRow | i <- [0,1..sz-1]]

applyRules rules sq = combineSquares $ map (map enhance) $ squaresOfSize sz sq
    where
        sz = if even (length sq) then 2 else 3
        enhance x = head [toSq | (fromSq, toSq) <- rules, x `isSame` fromSq]

main :: IO ()
main = do
    fileHandle <- openFile "21-input.txt" ReadMode
    inputLines <- lines <$> hGetContents fileHandle
    let initialSquare = readSq ".#./..#/###"
    let rules = map readRule inputLines
    let seq = iterate (applyRules rules) initialSquare
    -- same solution as part 1 – it takes a little while but works
    print $ countPixels $ seq !! 18
