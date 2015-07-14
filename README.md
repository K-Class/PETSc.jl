# PETSc
This package provides thin wrappers for PETSc, as well as a few convience functions that take advantage of multiple dispatch.

This package requires the MPI.jl package be installed.  Once it is installed you should be able to run both Julia and Petsc in parallel using MPI for all communcation.  Initial some initial experiments indicate this works, although it is not thoroughly tested yet.

To use the package, simple put `using PETSc` at the top of your Julia source file.  The module exports the names of all the functions, as well as the Petsc datatype aliases and constants such as PETSC_DECIDE.

In general, it is possible to run PETSC in parallel. To do so with 4 processors, do:

mpirun -np 4 julia ./name_of_file

To run in serial, do:

julia ./name_of_file

The only currently working example is  test/exKSP3.jl, which solves a simple system with a Krylov Subspace method and compares the result with a direct solve using Julia's backslash operator.  This is a serial example only.



# To do:
  * Use Petsc typealiases for all arguments
  * Generate file at installation that defines the correct typealiases, taking into account the options Petsc was built with (the Petsc function PetscDataTypeGetSize()  should help)
  * Handle Petsc error codes properly
  * Make the script for building Petsc more flexible, eg. allowing more configuration options like building blas or lapack, while ensure it remains completely autonomous (needed for Travis testig)
  * Wrap more PetscVec functions
  * Wrap more PetscMat functions
  * Wrap more KSP function
  * Determine priorities for wrapping additional functions
  * Add backup finalizer/destructor in case the variable holding the pointer to a Petsc object gets reassigned before the Petsc object is destroyed
  * Provide methods that copy indices to proper size integer
  * Create warning system (@inefficient macro?) for use of copying methods
  * Decide about zero or one based indexing


# For Contributors:
  Wrappers generated by Clang.jl are in the src/auto directory.  Although not quite usable, with the functions can be made useable with a few simple modifications:
  * Pass comm.val instead of comm itself for MPI communicators, and change the type of an integer (32 bits?)
  * Pass obj.pobj instead of obj for Petsc objects as Ptr{Void}
  * For each Petsc object, you must create a type that holds a void pointer called pobj and use that in place of the (incorrect) type generated by Clang.jl
  * For every function you add, create a test

# Directory Structure
  /src : source files.  PETSc.jl is the main file containing initialization, with the functions for each type of Petsc object in its own file.  All constants are declared in petsc_constants.jl

  /src/auto: auto generated wrappers from Clang.jl.  Not directly useful, but easy to modify to make useful

  /test : contains runtest.jl, which does some setup and runs all tests.  Test for each type of Petsc object (mirroring the files in /src) are contained in separate files.

  /deps : builds Petsc if needed.  See description below


# Building Petsc (or not)
Upon installation of the package, the build script (`build.jl`) checks for the environmental variables `PETSC_DIR` and `PETSC_ARCH`.  If both are present, it does nothing, otherwise is downloads and builds Petsc using the script `install_petsc.sh`.  Note that the script assumes BLAS, LAPACK and MPI are already installed.  See `.travis.yml` to see the Ubuntu packages used for testing.  When complete, it generates two files, `use_petsc.sh` and `petsc_evars`, which contains the values of `PETSC_DIR` and `PETSC_ARCH` for the Petsc installation.

  At runtime, the module checks for the presents of the environmental variables and uses them if found, otherwise it uses the values in `petsc_evars`.  This enables you to use different Petsc installations if you choose.  Note that (currently), Petsc must be built with 32 bit integers and PetscScalar as a 64 bit float.  Auto-detecting the Petsc data types is high on the priority list, so hopefully this limitation will be removed shortly.


# Installing MPI.jl
This package requires MPI.jl, although it is not listed in the REQUIRE file because that would download the release version of MPI.jl, which does not work.  Instead, you must use the master branch.  After you have an MPI implimentation installed, execute the following Julia commands:
```
  Pkg.clone("MPI")
  Pkg.build("MPI")
```

[![Build Status](https://travis-ci.org/JaredCrean2/PETSc.jl.svg?branch=master)](https://travis-ci.org/JaredCrean2/PETSc.jl)
