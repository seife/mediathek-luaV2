
function initLocale()
	l={}
	l.key = {}

	local language_default = "english"
	local language = N:GetLanguage()
	if language == nil or language == "" or (H.fileExist(pluginScriptPath .. "/locale/" .. language .. ".lua") == false) then
		language = language_default
	end

	dofile(pluginScriptPath .. "/locale/" .. language .. ".lua");
end

function initVars()
	pluginVersion		= "0.2beta-11"
	pluginName		= "Coolithek"

	noCacheFiles		= false
	dlDebug			= false

	forcePluginExit		= false
	Curl			= nil

	url_base_b		= "http://mediathek.slknet.de"
	url_base_4		= "http://mediathek4.slknet.de"
	url_base		= url_base_b

	conf			= {}
	conf.livestream		= {}
	config			= configfile.new()
	user_agent		= "\"Mozilla/5.0 (compatible; " .. pluginName .. " plugin v" .. pluginVersion .. " for NeutrinoHD)\"";
	user_agent2		= "\"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0\""

	actionCmd_versionInfo	= "action=getVersionInfo&pVersion="	.. pluginVersion
	actionCmd_livestream	= "action=listLivestream&pVersion="	.. pluginVersion
	actionCmd_listChannels	= "action=listChannels&pVersion="	.. pluginVersion
	actionCmd_listVideos	= "action=listVideos&pVersion="		.. pluginVersion

	jsonData		= pluginTmpPath .. "/mediathek_data.txt";
	m3u8Data		= pluginTmpPath .. "/mediathek_data.m3u8";
	pluginIcon		= "multimedia";
	backgroundImage		= pluginScriptPath .. "/background.jpg";
	videoTable		= {};
	h_mainWindow		= nil;

	fontMainMenu		= nil;
	fontMiniInfo		= nil;
	fontLeftMenu1		= nil;
	fontLeftMenu2		= nil;

	h_mtWindow		= nil
	mtScreen		= nil

	mainScreen		= 0
	moviePlayed		= false

	MINUTE			= 60
	HOUR			= 3600
	DAY			= HOUR*24
	WEEK			= DAY*7

-- ################################################

	local function fillMainMenuEntry(e1, e2)
		local i = #mainMenuEntry+1
		mainMenuEntry[i] 	= {}
		mainMenuEntry[i][1]	= e1
		mainMenuEntry[i][2]	= e2
	end

	mainMenuEntry = {}
	fillMainMenuEntry(l.key.ok,	l.start_mediathek)
	fillMainMenuEntry(l.key.sat,	l.start_livestreams)
	fillMainMenuEntry(l.key.menu,	l.settings)
	fillMainMenuEntry(l.key.info,	l.versioninfo)
	fillMainMenuEntry(l.empty,	l.empty)
	fillMainMenuEntry(l.key.exit,	l.exit_program)

	if (H.fileExist(pluginScriptPath .. "/local.lua") == true) then
		-- locale settings for testing
		dofile(pluginScriptPath .. "/local.lua");
	end
end
