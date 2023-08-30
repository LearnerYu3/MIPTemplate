function LazyAndUserCut(cb_data, model, theta, y, isLazy, V, clients, facilities, cost)
    # get value with boardcast method
    theta_vals = callback_value.(cb_data, theta)
    y_vals = callback_value.(cb_data, y)

    maxK = FindMaxK(V, clients, facilities, y_vals)

    for i in 1:clients
        K = maxK[i]
        val = (cost[i, V[i, K]] .- cost[i, V[i, 1:K-1]])' * y_vals[ V[i, 1:K-1] ]
        accumulated = theta_vals[i] - cost[i, V[i, K]] + val
        if accumulated < -EPS
            # add cuts which is violated
            cut = @build_constraint(theta[i] + (cost[i, V[i, K]] .- cost[i, V[i, 1:K-1]])' * y[ V[i, 1:K-1] ] >=
                                    cost[i, V[i, K]])

            Cons = isLazy == true ? MOI.LazyConstraint : MOI.UserCut
            MOI.submit(model, Cons(cb_data), cut)
        end
    end
end

function BendersModel(cost, p, clients, facilities)
    V = SortCost(cost)

    # Create model object
    model = SelectSolver("Cplex")

    # set timelimit parameter
    set_time_limit_sec(model, TIME_LIMITS)
    # parameter setting
    set_optimizer_attribute(model, "CPXPARAM_MIP_Tolerances_MIPGap", 0.0)

    # create variables
    @variable(model, cost[i, V[i, 1]] <= theta[i in 1:clients] <= cost[i, V[i, facilities]])
    @variable(model, y[j in 1:facilities], Bin)

    # create objective function
    @objective(model, Min, sum(theta))

    # create constraints
    @constraint(model, pmed_1, sum(y) == p)

    # add cuts with callback
    function lazyCons(cb_data)
        isLazy = true
        LazyAndUserCut(cb_data, model, theta, y, isLazy, V, clients, facilities, cost)
    end
    function UserCons(cb_data)
        isLazy = false
        LazyAndUserCut(cb_data, model, theta, y, isLazy, V, clients, facilities, cost)
    end
    MOI.set(model, MOI.LazyConstraintCallback(), lazyCons)
    MOI.set(model, MOI.UserCutCallback(), UserCons)

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
