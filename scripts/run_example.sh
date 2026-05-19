
#!/bin/bash

# ============================================
# Example run script
# ============================================

# Number of MPI processes
NPROC=64

# Executable
EXEC=./fiber_in_HIT_prog

echo "======================================"
echo " Running FiberDNS-SBT"
echo " MPI processes: $NPROC"
echo "======================================"

mpirun -np $NPROC $EXEC

echo "======================================"
echo " Simulation completed"
echo "======================================"
