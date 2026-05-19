# Inertial_fibers_in_HIT: MPI-based pseudo-spectral DNS coupled with inertial slender-body theory

An open-source MPI-parallel Fortran (.f90) framework for simulating the motion of slender fibers in homogeneous isotropic turbulence using a pseudo-spectral DNS solver coupled iteratively with an inertial slender-body theory (SBT). 

## Overview

This code solves the coupled particle-fluid problem for slender fibers in isotropic turbulence by combining:

- a distributed-memory pseudo-spectral DNS solver for the carrier flow,
- inertial slender-body theory to resolve fiber-scale hydrodynamic forcing,
- an iterative coupling procedure in which
  1. the fiber force exerted on the fluid is supplied to the DNS solver,
  2. the DNS solver computes the velocity disturbance,
  3. the disturbance feeds the SBT integral equation,
  4. the inertial SBT update returns the fiber force on the fluid.

The framework alows for an iterative multiscale coupling between pseudo-spectral DNS and inertial slender-body theory, allowing fiber-scale hydrodynamic forcing to be incorporated without directly resolving the fiber thickness on the DNS grid

## Features

- MPI-parallel Fortran implementation
- 3D pseudo-spectral DNS for isotropic turbulence
- iterative coupling of DNS and inertial SBT
- scalable distributed-memory architecture
- modular code structure for DNS, SBT, coupling, and post-processing
- suitable for studies of fiber orientation, settling, rotation, and particle-flow statistics

## Scientific scope

This code is intended for research on:

- Slender particle dynamics at finite Reynolds numbers using a fully inertial slender-body theory 
- Effects of particle-flow coupling on dynamics of suspensions in turbulent flow 
- orientation, rotation-rate, and settling statistics of slender particles with or without turbulent flow

## Repository structure

- `input/` - sample input file
- `scripts/` - build and run scripts
- `docs/` - documentation on theory and numerics 
- `examples/` - example simulation cases 

## Build requirements

Typical requirements include:

- Fortran compiler with MPI support
- MPI library
- BLAS/LAPACK and ScaLAPACK 
- Make or CMake
- Python or MATLAB (optional but recommended, for post-processing) 

## Build

Compile the code using:

```bash
make
```

This generates the executable:

```bash
fiber_in_HIT_prog
```

## Run

Example:

```bash
./scripts/run_example.sh
```

## Source Code Availability

The source code associated with this project is currently maintained in a private repository while related research is ongoing. Access may be granted upon request for academic or research purposes.
