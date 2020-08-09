module CONTACTS

using DataFrames
using CSV


df = DataFrame()
df = CSV.File("STATIC.csv"; header = false) |> DataFrame!


N = size(df.Column8)[1]
partNum = 717
A = zeros(partNum,partNum) #adjacency matrix
x_pos = zeros(partNum)
y_pos = zeros(partNum)


for i = 1:N
    row     = df.Column8[i]
    column  = df.Column9[i]
    if row ≤ 717 && column ≤ 717
        A[row,column] = 1
        x_pos[row]  = df.Column2[i]
        y_pos[row]  = df.Column3[i]
    end
end


A[:] = A + transpose(A)

export A

end
