import System.Environment
import System.Exit
import System.IO
import Data.List
import System.Posix.User
import System.Process
main = do
        continueIfRoot
        args <- getArgs
        if (length args) == 0
        then usage        >> exit
        else parse (args !! 0)

parse "help"       = usage   >> exit
parse "version"    = version >> exit
parse ""           = usage   >> exit
parse "installpkg" = installpkg >> exit
parse "info-local" = infolocal >> exit

continueIfRoot = do
                  isRoot <- fmap (== 0) getRealUserID
                  if isRoot then return ()
                  else putStrLn "Beaver must be runned as root." >> exit
usage      = do
              putStrLn "Usage: beaver <operation> [...]"
              putStrLn "\thelp\t\t\tdisplays this message"
              putStrLn "\tversion\t\t\tdisplays version"
              putStrLn "\tsync\t\t\tsynchronizes databases"
              putStrLn "\tinstall <package>\t\tinstalls package"
              putStrLn "\tlist\t\t\tlists packages from all repositories"
              putStrLn "\tinfo <package>\t\tdisplays informations about package"
              putStrLn "\tinfo-local <file>\tdisplays informations about local package"
              putStrLn "\tinstall-local <file>\tinstalls local package"
version    = putStrLn "beaver 0.1"
infolocal  = do
              args <- getArgs
              pkgname <- readProcess "beaver-pkgname" [(args !! 1)] ""
              extractpkg
              architecture <- metaprop "arch" pkgname
              version <- metaprop "version" pkgname
              revision <- metaprop "revision" pkgname
              files <- metaprop "files" pkgname
              depends <- metaprop "depends" pkgname
              optionaldepends <- metaprop "optional-depends" pkgname
              conflicts <- metaprop "conflicts" pkgname
              putStrLn ("Name: " ++ pkgname ++ "\nArchitecture: " ++ architecture ++ "\nVersion: " ++ version ++ "\nRevision: " ++ revision ++ "\nDependencies: " ++ depends ++ "\nOptional dependencies: " ++ optionaldepends ++ "\nConflicts: " ++ conflicts ++ "\nFiles: " ++ files)
installpkg = do
              args <- getArgs
              pkgname <- readProcess "beaver-pkgname" [(args !! 1)] ""
              extractpkg
              -- not implemented yet
extractpkg = do
              args <- getArgs
              system ("tar xJf " ++ (args !! 1) ++ " -C /tmp/")
metaprop s p = do
                r <- getprop s ("/tmp/" ++ p ++ "/.META")
                return (r)
getprop s f = do
               r <- readProcess "beaver-parse" [s, f] ""
               return (r)
exit = exitWith ExitSuccess
