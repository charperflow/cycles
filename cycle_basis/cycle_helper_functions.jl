#=----------
This file contains all of the functions we use in our cycle extraction and
building scripts.
----------=#

"""
    function extract_edges(A)
Generates a set of all edges, `E` from graph `A`. Each edge is represented as
a tuple representing the vertices they connect.
"""
function extract_edges(A)
    N = size(A)[1]
    Edges = Array{Tuple{Int64,Int64}}(undef,0)
    for i = 1:N
        for j = i:N
            if A[i,j] != 0
                push!(Edges, (i,j))
            end
        end
    end

    return Edges
end


"""
    function find_edge(z,E)
Returns the first edge in the list if edges `E` which contains vertice `z`. If there
are no such edges it returns (0,0)
"""
function find_edge(z,E)
    N = size(E)[1]
    edge = (0,0)
    for i = 1:N
        if size(intersect(z,E[i]))[1] !=0
            edge = E[i]
            return edge
        end
    end
    return edge
end


"""
    function find_cycle(w,z,tree,seed)
Returns a list of edges representing the cycle from `w` to `z`. This function
relies on using the last elemnt approach when examining vertices. This
gaurantees that `w` is only one edge from the root of `z`, and we only need to
construc the path back from z to its seed and we're done!
"""
function find_cycle(w,z,tree,seed)

    cycle_path   = Array{Tuple{Int64, Int64}}(undef,0)
    M            = size(tree)[1]
    link_vertex  = z

    #=---------
    The general idea here is that tracing back UP the tree each vertice only
    has one edge, so we just back track. Starting with z, then pulling the FIRST
    edge which also has z in it. The first time z appears in tree, will be its
    link "up" the tree.
    ----------=#

    while link_vertex != seed
        link_list = [edge for edge in tree if link_vertex in edge]
        link_edge = link_list[1]
        push!(cycle_path,link_edge)
        if link_edge[1] == link_vertex
            link_vertex = link_edge[2]
        else
            link_vertex = link_edge[1]
        end
    end

    push!(cycle_path,(w,z))
    push!(cycle_path,(seed,w))

    return cycle_path
end

"""
BLAH BLAH BLAH

"""
function build_cycle_basis!(cycle_basis, E, T, tree)
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
end


"""
BLAH BLAH BLAH
"""
function basis_wrt_E(basis, E)
    N = size(E)[1]
    M = size(basis)[1]

    basis_E = zeros(N)

    for i = 1:M
        for j = 1:N
            if basis[i] == E[j]
                basis_E[j] = 1
                break
            end
        end
    end

    return basis_E

end
