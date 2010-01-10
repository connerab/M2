-- -*- coding: utf-8 -*-
newPackage(
	"BuchbergerForBrp",
    	Version => "1.0", 
    	Date => "April 28, 2005",
    	Authors => {
	     {Name => "Jane Doe", Email => "doe@math.uiuc.edu"}
	     },
    	HomePage => "http://www.math.uiuc.edu/~doe/",
    	Headline => "an example Macaulay2 package",
	AuxiliaryFiles => false, -- set to true if package comes with auxiliary files
    	DebuggingMode => true		 -- set to true only during development
    	)

needs "BitwiseRepresentationPolynomials.m2"

-- Any symbols or functions that the user is to have access to
-- must be placed in one of the following two lists
export {makePairsFromLists }
exportMutable {}

-- Run Buchberger on the ideal I generated by Brps, return GB (Brps)

-- R = ZZ/2[x,y,z]
-- poly = new Brp from {{1,0,0}}

-- list of input polynomials
-- F = {poly}  -- list of input
 
--f = new HashTable from { "1" => "x*2+y"}

-- pairs of indexes referring to polynomials, changing as we find more pairs
-- listOfPairs = {}

-- growing list of generators for basis 
-- G ={}

-- FPs have negative indices 
-- n FPs, m Brps
-- listOfPairs = every FP with every Brp, every Brp with every Brp
-- G = F
-- nextIndex = #F 

--while notEmpty listOfPairs
--  pair = first listOfPairs
--  listOfPairs = remove(listOfPairs, pair)
--  S = SPolynomial(pair)
--  remainder = reduce (S,G)
--  if (remainder != 0 ) then (
--    nextIndex += 1
--    append(G, remainder) 
--    makeMorePairs(G, remainder)
--  )
--)
--
--minimizeBasis(G)
 
-- from pair of indices get corresponding polynomials, then compute their S
-- polynomial
SPolynomial = method()
SPolynomial( List, HashTable ) := Brp => (l,G) -> (
  assert (#l == 2);
  j = last l;
  n = 3;
  variables = entries(id_(ZZ^n));
  if ( i < 0 ) then (-- we are working with a FP
    i = - first l;
    f = G#j;
    xx = new Brp from {variables#i};
    g = new Brp from select( f, mono -> isDivisible( new Brp from {mono}, xx) == false );
    g*xx+g
  )
  else (
    i = first l;
    f = G#i;
    g = G#j;
--    f*ltm g + .....
  )
)

 
-- Make a list with all possible pairs of elements of the separate lists, but
-- remove self-pairs 
makePairsFromLists = method()
makePairsFromLists (List,List) := List => (a,b) -> (
  ll = (apply( a, i-> apply(b, j-> if (i != j) then sort {i,j} else 0 ) ));
  unique delete(0, flatten ll)
)


beginDocumentation()
document { 
	Key => BuchbergerForBrp,
	Headline => "BuchbergerForBrp making use of bit-wise representation",
	EM "PackageTemplate", " is an example package which can
	be used as a template for user packages."
	}
TEST ///
  assert( makePairsFromLists( {1,2,3,4,5}, {1,2,3,4,5}) ==  {{1, 2}, {1, 3},
  {1, 4}, {1, 5}, {2, 3}, {2, 4}, {2, 5}, {3, 4}, {3, 5}, {4, 5}})
  assert(  makePairsFromLists( {1,2,3}, {10,100,1000}) == {{1, 10}, {1, 100},
  {1, 1000}, {2, 10}, {2, 100}, {2, 1000}, {3, 10}, {3, 100}, {3, 1000}})
  assert ( makePairsFromLists( {-1,-3,-2}, {100, 10}) == {{-1, 100}, {-1, 10},
  {-3, 100}, {-3, 10}, {-2, 100}, {-2, 10}} )
  assert ( makePairsFromLists ( {0,1,2}, {22} ) == {{0, 22}, {1, 22}, {2,
  22}})
///
  
       
end

-- Here place M2 code that you find useful while developing this
-- package.  None of it will be executed when the file is loaded,
-- because loading stops when the symbol "end" is encountered.

restart
installPackage "BuchbergerForBrp"
installPackage("BuchbergerForBrp", RemakeAllDocumentation=>true)
check BuchbergerForBrp
