## Governing Equations

The code solves the governing equations for the turbulent flow of an incompressible Newtonian fluid laden with slender fibers. The fluid flow is governed by the incompressible Navier–Stokes equations, which written in index notation is given as, 

$$
\frac{\partial u_i}{\partial t} + \frac{\partial}{\partial r_j} (u_i u_j) = -\frac{1}{\rho}\frac{\partial p}{\partial r_i} + \nu \frac{\partial^2 u_i}{\partial r_i^2} + \frac{1}{\rho}(F_{i}^{\mathrm{turb}} + F_{i}^{\mathrm{fiber}})
$$

with incompressibility constraint

$$
\frac{\partial u_i}{\partial r_i} = 0 
$$

Here, $u_i$ and $p$ denote the fluid velocity and pressure, $\rho$ and $\nu$ are the fluid density and kinematic viscosity, and $F_{i}^{\mathrm{turb}}$ and $F_{i}^{\mathrm{fiber}}$ represent the force per unit volume on the fluid from the stochastic turbulent forcing and the fibers in the box. The turbulent force is necessary to maintain the turbulent fluid velocity in a statistically steady state. 

The governing equations given above are solved in a periodic domain with unit cell dimensions $H_x$, $H_y$ and $H_z$. The fluid velocity and pressure fields satisfying the periodic boundary conditions can then be approximated using a truncated discrete Fourier series, 

$$
u_i = \sum_{k_x} \sum_{k_y} \sum_{k_z} \hat{u}_i \mathrm{exp} (ik_j r_j) 
$$

$$
p = \sum_{k_x} \sum_{k_y} \sum_{k_z} \hat{p} \mathrm{exp} (i k_j r_j) 
$$ 

where, $(k_x, k_y, k_z)^T$ denotes the wave vector and caret indicates the discrete Fourier transform. The wavevector in an orthogonal unit cell (considered in the code) is defined as, 

$$
k_x = \frac{2 \pi}{H_x} n_x, \ \ \  k_y = \frac{2 \pi}{H_y} n_y, \ \ \   k_z = \frac{2 \pi}{H_z} n_z 
$$ 

where, $n_{\alpha} \in \\{-N_{\alpha}/2, -N_{\alpha}/2 + 1, ..., 0, 1, 2, ..., N_{\alpha}/2 - 1 \\}$ and $\alpha = x, y, z$. We employ direct numerical simulations (DNS) to solve the governing equations, which in the Fourier space becomes, 

$$ 
\frac{\partial \hat{u}_i}{\partial t} + \nu k^2 \hat{u}_i = \left( \delta_{ij} - \frac{k_i k_j}{k^2} \right) \left(-\hat{\frac{\partial}{\partial r_j} u_i u_j} + \frac{1}{\rho} (\hat{F}_{i}^{\mathrm{fiber}} + \hat{F}_{i}^{\mathrm{turb}}) \right)  
$$

The equation above is integrated numerically in time using a second order Runge-Kutta (RK-2) method. In our pseudo-spectral code, the nonlinear dyadic products $u_i u_j$ are first formed in physical space, and then transformed to the Fourier space. Aliasing errors associated nonlinear terms are removed by a combination of phase shifting (for aliasing in one dimension) and truncation at the wavenumber magnitude $k_{\mathrm{max},\alpha} = (2\pi/H_{\alpha}) \sqrt{2} N_{\alpha}/3$ (which eliminates the doubly and triply aliased Fourier modes). Use of the dyadic form as in $\frac{\partial}{\partial r_j} (u_i u_j)$ versus the advective form $u_j \frac{\partial}{\partial r_j} u_i$ has the advantage of reducing the number of variables that need to be Fourier-transformed, as well as the level of residual aliasing errors that may arise. The force $F_{i}^{\mathrm{fiber}}$ exerted by the fibers on the fluid is obtained as a convolution integral of Dirac delta function with a linear force per unit length $f_i(s)$ along all the fiber axes. 

