/* This is part of the Aw:: Perl module.  A Perl interface to the ActiveWorks(tm) 
   libraries.  Copyright (C) 1999-2000 Daniel Yacob.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif


#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include <awadapter.h>
#include <aweb.h>
#include <adapter_log.h>

#if ( AW_VERSION_31 || AW_VERSION_40 )
#  include <adapter_sessions.h>
#endif /* ( AW_VERSION_31 || AW_VERSION_40 ) */

#include <awfilter.h>

/* Theses are required only for the constant routine */

#include "messages.h"
#include <awlicense.h>

/* includes for Admin.xs */

#include <admin/awadmin.h>
#include <admin/awaccess.h>
#include <admin/awetadm.h>
#include <admin/awlog.h>
#include <admin/awserver.h>


/* includes for Aw.xs */

#include <awxs.h>
#include <awxs.m>
#include <awxs.def>

#include <admin/adminxs.h>
#include <admin/adminxs.m>
#include <admin/adminxs.def>


#include "Av_CharPtrPtr.h"
#include "exttypes.h"
#include "Util.h"


BrokerError gErr;
char * gErrMsg;
int gErrCode;

/*
 *
 */
awaBool gWarn;

SV * getBrokerClientSessions (  BrokerClientSession * sessions, int num_sessions );
void BrokerServerConnectionCallbackFunc ( BrokerServerClient cbClient, int connect_status, void * vcb );



static int
not_here(char *s)
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(char *name, int arg)
{
    errno = 0;
    switch (*name) {
    case 'A':
	if (strEQ(name, "AW_AUTH_TYPE_NONE"))
#ifdef AW_AUTH_TYPE_NONE
	    return AW_AUTH_TYPE_NONE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_AUTH_TYPE_SSL"))
#ifdef AW_AUTH_TYPE_SSL
	    return AW_AUTH_TYPE_SSL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_LIFECYCLE_DESTROY_ON_DISCONNECT"))
#ifdef AW_LIFECYCLE_DESTROY_ON_DISCONNECT
	    return AW_LIFECYCLE_DESTROY_ON_DISCONNECT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_LIFECYCLE_EXPLICIT_DESTROY"))
#ifdef AW_LIFECYCLE_EXPLICIT_DESTROY
	    return AW_LIFECYCLE_EXPLICIT_DESTROY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_LOG_ALL_ENTRIES"))
#ifdef AW_SERVER_LOG_ALL_ENTRIES
	    return AW_SERVER_LOG_ALL_ENTRIES;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_LOG_MESSAGE_ALERT"))
#ifdef AW_SERVER_LOG_MESSAGE_ALERT
	    return AW_SERVER_LOG_MESSAGE_ALERT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_LOG_MESSAGE_INFO"))
#ifdef AW_SERVER_LOG_MESSAGE_INFO
	    return AW_SERVER_LOG_MESSAGE_INFO;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_LOG_MESSAGE_UNKNOWN"))
#ifdef AW_SERVER_LOG_MESSAGE_UNKNOWN
	    return AW_SERVER_LOG_MESSAGE_UNKNOWN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_LOG_MESSAGE_WARNING"))
#ifdef AW_SERVER_LOG_MESSAGE_WARNING
	    return AW_SERVER_LOG_MESSAGE_WARNING;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_STATUS_ERROR"))
#ifdef AW_SERVER_STATUS_ERROR
	    return AW_SERVER_STATUS_ERROR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_STATUS_RUNNING"))
#ifdef AW_SERVER_STATUS_RUNNING
	    return AW_SERVER_STATUS_RUNNING;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_STATUS_STARTING"))
#ifdef AW_SERVER_STATUS_STARTING
	    return AW_SERVER_STATUS_STARTING;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_STATUS_STOPPED"))
#ifdef AW_SERVER_STATUS_STOPPED
	    return AW_SERVER_STATUS_STOPPED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SERVER_STATUS_STOPPING"))
#ifdef AW_SERVER_STATUS_STOPPING
	    return AW_SERVER_STATUS_STOPPING;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SSL_STATUS_DISABLED"))
#ifdef AW_SSL_STATUS_DISABLED
	    return AW_SSL_STATUS_DISABLED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SSL_STATUS_ENABLED"))
#ifdef AW_SSL_STATUS_ENABLED
	    return AW_SSL_STATUS_ENABLED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SSL_STATUS_ERROR"))
#ifdef AW_SSL_STATUS_ERROR
	    return AW_SSL_STATUS_ERROR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_SSL_STATUS_NOT_SUPPORTED"))
#ifdef AW_SSL_STATUS_NOT_SUPPORTED
	    return AW_SSL_STATUS_NOT_SUPPORTED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_BROKER_ADDED"))
#ifdef AW_TRACE_BROKER_ADDED
	    return AW_TRACE_BROKER_ADDED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_BROKER_REMOVED"))
#ifdef AW_TRACE_BROKER_REMOVED
	    return AW_TRACE_BROKER_REMOVED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_CLIENT_CONNECT"))
#ifdef AW_TRACE_CLIENT_CONNECT
	    return AW_TRACE_CLIENT_CONNECT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_CLIENT_CREATE"))
#ifdef AW_TRACE_CLIENT_CREATE
	    return AW_TRACE_CLIENT_CREATE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_CLIENT_DESTROY"))
#ifdef AW_TRACE_CLIENT_DESTROY
	    return AW_TRACE_CLIENT_DESTROY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_CLIENT_DISCONNECT"))
#ifdef AW_TRACE_CLIENT_DISCONNECT
	    return AW_TRACE_CLIENT_DISCONNECT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_EVENT_DROP"))
#ifdef AW_TRACE_EVENT_DROP
	    return AW_TRACE_EVENT_DROP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_EVENT_ENQUEUE"))
#ifdef AW_TRACE_EVENT_ENQUEUE
	    return AW_TRACE_EVENT_ENQUEUE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_EVENT_PUBLISH"))
#ifdef AW_TRACE_EVENT_PUBLISH
	    return AW_TRACE_EVENT_PUBLISH;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_EVENT_RECEIVE"))
#ifdef AW_TRACE_EVENT_RECEIVE
	    return AW_TRACE_EVENT_RECEIVE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "AW_TRACE_OTHER"))
#ifdef AW_TRACE_OTHER
	    return AW_TRACE_OTHER;
#else
	    goto not_there;
#endif
	break;
    case 'B':
	break;
    case 'C':
	break;
    case 'D':
	break;
    case 'E':
	break;
    case 'F':
	break;
    case 'G':
	break;
    case 'H':
	break;
    case 'I':
	break;
    case 'J':
	break;
    case 'K':
	break;
    case 'L':
	break;
    case 'M':
	break;
    case 'N':
	break;
    case 'O':
	break;
    case 'P':
	break;
    case 'Q':
	break;
    case 'R':
	break;
    case 'S':
	break;
    case 'T':
	break;
    case 'U':
	break;
    case 'V':
	break;
    case 'W':
	break;
    case 'X':
	break;
    case 'Y':
	break;
    case 'Z':
	break;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}



SV *
getBrokerClientSessions (  BrokerClientSession * sessions, int num_sessions )
{
AV * av;
HV * hv;
SV * sv;
int i;

	av = newAV();

	for ( i = 0; i < num_sessions ; i++ ) {
		hv = newHV();

		hv_store ( hv, "session_id",        10, newSViv ( (int)sessions[i].session_id ), 0 );
		hv_store ( hv, "connection_id",     13, newSViv ( (int)sessions[i].connection_id ), 0 );
		hv_store ( hv, "ip_address",        10, newSViv ( (int)sessions[i].ip_address ), 0 );
		hv_store ( hv, "port",               4, newSViv ( (int)sessions[i].port ), 0 );
		hv_store ( hv, "encrypt_level",     13, newSViv ( (int)sessions[i].encrypt_level ), 0 );
		hv_store ( hv, "num_platform_info", 17, newSViv ( (int)sessions[i].num_platform_info ), 0 );


		if ( sessions[i].encrypt_protocol != NULL )
			hv_store ( hv, "encrypt_protocol", 16, newSVpv ( (char *)sessions[i].encrypt_protocol, 0 ), 0 );
		if ( sessions[i].encrypt_version != NULL )
			hv_store ( hv, "encrypt_version",  15, newSVpv ( (char *)sessions[i].encrypt_version, 0 ), 0 );
		if ( sessions[i].auth_protocol != NULL )
			hv_store ( hv, "auth_protocol",    13, newSVpv ( (char *)sessions[i].auth_protocol, 0 ), 0 );
		if ( sessions[i].auth_version != NULL )
			hv_store ( hv, "auth_version",     12, newSVpv ( (char *)sessions[i].auth_version, 0 ), 0 );


		if ( &sessions[i].ssl_certificate != NULL ) {
			sv = sv_newmortal();
			SvREFCNT_inc(sv);
			sv_setref_pv( sv, "Aw::SSLCertificate", (void*)&sessions[i].ssl_certificate );
			hv_store ( hv, "ssl_certificate", 15, sv, 0 );
		}

		sv = sv_newmortal();
		SvREFCNT_inc(sv);
		sv_setref_pv( sv, "Aw::Date", (void*)&sessions[i].connect_time );
		hv_store ( hv, "connect_time", 12, sv, 0 );

		sv = sv_newmortal();
		SvREFCNT_inc(sv);
		sv_setref_pv( sv, "Aw::Date", (void*)&sessions[i].create_time );
		hv_store ( hv, "create_time", 11, sv, 0 );

		sv = sv_newmortal();
		SvREFCNT_inc(sv);
		sv_setref_pv( sv, "Aw::Date", (void*)&sessions[i].last_activity_time );
		hv_store ( hv, "last_activity_time", 18, sv, 0 );

		if ( sessions[i].num_platform_info ) {
			int j;
			HV * hi;
			hi = newHV();

			for ( j = 0; j < sessions[i].num_platform_info; j++ ) {
				hv_store ( hi, 
				   sessions[i].platform_info_keys[j],
				   strlen(sessions[i].platform_info_keys[j]),
				   newSVpv ( (char *)sessions[i].platform_info_values[j], 0 ),
				   0 );
			}
			hv_store ( hv, "platform_info", 13, newRV_noinc((SV*)hi), 0 );
		}

		av_push( av, newRV_noinc((SV*) hv) );
	}

	return ( newRV((SV*)av) );
}



