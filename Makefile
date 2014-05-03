deps:
	cabal install directory-1.2.0.1 boundedchan lens hedis --constraint 'unix < 2.7' --force-reinstalls

clean:
	rm -f *.o *.hi
#	cabal install unix-2.5.1.0 directory-1.2.0.1 lens
#	cabal install unix-2.5.1.0 directory-1.2.0.1 data-lens distributive-0.4 text-1.1.0.0 hashable-1.2.1.0 unordered-containers-0.2.3.3 semigroups-0.12.2 comonad-4.0 semigroupoids-4.0 data-lens-2.10.4 --force-reinstalls
