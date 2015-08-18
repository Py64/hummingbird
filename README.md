# Hummingbird
A tool to build packages in Beaver format.

# Requirements
- beaver
- haskell-split
- haskell-missingh

# Building
```
mkdir out src/.o src/.hi
cd out
ghc --make ../src/hummingbird.hs -o ./hummingbird -odir ../src/.o -hidir ../src/.hi
```

# Installing
EXECUTE AS ROOT IN out DIRECTORY
```
cp hummingbird /usr/bin/
```
