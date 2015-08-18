import System.Environment
import System.Exit
import System.IO
import Data.List
import System.Directory
import Data.List.Utils
import System.Posix.User

main = do
        continueIfRoot
        args <- getArgs
        if (length args) == 0
        then usage        >> exit
        else parse (args !! 0)

continueIfRoot = do
                  isRoot <- fmap (== 0) getRealUserID
                  if isRoot then return ()
                  else putStrLn "Chameleon must be runned as root." >> exit

parse "help"       = usage      >> exit
parse "version"    = version    >> exit
parse "list"       = list       >> exit
parse "addmirror"  = addmirror >> exit
parse "add"        = addrepo >> exit
usage      = do
              putStrLn "Usage: chameleon <operation> [...]"
              putStrLn "\thelp\t\t\t\tdisplays this message"
              putStrLn "\tversion\t\t\t\tdisplays version"
              putStrLn "\tadd [name] [server]\t\tadds repository"
              putStrLn "\tremove [name]\t\t\tremoves repository"
              putStrLn "\tlist\t\t\t\tlists repositories"
              putStrLn "\taddmirror [name] [server]\tadds mirror to repository"
version    = putStrLn "chameleon 0.1 (a component of beaver)"
exists s  = do
              result <- doesFileExist s
              if result then return (True) else return (False)
list       = do
              files <- getDirectoryContents "/etc/beaver.repos/"
              putStrLn (replace ".repo" "" (intercalate "\n" (drop 2 files)))
addmirror  = do
              args <- getArgs
              exist <- exists ("/etc/beaver.repos/" ++ (args !! 1) ++ ".repo")
              if exist
              then do
                    result <- readFile ("/etc/beaver.repos/" ++ (args !! 1) ++ ".repo")
                    if isInfixOf (args !! 2) result
                    then do
                          putStrLn "Mirror already exists."
                          exit
                    else appendFile ("/etc/beaver.repos/" ++ (args !! 1) ++ ".repo") ((args !! 2) ++ "\r\n")
                    putStrLn ("Mirror " ++ (args !! 2) ++ " has been added to " ++ (args !! 1))
              else putStrLn "Repository does not exists. Maybe you wanted to use add operation?"
addrepo   = do
             args <- getArgs
             exist <- exists ("/etc/beaver.repos/" ++ (args !! 1) ++ ".repo")
             if exist
             then putStrLn "Repository already exists. Maybe you wanted to use addmirror operation?"
             else do
                   writeFile ("/etc/beaver.repos/" ++ (args !! 1) ++ ".repo") ((args !! 2) ++ "\r\n")
                   putStrLn "Added repository."
exit = exitWith ExitSuccess
