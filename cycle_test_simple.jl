using SparseArrays, LinearAlgebra

Is = [1,1,3,4,2,3,2,6]
Js = [2,3,4,5,5,2,6,7]
Vs = [1,1,1,1,1,1,1,1]

simple_A = sparse(Is,Js,Vs,7,7)
simple_A = simple_A + transpose(simple_A)
