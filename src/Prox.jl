# Prox.jl - library of nonsmooth functions and associated proximal mappings

__precompile__()

module Prox

using Compat
import Compat.String

typealias RealArray Array{Float64}
typealias ComplexArray Array{Complex{Float64}}
typealias RealOrComplex Union{Float64, Complex{Float64}}
typealias RealOrComplexArray Union{Array{Float64}, Array{Complex{Float64}}}
typealias RealOrComplexVector Union{Array{Float64,1}, Array{Complex{Float64},1}}
typealias RealOrComplexMatrix Union{Array{Float64,2}, Array{Complex{Float64},2}}

export prox, prox!

export ProximableFunction,
       IndAffine,
       IndBallInf,
       IndBallL0,
       IndBallL2,
       IndBallL20,
       IndBallRank,
       IndBox,
       IndHalfspace,
       IndNonnegative,
       IndSimplex,
       IndSOC,
       ElasticNet,
       NormL0,
       NormL1,
       NormL2,
       NormL21,
       SqrNormL2,
       DistL2,
       SqrDistL2

# A hierarchy of abstract types like this may be useful.
# Unfortunately Julia does not allow for multiple inheritance.
#
# ProximableFunction --+-- NormFunction
#                      |
#                      +-- IndicatorFunction -- IndicatorConvex
#

abstract ProximableFunction
abstract NormFunction <: ProximableFunction
abstract IndicatorFunction <: ProximableFunction
abstract IndicatorConvex <: IndicatorFunction

include("functions/distL2.jl")
include("functions/elasticNet.jl")
include("functions/normL2.jl")
include("functions/normL1.jl")
include("functions/normL21.jl")
include("functions/normL0.jl")
include("functions/indAffine.jl")
include("functions/indBallL0.jl")
include("functions/indBallL2.jl")
include("functions/indBallRank.jl")
include("functions/indBox.jl")
include("functions/indSOC.jl")
include("functions/indHalfspace.jl")
include("functions/indSimplex.jl")
include("functions/sqrDistL2.jl")
include("functions/sqrNormL2.jl")

function Base.show(io::IO, f::ProximableFunction)
  println(io, "description : ", fun_name(f))
  println(io, "type        : ", fun_type(f))
  println(io, "expression  : ", fun_expr(f))
  print(  io, "parameters  : ", fun_params(f))
end

fun_name(  f) = "n/a"
fun_type(  f) = "n/a"
fun_expr(  f) = "n/a"
fun_params(f) = "n/a"

"""
  prox(f::ProximableFunction, x::Array, γ::Float64)

Computes the proximal point of `x` with respect to function `f`
and parameter `γ > 0`, that is

  y = argmin_z { f(z) + 1/(2γ)||z-x||^2 }

and returns `y` and `f(y)`.
"""

function prox(f, x, gamma::Float64=1.0)
  y = similar(x)
  fy = prox!(f, x, gamma, y)
  return y, fy
end

"""
  prox!(f::ProximableFunction, x::Array, γ::Float64, y::Array)

Computes the proximal point of `x` with respect to function `f`
and parameter `γ > 0`, and writes the result in `y`. Returns f(y)`.
"""

function prox!(f, x, gamma, y)
  error(
    "prox! is not implemented for functions of type ", typeof(f), " ",
    "and arguments of type ", typeof(x)
  )
end

"""
  prox!(f::ProximableFunction, x::Array, γ::Float64=1.0)

Computes the proximal point of `x` with respect to function `f`
and parameter `γ > 0` *in place*, that is

  x ← argmin_z { f(z) + 1/(2γ)||z-x||^2 }

and returns f(x)`.
"""

prox!(f, x, gamma::Float64=1.0) = prox!(f, x, gamma, x)

# this is for testing
# has to be implemented in a "naive" way for each ProximableFunction subtype
# should be the "textbook" implementation, the "math-to-code" one
# should be the implementation that you look at it you can say it's correct
# no fancy things, no optimizations, no memory savings, just correctness
# when testing, check that prox returns the same as prox_naive
prox_naive(f, x, gamma::Float64=1.0) = prox(f, x, gamma)
# in principle, the above line should be removed and let specific naive implementations operate

end
