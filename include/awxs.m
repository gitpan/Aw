#ifndef AWXS_M
#define AWXS_M 1


#define AWXS_ADAPTER(x)           ((xsAdapter *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_ADAPTEREVENTTYPE(x)  ((xsAdapterEventType *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_ADAPTERLOG(x)        ((xsAdapterLog *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_ADAPTERLICENSE(x)    ((xsAdapterLicense *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_ADAPTERREPLIES(x)    ((xsAdapterReplies *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_ADAPTERUTIL(x)       ((xsAdapterUtil *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKEREVENT(x)       ((xsBrokerEvent *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERCLIENT(x)      ((xsBrokerClient *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERCONNECTIONDESC(x) ((xsBrokerConnectionDescriptor *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERDATE(x)        ((BrokerDate *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERERROR(x)       ((xsBrokerError *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERFILTER(x)      ((xsBrokerFilter *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERFORMAT(x)      ((xsBrokerFormat *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERTYPEDEF(x)      ((xsBrokerTypeDef *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERTYPEDEFCACHE(x) ((xsBrokerTypeDefCache *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERSSLCERTIFICATE(x) ((BrokerSSLCertificate *)SvIV((SV*)SvRV( ST(x) )))
#define AWXS_BROKERSUBSCRIPTION(x) ((BrokerSubscription *)SvIV((SV*)SvRV( ST(x) )))


#define AWXS_CLEARERROR { self->err = AW_NO_ERROR; if (self->errMsg == gErrMsg) gErrMsg = NULL; safefree (self->errMsg); self->errMsg = NULL; gErrCode = 0x0; }

#define AWXS_HANDLE_CLEARERROR(x) {\
	if ( ix && ix != x ) {\
		xsAdapter * self = AWXS_ADAPTER(0);\
		AWXS_CLEARERROR\
	} else {\
		xsAdapterUtil * self = AWXS_ADAPTERUTIL(0);\
		AWXS_CLEARERROR\
	}\
}

#endif /* AWXS_M */
