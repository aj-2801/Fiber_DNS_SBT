# Input parameters

This document describes the Fortran namelist parameters in `input/input_file`.

The input uses the namelist

```fortran
&parameters
    ...
/
```

Fortran namelist names are generally case-insensitive, but retaining the capitalization used in the sample file is recommended.

All dimensional quantities must use a consistent system of units. If the solver is operated in nondimensional form, all values must use the same nondimensionalization.

## 1. DNS resolution

| Parameter | Type | Description |
|---|---:|---|
| `nx` | Integer | Base-two exponent defining the number of grid points in the $x$ direction. |
| `ny` | Integer | Base-two exponent defining the number of grid points in the $y$ direction. |
| `nz` | Integer | Base-two exponent defining the number of grid points in the $z$ direction. |

The grid dimensions are

$$N_x=2^{nx},\qquad N_y=2^{ny},\qquad N_z=2^{nz}.$$

For the sample input,

$$N_x=N_y=N_z=64.$$

## 2. MPI decomposition

| Parameter | Type | Description |
|---|---:|---|
| `dproc` | Integer | Base-two exponent defining the total number of MPI processes. |
| `dx` | Integer | Decomposition exponent in the $x$ direction. |
| `dy` | Integer | Decomposition exponent in the $y$ direction. |
| `dz` | Integer | Decomposition exponent in the $z$ direction. |

The total process count is

$$N_{\mathrm{proc}}=2^{dproc},$$

and the decomposition must satisfy

$$dx+dy+dz=dproc.$$

The process lattice is

$$2^{dx}\times2^{dy}\times2^{dz}.$$

For the sample input,

$$dproc=6,\qquad dx=dy=dz=2,$$

so

$$N_{\mathrm{proc}}=64$$

with a $4\times4\times4$ process decomposition.

## 3. Time integration

| Parameter | Type | Description |
|---|---:|---|
| `MaxStep` | Integer | Maximum number of time steps. |
| `EndTime` | Real | Final simulation time. |
| `deltat` | Real | Physical time-step size. |
| `interval_calc` | Integer | Interval, measured in time steps, for selected calculations and output. The sample input requires this value to be even. |
| `t_fiber_start` | Real | Time at which the fiber calculation or coupling begins. |
| `t_fiber_end` | Real | Time at which the fiber calculation or coupling ends. |

The sample input notes that `t_fiber_start` is rounded down to the largest multiple of `deltat` that does not exceed the requested value.

The overall simulation stops when the configured step or time limit is reached.

## 4. Restart control

| Parameter | Type | Allowed values | Description |
|---|---:|---:|---|
| `restart` | Integer | `0`, `1` | Selects a new or restarted simulation. |

Interpretation:

- `restart = 0`: begin a new simulation.
- `restart = 1`: continue from saved checkpoint data.

The sample input instructs users not to alter the numerical and physical configuration when restarting a case.

## 5. Periodic-domain dimensions

| Parameter | Type | Description |
|---|---:|---|
| `Hx` | Real | Periodic-domain length in the $x$ direction. |
| `Hy` | Real | Periodic-domain length in the $y$ direction. |
| `Hz` | Real | Periodic-domain length in the $z$ direction. |

The physical grid spacings are

$$\Delta x=\frac{H_x}{N_x},\qquad \Delta y=\frac{H_y}{N_y},\qquad \Delta z=\frac{H_z}{N_z}.$$

## 6. Ewald summation

| Parameter | Type | Description |
|---|---:|---|
| `r_cutoff_ewald` | Real | Cutoff radius for the real-space contribution to the Ewald sum used for periodic image fibers. |

Increase this value until the periodic image correction and fiber dynamics are converged.

## 7. Nonlinear-term treatment

| Parameter | Type | Allowed values | Description |
|---|---:|---:|---|
| `truncation_type` | Integer | `0`, `1`, `2` | Selects the nonlinear-term and dealiasing treatment. |

Interpretation:

- `0`: omit the nonlinear term;
- `1`: Rogallo truncation with phase shifting;
- `2`: spherical truncation with phase shifting.

Use `0` only for calculations in which the nonlinear advection term is intentionally disabled.

## 8. Fluid and fiber properties

| Parameter | Type | Description |
|---|---:|---|
| `mu` | Real | Fluid dynamic viscosity, $\mu$. |
| `rho_fluid` | Real | Fluid density, $\rho_f$. |
| `kappa` | Real | Fiber aspect ratio, $\kappa=l/a_0$. |
| `l_fiber` | Real | Fiber half-length, $l$. |
| `rho_fiber` | Real | Fiber density, $\rho_p$. |

The kinematic viscosity is

$$\nu=\frac{\mu}{\rho_f}.$$

The characteristic fiber radius is

$$a_0=\frac{l}{\kappa}.$$

## 9. Fiber inertia

