# Using a mixed-dimensional mesh
# Steady-state porepressure distribution along a fracture in a porous matrix
# This is used to initialise the transient solute-transport simulation
[Mesh]
  type = FileMesh
  # The gold mesh is used to reduce the number of large files in the MOOSE repository.
  # The porepressure is not read from the gold mesh
  file = 'gold/fine_steady_out.e'
  block_id = '1 2 3'
  block_name = 'fracture matrix1 matrix2'

  boundary_id = '1 2'
  boundary_name = 'bottom top'
[]

[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 0 0'
[]

[Variables]
  [./pp]
  [../]
[]

[ICs]
  [./pp]
    type = ConstantIC
    variable = pp
    value = 1e6
  [../]
[]

[BCs]
  [./ptop]
    type = PresetBC
    variable = pp
    boundary =  top
    value = 1e6
  [../]
  [./pbottom]
    type = PresetBC
    variable = pp
    boundary = bottom
    value = 1.002e6
  [../]
[]

[Kernels]
  [./adv0]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    variable = pp
  [../]
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pp'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
[]

[Modules]
  [./FluidProperties]
    [./simple_fluid]
      type = SimpleFluidProperties
      bulk_modulus = 2e9
      density0 = 1000
      thermal_expansion = 0
      viscosity = 1e-3
    [../]
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
  [../]
  [./temperature_nodal]
    type = PorousFlowTemperature
    at_nodes = true
  [../]
  [./ppss]
    type = PorousFlow1PhaseFullySaturated
    at_nodes = true
    porepressure = pp
  [../]
  [./ppss_qp]
    type = PorousFlow1PhaseFullySaturated
    porepressure = pp
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
  [../]
  [./massfrac_nodal]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]
  [./simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
    at_nodes = true
  [../]
  [./simple_fluid_qp]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
  [../]
  [./dens_qp_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_qp
    at_nodes = false
  [../]
  [./dens_nodal_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_nodal
    at_nodes = true
    include_old = true
  [../]
  [./visc_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_viscosity_qp
  [../]
  [./visc_all_nodal]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_viscosity_nodal
  [../]
  [./relp]
    type = PorousFlowRelativePermeabilityConst
    phase = 0
  [../]
  [./relp_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_relative_permeability_qp
  [../]
  [./relp_nodal]
    type = PorousFlowRelativePermeabilityConst
    at_nodes = true
    phase = 0
  [../]
  [./relp_all_nodal]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_relative_permeability_nodal
  [../]
  [./permeability1]
    type = PorousFlowPermeabilityConst
    permeability = '1.8e-11 0 0 0 1.8e-11 0 0 0 1.8e-11' # kf=3e-8, a=6e-4m.  1.8e-11 = kf * a
    block = 'fracture'
  [../]
  [./permeability2]
    type = PorousFlowPermeabilityConst
    permeability = '1e-20 0 0 0 1e-20 0 0 0 1e-20'
    block = 'matrix1 matrix2'
  [../]
[]

[Preconditioning]
  active = basic
  [./mumps_is_best_for_parallel_jobs]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  [../]
  [./basic]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = 'gmres      asm      lu           NONZERO                   2             '
  [../]
[]

[Executioner]
  type = Steady
  solve_type = NEWTON

  # controls for nonlinear iterations
  nl_abs_tol = 1e-9
  nl_rel_tol = 1e-10
[]


[Outputs]
  exodus = true
  execute_on = 'timestep_end'
[]