$$
F_{i}^{\mathrm{fiber}} = \sum_{m = 1}^{N_{\mathrm{fiber}}} \int_{-1}^{1} l \mathrm{d}s f_i^m(s) \delta (r_i - r_{c,i}^m - sp_i l) 
$$ 

where, $s \in [-l,l]$ is the coordinate along the fiber axis, and $l$ is the fiber half-length. The position of the center of mass of the $m$-th fiber is denoted by $r_{c,i}^m$ and its fiber orientation (unit vector along the fiber axis) is denoted by $p_i^m$. The Fourier transform of the fiber forcing is then calculated as, 

$$
\hat{F}_{i}^{\mathrm{fiber}} (k_x, k_y, k_z) = \sum_{m = 1}^{N_{\mathrm{fiber}}} \int_{-1}^{1} l \mathrm{d}s f_i^m(s) \delta (r_i - r_{c,i}^m - sp_i^m l) \mathrm{exp} (-i k_j (r_{c,j}^m + sp_j^m l)) 
$$

The force per unit length along the fiber axis is obtained by solving an integral equation obtained from an inertial slender-body theory (Joshi et. al., JFM, in prep.), 

$$
4\pi (\eta_{\perp}(s)(\delta_{ij}-p_i^m p_j^m)+\eta_{\parallel}(s) p_i^m p_j^m) (U_j^m+s\dot{p}_j^m l-u_j^{NS}) = f_i^m(s) \left(\mathrm{ln}(2\kappa) + \mathrm{ln}\left(\frac{(1-s^2)^{1/2}}{\tilde{a}(s)}\right)\right) + \frac{1}{2}\int_{-1}^{1}\frac{f_i^m(s')-f_i^m(s)}{|s-s'|} \mathrm{d}s' + \frac{1}{2}(\delta_{ik}- 2p_i^m p_k^m)f_k^m(s) 
$$ 

Here, $u_i^{NS}$ denotes the "non-singular" part of the velocity disturbance at the fiber axis, $U_i^m$ and $\dot{p}_i^m$ are the fiber velocity and rotation rate respectively, and $\kappa$ is the fiber aspect ratio. The non-singular part of the velocity disturbance at the fiber axis is obtained by subtracting the Stokes flow disturbance due to the fiber forcing from the total flow in the Fourier space, and supplementing the Stokes flow disturbance only due to image fibers (in other unit cells) to the difference. The Stokes flow disturbance due to image fibers $u_i^{SI}$ is obtained from the analysis of Hasimoto, using an Ewald summation.

$$ 
u_i^{NS} = \mathrm{IFT} \left[\hat{u}_i - \frac{1}{\mu k^2} (\delta_{ij} - \frac{k_i k_j}{k^2} ) \hat{F}_{j}^{\mathrm{fiber}} \right] + u_i^{SI}
$$ 

As discussed above, to sustain turbulence at steady state, the code uses a stochastic forcing scheme proposed by Eswaran and Pope. The forcing term $\hat{F}_{i}^{\mathrm{turb}}$ is non-zero only in the wavenumber band $k \in (0, k_F]$, and is computed using six independent Uhlenbeck-Ornstein (UO) processes at each of the forced wavenumbers. The UO processes denoted by $\hat{b}_i (k_i,t)$ can be written as, 

$$
\hat{b}_i (k_i,t+\Delta t) = \hat{b}_i (k_i,t) \left(1-\frac{\Delta t}{T_F} \right) + \theta_i \left(\frac{2\sigma^2 \Delta t}{T_F} \right)
$$ 

where, $\Delta t$ is the time step, $\theta_i$ is a vector of complex random numbers whose components are drawn from a standard normal distribution, and $\sigma^2$ and $T_F$ are the variance and time scale respectively, of the UO process. Finally, the turbulent forcing $\hat{F}_{\mathrm{turb},i}$ is the projection of $\hat{b}_i(k_i,t)$ onto the plane normal to the wavevector $k_i$, 

$$
\hat{F}_{i}^{\mathrm{turb}} (k_i, t) = \left( \delta_{ij} - \frac{k_i k_j}{k^2} \right) \hat{b}_j (k_i, t) 
$$  

























