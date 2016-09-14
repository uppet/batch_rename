import Data.List
import Data.Maybe
import System.Directory
import System.Environment
import System.FilePath.Glob
import System.FilePath.Posix

usage :: IO ()
usage = do progName <- getProgName
           putStrLn ("Usage:\n\t" ++ progName ++ " \"srcPattern\" \"dstPattern\"")

hasWildcard :: String -> Bool
hasWildcard name = 1 == length (filter (== '*') name)

trimHeadTail s pre pos = let
  nohead = drop (length pre) s in
    reverse (drop (length pos) (reverse nohead))


partRename preL posL preR posR name = 
  let fn = takeFileName name in
  renameFile fn (preR ++ 
                      trimHeadTail fn preL posL ++
                      posR)

batchRename :: String -> String -> IO ()
batchRename left right = if hasWildcard left && hasWildcard right then
                           let wildcardLeftIndex = fromMaybe 0 (elemIndex '*' left)
                               oldPreLeft = take wildcardLeftIndex left 
                               oldPosLeft = drop (wildcardLeftIndex + 1) left
                               wildcardRightIndex = fromMaybe 0 (elemIndex '*' right)
                               oldPreRight = take wildcardRightIndex right
                               oldPosRight = drop (wildcardRightIndex + 1) right in
                             do files <- glob left
                                mapM_ (partRename oldPreLeft oldPosLeft oldPreRight oldPosRight)
                                      files
                         else
                           putStrLn "Oops, use simple rename please."
main :: IO ()
main = do args <- System.Environment.getArgs
          case args of
            [l,r] -> batchRename l r
            otherwise -> usage

