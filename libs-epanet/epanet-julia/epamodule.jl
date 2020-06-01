using Libdl
# sym = Libdl.dlsym(lib, :my_fcn)   # Get a symbol for the function to call.
# ccall(sym, ...) # Use the pointer `sym` instead of the (symbol, library) tuple (remaining arguments are thesame).  
# Libdl.dlclose(lib) # Close the library explicitly.
#=
Lista de funções a serem chamadas
ENopenH()

=#
path_epanet = "../EPANET/build/lib/libepanet2.so"
lib = Libdl.dlopen(path_epanet) # Open the library explicitly.


#ENopenH()
function openH()
    sym = Libdl.dlsym(lib, :EN_openH)
end

using CBinding

lib2 = Clibrary(path_epanet)