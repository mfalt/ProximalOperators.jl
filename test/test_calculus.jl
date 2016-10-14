# Test equivalence of functions and prox mappings by means of calculus rules

stuff = [
  Dict( "funcs"  => (IndBallInf(), Conjugate(NormL1())),
        "args"   => ( randn(10), ),
        "gammas" => ( 1.0, )
      ),

  Dict( "funcs"  => (lambda -> (NormL1(lambda), Conjugate(IndBallInf(lambda))))(0.1+10.0*rand()),
        "args"   => ( 5.0*sign(randn(10)) + 5.0*randn(10),
                      5.0*sign(randn(20)) + 5.0*randn(20) ),
        "gammas" => ( 0.5+rand(), 0.5+rand() )
      ),

  Dict( "funcs"  => (lambda -> (IndBallInf(lambda), Conjugate(NormL1(lambda))))(0.1+10.0*rand()),
        "args"   => ( 5.0*sign(randn(10)) + 5.0*randn(10),
                      5.0*sign(randn(20)) + 5.0*randn(20) ),
        "gammas" => ( 0.5+rand(), 0.5+rand() )
      ),

  Dict( "funcs"  => (lambda -> (NormL1(lambda), Conjugate(IndBox(-lambda,lambda))))(0.1+10.0*rand(30)),
        "args"   => ( 5.0*sign(randn(30)) + 5.0*randn(30), ),
        "gammas" => ( 0.5+rand(), 0.5+rand() )
      ),

  Dict( "funcs"  => (lambda -> (IndBox(-lambda,lambda), Conjugate(NormL1(lambda))))(0.1+10.0*rand(30)),
        "args"   => ( 5.0*sign(randn(30)) + 5.0*randn(30), ),
        "gammas" => ( 0.5+rand(), 0.5+rand() )
      ),

  Dict( "funcs"  => (lambda -> (NormL2(lambda), Conjugate(IndBallL2(lambda))))(0.1+10.0*rand()),
        "args"   => ( 5.0*sign(randn(10)) + 5.0*randn(10),
                      5.0*sign(randn(20)) + 5.0*randn(20) ),
        "gammas" => ( 0.5+rand(), 0.5+rand() )
      ),

  Dict( "funcs"  => (lambda -> (IndBallL2(lambda), Conjugate(NormL2(lambda))))(0.1+10.0*rand()),
        "args"   => ( 5.0*sign(randn(10)) + 5.0*randn(10),
                      5.0*sign(randn(20)) + 5.0*randn(20) ),
        "gammas" => ( 0.5+rand(), 0.5+rand() )
      ),

  Dict( "funcs"  => ((a, b, mu) -> (LogBarrier(a, b, mu), Postcomposition(Precomposition(LogBarrier(), a, b), mu)))(2.0, 0.5, 1.0),
        "args"   => ( rand(10), rand(10) ),
        "gammas" => ( 0.5+rand(), 0.5+rand() )
      ),

  Dict( "funcs"  => (p -> (IndPoint(p), IndBox(p, p)))(randn(50)),
        "args"   => ( randn(50), randn(50), randn(50) ),
        "gammas" => ( 1.0, rand(), 5.0*rand() )
      ),

  Dict( "funcs"  => (IndZero(), IndBox(0, 0)),
        "args"   => ( randn(50), randn(50), randn(50) ),
        "gammas" => ( 1.0, rand(), 5.0*rand() )
      ),

  Dict( "funcs"  => (IndFree(), IndBox(-Inf, +Inf)) ,
        "args"   => ( randn(50), randn(50), randn(50) ),
        "gammas" => ( 1.0, rand(), 5.0*rand() )
      ),

  Dict( "funcs"  => (IndNonnegative(), IndBox(0.0, Inf)),
        "args"   => ( randn(50), randn(50), randn(50) ),
        "gammas" => ( 1.0, rand(), 5.0*rand() )
      ),

  Dict( "funcs"  => (IndNonpositive(), IndBox(-Inf, 0.0)),
        "args"   => ( randn(50), randn(50), randn(50) ),
        "gammas" => ( 1.0, rand(), 5.0*rand() )
      )
]

for i = 1:length(stuff)
  println("----------------------------------------------------------")
  f = stuff[i]["funcs"][1]
  g = stuff[i]["funcs"][2]
  println(string(rpad(typeof(f), 25, " "), " VS ", typeof(g)))

  for j = 1:length(stuff[i]["args"])
    x = stuff[i]["args"][j]
    gamma = stuff[i]["gammas"][j]

    # compare the three versions (for f)
    yf, fy = prox_test(f, x, gamma)

    # compare the three versions (for g)
    yg, gy = prox_test(g, x, gamma)

    # compare results of f and g
    @test vecnorm(yf-yg, Inf)/(1+norm(yf, Inf)) <= TOL_ASSERT
    @test fy == gy || abs(fy-gy)/(1+abs(fy)) <= TOL_ASSERT
  end

end