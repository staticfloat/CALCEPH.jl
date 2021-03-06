"""
    orient(eph,jd0,time,target,unit)

Compute Euler angles and first derivative for the orientation of target at
epoch jd0+time.
To get the best precision for the interpolation, the time is splitted in two
floating-point numbers. The argument jd0 should be an integer and time should
be a fraction of the day. But you may call this function with time=0 and jd0,
the desired time, if you don't take care about precision.

# Arguments
- `jd0::Float64`: jd0+time must be equal to the Julian Day for the time coordinate corresponding to the ephemeris (usually TDB or TCB)
- `time::Float64`: jd0+time must be equal to the Julian Day for the time coordinate corresponding to the ephemeris (usually TDB or TCB)
- `target::Integer`: The body whose orientation is required. The numbering system depends on the parameter unit.
- `unit::Integer` : The units of the result. This integer is a sum of some unit constants (unit*) and/or the constant useNaifId. If the unit contains useNaifId, the NAIF identification numbering system is used for the target and the center. If the unit does not contain useNaifId, the old number system is used for the target and the center (see the list in the documentation of function compute). The angles are expressed in radians if unit contains unitRad.

"""
function orient(eph::Ephem,jd0::Float64,time::Float64,
   target::Integer,unit::Integer)
    @_checkPointer eph.data "Ephemeris is not properly initialized!"
    result = Array{Float64,1}(6)
    stat = ccall((:calceph_orient_unit, libcalceph), Cint,
    (Ptr{Void},Cdouble,Cdouble,Cint,Cint,Ref{Cdouble}),
    eph.data,jd0,time,target,unit,result)
    @_checkStatus stat "Unable to compute ephemeris"
    return result
end

"""
    orient(eph,jd0,time,target,unit,order)

Compute Euler angles and derivatives up to order for the orientation of target
at epoch jd0+time.
To get the best precision for the interpolation, the time is splitted in two
floating-point numbers. The argument jd0 should be an integer and time should
be a fraction of the day. But you may call this function with time=0 and jd0,
the desired time, if you don't take care about precision.

# Arguments
- `jd0::Float64`: jd0+time must be equal to the Julian Day for the time coordinate corresponding to the ephemeris (usually TDB or TCB)
- `time::Float64`: jd0+time must be equal to the Julian Day for the time coordinate corresponding to the ephemeris (usually TDB or TCB)
- `target::Integer`: The body whose orientation is required. The numbering system depends on the parameter unit.
- `unit::Integer` : The units of the result. This integer is a sum of some unit constants (unit*) and/or the constant useNaifId. If the unit contains useNaifId, the NAIF identification numbering system is used for the target and the center. If the unit does not contain useNaifId, the old number system is used for the target and the center (see the list in the documentation of function compute).
- `order::Integer` : The order of derivatives
    * 0: only the angles are computed.
    * 1: only the angles and 1st derivatives are computed.
    * 2: only the angles, the 1st derivatives and 2nd derivatives are computed.
    * 3: the angles, the 1st derivatives, 2nd derivatives and 3rd derivatives are computed.

"""
function orient(eph::Ephem,jd0::Float64,time::Float64,
   target::Integer,unit::Integer,order::Integer)
    @_checkPointer eph.data "Ephemeris is not properly initialized!"
    @_checkOrder order
    result = Array{Float64,1}(3+3order)
    stat = ccall((:calceph_orient_order, libcalceph), Cint,
    (Ptr{Void},Cdouble,Cdouble,Cint,Cint,Cint,Ref{Cdouble}),
    eph.data,jd0,time,target,unit,order,result)
    @_checkStatus stat "Unable to compute ephemeris"
    return result
end
