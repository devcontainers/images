from sympy import Symbol, Eq, solve

x = Symbol("x")
y = Symbol("y")

equation_1 = Eq((x + y), 2)
equation_2 = Eq((x - y), 4)
print("Equation 1:", equation_1)
print("Equation 2:", equation_2)

solution = solve((equation_1, equation_2), (x, y))
print("Solution:", solution)