void
BrokerServerConnectionCallbackFunc ( BrokerServerClient cbClient, int connect_status, void * vcb )
{
dSP;
SV *esv, *csv;
xsCallBackStruct * cb;
xsServerClient * client;


	cb = (xsCallBackStruct *)vcb;

	ENTER;
	SAVETMPS;

	PUSHMARK(sp);
	XPUSHs( cb->self );
	XPUSHs(sv_2mortal(newSViv(connect_status)));
	XPUSHs( cb->data );
	PUTBACK;

	/* Not checking method with "can", assume for now if method was registered that it exists */
	perl_call_method( cb->method, G_SCALAR );

	SPAGAIN;
	PUTBACK;

	FREETMPS;
	LEAVE;

}



/*
#=============================================================================*/

MODULE = Aw::Admin		PACKAGE = Aw::Admin

#===============================================================================

PROTOTYPES: DISABLE


BOOT:

	if ( (int)SvIV(perl_get_sv("Aw::Admin::SPAM", FALSE)) )
		printf ( "\nAw %s [%s] (c) RCN <yacob@rcn.com>\n\n" ,
			 (char *)SvPV(perl_get_sv("Aw::Admin::VERSION", FALSE), PL_na),
			 (char *)SvPV(perl_get_sv("Aw::Admin::VERSION_NAME", FALSE), PL_na)  );



double
constant(name,arg)
	char *		name
	int		arg



#===============================================================================

MODULE = Aw::Admin		PACKAGE = Aw::Admin::AccessControlList

#===============================================================================

Aw::Admin::AccessControlList
new ( CLASS )
	char * CLASS

	CODE:

		RETVAL = (xsAccessControlList *)safemalloc ( sizeof(xsAccessControlList) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		              /* this casting was required but seems suspicious */
		RETVAL->acl = (BrokerAccessControlList) awNewBrokerAccessControlList ( );

	OUTPUT:
	RETVAL


void
delete ( self )
	Aw::Admin::AccessControlList self

	CODE:
		awDeleteAccessControlList ( self->acl );


Aw::Admin::AccessControlList
copy ( self )
	Aw::Admin::AccessControlList self

	PREINIT:
		char CLASS[] = "Aw::Admin::AccessControlList";

	CODE:
		RETVAL = (xsAccessControlList *)safemalloc ( sizeof(xsAccessControlList) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		              /* this casting was required but seems suspicious */
		RETVAL->acl = (BrokerAccessControlList) awCopyBrokerAccessControlList ( self->acl );

	OUTPUT:
	RETVAL



char **
getAuthNamesRef ( self )
	Aw::Admin::AccessControlList self

	ALIAS:
		Aw::Admin::AccessControlList::getUserNamesRef = 1

	PREINIT:
		int n;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err 
		= (ix)
		  ? awGetACLUserNames  ( self->acl, &n, &RETVAL )
		  : awGetACLAuthNames  ( self->acl, &n, &RETVAL )
		;

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL


awaBool
getAuthNameState ( self, name )
	Aw::Admin::AccessControlList self
	char * name

	ALIAS:
		Aw::Admin::AccessControlList::getUserNameState = 1

	PREINIT:
		BrokerBoolean bRV;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err 
		= (ix)
		  ? awGetACLUserNameState ( self->acl, name, &bRV )
		  : awGetACLAuthNameState ( self->acl, name, &bRV )
		;


		AWXS_CHECKSETERROR_RETURN

		RETVAL = (awaBool)bRV;

	OUTPUT:
	RETVAL


awaBool
setAuthNames ( self, names )
	Aw::Admin::AccessControlList self
	char ** names

	ALIAS:
		Aw::Admin::AccessControlList::setUserNameState = 1

	PREINIT:
		int n;

	CODE:

		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(1) ) ) + 1;

		gErr = self->err 
		= (ix)
		  ? awSetACLAuthNames ( self->acl, n, names )
		  : awSetACLUserNames ( self->acl, n, names )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;
	
	OUTPUT:
	RETVAL



awaBool
setAuthNameStates ( self, names, is_allowed )
	Aw::Admin::AccessControlList self
	char ** names
	awaBool is_allowed

	PREINIT:
		int n;

	ALIAS:
		Aw::Admin::AccessControlList::setUserNameStates = 1

	CODE:

		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(1) ) ) + 1;

		gErr = self->err 
		= (ix)
		  ? awSetACLUserNameStates  ( self->acl, n, names, (BrokerBoolean) is_allowed )
		  : awSetACLAuthNameStates  ( self->acl, n, names, (BrokerBoolean) is_allowed )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;
	
	OUTPUT:
	RETVAL




#===============================================================================

MODULE = Aw::Admin		PACKAGE = Aw::Admin::TypeDef

#===============================================================================

Aw::Admin::TypeDef
new ( CLASS, type_name, type )
	char * CLASS
	char * type_name
	short type

	CODE:

		RETVAL = (xsBrokerAdminTypeDef *)safemalloc ( sizeof(xsBrokerAdminTypeDef) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		if ( items == 3 )
			gErr = RETVAL->err = awNewBrokerAdminTypeDef ( (char *)SvPV(ST(1),PL_na), (short)SvIV(ST(2)), &RETVAL->type_def );
		else if ( sv_isobject ( ST(1) ) ) {
			if ( sv_derived_from ( ST(1), "Aw::Admin::TypeDef" ) )
				RETVAL->type_def = awCopyBrokerAdminTypeDef ( AWXS_BROKERADMINTYPEDEF(1)->type_def );
			else if ( sv_derived_from ( ST(1), "Aw::TypeDef" ) )
				RETVAL->type_def = awCopyBrokerTypeDef ( AWXS_BROKERTYPEDEF(1)->type_def );
			else
			        warn( "Aw::Event::new() -- Arg 1 is not an Aw::TypeDef or Aw::Admin::TypeDef reference." );
		}
		else
			gErr = RETVAL->err = awNewBrokerAdminTypeDef ( NULL, (short)SvIV(ST(1)), &RETVAL->type_def );


		if ( RETVAL->err != AW_NO_ERROR ) {
			setErrMsg ( &gErrMsg, 2, "unable to instantiate new Aw::Admin::TypeDef %s", awErrorToCompleteString ( RETVAL->err ) );
			Safefree ( RETVAL );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
			warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}

	OUTPUT:
	RETVAL


void
delete ( self )
	Aw::Admin::TypeDef self

	ALIAS:
		Aw::Admin::TypeDef::doesSubscriptionExist = 1
		Aw::Admin::TypeDef::setPlatformInfo       = 2

	CODE:
		AWXS_CLEARERROR

		if (ix) {
		  if (ix-1)
		    awSetAdminTypeDefModificationFlag ( self->type_def );
		  else
		    awClearAdminTypeDefModificationFlag ( self->type_def );
		}
		else
		  awDeleteAdminTypeDef ( self->type_def );

		

Aw::Admin::TypeDef
getFieldDef ( self, field_name )
	Aw::Admin::TypeDef self
	char * field_name

	PREINIT:
		char CLASS[] = "Aw::Admin::TypeDef";

	CODE:
		AWXS_CLEARERROR

		RETVAL = (xsBrokerAdminTypeDef *)safemalloc ( sizeof(xsBrokerAdminTypeDef) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new Aw::Admin::TypeDef" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		gErr = self->err = awGetAdminTypeDefFieldDef ( self->type_def, (char *)SvPV(ST(1),PL_na), &RETVAL->type_def );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



awaBool
clearField ( self, string )
	Aw::Admin::TypeDef self
	char * string

	ALIAS:
		Aw::Admin::TypeDef::setDescription = 1
		Aw::Admin::TypeDef::setTypeName    = 2

	CODE:
		AWXS_CLEARERROR

		gErr = self->err 
		= ( ix )
		  ? (ix-1)
		    ? awSetAdminTypeDefTypeName ( self->type_def, string )
		    : awSetAdminTypeDefDescription ( self->type_def, string )
		  : awClearAdminTypeDefField ( self->type_def, string )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



char *
getDescription ( self )
	Aw::Admin::TypeDef self

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awGetAdminTypeDefDescription ( self->type_def, &RETVAL );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



char *
getBaseTypeName ( self )
	Aw::Admin::TypeDef self

	CODE:
		AWXS_CLEARERROR

		RETVAL = awGetAdminTypeDefTypeName ( self->type_def );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



int
getTimeToLive ( self )
	Aw::Admin::TypeDef self

	ALIAS:
		Aw::Admin::TypeDef::getStorageType = 1

	CODE:
		AWXS_CLEARERROR

		gErr = self->err 
		= ( ix )
		  ? awGetAdminTypeDefTimeToLive  ( self->type_def, &RETVAL ) 
		  : awGetAdminTypeDefStorageType ( self->type_def, &RETVAL )
		;

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



awaBool
setTimeToLive ( self, number )
	Aw::Admin::TypeDef self
	int number

	ALIAS:
		Aw::Admin::TypeDef::setStorageType = 1

	CODE:
		AWXS_CLEARERROR

		gErr = self->err 
		= ( ix )
		  ? awSetAdminTypeDefTimeToLive  ( self->type_def, number ) 
		  : awSetAdminTypeDefStorageType ( self->type_def, number )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



short
getFieldType ( self, field_name )
	Aw::Admin::TypeDef self
	char * field_name
	
	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awGetAdminTypeDefFieldType ( self->type_def, field_name, &RETVAL );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



char **
getFieldNamesRef ( self, field_name )
	Aw::Admin::TypeDef self
	char * field_name
	
	PREINIT:
		int n;

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awGetAdminTypeDefFieldNames ( self->type_def, field_name, &n, &RETVAL );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



awaBool
orderFields ( self, field_name, field_names )
	Aw::Admin::TypeDef self
	char * field_name
	char ** field_names
	
	PREINIT:
		int n;

	CODE:
		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(2) ) ) + 1;
		
		gErr = self->err = awOrderAdminTypeDefFields ( self->type_def, field_name, n, field_names );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




awaBool
setFieldType ( self, field_name, field_type, type_name )
	Aw::Admin::TypeDef self
	char * field_name
	short field_type
	char * type_name
	
	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awSetAdminTypeDefFieldType ( self->type_def, field_name, field_type, type_name );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL


awaBool
insertFieldDef ( self, field_name, index, field_def )
	Aw::Admin::TypeDef self
	char * field_name
	int index
	Aw::Admin::TypeDef field_def
	
	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awInsertAdminTypeDefFieldDef ( self->type_def, field_name, index, field_def->type_def );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL


awaBool
setFieldDef ( self, field_name, field_def )
	Aw::Admin::TypeDef self
	char * field_name
	Aw::Admin::TypeDef field_def
	
	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awSetAdminTypeDefFieldDef ( self->type_def, field_name, field_def->type_def );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




awaBool
renameField ( self, old_field_name, new_field_name )
	Aw::Admin::TypeDef self
	char * old_field_name
	char * new_field_name
	
	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awRenameAdminTypeDefField ( self->type_def, old_field_name, new_field_name );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
hasBeenModified ( self )
	Aw::Admin::TypeDef self

	ALIAS:
		Aw::Admin::TypeDef::isSystemDefined = 1

	CODE:
		AWXS_CLEARERROR

		if (ix) 
			awIsAdminTypeDefSystemDefined ( self->type_def, &RETVAL );
		else
			RETVAL = awHasAdminTypeDefBeenModified ( self->type_def );

	OUTPUT:
	RETVAL


awaBool
clearFields ( self )
	Aw::Admin::TypeDef self

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awClearAdminTypeDefFields ( self->type_def );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



#===============================================================================

MODULE = Aw::Admin		PACKAGE = Aw::Admin::LogConfig

#===============================================================================

Aw::Admin::LogConfig
new ( CLASS )
	char * CLASS

	CODE:

		RETVAL = (xsBrokerLogConfig *)safemalloc ( sizeof(xsBrokerLogConfig) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		RETVAL->log_config = awNewBrokerLogConfig ();

	OUTPUT:
	RETVAL


void
delete ( self )
	Aw::Admin::LogConfig self

	CODE:
		awDeleteLogConfig ( self->log_config );


Aw::Admin::LogConfig
copy ( self )
	Aw::Admin::LogConfig self

	PREINIT:
		char CLASS[] = "Aw::Admin::LogConfig";

	CODE:
		RETVAL = (xsBrokerLogConfig *)safemalloc ( sizeof(xsBrokerLogConfig) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		RETVAL->log_config = awCopyBrokerLogConfig ( self->log_config );

	OUTPUT:
	RETVAL




HV *
getLogOutput ( self, code )
	Aw::Admin::LogConfig self
	char * code

	ALIAS:
		Aw::Admin::LogConfig::getLogTopic = 1

	PREINIT:
		BrokerBoolean enabled;
		char * value;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err 
		= (ix)
		  ? awGetLogOutput ( self->log_config, code, &enabled, &value )
		  : awGetLogTopic  ( self->log_config, code, &enabled, &value )
		;

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newHV();

		hv_store ( RETVAL, "code", 4, newSVpv ( code, 0 ), 0 );
		hv_store ( RETVAL, "enabled", 7, newSViv ( (int)enabled ), 0 );
		hv_store ( RETVAL, "value", 5, newSVpv ( value, 0 ), 0 );


	OUTPUT:
	RETVAL



awaBool
setLogOutput ( self, data )
	Aw::Admin::LogConfig self
	HV * data
	
	ALIAS:
		Aw::Admin::LogConfig::setLogTopic   = 1

	PREINIT:
		char * code;
		BrokerBoolean enabled;
		char * value;
		SV ** sv;
	
	CODE:

		sv      = hv_fetch ( data, "code", 4, 0 );
		code    = (char *)SvPV(*sv, PL_na);

		sv      = hv_fetch ( data, "enabled", 7, 0 );
		enabled = (BrokerBoolean)SvIV(*sv);

		sv      = hv_fetch ( data, "value", 5, 0 );
		value   = (char *)SvPV(*sv, PL_na);


		gErr = self->err 
		= (ix)
		  ? awSetLogOutput ( self->log_config, code, enabled, value )
		  : awSetLogTopic  ( self->log_config, code, enabled, value )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
setLogOutputs ( self, av )
	Aw::Admin::LogConfig self
	AV * av

	ALIAS:
		Aw::Admin::LogConfig::setLogTopics = 1

	PREINIT:
		int i, n;
		BrokerLogConfigEntry * log_things;
		HV * hv;
		SV ** sv;

	CODE:

		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(1) ) ) + 1;

		log_things = (BrokerLogConfigEntry *)safemalloc ( sizeof(BrokerLogConfigEntry)*n );

		for ( i = 0; i < n; i++ ) {	
			sv = av_fetch ( av, i, 0 );
			hv = (HV*)SvRV(*sv);

			sv                    = hv_fetch ( hv, "code", 4, 0 );
			log_things[i].code    = (char *)SvPV(*sv, PL_na);

			sv                    = hv_fetch ( hv, "enabled", 7, 0 );
			log_things[i].enabled = (BrokerBoolean)SvIV(*sv);

			sv                    = hv_fetch ( hv, "value", 5, 0 );
			log_things[i].value   = (char *)SvPV(*sv, PL_na);
		}


		gErr = self->err 
		= (ix)
		  ? awSetLogOutputs ( self->log_config, n, log_things )
		  : awSetLogTopics  ( self->log_config, n, log_things )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




AV *
getLogOutputsRef ( self, av )
	Aw::Admin::LogConfig self
	AV * av

	ALIAS:
		Aw::Admin::LogConfig::getLogTopics = 1

	PREINIT:
		int i, n;
		BrokerLogConfigEntry * log_things;
		HV * hv;
		SV * sv;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err 
		= (ix)
		  ? awGetLogOutputs ( self->log_config, &n, &log_things )
		  : awGetLogTopics  ( self->log_config, &n, &log_things )
		;

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newAV();

		for ( i = 0; i < n; i++ ) {	
			hv = newHV();

			hv_store ( hv, "code", 4, newSVpv ( log_things[i].code, 0 ), 0 );
			hv_store ( hv, "enabled", 7, newSViv ( (int)log_things[i].enabled ), 0 );
			hv_store ( hv, "value", 5, newSVpv ( log_things[i].value, 0 ), 0 );

			
			av_push( RETVAL, newRV_noinc((SV*) hv) );
		
		}


	OUTPUT:
	RETVAL


awaBool
clearOutput ( self, ... )
	Aw::Admin::LogConfig self

	ALIAS:
		Aw::Admin::LogConfig::clearLogTopic   = 1
		Aw::Admin::LogConfig::clearLogOutputs = 2
		Aw::Admin::LogConfig::clearLogTopics  = 3

	CODE:

		AWXS_CLEARERROR

		gErr = self->err 
		= (ix>=2)
		  ? (ix-2)
		    ? awClearLogOutputs ( self->log_config )
		    : awClearLogTopics  ( self->log_config )
		  : (ix)
		    ? awClearLogTopic   ( self->log_config, (char *)SvPV( ST(1), PL_na ) )
		    : awClearLogOutput  ( self->log_config, (char *)SvPV( ST(1), PL_na ) )
		;

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



char *
toString ( self )
	Aw::Admin::LogConfig self

	CODE:

		RETVAL = awLogConfigToString ( self->log_config );

	OUTPUT:
	RETVAL



#===============================================================================

MODULE = Aw::Admin		PACKAGE = Aw::Admin::ServerClient

#===============================================================================

