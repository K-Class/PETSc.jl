module PETSc
    """
    PETSc wrapper for Julia.
    Provides functionalities to use PETSc libraries in Julia code.
    """

using MPI, LinearAlgebra, SparseArrays

if !MPI.Initialized()
    MPI.Init()
end

using Libdl

function _petsc_link(fname)
    return """
    [`$fname`](https://petsc.org/release/docs/manualpages/$fname.html)
    """
end


function _doc_external(fname)
    return """
    - PETSc Manual: $(_petsc_link(fname))
    """
end

include("const.jl")
include("startup.jl")
include("lib.jl")
include("init.jl")
include("ref.jl")
include("viewer.jl")
include("options.jl")
include("vec.jl")
include("mat.jl")
include("matshell.jl")
include("dm.jl")
include("dmda.jl")
include("dmstag.jl")
include("ksp.jl")
include("pc.jl")
include("snes.jl")
include("sys.jl")

end