| Parameter | Type | Allowed values | Description |
|---|---:|---:|---|
| `fiber_inertia` | Integer | `0`, `1` | Determines whether finite particle inertia is retained. |

Interpretation:

- `fiber_inertia = 1`: advance the fiber using Newton's translational and rotational equations.
- `fiber_inertia = 0`: determine fiber motion from instantaneous force and torque balance when the motion is not prescribed.

## 10. Number of fibers and axial resolution

| Parameter | Type | Description |
|---|---:|---|
| `N_fiber` | Integer | Number of fibers in the periodic domain. The input comments recommend a power of two. |
| `Ns` | Integer | Number of numerical points along each fiber axis. |

Increase `Ns` until the axial force distribution and fiber motion are converged.

## 11. Initial fiber orientation

| Parameter | Type | Allowed values | Description |
|---|---:|---:|---|
| `random_init_p` | Integer | `0`, `1` | Selects deterministic or randomized initial orientations. |
| `px` | Real | Initial $x$ component of the common orientation when `random_init_p = 0`. |
| `py` | Real | Initial $y$ component of the common orientation when `random_init_p = 0`. |
| `pz` | Real | Initial $z$ component of the common orientation when `random_init_p = 0`. |

Interpretation:

- `random_init_p = 1`: initialize fiber orientations randomly.
- `random_init_p = 0`: use the vector specified by `px`, `py`, and `pz`.

For deterministic initialization,

$$\mathbf{p}(0)=\begin{bmatrix}px \\ py \\ pz\end{bmatrix},$$

and the components should satisfy

$$px^2+py^2+pz^2=1.$$

## 12. Fiber angular velocity

| Parameter | Type | Description |
|---|---:|---|
| `OmegaX` | Real | Initial or prescribed angular-velocity component in $x$. |
| `OmegaY` | Real | Initial or prescribed angular-velocity component in $y$. |
| `OmegaZ` | Real | Initial or prescribed angular-velocity component in $z$. |

The angular velocity is

$$\mathbf{\Omega}=\begin{bmatrix} OmegaX \\ OmegaY \\ OmegaZ \end{bmatrix}.$$

## 13. Fiber translational velocity

| Parameter | Type | Description |
|---|---:|---|
| `Ufiber` | Real | Initial or prescribed translational-velocity component in $x$. |
| `Vfiber` | Real | Initial or prescribed translational-velocity component in $y$. |
| `Wfiber` | Real | Initial or prescribed translational-velocity component in $z$. |

The translational velocity is

$$\mathbf{U}=\begin{bmatrix}Ufiber \\ Vfiber \\ Wfiber \end{bmatrix}.$$

## 14. Prescribed or freely evolving motion

| Parameter | Type | Allowed values | Description |
|---|---:|---:|---|
| `moveatprescribed` | Integer | `0`, `1` | Selects prescribed or dynamically determined fiber motion. |

Interpretation:

- `moveatprescribed = 1`: impose the values specified by `Ufiber`, `Vfiber`, `Wfiber`, `OmegaX`, `OmegaY`, and `OmegaZ`.
- `moveatprescribed = 0`: use those values as initial conditions and evolve the fiber dynamically.

The main combinations are:

| `moveatprescribed` | `fiber_inertia` | Motion model |
|---:|---:|---|
| `1` | `0` or `1` | Prescribed translation and rotation. |
| `0` | `1` | Newton's equations with finite fiber inertia. |
| `0` | `0` | Instantaneous force and torque balance. |

## 15. Imposed uniform fluid velocity

| Parameter | Type | Description |
|---|---:|---|
| `U_far_Imposed` | Real | Uniform imposed fluid velocity in $x$. |
| `V_far_Imposed` | Real | Uniform imposed fluid velocity in $y$. |
| `W_far_Imposed` | Real | Uniform imposed fluid velocity in $z$. |

The imposed uniform velocity is

$$\mathbf{U}_{\infty}=\begin{bmatrix} U_{{far}_{Imposed}} \\ V_{{far}_{Imposed}} \\ W_{{far}_{Imposed}} \end{bmatrix}.$$

## 16. Gravity

| Parameter | Type | Description |
|---|---:|---|
| `gravity_Imposed` | Real | Magnitude of gravitational acceleration. Use zero to disable gravity. |
| `gx` | Real | $x$ component of the gravity direction. |
| `gy` | Real | $y$ component of the gravity direction. |
| `gz` | Real | $z$ component of the gravity direction. |

The gravity vector is

$$\mathbf{g}=gravity\_Imposed\begin{bmatrix}gx \\ gy \\ gz \end{bmatrix}.$$

When gravity is active, the direction should satisfy

$$gx^2+gy^2+gz^2=1.$$

## 17. External force

