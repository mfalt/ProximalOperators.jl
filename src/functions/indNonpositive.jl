# indicator of nonpositive orthant

"""
  IndNonpositive()

Returns the indicator function the nonpositive orthant, that is

  `g(x) = 0 if x ⩽ 0, +∞ otherwise`
"""

immutable IndNonpositive <: IndicatorConvexCone end


function (f::IndNonpositive){R <: Real}(x::AbstractArray{R})
  for k in eachindex(x)
    if x[k] > 0
      return +Inf
    end
  end
  return 0.0
end

function prox!{R <: Real}(f::IndNonpositive, x::AbstractArray{R}, y::AbstractArray{R}, gamma::Real=1.0)
  for k in eachindex(x)
    if x[k] > 0
      y[k] = zero(R)
    else
      y[k] = x[k]
    end
  end
  return 0.0
end

fun_name(f::IndNonpositive) = "indicator of the Nonpositive cone"
fun_dom(f::IndNonpositive) = "AbstractArray{Real}"
fun_expr(f::IndNonpositive) = "x ↦ 0 if all(0 ⩾ x), +∞ otherwise"
fun_params(f::IndNonpositive) = "none"

function prox_naive{R <: Real}(f::IndNonpositive, x::AbstractArray{R}, gamma::Real=1.0)
  y = min.(zero(R), x)
  return y, 0.0
end
