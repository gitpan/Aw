#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif



MODULE = CORBA::ORBit            PACKAGE = CORBA::LongLong

CORBA::LongLong
new (Class, str)
    char *str
    CODE:
    RETVAL = longlong_from_string (str);
    OUTPUT:
    RETVAL

SV *
stringify (self, other=0, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CODE:
    {
	char *result = longlong_to_string (self);
        RETVAL = newSVpv (result, 0);
	Safefree (result);
    }
    OUTPUT:
    RETVAL

CORBA::LongLong
add (self, other, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CORBA::LongLong other
    CODE:
    RETVAL = self+other;
    OUTPUT:
    RETVAL

CORBA::LongLong
subtract (self, other, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CORBA::LongLong other
    SV *reverse
    CODE:
    if (SvTRUE (reverse))
        RETVAL = other - self;
    else
        RETVAL = self - other;
    OUTPUT:
    RETVAL

CORBA::LongLong
div (self, other, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CORBA::LongLong other
    SV *reverse
    CODE:
    if (SvTRUE (reverse))
        RETVAL = other / self;
    else
        RETVAL = self / other;
    OUTPUT:
    RETVAL

CORBA::LongLong
mul (self, other, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CORBA::LongLong other
    CODE:
    RETVAL = self*other;
    OUTPUT:
    RETVAL

CORBA::LongLong
mod (self, other, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CORBA::LongLong other
    SV *reverse
    CODE:
    if (SvTRUE (reverse))
        RETVAL = other % self;
    else
        RETVAL = self % other;
    OUTPUT:
    RETVAL

CORBA::LongLong
neg (self, other=0, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CODE:
    RETVAL = -self;
    OUTPUT:
    RETVAL

CORBA::LongLong
abs (self, other=0, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CODE:
    RETVAL = (self > 0) ? self : -self;
    OUTPUT:
    RETVAL

int
cmp (self, other, reverse=&PL_sv_undef)
    CORBA::LongLong self
    CORBA::LongLong other
    SV *reverse
    CODE:
    if (SvTRUE (reverse))
      RETVAL = (self == other) ? 0 : ((self > other) ? 1 : -1);
    else
      RETVAL = (other == self) ? 0 : ((other > self) ? 1 : -1);
    OUTPUT:
    RETVAL
