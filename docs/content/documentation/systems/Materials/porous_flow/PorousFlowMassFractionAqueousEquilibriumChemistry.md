# PorousFlow Mass Fraction Aqueous Equilibrium Chemistry
!syntax description /Materials/PorousFlowMassFractionAqueousEquilibriumChemistry

This forms `PorousFlow` mass-fractions appropriate for an aqueous
equilibrium chemistry simulation.  The first $N-1$ of these are the
total concentrations of the primary species of the chemical reaction
system, while the last one is the mass-fraction of the remaining
component, which is assumed to be pure water.

!!! warning
    The numerical implementation of the chemical-reactions part of `PorousFlow` is quite simplistic, with very few guards against strange numerical behavior that might arise during the non-linear iterative process that MOOSE uses to find the solution.  Therefore, care must be taken to define your chemical reactions so that the primary species concentrations remain small, but nonzero.

Details concerning aqueous equilibrium chemistry may be found in the
[`chemical reactions`](/chemical_reactions/index.md) module.  The `PorousFlowMassFractionAqueousEquilibriumChemistry` computes the secondary concentrations, and adds them appropriately to the primary concentrations to form the mass-fractions.  There are three main differences between the `chemical reactions` module and `PorousFlow`.  These are:

 - The molar volumes must be specified in `PorousFlow`.  This is so that the concentrations may be measured in $m^{3}/m^{3}$ rather than mol.m$^{-3}$.

 - The equilibrium constants are defined in absolute terms, not as a log10.  Therefore a `PorousFlow` equilibrium constant might be $10^{-6}$, while in `chemical_reactions` it is simply $-6$.
 
 - Unlike the `chemical reactions` module, users of `PorousFlow` must specify the stoichiometric coefficients themselves.  In each reaction, the primary concentrations (variables) must be brought to the left-hand-side.  The right-hand-sides are the secondary species, by definition.  For instance, consider a 2-reaction system consisting of 3 primary variables, $a$, $b$ and $c$.  The reactions are
 \begin{equation}
 \begin{array}{rcl}
 1a + 2b - 3c & \rightleftharpoons & \mathrm{secondary0} \\
4a -5b + 6c   & \rightleftharpoons & \mathrm{secondary1}
\end{array}
\end{equation}
Then the `reactions` input is `1 2 -3 4 -5 6`.




!syntax parameters /Materials/PorousFlowMassFractionAqueousEquilibriumChemistry

!syntax inputs /Materials/PorousFlowMassFractionAqueousEquilibriumChemistry

!syntax children /Materials/PorousFlowMassFractionAqueousEquilibriumChemistry
