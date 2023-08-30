using JuMP
using CPLEX
# using SCIP
# using GLPK

import MathOptInterface
const MOI = MathOptInterface

function SelectSolver(solver)
    """
    select a solver
    """
    if solver == "Cplex"
        return direct_model(CPLEX.Optimizer())
    elseif solver == "Gurobi"
        return Model(Gurobi.Optimizer)
    elseif solver == "Scip"
        return direct_model(SCIP.Optimizer())
    elseif solver == "Glpk"
        return direct_model(GLPK.Optimizer())
    else
        println("Please set the correct solver!")
    end
end

function PrintInfos(model)
    # solution status (OPTIMAL/TIME_LIMIT/INFEASIBLE)
    @show termination_status(model)

    # feasibility (FEASIBLE_POINT/NO_SOLUTION)
    @show primal_status(model)

    # show some information
    if termination_status(model) == OPTIMAL
        @show objective_value(model)
    elseif termination_status(model) == TIME_LIMIT
        if has_values(model)
            # the best objective value by now
            @show objective_value(model)
        end
    else
        if termination_status(model) != INFEASIBLE
            error("The model was not solved correctly !!!")
        end
    end

    @show solve_time(model)
    # if solver == "Cplex"
    #     @show node_count(model)
    # end
end
