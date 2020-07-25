GCloudVoiceErrno =
    {
        GCLOUD_VOICE_SUCC           = 0,
		
		-- //common base err
		GCLOUD_VOICE_PARAM_NULL = 0x1001,	--//4097, some param is null
		GCLOUD_VOICE_NEED_SETAPPINFO = 0x1002,	--//4098, you should call SetAppInfo first before call other api
		GCLOUD_VOICE_INIT_ERR = 0x1003,	--//4099, --Init Erro
		GCLOUD_VOICE_RECORDING_ERR = 0x1004,		--//4100, now is recording, can't do other operator
		GCLOUD_VOICE_POLL_BUFF_ERR = 0x1005,	--//4101, poll buffer is not enough or null 
		GCLOUD_VOICE_MODE_STATE_ERR = 0x1006,	--//4102, call some api, but the mode is not correct, maybe you shoud call SetMode first and correct
		GCLOUD_VOICE_PARAM_INVALID = 0x1007,	--//4103, some param is null or value is invalid for our request, used right param and make sure is value range is correct by our comment 
		GCLOUD_VOICE_OPENFILE_ERR = 0x1008, --//4104, open a file err
		GCLOUD_VOICE_NEED_INIT = 0x1009, --//4105, you should call Init before do this operator
		GCLOUD_VOICE_ENGINE_ERR = 0x100A, --//4106, you have not get engine instance, this common in use c# api, but not get gcloudvoice instance first
		GCLOUD_VOICE_POLL_MSG_PARSE_ERR = 0x100B, --//4107, this common in c# api, parse poll msg err
		GCLOUD_VOICE_POLL_MSG_NO = 0x100C, --//4108, poll, no msg to update


		-- //realtime err
		GCLOUD_VOICE_REALTIME_STATE_ERR = 0x2001, --//8193, call some realtime api, but state err, such as OpenMic but you have not Join Room first
		GCLOUD_VOICE_JOIN_ERR = 0x2002, --//8194, join room failed
		GCLOUD_VOICE_QUIT_ROOMNAME_ERR = 0x2003,	--//8195, quit room err, the quit roomname not equal join roomname
		GCLOUD_VOICE_OPENMIC_NOTANCHOR_ERR = 0x2004,--//8196, open mic in bigroom,but not anchor role


		-- //message err
		GCLOUD_VOICE_AUTHKEY_ERR = 0x3001, --//12289, apply authkey api error
		GCLOUD_VOICE_PATH_ACCESS_ERR = 0x3002, --//12290, the path can not access ,may be path file not exists or deny to access
		GCLOUD_VOICE_PERMISSION_MIC_ERR = 0x3003,	--//12291, you have not right to access micphone in android
		GCLOUD_VOICE_NEED_AUTHKEY = 0x3004,		--//12292,you have not get authkey, call ApplyMessageKey first
		GCLOUD_VOICE_UPLOAD_ERR = 0x3005,	--//12293, upload file err
		GCLOUD_VOICE_HTTP_BUSY = 0x3006,	--//12294, http is busy,maybe the last upload/download not finish.
		GCLOUD_VOICE_DOWNLOAD_ERR = 0x3007,	--//12295, download file err
		GCLOUD_VOICE_SPEAKER_ERR = 0x3008, --//12296, open or close speaker tve error
		GCLOUD_VOICE_TVE_PLAYSOUND_ERR = 0x3009, --//12297, tve play file error
        GCLOUD_VOICE_AUTHING = 0x300a, --// 12298, Already in applying auth key processing

		GCLOUD_VOICE_INTERNAL_TVE_ERR = 0x5001,		--//20481, internal TVE err, our used
		GCLOUD_VOICE_INTERNAL_VISIT_ERR = 0x5002,	--//20482, internal Not TVE err, out used
		GCLOUD_VOICE_INTERNAL_USED = 0x5003, --//20483, internal used, you should not get this err num
        
        GCLOUD_VOICE_BADSERVER = 0x06001, --// 24577, bad server address,should be "udp://capi.xxx.xxx.com"
        
        GCLOUD_VOICE_STTING =  0x07001, --// 28673, Already in speach to text processing

    };
    
GCloudVoiceCompleteCode = 
    {
		GV_ON_JOINROOM_SUCC = 1,	--//join room succ
		GV_ON_JOINROOM_TIMEOUT = 2,  --//join room timeout
		GV_ON_JOINROOM_SVR_ERR = 3,  --//communication with svr occur some err, such as err data recv from svr
		GV_ON_JOINROOM_UNKNOWN = 4, --//reserved, our internal unknow err

		GV_ON_NET_ERR = 5,  --//net err,may be can't connect to network

		GV_ON_QUITROOM_SUCC = 6, --//quitroom succ, if you have join room succ first, quit room will alway return succ

		GV_ON_MESSAGE_KEY_APPLIED_SUCC = 7,  --//apply message authkey succ
		GV_ON_MESSAGE_KEY_APPLIED_TIMEOUT = 8,		--//apply message authkey timeout
		GV_ON_MESSAGE_KEY_APPLIED_SVR_ERR = 9,  --//communication with svr occur some err, such as err data recv from svr
		GV_ON_MESSAGE_KEY_APPLIED_UNKNOWN = 10,  --//reserved,  our internal unknow err

        GV_ON_UPLOAD_RECORD_DONE = 11,  --//upload record file succ
        GV_ON_UPLOAD_RECORD_ERROR = 12,  --//upload record file occur error
        GV_ON_DOWNLOAD_RECORD_DONE = 13,	--//download record file succ
        GV_ON_DOWNLOAD_RECORD_ERROR = 14,	--//download record file occur error

        GV_ON_STT_SUCC = 15, --// speech to text successful
        GV_ON_STT_TIMEOUT = 16, --// speech to text with timeout
        GV_ON_STT_APIERR = 17, --// server's error
        
		GV_ON_PLAYFILE_DONE = 18,  --//the record file played end
        
        GV_ON_ROOM_OFFLINE = 19, --// Dropped from the room
        GV_ON_UNKNOWN = 20,
    };

-- return GCloudVoiceErrno,GCloudVoiceCompleteCode