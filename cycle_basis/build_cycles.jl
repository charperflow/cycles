using CSV, DataFrames

include("cycle_helper_functions.jl")
include("cycle_test_simple.jl")

A           = simple_A
cycle       = DataFrame()
cycle       = CSV.File("cycle_basis.csv") |> DataFrame!
cycle.Path  = eval.(Meta.parse.(cycle.Path))

N =size(cycle.Size)[1]


cycle_basis     = Array{Array{Tuple{Int64, Int64},1}}(undef,N)
cycle_size      = Array{Int64}(undef,N)
cycle_basis_E   = Array{Array{Int64}}(undef,N)
E               = extract_edges(A)

cycle_basis[:]  = cycle.Path
cycle_size[:]   = cycle.Size

for i = 1:N
    cycle_basis_E[i] = basis_wrt_E(cycle_basis[i],E)
end
