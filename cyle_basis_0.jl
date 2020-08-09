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
Now we select any v in V to serve as the root of the tree
----------=#

push!(T,V[1])

#=----------
Now let z ∈ T ∩ X , we examine each edge z-w in E.
*IMPORTANT* we choose z to be the last vertex in T, this is 30% faster than
chosing the first
----------=#

T_and_X = intersect(T,X)
z = last(T_and_X)

#=----------
Setting the initial conditions for our algorithim to run
----------=#

edge = find_edge(z,E)
cycle_path  = Array{Tuple{Int64, Int64}}(undef,0)
count = 0


while size(T_and_X)[1] !=0 && count < 10
    global count
    global edge, T, cycle_basis, z, cycle_path, tree

    print("z is ")
    println(z)
    println("")

    while edge != (0,0)
        print("We are considering the following edge: ")
        println(edge)
        println("  ")
        if edge[1] == z
            w = edge[2]
        else
            w = edge[1]
        end

        print("w is ")
        println(w)
        println("")

        if size(intersect([w],T))[1] == 0
            push!(T,w)
            push!(tree,edge)
            print("We can add this w to the tree. T is : ")
            println(T)
            println("")

        else
            println("this w is already in the tree and now we have a cycle!")
            println("")
            cycle_path = find_cycle(w,z,tree,T[1])
            println("our new cycle is: ")
            println(cycle_path)
            println("")
            push!(cycle_basis,cycle_path)
        end

        filter!(e->e!=edge,E)
        edge = find_edge(z,E)

        print("This edge is now removed and E is: ")
        println(E)
        println("")

        print("and the new edge E is ")
        println(edge)
        println(" ")
    end

    filter!(x->x!=z,X)
    print("z has been considered so now X is:")
    println(X)
    println("")

    print("T is now: ")
    println(T)
    println("")


    T_and_X = intersect(T,X)
    print("T∩X us now: ")
    println(T_and_X)
    println("")

    if size(T_and_X )[1] !=0
        z = last(T_and_X)
        edge = find_edge(z,E)
    end

    print("z is now: ")
    println(z)
    println("")

    print("our first edge with z is ")
    print(edge)
    println("")

    count = count + 1


end