| Parameter | Type | Description |
|---|---:|---|
| `F_ext_X` | Real | External-force component in $x$, applied to each fiber. |
| `F_ext_Y` | Real | External-force component in $y$, applied to each fiber. |
| `F_ext_Z` | Real | External-force component in $z$, applied to each fiber. |

The external force is

$$\mathbf{F}_{\mathrm{ext}}=\begin{bmatrix} F_{ext_{X}} \\ F_{ext_{Y}} \\ F_{ext_{Z}} \end{bmatrix}.$$

## 18. External torque

| Parameter | Type | Description |
|---|---:|---|
| `T_ext_X` | Real | External-torque component in $x$, applied to each fiber. |
| `T_ext_Y` | Real | External-torque component in $y$, applied to each fiber. |
| `T_ext_Z` | Real | External-torque component in $z$, applied to each fiber. |

The external torque is

$$\mathbf{T}_{\mathrm{ext}}=\begin{bmatrix} T_{ext_{X}} \\ T_{ext_{Y}} \\ T_{ext_{Z}} \end{bmatrix}.$$

## 19. Interpolation order

| Parameter | Type | Description |
|---|---:|---|
| `interp_order_x` | Integer | Interpolation order in $x$. |
| `interp_order_y` | Integer | Interpolation order in $y$. |
| `interp_order_z` | Integer | Interpolation order in $z$. |

The sample input instructs users to keep all three interpolation orders even.

Increase the orders until the velocity interpolated along the fiber axis and resulting fiber dynamics are converged.

## 20. Turbulence forcing

| Parameter | Type | Description |
|---|---:|---|
| `k_F` | Real | Maximum wavenumber magnitude included in the stochastic forcing band. |
| `sigma` | Real | Parameter controlling forcing amplitude. |
| `T_F` | Real | Forcing correlation timescale. |

The forced modes satisfy

$$ 0 \leq k \leq k_F.$$

The sample input gives the grid-compatibility condition

$$\frac{H_\alpha k_F}{2\pi}<\frac{N_\alpha}{2}$$

for each coordinate direction $\alpha$.

Setting `sigma = 0` disables stochastic energy input even when `k_F` and `T_F` are nonzero.

## 21. Output directory

| Parameter | Type | Description |
|---|---:|---|
| `out_path` | Character string | Directory used to store simulation output. |

Example:

```fortran
out_path = 'Results'
```

Create the directory in advance if the implementation does not create it automatically.

## 22. Sample input

```fortran
&parameters

nx = 6
ny = 6
nz = 6

dproc = 6
dx = 2
dy = 2
dz = 2

MaxStep = 200000
EndTime = 200.d0
deltat = 1e-2

interval_calc = 10
t_fiber_start = 0.07d0
t_fiber_end = 100.d0

restart = 0

Hx = 20.d0
Hy = 20.d0
Hz = 20.d0

r_cutoff_ewald = 30.d0
truncation_type = 2

mu = 1.d0
rho_fluid = 40.d0
kappa = 20.d0
l_fiber = 1.d0
rho_fiber = 2.d0

fiber_inertia = 1
N_fiber = 4
Ns = 20

random_init_p = 1

px = 0.7071d0
py = 0.d0
pz = 0.7071d0

OmegaX = 0.d0
OmegaY = 0.d0
OmegaZ = 0.d0

Ufiber = 0.d0
Vfiber = 0.d0
Wfiber = 0.d0

moveatprescribed = 0

U_far_Imposed = 0.d0
V_far_Imposed = 0.d0
W_far_Imposed = 0.d0

gravity_Imposed = 0.d0
gx = 0.d0
gy = 0.d0
gz = 1.d0

F_ext_X = 0.d0
F_ext_Y = 0.d0
F_ext_Z = 0.d0

T_ext_X = 0.d0
T_ext_Y = 0.d0
T_ext_Z = 0.d0

interp_order_x = 4
interp_order_y = 4
interp_order_z = 4

k_F = 1.4143d0
sigma = 0.d0
T_F = 4.802d0

out_path = 'Results'

/
```

## 23. Pre-run checklist

Before launching a simulation, verify that:

1. $N_x=2^{nx}$, $N_y=2^{ny}$, and $N_z=2^{nz}$ provide adequate DNS resolution.
2. `dx + dy + dz = dproc`.
3. The launch process count equals $2^{dproc}$.
4. The domain dimensions and resolution give an acceptable $k_{\max}\eta$.
5. `interval_calc` is even.
6. `t_fiber_start < t_fiber_end < EndTime`.
7. The deterministic initial orientation is normalized when `random_init_p = 0`.
8. The gravity direction is normalized when gravity is active.
9. The interpolation orders are even.
10. `k_F` satisfies the grid-compatibility restriction.
11. `r_cutoff_ewald`, `Ns`, interpolation order, and `deltat` have been checked for convergence.
12. The restart files are available when `restart = 1`.
13. The output directory is writable.
