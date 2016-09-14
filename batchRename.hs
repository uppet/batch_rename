import Data.List
import Data.Maybe
import System.Directory
import System.Environment
import System.FilePath.Glob
import System.FilePath

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

fetchPrePos s = let idx = fromMaybe 0 (elemIndex '*' s) in
  (take idx s, drop (idx + 1) s)

batchRename :: String -> String -> IO ()
batchRename left right = if hasWildcard left && hasWildcard right then
                           let (oldPreLeft, oldPosLeft) = fetchPrePos left
                               (oldPreRight, oldPosRight) = fetchPrePos right in
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

