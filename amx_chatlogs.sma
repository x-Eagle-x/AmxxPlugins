/* Chat logs */
/* https://www.youtube.com/watch?v=2iG54dRVcQo */
/* Written with <3 on JOE (Joe's own editor) */

#include <amxmodx>

new g_szLogFilename[] = "chatlogs.ini", g_szLogFile[32], g_pEnabled;

public plugin_init()
{
	register_plugin("Chat logs", "1.1", "thEsp");
	
	g_pEnabled = register_cvar("amx_chatlogs", "1");	

	new szConfigsDir[32], szConfigFile[64];
	get_localinfo("amxx_configsdir", szConfigsDir, charsmax(szConfigsDir));
	format(szConfigFile, charsmax(szConfigFile), "%s/%s", szConfigsDir,
	g_szLogFilename); 

	new fConfig = fopen(szConfigFile, "rt"), szLine[32];	
	while (!feof(fConfig))
	{
		fgets(fConfig, szLine, charsmax(szLine));
		trim(szLine);

		if (szLine[0] == EOS || szLine[0] == ';' || (szLine[0] == '/' && szLine[1] == '/'))
			continue;
		
		register_clcmd(szLine, "onChat");
	}
	fclose(fConfig);

	get_time("Chat [%F].log", g_szLogFile, charsmax(g_szLogFile));
}

public onChat(id)
{
	if (!get_pcvar_bool(g_pEnabled))
		return;

	new szCommand[16], szMessage[32];

	read_argv(0, szCommand, charsmax(szCommand));
	read_args(szMessage, charsmax(szMessage));
	remove_quotes(szMessage);

	log_to_file(g_szLogFile, "(^"%s^") %n: %s", szCommand, id, szMessage);				
}