Aw::Admin::ServerClient
new ( CLASS, broker_host, desc )
	char * CLASS
	char * broker_host
	Aw::ConnectionDescriptor desc

	CODE:

		RETVAL = (xsServerClient *)safemalloc ( sizeof(xsServerClient) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		gErr = RETVAL->err = awNewBrokerServerClient ( broker_host, desc->desc, &RETVAL->server_client );

		if ( RETVAL->err != AW_NO_ERROR ) {
			setErrMsg ( &gErrMsg, 2, "unable to instantiate new Aw::Admin::ServerClient %s", awErrorToCompleteString ( RETVAL->err ) );
			Safefree ( RETVAL );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
			warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}

	OUTPUT:
	RETVAL


void
DESTROY ( self )
	Aw::Admin::ServerClient self

	CODE:
		awDestroyServerClient ( self->server_client );



Aw::Admin::AccessControlList
getAdminACL ( self )
	Aw::Admin::ServerClient self

	PREINIT:
		char CLASS[] = "Aw::Admin::AccessControlList";

	CODE:

		AWXS_CLEARERROR

		RETVAL = (xsAccessControlList *)safemalloc ( sizeof(xsAccessControlList) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		gErr = self->err = awGetServerAdminACL ( self->server_client, &RETVAL->acl );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



awaBool
setAdminACL ( self, acl )
	Aw::Admin::ServerClient self
	Aw::Admin::AccessControlList acl

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awSetServerAdminACL ( self->server_client, acl->acl );

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
setACL ( self, acl )
	Aw::Admin::ServerClient self
	Aw::Admin::AccessControlList acl

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awSetServerAdminACL ( self->server_client, acl->acl );

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL


char **
getDNsFromCertFileRef ( self, certificate_file, password )
	Aw::Admin::ServerClient self
	char * certificate_file
	char * password

	ALIAS:
		Aw::Admin::ServerClient::getRootDNsFromCertFile = 1
		
	PREINIT:
		int n;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? awGetServerDNsFromCertFile     ( self->server_client, certificate_file, password, &n, &RETVAL )
		  : awGetServerRootDNsFromCertFile ( self->server_client, certificate_file, password, &n, &RETVAL )
		;

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL




HV  *
getActiveSSLConfig ( self )
	Aw::Admin::ServerClient self

	ALIAS:
		Aw::Admin::ServerClient::getActiveProcessInfo = 1
		Aw::Admin::ServerClient::getSavedSSLConfig    = 2
		Aw::Admin::ServerClient::getSSLStatus         = 3

	PREINIT:
		char * string1;
		char * string2;
		char * string3;
		int status;
		int level;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err
		= (ix>=2)
		  ? (ix-2)
		    ? awGetServerSSLStatus       ( self->server_client, &status,  &level,   &string1 )
		    : awGetServerSavedSSLConfig  ( self->server_client, &string1, &string2, &string3 )
		  : (ix) 
		    ? awGetServerActiveProcessInfo ( self->server_client, &string1, &string2 )
		    : awGetServerActiveSSLConfig   ( self->server_client, &string1, &string2, &string3 )
		;

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newHV();

		switch (ix) {
			case 0:
			case 2:
				hv_store ( RETVAL, "certificate_file", 16, newSVpv ( string1, 0 ), 0 );
				hv_store ( RETVAL, "distinguished_name", 18, newSVpv ( string2, 0 ), 0 );
				hv_store ( RETVAL, "issuer_distinguished_name", 25, newSVpv ( string3, 0 ), 0 );
				break;
                            
			case 1:
				hv_store ( RETVAL, "executable_name", 15, newSVpv ( string1, 0 ), 0 );
				hv_store ( RETVAL, "data_directory", 14, newSVpv ( string2, 0 ), 0 );
				break;
                                         
			case 3:
				hv_store ( RETVAL, "status", 6, newSViv ( (int)status ), 0 );
				hv_store ( RETVAL, "level",  5, newSViv ( (int)level ), 0 );
				hv_store ( RETVAL, "error_string", 12, newSVpv ( string1, 0 ), 0 );
				break;
		}

	OUTPUT:
	RETVAL



awaBool
setSSLConfig ( self, new_config )
	Aw::Admin::ServerClient self
	HV * new_config

	PREINIT:
		char * certificate_file;
		char * password;
		char * distinguished_name;
		SV  ** sv;
	
	CODE:

		sv                 = hv_fetch ( new_config, "certificate_file", 16, 0 );
		certificate_file   = (char *)SvPV(*sv, PL_na);

		sv                 = hv_fetch ( new_config, "password", 8, 0 );
		password           = (char *)SvPV(*sv, PL_na);

		sv                 = hv_fetch ( new_config, "distinguished_name", 18, 0 );
		distinguished_name = (char *)SvPV(*sv, PL_na);
	
		gErr = self->err = awSetServerSSLConfig ( self->server_client, certificate_file, password, distinguished_name );

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




Aw::Admin::LogConfig
getServerLogConfig ( self )
	Aw::Admin::ServerClient self

	PREINIT:
		char CLASS[] = "Aw::Admin::LogConfig";

	CODE:

		AWXS_CLEARERROR

		RETVAL = (xsBrokerLogConfig *)safemalloc ( sizeof(xsBrokerLogConfig) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		gErr = self->err = awGetServerLogConfig ( self->server_client, &RETVAL->log_config );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



awaBool
setServerLogConfig ( self, log_config )
	Aw::Admin::ServerClient self
	Aw::Admin::LogConfig log_config

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awSetServerLogConfig ( self->server_client, log_config->log_config );

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



HV *
getServerLogStatus ( self )
	Aw::Admin::ServerClient self

	PREINIT:
		BrokerServerLogInfo info;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetServerLogStatus ( self->server_client, &info );

		AWXS_CHECKSETERROR_RETURN

		{
		SV * sv;

		RETVAL = newHV();

		sv = sv_newmortal();
		sv_setref_pv( sv, "Aw::Date", (void*)&info.first_entry );
		SvREFCNT_inc(sv);
		hv_store ( RETVAL, "first_entry", 11, sv, 0 );

		sv = sv_newmortal();
		sv_setref_pv( sv, "Aw::Date", (void*)&info.last_entry );
		SvREFCNT_inc(sv);
		hv_store ( RETVAL, "last_entry", 10, sv, 0 );

		hv_store ( RETVAL, "num_entries", 11, newSViv ( (int)info.num_entries ), 0 );
		}


	OUTPUT:
	RETVAL




AV *
getServerLogEntriesRef ( self, first_entry, locale )
	Aw::Admin::ServerClient self
	Aw::Date first_entry
	char * locale

	PREINIT:
		int n;
		BrokerServerLogEntry * entries;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetServerLogEntries ( self->server_client, *first_entry, locale, &n, &entries );

		AWXS_CHECKSETERROR_RETURN

		{
		HV * hv;
		SV * sv;
		int i;

		RETVAL = newAV();

		for ( i = 0; i < n; i++ ) {	
			hv = newHV();

			sv = sv_newmortal();
			sv_setref_pv( sv, "Aw::Date", (void*)&entries[i].time_stamp );
			SvREFCNT_inc(sv);
			hv_store ( hv, "time_stamp", 10, sv, 0 );

			hv_store ( hv, "entry_type", 10, newSViv ( (int)entries[i].entry_type ), 0 );
			hv_store ( hv, "entry_msg_id", 12, newSViv ( (int)entries[i].entry_msg_id ), 0 );
			hv_store ( hv, "entry_msg_text", 14, newSVpv ( entries[i].entry_msg_text, 0 ), 0 );
			
			av_push( RETVAL, newRV_noinc((SV*) hv) );
		
		}

		}


	OUTPUT:
	RETVAL



awaBool
pruneServerLog ( self, older_than )
	Aw::Admin::ServerClient self
	Aw::Date older_than

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awPruneServerLog ( self->server_client, *older_than );

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



int
getActivePort ( self, ... )
	Aw::Admin::ServerClient self

	ALIAS:
		Aw::Admin::ServerClient::getServerVersionNumber    = 1
		Aw::Admin::ServerClient::getServerProcessRunStatus = 2

	CODE:

		AWXS_CLEARERROR

		gErr = self->err
		= (ix == 2)
		  ? awGetServerProcessRunStatus ( (char *)SvPV( ST(1), PL_na ), &RETVAL )
		  : (ix)
		    ? awGetServerVersionNumber ( self->server_client, &RETVAL )
		    : awGetServerActivePort    ( self->server_client, &RETVAL )
		;

	OUTPUT:
	RETVAL



awaBool
startProcess ( self, ... )
	Aw::Admin::ServerClient self

	ALIAS:
		Aw::Admin::ServerClient::stopProcess = 1

	CODE:

		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? awStopServerProcess  ( self->server_client )
		  : awStartServerProcess ( (char *)SvPV( ST(1), PL_na ) )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




awaBool
createBroker ( self, broker_name, description, is_default )
	Aw::Admin::ServerClient self
	char * broker_name
	char * description
	awaBool is_default


	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awCreateBroker ( self->server_client, broker_name, description, (BrokerBoolean) is_default );

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




AV *
getServerBrokersRef ( self )
	Aw::Admin::ServerClient self

	PREINIT:
		int n;
		BrokerInfo * broker_infos;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetServerBrokers ( self->server_client, &n, &broker_infos );

		AWXS_CHECKSETERROR_RETURN

		{
		HV * hv;
		SV * sv;
		int i;

		RETVAL = newAV();

		for ( i = 0; i < n; i++ ) {	
			hv = newHV();

			hv_store ( hv, "territory_name", 14, newSVpv ( broker_infos[i].territory_name, 0 ), 0 );
			hv_store ( hv, "broker_host", 11, newSVpv ( broker_infos[i].broker_host, 0 ), 0 );
			hv_store ( hv, "broker_name", 11, newSVpv ( broker_infos[i].broker_name, 0 ), 0 );
			hv_store ( hv, "description", 11, newSVpv ( broker_infos[i].description, 0 ), 0 );
			
			av_push( RETVAL, newRV_noinc((SV*) hv) );
		
		}

		}


	OUTPUT:
	RETVAL



awaBool
registerCallbackForSubId ( self, method, client_data )
	Aw::Admin::ServerClient self
	char * method
	SV * client_data

	PREINIT:
		xsCallBackStruct * cb;

	CODE:
		AWXS_CLEARERROR
		
		cb = (xsCallBackStruct *) malloc ( sizeof (xsCallBackStruct) );
		cb->self   = ST(0);
		cb->data   = client_data;
		cb->id     = 0;
		cb->method = strdup ( method );

		gErr = self->err = awRegisterServerConnectionCallback ( self->server_client, BrokerServerConnectionCallbackFunc, cb );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



Aw::Event
getServerStats ( self )
	Aw::Admin::ServerClient self

	ALIAS:
		Aw::Admin::ServerClient::getServerUsageStats = 1
	
	PREINIT:
		char CLASS[] = "Aw::Event";

	CODE:
		AWXS_CLEARERROR
		
		RETVAL = (xsBrokerEvent *)safemalloc ( sizeof(xsBrokerEvent) );
		if ( RETVAL == NULL ) {
			self->errMsg = setErrMsg ( &gErrMsg, 1, "unable to malloc new event" );
#ifdef AWXS_WARNS
			if ( self->Warn )
				warn ( self->errMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		RETVAL->err      = NULL;
		RETVAL->errMsg   = NULL;
		RETVAL->Warn     = gWarn;
		RETVAL->deleteOk = 0;


		gErr = self->err
		= (ix)
		  ? awGetServerStats      ( self->server_client, &RETVAL->event )
		  : awGetServerUsageStats ( self->server_client, &RETVAL->event )
		;


		if ( self->err != AW_NO_ERROR ) {
			self->errMsg = setErrMsg ( &gErrMsg, 2, "unable to instantiate new event %s", awErrorToCompleteString ( self->err ) );
			Safefree ( RETVAL );
#ifdef AWXS_WARNS
			if ( self->Warn )
				warn ( self->errMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}


	OUTPUT:
	RETVAL



char *
getClientHostName ( self )
	Aw::Admin::ServerClient self

	ALIAS:
		Aw::Admin::ServerClient::getDefaultBrokerName = 1
		Aw::Admin::ServerClient::getDescription       = 2
		Aw::Admin::ServerClient::getLicense           = 3
		Aw::Admin::ServerClient::getVersion           = 4

	CODE:

		AWXS_CLEARERROR

		gErr = self->err 
		= ( ix == 4 )
		  ? awGetServerVersion ( self->server_client, &RETVAL )
		  : ( ix > 3 )
		    ? ( ix == 3 )
		      ? awGetServerLicense ( self->server_client, &RETVAL )
		      : awGetServerDescription ( self->server_client, &RETVAL )
		    : ( ix ) 
		      ? awGetServerDefaultBrokerName ( self->server_client, &RETVAL )
		      : awGetServerClientHostName ( self->server_client, &RETVAL )
		;

	OUTPUT:
	RETVAL



awaBool
setDefaultBrokerName ( self, string )
	Aw::Admin::ServerClient self
	char * string

	ALIAS:
		Aw::Admin::ServerClient::setDescription = 1
		Aw::Admin::ServerClient::setLicense     = 2

	CODE:

		AWXS_CLEARERROR

		gErr = self->err 
		= ( ix )
		  ? (ix-1)
		    ? awSetServerLicense ( self->server_client, string  )
		    : awSetServerDescription ( self->server_client, string  )
		  : awSetServerDefaultBrokerName ( self->server_client, string  )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( gErr == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



#===============================================================================

MODULE = Aw::Admin		PACKAGE = Aw::Admin::Client

#===============================================================================


awaBool
createClient ( self, client_id, client_group, app_name, user_name, authenticator_name, ... )
	Aw::Admin::Client self
	char * client_id
	char * client_group
	char * app_name
	char * user_name
	char * authenticator_name


	PREINIT:
		BrokerConnectionDescriptor myDesc = NULL;

	CODE:

		if ( user_name[0] == '\0' )
			user_name = NULL;
		if ( authenticator_name[0] == '\0' )
			authenticator_name = NULL;

		if ( items == 7 && ( sv_isobject(ST(6)) && (SvTYPE(SvRV(ST(6))) == SVt_PVMG) ) )
			myDesc = AWXS_BROKERCONNECTIONDESC(6)->desc;

		gErr = self->err = awCreateClient ( self->client, client_id, client_group, app_name, user_name, authenticator_name, myDesc );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
DESTROY ( self )
	Aw::Admin::Client self

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awDestroyBroker ( self->client );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
changeLock ( self )
	Aw::Admin::Client self

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awReleaseBrokerChangeLock ( self->client );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL


awaBool
createClientGroup ( self, client_group_name, life_cycle, storage_type )
	Aw::Admin::Client self
	char * client_group_name
	int life_cycle
	int storage_type

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awCreateClientGroup ( self->client, client_group_name, life_cycle, storage_type );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL


awaBool
destroyClientGroup ( self, name, force_destroy )
	Aw::Admin::Client self
	char * name
	awaBool force_destroy

	ALIAS:
		Aw::Admin::Client::destroyEventType = 1

	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? awDestroyClientGroup ( self->client, name, (BrokerBoolean) force_destroy )
		  : awDestroyEventType   ( self->client, name, (BrokerBoolean) force_destroy )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL


char **
getClientGroupNamesRef ( self )
	Aw::Admin::Client self

	PREINIT:
		int n;

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awGetClientGroupNames ( self->client, &n, &RETVAL );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL




char **
getClientGroupCanPublishListRef ( self, string )
	Aw::Admin::Client self
	char * string

	ALIAS:
		Aw::Admin::Client::getClientGroupCanSubscribeListRef   = 1
		Aw::Admin::Client::getClientGroupsWhichCanPublishRef   = 2
		Aw::Admin::Client::getClientGroupsWhichCanSubscribeRef = 3
		Aw::Admin::Client::getClientIdsByClientGroupRef        = 4
		Aw::Admin::Client::getClientIdsWhichAreSubscribedRef   = 5

	PREINIT:
		int n;

	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix<2)
		  ? (ix==5)
		    ? awGetClientIdsByClientGroup      ( self->client, string, &n, &RETVAL )
		    : awGetClientIdsWhichAreSubscribed ( self->client, string, &n, &RETVAL )
		  : (ix>1)
		    ? (ix==3)
		      ? awGetClientGroupsWhichCanSubscribe ( self->client, string, &n, &RETVAL )
		      : awGetClientGroupsWhichCanPublish   ( self->client, string, &n, &RETVAL )
		    : (ix)
		      ? awGetClientGroupCanSubscribeList   ( self->client, string, &n, &RETVAL )
		      : awGetClientGroupCanPublishList     ( self->client, string, &n, &RETVAL )
		;

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL


char **
getClientIdsRef ( self )
	Aw::Admin::Client self

	PREINIT:
		int n;

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awGetClientIds ( self->client, &n, &RETVAL );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL





awaBool
setClientGroupAccessLabelRequired ( self, string, ... )
	Aw::Admin::Client self
	char * string

	ALIAS:
		Aw::Admin::Client::setClientStateShareLimitById           = 1
		Aw::Admin::Client::setClientGroupRequiredEncryption       = 2
		Aw::Admin::Client::setClientLastPublishSequenceNumberById = 3

	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix>1)
		  ? (ix==3)
		    ? awSetClientLastPublishSequenceNumberById ( self->client, string, awBrokerLongFromString ( longlong_to_string ( SvLLV (ST(2)) ) ) )
		    : awSetClientGroupRequiredEncryption  ( self->client, string, (int)SvIV(ST(2)) )
		  : (ix)
                    ? awSetClientStateShareLimitById      ( self->client, string, (int)SvIV(ST(2)) )
		    : awSetClientGroupAccessLabelRequired ( self->client, string, (BrokerBoolean)SvIV(ST(2)) )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
setClientGroupDescription ( self, client_group_name, description )
	Aw::Admin::Client self
	char * client_group_name
	char * description

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awSetClientGroupDescription ( self->client, client_group_name, description );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




awaBool
setClientGroupCanPublishList ( self, client_group_name, event_type_names )
	Aw::Admin::Client self
	char * client_group_name
	char ** event_type_names

	ALIAS:
		Aw::Admin::Client::setClientGroupCanSubscribeList = 1

	PREINIT:
		int n;

	CODE:
		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(2) ) ) + 1;

		gErr = self->err
		= (ix)
		  ? awSetClientGroupCanSubscribeList ( self->client, client_group_name, n, event_type_names )
		  : awSetClientGroupCanPublishList   ( self->client, client_group_name, n, event_type_names )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL






awaBool
destroyClientById ( self, string )
	Aw::Admin::Client self
	char * string

	ALIAS:
		Aw::Admin::Client::disconnectClientById = 1
		Aw::Admin::Client::setBrokerDescription = 2
		
	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? (ix-1)
		    ? awSetBrokerDescription ( self->client, string )
		    : awDisconnectClientById ( self->client, string )
		  : awDestroyClientById    ( self->client, string )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




awaBool
disconnectClientSessionById ( self, client_id, session_id )
	Aw::Admin::Client self
	char * client_id
	int session_id

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awDisconnectClientSessionById ( self->client, client_id, session_id );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
doesSubscriptionExistById ( self, client_id, event_type_name, filter )
	Aw::Admin::Client self
	char * client_id
	char * event_type_name
	char * filter

	PREINIT:
		BrokerBoolean bRV;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awDoesSubscriptionExistById ( self->client, client_id, event_type_name, filter, &bRV );

		AWXS_CHECKSETERROR_RETURN

		RETVAL = (awaBool)bRV;

	OUTPUT:
	RETVAL



awaBool
createSubscriptionById ( self, client_id, sub )
	Aw::Admin::Client self
	char * client_id
	Aw::Subscription sub

	ALIAS:
		Aw::Admin::Client::destroySubscriptionById = 1

	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? awDestroyClientSubscriptionById ( self->client, client_id, sub )
		  : awCreateClientSubscriptionById  ( self->client, client_id, sub )
		;

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
createSubscriptionsById ( self, client_id, av_subs )
	Aw::Admin::Client self
	char * client_id
	AV * av_subs

	ALIAS:
		Aw::Admin::Client::destroySubscriptionsById = 1

	PREINIT:
		int i, n;
		SV ** sv;
		BrokerSubscription * subs;

	CODE:
		AWXS_CLEARERROR

		n = av_len ( av_subs ) + 1;

		subs = (BrokerSubscription *)safemalloc ( sizeof(BrokerSubscription)*n );

		for ( i = 0; i < n; i++ ) {
			sv = av_fetch ( av_subs, i, 0 );
			memcpy ( &subs[i], ((BrokerSubscription *)SvIV((SV*)SvRV( *sv ))), sizeof(BrokerSubscription) );
		}

		gErr = self->err
		= (ix)
		  ? awDestroyClientSubscriptionsById ( self->client, client_id, n, subs )
		  : awCreateClientSubscriptionsById  ( self->client, client_id, n, subs )
		;

		for ( i = 0; i < n; i++ ) {
			Safefree ( &subs[i] );
		}

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



AV *
getSubscriptionsByIdRef ( self, client_id )
	Aw::Admin::Client self
	char * client_id

	PREINIT:
		int n;
		BrokerSubscription ** subs;

	CODE:
		AWXS_CLEARERROR
		
		gErr = self->err = awGetClientSubscriptionsById ( self->client, client_id, &n, subs );

		AWXS_CHECKSETERROR_RETURN

		{		/* now convert subs into an AV */
		SV *sv;
		int i;

			RETVAL = newAV();
			for ( i = 0; i<n; i++ ) {
				sv = sv_newmortal();
				sv_setref_pv( sv, "Aw::Subscription", (void*)subs[i] );
				SvREFCNT_inc(sv);
				av_push( RETVAL, sv );
				Safefree ( subs[i] );
			}
		}

	OUTPUT:
	RETVAL




Aw::Event
getClientGroupStats ( self, string )
	Aw::Admin::Client self
	char * string

	ALIAS:
		Aw::Admin::Client::awGetClientInfosetById     = 1
		Aw::Admin::Client::awGetClientStatsById       = 2
		Aw::Admin::Client::awGetEventTypeStats        = 3
		Aw::Admin::Client::awGetTerritoryGatewayStats = 4

	PREINIT:
		char CLASS[] = "Aw::Event";

	CODE:
		AWXS_CLEARERROR
		
		RETVAL = (xsBrokerEvent *)safemalloc ( sizeof(xsBrokerEvent) );
		if ( RETVAL == NULL ) {
			self->errMsg = setErrMsg ( &gErrMsg, 1, "unable to malloc new event" );
#ifdef AWXS_WARNS
			if ( self->Warn )
				warn ( self->errMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		RETVAL->err      = NULL;
		RETVAL->errMsg   = NULL;
		RETVAL->Warn     = gWarn;
		RETVAL->deleteOk = 0;

		gErr = self->err
		= (ix==4)
		  ? awGetTerritoryGatewayStats ( self->client, string, &RETVAL->event )
		  : (ix>1)
		    ? (ix==3)
		      ? awGetEventTypeStats  ( self->client, string, &RETVAL->event )
		      : awGetClientStatsById ( self->client, string, &RETVAL->event )
		    : (ix)
		      ? awGetClientInfosetById ( self->client, string, &RETVAL->event )
		      : awGetClientGroupStats  ( self->client, string, &RETVAL->event )
		;


		if ( self->err != AW_NO_ERROR ) {
			self->errMsg = setErrMsg ( &gErrMsg, 2, "unable to instantiate new event %s", awErrorToCompleteString ( self->err ) );
			Safefree ( RETVAL );
#ifdef AWXS_WARNS
			if ( self->Warn )
				warn ( self->errMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}


	OUTPUT:
	RETVAL



awaBool
setEventTypeInfosets ( self, event_type_name, av )
	Aw::Admin::Client self
	char * event_type_name
	AV* av

	PREINIT:
		int i, n;
		BrokerEvent * infosets;
		SV ** sv;

	CODE:
		AWXS_CLEARERROR

		n  = av_len ( av ) + 1;

		infosets = (BrokerEvent *) safemalloc ( sizeof(BrokerEvent)*n );

		for ( i = 0; i < n; i++ ) {
			sv = av_fetch ( av, i, 0 );
			memcpy ( &infosets[i], ( (xsBrokerEvent *)SvIV((SV*)SvRV( *sv )) )->event, sizeof(BrokerEvent) );
		}

		gErr = self->err = awSetEventTypeInfosets ( self->client, event_type_name, n, infosets );

		for ( i = 0; i < n; i++ ) {
			Safefree ( infosets[i] );
		}

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
setClientStatsById ( self, client_id, infoset )
	Aw::Admin::Client self
	char * client_id
	Aw::Event infoset


	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awSetClientInfosetById ( self->client, client_id, infoset->event );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
destroyEventTypes ( self, event_type_names, force_destroy )
	Aw::Admin::Client self
	char ** event_type_names
	awaBool force_destroy

	PREINIT:
		int n;

	CODE:
		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(1) ) ) + 1;

		gErr = self->err = awDestroyEventTypes ( self->client, n, event_type_names, (BrokerBoolean) force_destroy );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL




Aw::Admin::TypeDef
getEventAdminTypeDef ( self, event_type_name )
	Aw::Admin::Client self
	char * event_type_name

	PREINIT:
		char CLASS[] = "Aw::Admin::TypeDef";

	CODE:
		AWXS_CLEARERROR

		RETVAL = (xsBrokerAdminTypeDef *)safemalloc ( sizeof(xsBrokerAdminTypeDef) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new Aw::Admin::TypeDef" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		gErr = self->err = awGetEventAdminTypeDef ( self->client, event_type_name, &RETVAL->type_def );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



AV *
getEventAdminTypeDefsRef ( self, event_type_names )
	Aw::Admin::Client self
	char ** event_type_names

	PREINIT:
		int n;
		BrokerAdminTypeDef * type_defs;

	CODE:
		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(1) ) ) + 1;

		gErr = self->err = awGetEventAdminTypeDefs ( self->client, &n, event_type_names, &type_defs );

		AWXS_CHECKSETERROR_RETURN

		
		{
		SV *sv;
		int i;
		xsBrokerAdminTypeDef * type_def;

			RETVAL = newAV();

			for ( i = 0; i<n; i++ ) {
				sv = sv_newmortal();

				type_def = (xsBrokerAdminTypeDef *)safemalloc ( sizeof(xsBrokerAdminTypeDef) );

				if ( type_def == NULL ) {
					setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
					if ( gWarn )
						warn ( gErrMsg );
#endif /* AWXS_WARNS */
					XSRETURN_UNDEF;
				}
				/* initialize the error cleanly */
				type_def->err      =  AW_NO_ERROR;
				type_def->errMsg   =  NULL;
				type_def->Warn     =  gWarn;
				type_def->type_def =  type_defs[i];

				sv_setref_pv( sv, "Aw::Admin::TypeDefs", (void*)type_def );
				SvREFCNT_inc(sv);
				av_push( RETVAL, sv );
			}

		}


	OUTPUT:
	RETVAL



AV *
getEventAdminTypeDefsByScopeRef ( self, scope_name )
	Aw::Admin::Client self
	char * scope_name

	PREINIT:
		int n;
		BrokerAdminTypeDef * type_defs;

	CODE:
		AWXS_CLEARERROR


		gErr = self->err = awGetEventAdminTypeDefsByScope ( self->client, scope_name, &n, &type_defs );
		
		{
		SV *sv;
		int i;
		xsBrokerAdminTypeDef * type_def;

			RETVAL = newAV();

			for ( i = 0; i<n; i++ ) {
				sv = sv_newmortal();

				type_def = (xsBrokerAdminTypeDef *)safemalloc ( sizeof(xsBrokerAdminTypeDef) );

				if ( type_def == NULL ) {
					setErrMsg ( &gErrMsg, 1, "unable to malloc new client" );
#ifdef AWXS_WARNS
					if ( gWarn )
						warn ( gErrMsg );
#endif /* AWXS_WARNS */
					XSRETURN_UNDEF;
				}
				/* initialize the error cleanly */
				type_def->err      =  AW_NO_ERROR;
				type_def->errMsg   =  NULL;
				type_def->Warn     =  gWarn;
				type_def->type_def =  type_defs[i];

				sv_setref_pv( sv, "Aw::Admin::TypeDefs", (void*)type_defs );
				SvREFCNT_inc(sv);
				av_push( RETVAL, sv );
			}

		}


	OUTPUT:
	RETVAL



awaBool
setEventAdminTypeDef ( self, type_def )
	Aw::Admin::Client  self
	Aw::Admin::TypeDef type_def

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awSetEventAdminTypeDef ( self->client, type_def->type_def );

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

		AWXS_CHECKSETERROR

	OUTPUT:
	RETVAL



awaBool
setEventAdminTypeDefs ( self, territory_name, av )
	Aw::Admin::Client self
	char * territory_name
	AV * av
	

	PREINIT:
		SV ** sv;
		int i, n;
		BrokerAdminTypeDef * type_defs;
	
	CODE:

		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(2) ) ) + 1;
		type_defs = (BrokerAdminTypeDef *)safemalloc ( sizeof(BrokerAdminTypeDef)*n );

		for ( i = 0; i < n; i++ ) {
			sv = av_fetch ( av, i, 0 );
			memcpy ( &type_defs[i], ( (xsBrokerAdminTypeDef *)SvIV((SV*)SvRV( *sv )) )->type_def, sizeof(BrokerAdminTypeDef) );
		}


		gErr = self->err = awSetEventAdminTypeDefs ( self->client, n, type_defs );

		for ( i = 0; i < n; i++ ) {
			Safefree ( type_defs[i] );
		}

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;


	OUTPUT:
	RETVAL



awaBool
destroyEventTypeInfosets ( self, event_type_name, infoset_names )
	Aw::Admin::Client self
	char * event_type_name
	char ** infoset_names

	PREINIT:
		int n;

	CODE:
		AWXS_CLEARERROR

		n = av_len ( (AV*)SvRV( ST(2) ) ) + 1;

		gErr = self->err = awDestroyEventTypeInfosets ( self->client, event_type_name, n, infoset_names );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
setTerritoryGatewaySecurity ( self, territory_name, auth_type, encrypt_level )
	Aw::Admin::Client self
	char * territory_name
	int auth_type
	int encrypt_level

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awSetTerritoryGatewaySecurity ( self->client, territory_name, auth_type, encrypt_level );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



char *
getBrokerDescription ( self )
	Aw::Admin::Client self

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awGetBrokerDescription ( self->client, &RETVAL );

		AWXS_CHECKSETERROR_RETURN

	OUTPUT:
	RETVAL



awaBool
setEventTypeInfoset ( self, event_type_name, infoset_name, infoset )
	Aw::Admin::Client self
	char * event_type_name
	char * infoset_name
	Aw::Event infoset

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awSetEventTypeInfoset  ( self->client, event_type_name, infoset_name, infoset->event );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



Aw::Event
getBrokerStats ( self )
	Aw::Admin::Client self

	ALIAS:
		Aw::Admin::Client::getTerritoryStats = 1

	PREINIT:
		char CLASS[] = "Aw::Event";

	CODE:
		AWXS_CLEARERROR
		
		RETVAL = (xsBrokerEvent *)safemalloc ( sizeof(xsBrokerEvent) );
		if ( RETVAL == NULL ) {
			self->errMsg = setErrMsg ( &gErrMsg, 1, "unable to malloc new event" );
#ifdef AWXS_WARNS
			if ( self->Warn )
				warn ( self->errMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		RETVAL->err      = NULL;
		RETVAL->errMsg   = NULL;
		RETVAL->Warn     = gWarn;
		RETVAL->deleteOk = 0;

		gErr = self->err
		= (ix)
		  ? awGetTerritoryStats ( self->client, &RETVAL->event )
		  : awGetBrokerStats    ( self->client, &RETVAL->event )
		;

		AWXS_CHECKSETERROR_RETURN


	OUTPUT:
	RETVAL




awaBool
leaveTerritroy ( self, number, ... )
	Aw::Admin::Client self
	int number

	ALIAS:
		Aw::Admin::Client::setTerritorySecurity = 1

	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? awLeaveTerritory       ( self->client, number, (BrokerBoolean)SvIV(ST(2)) )
		  : awSetTerritorySecurity ( self->client, number, (int)SvIV(ST(2)) )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



Aw::Admin::AccessControlList
getTerritoryACL ( self )
	Aw::Admin::Client self

	PREINIT:
		char CLASS[] = "Aw::Admin::AccessControlList";

	CODE:
		AWXS_CLEARERROR

		RETVAL = (xsAccessControlList *)safemalloc ( sizeof(xsAccessControlList) );
		if ( RETVAL == NULL ) {
			setErrMsg ( &gErrMsg, 1, "unable to malloc new acl" );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}
		/* initialize the error cleanly */
		RETVAL->err    = AW_NO_ERROR;
		RETVAL->errMsg = NULL;
		RETVAL->Warn   = gWarn;

		gErr = RETVAL->err = awGetTerritoryACL ( self->client, &RETVAL->acl );


		if ( RETVAL->err != AW_NO_ERROR ) {
			setErrMsg ( &gErrMsg, 2, "unable to instantiate new Aw::Admin::AccessControlList %s", awErrorToCompleteString ( RETVAL->err ) );
			Safefree ( RETVAL );
#ifdef AWXS_WARNS
			if ( gWarn )
				warn ( gErrMsg );
			warn ( gErrMsg );
#endif /* AWXS_WARNS */
			XSRETURN_UNDEF;
		}

	OUTPUT:
	RETVAL



awaBool
setTerritoryACL ( self, acl )
	Aw::Admin::Client self
	Aw::Admin::AccessControlList acl

	CODE:
		AWXS_CLEARERROR

		gErr = self->err = awSetTerritoryACL ( self->client, acl->acl );

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
setClientGroupACL ( self, string, acl )
	Aw::Admin::Client self
	char * string
	Aw::Admin::AccessControlList acl

	ALIAS:
		Aw::Admin::Client::setTerritroyGatewayACL = 1

	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? awSetTerritoryGatewayACL ( self->client, string, acl->acl )
		  : awSetClientGroupACL ( self->client, string, acl->acl )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
clearClientQueueById ( self, string )
	Aw::Admin::Client self
	char * string

	ALIAS:
		Aw::Admin::Client::destroyTerritroyGateway = 1
		Aw::Admin::Client::createTerritroy         = 2

	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? (ix-1)
		    ? awDestroyTerritoryGateway ( self->client, string )
		    : awCreateTerritory ( self->client, string )
		  : awClearClientQueueById ( self->client, string )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



awaBool
setCreateTerritoryGateway ( self, string1, string2, ... )
	Aw::Admin::Client self
	char * string1
	char * string2

	ALIAS:
		Aw::Admin::Client::destroyEventTypeInfoset   = 1
		Aw::Admin::Client::removeBrokerFromTerritory = 2

	CODE:
		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? (ix-1)
		    ? awRemoveBrokerFromTerritory ( self->client, string1, string2 )
		    : awDestroyEventTypeInfoset ( self->client, string1, string2 )
		  : awCreateTerritoryGateway ( self->client, string1, string2, (char *)SvPV ( ST(1), PL_na ) )
		;

		AWXS_CHECKSETERROR

		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;

	OUTPUT:
	RETVAL



AV *
getBrokersInTerritroyRef ( self )
	Aw::Admin::Client self

	PREINIT:
		int n;
		BrokerInfo * broker_infos;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetBrokersInTerritory ( self->client, &n, &broker_infos );

		AWXS_CHECKSETERROR_RETURN

		{
		HV * hv;
		SV * sv;
		int i;

		RETVAL = newAV();

		for ( i = 0; i < n; i++ ) {	
			hv = newHV();

			hv_store ( hv, "territory_name", 14, newSVpv ( broker_infos[i].territory_name, 0 ), 0 );
			hv_store ( hv, "broker_host", 11, newSVpv ( broker_infos[i].broker_host, 0 ), 0 );
			hv_store ( hv, "broker_name", 11, newSVpv ( broker_infos[i].broker_name, 0 ), 0 );
			hv_store ( hv, "description", 11, newSVpv ( broker_infos[i].description, 0 ), 0 );
			
			av_push( RETVAL, newRV_noinc((SV*) hv) );
		
		}

		}


	OUTPUT:
	RETVAL



AV *
getAllTerritoryGatewaysRef ( self )
	Aw::Admin::Client self

	ALIAS:
		Aw::Admin::Client::getLocalTerritoryGateways = 1

	PREINIT:
		int n;
		BrokerTerritoryGatewayInfo * infos;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err
		= (ix)
		  ? awGetLocalTerritoryGateways ( self->client, &n, &infos )
		  : awGetAllTerritoryGateways   ( self->client, &n, &infos )
		;

		AWXS_CHECKSETERROR_RETURN

		{
		HV * hv;
		SV * sv;
		int i;

		RETVAL = newAV();

		for ( i = 0; i < n; i++ ) {	
			hv = newHV();

			hv_store ( hv, "gateway_host_name",         17, newSVpv ( infos[i].gateway_host_name, 0 ), 0 );
			hv_store ( hv, "gateway_broker_name",       19, newSVpv ( infos[i].gateway_broker_name, 0 ), 0 );
			hv_store ( hv, "remote_territory_name",     21, newSVpv ( infos[i].remote_territory_name, 0 ), 0 );
			hv_store ( hv, "remote_host_name",          16, newSVpv ( infos[i].remote_host_name, 0 ), 0 );
			hv_store ( hv, "remote_broker_name",        18, newSVpv ( infos[i].remote_broker_name, 0 ), 0 );
			hv_store ( hv, "remote_broker_description", 25, newSVpv ( infos[i].remote_broker_description, 0 ), 0 );
			hv_store ( hv, "auth_type",                  9, newSViv ( (int)infos[i].auth_type ), 0 );
			hv_store ( hv, "encrypt_level",             13, newSViv ( (int)infos[i].encrypt_level ), 0 );
			hv_store ( hv, "is_local",                   8, newSViv ( (awaBool)infos[i].is_local ), 0 );
			hv_store ( hv, "is_complete",               11, newSViv ( (awaBool)infos[i].is_complete ), 0 );

			hv_store ( hv, "num_accessible_territories", 26, newSViv ( (int)infos[i].num_accessible_territories ), 0 );

			sv = sv_newmortal();
			XS_pack_charPtrPtr ( sv, infos[i].accessible_territories );
			hv_store ( hv, "accessible_territories", 22, sv, 0 );
			
			av_push( RETVAL, newRV_noinc((SV*) hv) );
		
		}

		}


	OUTPUT:
	RETVAL



awaBool
setTerritoryGatewaySharedEventTypes ( self, territory_name, av )
	Aw::Admin::Client self
	char * territory_name
	AV * av
	

	PREINIT:
		int i, n;
		HV * hv;
		SV ** sv;
		BrokerSharedEventTypeInfo * infos;
	
	CODE:

		AWXS_CLEARERROR

		n     = av_len ( (AV*)SvRV( ST(2) ) ) + 1;
		infos = (BrokerSharedEventTypeInfo *)safemalloc ( sizeof(BrokerSharedEventTypeInfo)*n );	


		for ( i = 0; i < n; i++ ) {
			sv = av_fetch ( av, i, 0 );
			hv = (HV*)SvRV(*sv);

			sv                        = hv_fetch ( hv, "event_type_name",  15, 0 );
			infos[i].event_type_name  = (char *)SvPV(*sv, PL_na);

			sv                        = hv_fetch ( hv, "subscribe_filter", 16, 0 );
			infos[i].subscribe_filter = (char *)SvPV(*sv, PL_na);

			sv                        = hv_fetch ( hv, "accept_publish",   14, 0 );
			infos[i].accept_publish   = (BrokerBoolean)SvIV(*sv);

			sv                        = hv_fetch ( hv, "accept_subscribe", 16, 0 );
			infos[i].accept_subscribe = (BrokerBoolean)SvIV(*sv);

			sv                        = hv_fetch ( hv, "is_synchronized",  15, 0 );
			infos[i].is_synchronized   = (BrokerBoolean)SvIV(*sv);
		}

		gErr = self->err = awSetTerritoryGatewaySharedEventTypes ( self->client, territory_name, n, infos );
		RETVAL = ( self->err == AW_NO_ERROR ) ? awaFalse : awaTrue;


	OUTPUT:
	RETVAL



AV *
getTerrioryGatewaySharedEventTypesRef ( self, territory_name )
	Aw::Admin::Client self
	char * territory_name;

	PREINIT:
		int n;
		BrokerSharedEventTypeInfo * infos;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetTerritoryGatewaySharedEventTypes ( self->client, territory_name, &n, &infos );

		AWXS_CHECKSETERROR_RETURN

		{
		HV * hv;
		SV * sv;
		int i;

		RETVAL = newAV();

		for ( i = 0; i < n; i++ ) {	
			hv = newHV();

			hv_store ( hv, "subscribe_filter", 16, newSVpv (  (char *)infos[i].subscribe_filter, 0 ), 0 );

			hv_store ( hv, "accept_publish",   14, newSViv ( (awaBool)infos[i].accept_publish ), 0 );
			hv_store ( hv, "accept_subscribe", 15, newSViv ( (awaBool)infos[i].accept_subscribe ), 0 );
			hv_store ( hv, "is_syncronized",   14, newSViv ( (awaBool)infos[i].is_synchronized ), 0 );
			
			av_push ( RETVAL, newRV_noinc((SV*) hv) );
		
		}

		}


	OUTPUT:
	RETVAL



HV *
getClientInfoById ( self, client_id )
	Aw::Admin::Client self
	char * client_id;

	PREINIT:
		int n;
		BrokerClientInfo * info;
		char blString[24];
		SV * sv;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetClientInfoById ( self->client, client_id, &info );

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newHV();

		hv_store ( RETVAL, "client_id",              9, newSVpv ( (char *)info->client_id, 0 ), 0 );
		hv_store ( RETVAL, "client_group",          12, newSVpv ( (char *)info->client_group, 0 ), 0 );
		hv_store ( RETVAL, "app_name",               8, newSVpv ( (char *)info->app_name, 0 ), 0 );

		hv_store ( RETVAL, "shared_event_ordering", 21, newSVpv ( (char *)info->shared_event_ordering, 0 ), 0 );

		if ( info->user_name )
		hv_store ( RETVAL, "user_name",              9, newSVpv ( (char *)info->user_name, 0 ), 0 );
		if ( info->authenticator_name )
		hv_store ( RETVAL, "authenticator_name",    18, newSVpv ( (char *)info->authenticator_name, 0 ), 0 );


		hv_store ( RETVAL, "can_share_state",       15, newSViv ( (awaBool)info->can_share_state ), 0 );
		hv_store ( RETVAL, "state_share_limit",     17, newSViv ( (int)info->state_share_limit ), 0 );

		sv = sv_newmortal();
		sv_setuv ( sv, (UV)((short *)info->access_label) );
		SvREFCNT_inc(sv);

		hv_store ( RETVAL, "access_label",          12, sv, 0 );

		hv_store ( RETVAL, "num_sessions",          12, newSViv ( (int)info->num_sessions ), 0 );
		hv_store ( RETVAL, "num_access_labels",     17, newSViv ( (int)info->num_access_labels ), 0 );

		hv_store ( RETVAL, "high_pub_seqn", 13, 
			   ll_from_longlong ( longlong_from_string ( awBrokerLongToString( info->high_pub_seqn, blString ) ) ), 0 );

		hv_store ( RETVAL, "sessions",    8, getBrokerClientSessions ( info->sessions, info->num_sessions ), 0 );
			
		newRV_noinc((SV*) RETVAL);
		

	OUTPUT:
	RETVAL



AV *
getClientInfosByIdRef ( self, client_ids, ... )
	Aw::Admin::Client self
	char ** client_ids

	PREINIT:
		int n;
		BrokerClientInfo ** infos;

	CODE:

		AWXS_CLEARERROR

		if ( items == 3 )
			n = (int)SvIV(ST(2));

		gErr = self->err = awGetClientInfosById ( self->client, &n, client_ids, &infos );

		AWXS_CHECKSETERROR_RETURN

		{
		HV * hv;
		SV * sv;
		int i;

		RETVAL = newAV();

		for ( i = 0; i < n; i++ ) {	
			hv = newHV();

			hv_store ( hv, "client_id",              9, newSVpv ( (char *)infos[i]->client_id, 0 ), 0 );
			hv_store ( hv, "client_group",          12, newSVpv ( (char *)infos[i]->client_group, 0 ), 0 );
			hv_store ( hv, "app_name",               8, newSVpv ( (char *)infos[i]->app_name, 0 ), 0 );

			hv_store ( hv, "shared_event_ordering", 19, newSVpv ( (char *)infos[i]->shared_event_ordering, 0 ), 0 );

			hv_store ( hv, "user_name",              9, newSVpv ( (char *)infos[i]->user_name, 0 ), 0 );
			hv_store ( hv, "authenticator_name",    18, newSVpv ( (char *)infos[i]->authenticator_name, 0 ), 0 );
			hv_store ( hv, "state_share_limit",     17, newSViv ( (int)infos[i]->state_share_limit ), 0 );
			hv_store ( hv, "num_access_labels",     17, newSViv ( (int)infos[i]->num_access_labels ), 0 );
			hv_store ( hv, "num_sessions",          12, newSViv ( (int)infos[i]->num_sessions ), 0 );

			hv_store ( hv, "sessions",              21, getBrokerClientSessions ( infos[i]->sessions, infos[i]->num_sessions ), 0 );
			

			av_push ( RETVAL, newRV_noinc((SV*) hv) );
		
		}

		}


	OUTPUT:
	RETVAL



HV *
getClientGroupInfo ( self, client_group_name )
	Aw::Admin::Client self
	char * client_group_name

	PREINIT:
		int n;
		BrokerClientGroupInfo * info;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetClientGroupInfo  ( self->client, client_group_name, &info );

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newHV();


		hv_store ( RETVAL, "name",                   4, newSVpv ( (char*)info->name, 0 ), 0 );
		hv_store ( RETVAL, "description",           11, newSVpv ( (char*)info->description, 0 ), 0 );

		hv_store ( RETVAL, "life_cyle",              9, newSViv ( (int)info->life_cycle ), 0 );
		hv_store ( RETVAL, "storage_type",          12, newSViv ( (int)info->storage_type ), 0 );
		hv_store ( RETVAL, "required_encryption",   19, newSViv ( (int)info->required_encryption ), 0 );

		hv_store ( RETVAL, "access_label_required", 21, newSViv ( (BrokerBoolean)info->access_label_required ), 0 );
		hv_store ( RETVAL, "is_system_defined",     17, newSViv ( (BrokerBoolean)info->is_system_defined ), 0 );
			
		newRV_noinc((SV*) RETVAL);


	OUTPUT:
	RETVAL




HV *
getTerritoryInfo ( self )
	Aw::Admin::Client self

	PREINIT:
		BrokerTerritoryInfo * info;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetTerritoryInfo ( self->client, &info );

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newHV();

		hv_store ( RETVAL, "territory_name", 14, newSVpv ( (char*)info->territory_name, 0 ), 0 );
		hv_store ( RETVAL, "auth_type",       9, newSViv ( (int)info->auth_type     ), 0 );
		hv_store ( RETVAL, "encrypt_level",  13, newSViv ( (int)info->encrypt_level ), 0 );

		newRV_noinc((SV*) RETVAL);
		

	OUTPUT:
	RETVAL



AV *
getTerritroyGatewaySharedEventTypesRef ( self, client_group_names )
	Aw::Admin::Client self
	char ** client_group_names

	PREINIT:
		int n;
		BrokerClientGroupInfo ** infos;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetClientGroupInfos ( self->client, &n, client_group_names, &infos );

		AWXS_CHECKSETERROR_RETURN

		{
		HV * hv;
		SV * sv;
		int i;

		RETVAL = newAV();

		for ( i = 0; i < n; i++ ) {	
			hv = newHV();

			hv_store ( hv, "name",                   4, newSVpv ( (char *)infos[i]->name, 0 ), 0 );
			hv_store ( hv, "description",           11, newSVpv ( (char *)infos[i]->description, 0 ), 0 );

			hv_store ( hv, "life_cycle",            10, newSViv ( (int)infos[i]->life_cycle ), 0 );
			hv_store ( hv, "storage_type",          12, newSViv ( (int)infos[i]->storage_type ), 0 );
			hv_store ( hv, "required_encryption",   19, newSViv ( (int)infos[i]->required_encryption ), 0 );

			hv_store ( hv, "is_system_defined",     17, newSViv ( (awaBool)infos[i]->is_system_defined ), 0 );
			hv_store ( hv, "access_label_required", 21, newSViv ( (awaBool)infos[i]->access_label_required ), 0 );

			av_push ( RETVAL, newRV_noinc((SV*) hv) );
		
		}

		}


	OUTPUT:
	RETVAL






HV *
acquireBrokerChangeLock ( self )
	Aw::Admin::Client self

	PREINIT:
		SV *sv;
		BrokerChangeLockInfo * info;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awAcquireBrokerChangeLock ( self->client, &info );

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newHV();

		hv_store ( RETVAL, "acquired",    8, newSViv ( (awaBool)info->acquired ), 0 );
		hv_store ( RETVAL, "client_id",   9, newSVpv ( (char*)info->client_id, 0 ), 0 );
		hv_store ( RETVAL, "session_id", 10, newSViv ( (int)info->session_id ), 0 );


		sv = sv_newmortal();
		sv_setref_pv( sv, "Aw::Date", (void*)&info->lock_time );
		hv_store ( RETVAL, "lock_time",   9, sv, 0 );


		newRV_noinc((SV*) RETVAL);


	OUTPUT:
	RETVAL




HV *
getActivityTraces ( self, seqn, msecs )
	Aw::Admin::Client self
	int seqn
	int msecs

	PREINIT:
		int n;
		BrokerTraceEvent * traces;
		char blString[24];

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awGetActivityTraces ( self->client, seqn, msecs, &n, &traces );

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newHV();

		hv_store ( RETVAL, "seqn",             4, newSViv ( (int)traces->seqn ), 0 );
		hv_store ( RETVAL, "key",              3, newSViv ( (int)traces->key ), 0 );
		hv_store ( RETVAL, "tag",              3, newSViv ( (int)traces->tag ), 0 );
		hv_store ( RETVAL, "ip_address",      10, newSViv ( (int)traces->ip_address ), 0 );
		hv_store ( RETVAL, "session_id",      10, newSViv ( (int)traces->session_id ), 0 );
		hv_store ( RETVAL, "session_count",   13, newSViv ( (int)traces->session_count ), 0 );
		hv_store ( RETVAL, "encrypt_level",   13, newSViv ( (int)traces->encrypt_level ), 0 );

		hv_store ( RETVAL, "has_tag",          7, newSViv ( (awaBool)traces->has_tag ), 0 );
		hv_store ( RETVAL, "is_authenticated", 16, newSViv ( (awaBool)traces->is_authenticated ), 0 );

		hv_store ( RETVAL, "event_id", 9, 
			   ll_from_longlong ( longlong_from_string ( awBrokerLongToString( traces->event_id, blString ) ) ), 0 );

		hv_store ( RETVAL, "dest_client_id",  14, newSVpv ( (char*)traces->dest_client_id, 0 ), 0 );
		hv_store ( RETVAL, "broker_name",     11, newSVpv ( (char*)traces->broker_name, 0 ), 0 );
		hv_store ( RETVAL, "broker_host",     11, newSVpv ( (char*)traces->broker_host, 0 ), 0 );
		hv_store ( RETVAL, "app_name",         8, newSVpv ( (char*)traces->app_name, 0 ), 0 );
		hv_store ( RETVAL, "client_group",    12, newSVpv ( (char*)traces->client_group, 0 ), 0 );
		hv_store ( RETVAL, "event_type_name", 15, newSVpv ( (char*)traces->event_type_name, 0 ), 0 );

		newRV_noinc((SV*) RETVAL);
		

	OUTPUT:
	RETVAL



HV *
joinTerritory ( self, broker_host, broker_name )
	Aw::Admin::Client self
	char * broker_host
	char * broker_name

	PREINIT:
		BrokerJoinFailureInfo * failure_info;
		SV * sv;

	CODE:

		AWXS_CLEARERROR

		gErr = self->err = awJoinTerritory ( self->client, broker_host, broker_name, &failure_info );

		AWXS_CHECKSETERROR_RETURN

		RETVAL = newHV();

		sv = sv_newmortal();
		XS_pack_charPtrPtr ( sv, failure_info->event_type_names );
		hv_store ( RETVAL, "event_type_names",       16, sv, 0 );

		sv = sv_newmortal();
		XS_pack_charPtrPtr ( sv, failure_info->client_group_names );
		hv_store ( RETVAL, "client_group_names",     18, sv, 0 );

		hv_store ( RETVAL, "num_client_group_names", 22, newSViv ( (int)failure_info->num_client_group_names ), 0 );
		hv_store ( RETVAL, "num_event_type_names",   20, newSViv ( (int)failure_info->num_event_type_names ), 0 );


		newRV_noinc((SV*) RETVAL);


	OUTPUT:
	RETVAL
