#pragma semicolon 1

#define PLUGIN_AUTHOR "F0rest"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <cstrike>
//#include <sdkhooks>

#pragma newdecls required

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Random team",
	author = PLUGIN_AUTHOR,
	description = "Random team when round start",
	version = PLUGIN_VERSION,
	url = "https://github.com/F0rest-csgo"
};

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	HookEvent("round_start", OnRoundStart);
}

public void OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	int team;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if(IsValidClient(i) && GetClientTeam(i) > CS_TEAM_NONE && GetClientTeam(i) < CS_TEAM_SPECTATOR)
		{
			team = GetRandomInt(1, 2);
			CS_SwitchTeam(i, team);
			
		}
	}
	if(GetClientCount() % 2 == 1)
	{
		while(GetTeamClientCount(CS_TEAM_T) > GetTeamClientCount(CS_TEAM_CT)-1)
		{
			RandomlySwitchTeam(CS_TEAM_T, CS_TEAM_CT);
		}
		while(GetTeamClientCount(CS_TEAM_T) < GetTeamClientCount(CS_TEAM_CT)-1)
		{
			RandomlySwitchTeam(CS_TEAM_CT, CS_TEAM_T);
		}
	}
	else
	{
		while(GetTeamClientCount(CS_TEAM_T) > GetTeamClientCount(CS_TEAM_CT))
		{
			RandomlySwitchTeam(CS_TEAM_T, CS_TEAM_CT);
		}
		while(GetTeamClientCount(CS_TEAM_T) < GetTeamClientCount(CS_TEAM_CT))
		{
			RandomlySwitchTeam(CS_TEAM_CT, CS_TEAM_T);
		}
	}
}

void RandomlySwitchTeam(int from,int team_to)
{
	int i = GetRandomInt(1,MaxClients);
	while(!IsValidClient(i) || GetClientTeam(i) != from)
	{
		i = GetRandomInt(1, MaxClients);
	}
	CS_SwitchTeam(i, team_to);
}

int GetTeamClientCount(int team)
{
	int count = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == team)
		{
			count++;
		}
	}
	return count;
}

bool IsValidClient(int client) {
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || !IsClientConnected(client) || IsFakeClient(client) || IsClientSourceTV(client))
		return false;
	
	return true;
}