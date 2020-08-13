using DataFrames, CSV

include("cycle_helper_functions.jl")
include("cycle_test_simple.jl") # for simplest test


A = simple_A

#=----------
Here we construct V and X
V :: the set of verticies
X :: the set of vertices not yet examined
----------=#
N       = size(A)[1]
X       = Array{Int64}(undef,N)
V       = [i for i ∈ 1:N]
X[:]    = V[:]

#=----------
Here we construct E, T, tree, and cycle_basis
E           :: the set of edges
T           :: the set of vertices in the tree. Starts empty
tree        :: list of tuples representing the edges in our tree
cycle_basis :: A list of our cycles. Starts empty and adds them as found
----------=#

E           = extract_edges(A)
T           = Array{Int64}(undef,0)
tree        = Array{Tuple{Int64, Int64}}(undef,0)
cycle_basis = Array[]


#=----------
now we call the function which uses Patron's algorithm to build our cycle basis
----------=#
build_cycle_basis!(cycle_basis, E, T, tree)

#=----------
Here we build cycle_size, which is a list containig the size of each cycle in
cycle_basis
----------=#

M = size(cycle_basis)[1]
cycle_size = Array{Int64}(undef,M)

for i = 1:M
    cycle_size[i] = size(cycle_basis[i])[1]
end


df = DataFrame()
df.Path = cycle_basis
df.Size = cycle_size

CSV.write("cycle_basis.csv",df)
