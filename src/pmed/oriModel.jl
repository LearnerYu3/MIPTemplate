
function oriModel(cost, p, clients, facilities)

    # Create model object
    model = SelectSolver("Cplex")

    # set timelimit parameter
    set_time_limit_sec(model, TIME_LIMITS)
    # parameter setting
    set_optimizer_attribute(model, "CPXPARAM_MIP_Tolerances_MIPGap", 0.0)
    set_optimizer_attribute(model, "CPXPARAM_Threads", 1)

    # create variables
    @variable(model, x[i in 1:clients, j in 1:facilities], Bin)
    @variable(model, y[j in 1:facilities], Bin)

    # create objective function
    @objective(model, Min, sum(cost[i, :]' * x[i, :] for i in 1:clients) )

    # create constraints
    @constraint(model, cons_a[i in 1:clients], sum(x[i, :]) == 1)
    @constraint(model, cons_b[i in 1:clients, j in 1:facilities], x[i, j] <= y[j])
    @constraint(model, cons_c, sum(y) == p)

    # optimize
    optimize!(model)

    # show solution summary
    solutionY = []
    if primal_status(model) == FEASIBLE_POINT
       valueY = round.(Int, value.(y))
       solutionY = [j for j in 1:facilities if valueY[j] == 1]
    end

    println("Solution Y: ", solutionY)

    PrintInfos(model)
    return solutionY
end