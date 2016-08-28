# Euclidean distance from a set

immutable DistL2 <: ProximableFunction
  ind::IndicatorConvex
  lambda::Float64
  DistL2(ind::IndicatorConvex, lambda::Float64=1.0) =
    lambda < 0 ? error("parameter λ must be nonnegative") : new(ind, lambda)
end

@compat function (f::DistL2)(x::Array)
  p, = prox(f.ind, x)
  return f.lambda*vecnorm(x-p)
end

function prox(f::DistL2, x::RealOrComplexArray, gamma::Float64=1.0)
  p, = prox(f.ind, x)
  d = vecnorm(x-p)
  gamlam = gamma*f.lambda
  if d > gamlam
    return x + gamlam/d*(p-x), f.lambda*(d-gamlam)
  end
  return p, 0.0
end

fun_name(f::DistL2) = "Euclidean distance from a convex set"
fun_type(f::DistL2) = "C^n → R"
fun_expr(f::DistL2) = "x ↦ λ inf { ||x-y|| : y ∈ S} "
fun_params(f::DistL2) = string("λ = $(f.lambda), S = ", typeof(f.ind))
