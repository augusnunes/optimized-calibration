#=
Julia EpanetToolkit
=#
module epamodule
using Libdl

lib_path = "/home/augusto/Documents/IC-2020/optimized-calibration/libs-epanet/EPANET/build/lib/libepanet2.so" # absolute path to lib epanet binary file
lib = Libdl.dlopen(lib_path) 

#=
*Lista de funções a serem implementadas
- ENgeterror()

=#

# ENgeterror()
#=
function ENtoolkitError(erro)
    sym = Libdl.dlsym(lib,:ENgeterror)
    errmsg = ""
    maxLen = 500
    ccall(sym, Cint,(Cint,Cstring,Cint), erro,errmsg,maxLen)
    return errmsg
end
=#


function ENopen(inpFile::String, rptFile::String = "", outFile::String = "")
    sym = Libdl.dlsym(lib, :ENopen)
    err = ccall(sym, Cint, (Cstring,Cstring,Cstring), inpFile, rptFile, outFile)
    if err != 0
        return "Error: "*string(err)
    end
end

function ENopenH()
    sym = Libdl.dlsym(lib, :ENopenH)
    err = ccall(sym,Cint,())
    if err != 0
        return "Error: "*string(err)
    end
end

function ENclose()
    sym = Libdl.dlsym(lib, :ENclose)
    err = ccall(sym,Cint,())
    if err != 0
        return "Error: "*string(err)
    end
end

function ENcloseH()
    sym = Libdl.dlsym(lib, :ENcloseH)
    err = ccall(sym,Cint,())
    if err != 0
        return "Error: "*string(err)
    end
end

function ENsolveH()
    sym = Libdl.dlsym(lib, :ENsolveH)
    err = ccall(sym,Cint,())
    if err != 0
        return "Error: "*string(err)
    end
end

function ENgetnodeindex(id::String)
    sym = Libdl.dlsym(lib, :ENgetnodeindex)
    index = Ref{Int64}(0)
    err = ccall(sym, Cint, (Cstring, Ref{Int64}), id, index)
    if err != 0
        return "Error: "*string(err)
    end
    return index.x
end

function ENgetnodevalue(index::Int64, paramcode::Int64)
    sym = Libdl.dlsym(lib,:ENgetnodevalue)
    ref = Ref{Float32}(0)
    err = ccall(sym, Cint,(Cint,Cint,Ref{Float32}), index, paramcode, ref)
    if err != 0
        return "Error: "*string(err)
    end
    return ref.x
end


function ENsetnodevalue(index::Int64, paramcode::Int64, value::Float64)
    sym = Libdl.dlsym(lib,:ENsetnodevalue)
    err = ccall(sym, Cint, (Cint, Cint, Cfloat), index, paramcode, value)
    if err != 0
        return "Error: "*string(err)
    end
end

function ENgetlinkindex(id::String)
    sym = Libdl.dlsym(lib, :ENgetlinkindex)
    index = Ref{Int64}(0)
    err = ccall(sym, Cint, (Cstring, Ref{Int64}), id, index)
    if err != 0
        return "Error: "*string(err)
    end
    return index.x
end

function ENgetlinkvalue(index::Int64, paramcode::Int64)
    sym = Libdl.dlsym(lib,:ENgetlinkvalue)
    ref = Ref{Float32}(0)
    err = ccall(sym, Cint,(Cint,Cint,Ref{Float32}), index, paramcode, ref)
    if err != 0
        return "Error: "*string(err)
    end
    return ref.x
end

function ENgetlinknodes(index::Int64)
    sym = Libdl.dlsym(lib, :ENgetlinknodes)
    ref1 = Ref{Int64}(0)
    ref2 = Ref{Int64}(0)
    err = ccall(sym, Cint, (Cint, Ref{Int64},Ref{Int64}), index, ref1, ref2)
    if err != 0
        return "Error: "*string(err)
    end
    return [ref1.x, ref2.x]
end

function ENsetlinkvalue(index::Int64, paramcode::Int64, value::Float64)
    sym = Libdl.dlsym(lib,:ENsetlinkvalue)
    err = ccall(sym, Cint, (Cint, Cint, Cfloat), index, paramcode, value)
    if err != 0
        return "Error: "*string(err)
    end
