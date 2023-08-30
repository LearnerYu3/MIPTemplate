function ReadPmed(filename)
   f = readlines(filename)
   str = split(f[1], (' '), keepempty=false)
   vertexn, edgen, p = parse.(Int, str)
   cost = Array{Float64}(undef, vertexn, vertexn)
   for i in 1:vertexn, j in 1:vertexn
      cost[i, j] = Inf
   end
   for i in 2:(edgen+1)
      str = split(f[i], (' '), keepempty=false)
      D = parse.(Int, str)
      cost[D[1], D[2]] = D[3]
      cost[D[2], D[1]] = D[3]
   end
   for i in 1:vertexn
      cost[i, i] = 0
   end
   for i in 1:vertexn, j in 1:vertexn, k in 1:vertexn
      if cost[j, k] >= cost[j, i] + cost[i, k]
         cost[j, k] = cost[j, i] + cost[i, k]
      end
   end
   return cost, p
end

if abspath(PROGRAM_FILE) == @__FILE__
   filename = ARGS[1]
   cost, p = ReadPmed(filename)
   println("p: ", p)
end
