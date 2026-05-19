# ================================
# Compiler
# ================================
FC = mpifort

# ================================
# Flags
# ================================
FFLAGS = -O3 -fallow-argument-mismatch -Wno-argument-mismatch

# ================================
# Libraries (WSL / Ubuntu)
# ================================
LIBS = -lscalapack-openmpi -llapack -lblas

# ================================
# Object files (order matters!)
# ================================
OBJECTS = \
    modules.o \
    initial_setup.o \
    SBT.o \
    FT_routines.o \
    linear_solver.o \
    output.o \
    NS_eqn_terms.o \
    interpolation.o \
    main_checkpt.o

# ================================
# Target executable
# ================================
TARGET = fiber_in_HIT_prog

# ================================
# Default rule
# ================================
all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(FC) $(FFLAGS) -o $(TARGET) $(OBJECTS) $(LIBS)

# ================================
# Compilation rules
# ================================
modules.o: modules.f90
	$(FC) $(FFLAGS) -c modules.f90

initial_setup.o: modules.o initial_setup.f90
	$(FC) $(FFLAGS) -c initial_setup.f90

SBT.o: modules.o SBT.f90
	$(FC) $(FFLAGS) -c SBT.f90

FT_routines.o: modules.o FT_routines.f90
	$(FC) $(FFLAGS) -c FT_routines.f90

linear_solver.o: modules.o linear_solver.f90
	$(FC) $(FFLAGS) -c linear_solver.f90

output.o: modules.o output.f90
	$(FC) $(FFLAGS) -c output.f90

NS_eqn_terms.o: modules.o NS_eqn_terms.f90
	$(FC) $(FFLAGS) -c NS_eqn_terms.f90

interpolation.o: modules.o interpolation.f90
	$(FC) $(FFLAGS) -c interpolation.f90

main_checkpt.o: modules.o main_checkpt.f90
	$(FC) $(FFLAGS) -c main_checkpt.f90

# ================================
# Clean
# ================================
clean:
	rm -f *.o *.mod $(TARGET)
