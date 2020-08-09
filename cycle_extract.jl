using .CONTACTS


N = size(A)[1] # sets number of particles
C = Matrix{Float64}(undef,N,N) #instantiates contact matrix C
C[:] = A # stores the expored contaxt matrix from module CONTACTS into C
