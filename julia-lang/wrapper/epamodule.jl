mutable struct epaobject
end

using Libdl
_lib = Libdl.dlopen("/home/augusto/Documents/EPANET/build/lib/libepanet2.so")
macro dlsym(func, lib)
    z = Ref{Ptr{Cvoid}}(C_NULL)
    quote
        let zlocal = $z[]
            if zlocal == C_NULL
                zlocal = dlsym($(esc(lib))::Ptr{Cvoid}, $(esc(func)))::Ptr{Cvoid}
                $z[] = $zlocal
            end
            zlocal
        end
    end
end

function open(inppath::String, rptpath::String = "", outputpath::String = "")
    output_ptr = ccall(
        @dlsym("ENopen", _lib),
        Ptr{epaobject},
        (Ptr{UInt8},Ptr{UInt8}, Ptr{UInt8}),
        inppath,
        rptpath,
        outputpath
    )
    if output_ptr == C_NULL 
        throw(OutOfMemoryError())
    end
    return output_ptr
end

println(open("/home/augusto/Documents/IC-2020/epanet_arquivos/c-town/C-Town.inp"))