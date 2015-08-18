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
parse "build" = build >> exit
parse "clean" = clean >> exit

continueIfRoot = do
                  isRoot <- fmap (== 0) getRealUserID
                  if isRoot then putStrLn "Hummingbird cannot run as root due to security threads." >> exit
                  else return()
usage      = do
              putStrLn "Usage: hummingbird <operation> [optional arguments]"
              putStrLn "\thelp\t\t\tdisplays this message"
              putStrLn "\tversion\t\t\tdisplays version"
              putStrLn "\tbuild\t\tbuilds package"
              putStrLn "\tclean\t\tcleans build directory"
              putStrLn "\nAdditional arguments can be passed to build operation."
              putStrLn "\t-install\t\tinstalls after successful build"
              putStrLn "\t-do-not-generate-checksums\twill disable checksum generating"
version    = putStrLn "hummingbird 0.1"
build  = do
              args <- getArgs
              pkgname <- readProcess "beaver-p" [(args !! 1)] ""
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