end


#-------------------------------------------------------------#
#= Node paramcodes =#
EN_ELEVATION     = 0      
EN_BASEDEMAND    = 1
EN_PATTERN       = 2
EN_EMITTER       = 3
EN_INITQUAL      = 4
EN_SOURCEQUAL    = 5
EN_SOURCEPAT     = 6
EN_SOURCETYPE    = 7
EN_TANKLEVEL     = 8
EN_DEMAND        = 9
EN_HEAD          = 10
EN_PRESSURE      = 11
EN_QUALITY       = 12
EN_SOURCEMASS    = 13
EN_INITVOLUME    = 14
EN_MIXMODEL      = 15
EN_MIXZONEVOL    = 16

EN_TANKDIAM      = 17
EN_MINVOLUME     = 18
EN_VOLCURVE      = 19
EN_MINLEVEL      = 20
EN_MAXLEVEL      = 21
EN_MIXFRACTION   = 22
EN_TANK_KBULK    = 23

#= Link paramcodes =#
EN_DIAMETER      = 0      
EN_LENGTH        = 1
EN_ROUGHNESS     = 2
EN_MINORLOSS     = 3
EN_INITSTATUS    = 4
EN_INITSETTING   = 5
EN_KBULK         = 6
EN_KWALL         = 7
EN_FLOW          = 8
EN_VELOCITY      = 9
EN_HEADLOSS      = 10
EN_STATUS        = 11
EN_SETTING       = 12
EN_ENERGY        = 13

#= Time paramcodes =#
EN_DURATION      = 0      # /* Time parameters */
EN_HYDSTEP       = 1
EN_QUALSTEP      = 2
EN_PATTERNSTEP   = 3
EN_PATTERNSTART  = 4
EN_REPORTSTEP    = 5
EN_REPORTSTART   = 6
EN_RULESTEP      = 7
EN_STATISTIC     = 8
EN_PERIODS       = 9

#= Component counts =#
EN_NODECOUNT     = 0      
EN_TANKCOUNT     = 1
EN_LINKCOUNT     = 2
EN_PATCOUNT      = 3
EN_CURVECOUNT    = 4
EN_CONTROLCOUNT  = 5

#= Node types =#
EN_JUNCTION      = 0      
EN_RESERVOIR     = 1
EN_TANK          = 2

#= Link types =#
EN_CVPIPE        = 0      
EN_PIPE          = 1
EN_PUMP          = 2
EN_PRV           = 3
EN_PSV           = 4
EN_PBV           = 5
EN_FCV           = 6
EN_TCV           = 7
EN_GPV           = 8

#= Quality analysis types =#
EN_NONE          = 0      
EN_CHEM          = 1
EN_AGE           = 2
EN_TRACE         = 3

#= Source quality types =#
EN_CONCEN        = 0      
EN_MASS          = 1
EN_SETPOINT      = 2
EN_FLOWPACED     = 3

# Flow units types
EN_CFS           = 0      
EN_GPM           = 1
EN_MGD           = 2
EN_IMGD          = 3
EN_AFD           = 4
EN_LPS           = 5
EN_LPM           = 6
EN_MLD           = 7
EN_CMH           = 8
EN_CMD           = 9

#= Misc. options =#
EN_TRIALS        = 0      
EN_ACCURACY      = 1
EN_TOLERANCE     = 2
EN_EMITEXPON     = 3
EN_DEMANDMULT    = 4

#= Control types =#
EN_LOWLEVEL      = 0      
EN_HILEVEL       = 1
EN_TIMER         = 2
EN_TIMEOFDAY     = 3

#= Time statistic types =#
EN_AVERAGE       = 1      
EN_MINIMUM       = 2
EN_MAXIMUM       = 3
EN_RANGE         = 4

#= Tank mixing models =#
EN_MIX1          = 0      
EN_MIX2          = 1
EN_FIFO          = 2
EN_LIFO          = 3


EN_NOSAVE        = 0      # /* Save-results-to-file flag */
EN_SAVE          = 1
EN_INITFLOW      = 10     # /* Re-initialize flow flag   */

end # Ends module