
include("startup.jl")
include("read_data.jl")
include("preprocess.jl")
include("BendersModel.jl")
include("oriModel.jl")
push!(LOAD_PATH, ".")

# constants definition
const EPS = 1e-6
const TIME_LIMITS = 7200
const filename = ARGS[1]
const mode = ARGS[2]


cost, p = ReadPmed(filename)
clients = size(cost, 1)
facilities = size(cost, 2)
println("clients: ", clients, " facilities: ", facilities, " p: ", p)

if mode == "benders"
    BendersModel(cost, p, clients, facilities)
elseif mode == "ori"
    oriModel(cost, p, clients, facilities)
end
