--		Copyright 1995 by Daniel R. Grayson

ScriptedFunctor = new Type of MutableHashTable
ScriptedFunctor.synonym = "scripted functor"
globalAssignment ScriptedFunctor
precedence ScriptedFunctor := x -> 70
net ScriptedFunctor := lookup(net,Type)
toString ScriptedFunctor := lookup(toString,Type)
methodOptions ScriptedFunctor := H -> null

protect argument
protect subscript
protect superscript
ScriptedFunctor ^ Thing := (G,i) -> (
     if G#?superscript 
     then G#superscript i
     else error("no method for ", toString G, "^", toString i)
     )
ScriptedFunctor _ Thing := (G,i) -> (
     if G#?subscript 
     then G#subscript i
     else error("no method for ", toString G, "_", toString i)
     )
ScriptedFunctor Thing := (G,X) -> (
     if G#?argument
     then G#argument X
     else error("no method for ", toString G, " ", toString X)
     )

args := method()
args(Thing,Sequence) := (i,args) -> prepend(i,args)
args(Thing,Thing) := identity
args(Thing,Thing,Sequence) := (i,j,args) -> prepend(i,prepend(j,args))
args(Thing,Thing,Thing) := identity

id = new ScriptedFunctor from { 
     subscript => (
	  (x) -> (
	       r := lookup(id,class x);
	       if r =!= null then r x
	       else error ("no method 'id_' found for item of class ", toString class x)))
     }

HH = new ScriptedFunctor from {
     subscript => (
	  i -> new ScriptedFunctor from {
	       superscript => (
		    j -> new ScriptedFunctor from {
	       	    	 argument => (
			      X -> cohomology args(i,j,X)
			      )
	       	    	 }
		    ),
	       argument => (
		    X -> homology args(i,X)
		    )
	       }
	  ),
     superscript => (
	  j -> new ScriptedFunctor from {
	       subscript => (
		    i -> new ScriptedFunctor from {
	       	    	 argument => (
			      X -> homology args(j,i,X)
			      )
	       	    	 }
		    ),
	       argument => (
		    X -> cohomology args(j,X)
		    )
	       }
	  ),
     argument => (
	  args -> homology(args)
	  )
     }

f :=
  ---- the following line seems not to be used, so we try commenting it out:
  -- homology(Nothing,Sequence) := 
  homology(ZZ,Sequence) := opts -> (i,X) -> homology prepend(i,X)

g :=
cohomology(ZZ,Sequence) := opts -> (i,X) -> cohomology(prepend(i,X), opts)

ck := f -> ( assert( f =!= null ); assert( instance(f, Function) ); f)
dispatcherFunctions = join(dispatcherFunctions, {ck f, ck g})

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
