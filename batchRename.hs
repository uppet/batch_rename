import Data.List
import System.Directory
import System.Environment
import System.FilePath.Glob
import System.FilePath.Posix

usage :: IO ()
usage = do progName <- getProgName
           putStrLn ("Usage:\n\t" ++ progName ++ " \"srcPattern\" \"dstPattern\"")

hasWildcard :: [Char] -> Bool
hasWildcard name = 1 == (length $ filter (\x -> x == '*') name)

bruteIndex e l = case (elemIndex e l) of
                   Just x -> x
                   Nothing -> 0

trimHeadTail s pre pos = let
  nohead = drop (length pre) s in
    reverse (drop (length pos) (reverse nohead))


partRename preL posL preR posR name = 
  let fn = takeFileName name in
  renameFile fn (preR ++ (trimHeadTail fn preL posL) ++ posR)

batchRename :: [Char] -> [Char] -> IO ()
batchRename left right = if hasWildcard left && hasWildcard right then
                           let wildcardLeftIndex = bruteIndex '*' left
                               oldPreLeft = take wildcardLeftIndex left 
                               oldPosLeft = drop (wildcardLeftIndex + 1) left
                               wildcardRightIndex = bruteIndex '*' right
                               oldPreRight = take wildcardRightIndex right
                               oldPosRight = drop (wildcardRightIndex + 1) right in
                             do files <- glob left
                                sequence_ (map (partRename oldPreLeft oldPosLeft
                                                          oldPreRight oldPosRight)
                                               files)
                         else
                           putStrLn "Oops, use simple rename please."
main :: IO ()
main = do args <- System.Environment.getArgs
          case args of
            [l,r] -> batchRename l r
            otherwise -> usage

