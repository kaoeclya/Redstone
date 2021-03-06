/*
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#include <sdkhooks>

#include <smlib>

public Plugin:myinfo =  {
	name 		= "Reload Fix",
	author 		= "yed_",
	description 	= "Fix the problem with double-reloading of weapon",
	version 	= "dummy",
    	url 		= "https://github.com/yedpodtrzitko/ndix"
}

public OnPluginStart() {
	//g_ActiveWeaponOffset = FindSendPropInfo("CBasePlayer", "m_hActiveWeapon");
	HookEvent("weapon_reload", Event_WeaponReload, EventHookMode_Pre);

	LOOP_CLIENTS(client, CLIENTFILTER_INGAME) {
		SetEntProp(client, Prop_Data, "m_afButtonDisabled", 0);
	}
}

public OnPluginEnd() {
	LOOP_CLIENTS(client, CLIENTFILTER_INGAME) {
		SetEntProp(client, Prop_Data, "m_afButtonDisabled", 0);
	}
}

public Event_WeaponReload(Handle:event, const String:name[], bool:broadcast) {
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	SetEntProp(client, Prop_Data, "m_afButtonDisabled", IN_ATTACK2);
	if (IsClientInGame(client) && !IsFakeClient(client)) {
		CreateTimer(0.3, Timer_EnableAttack2, client, TIMER_REPEAT);

	}
}


public Action:Timer_EnableAttack2(Handle:timer, any:client) {
	if (client < 1 || !IsClientInGame(client)) {
		return Plugin_Stop;
	}

	new g_ActiveWeaponOffset = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if (g_ActiveWeaponOffset == -1 ) {
		return Plugin_Stop;
	}

	new i_Weapon = GetEntDataEnt2(client, g_ActiveWeaponOffset);
	if (i_Weapon == -1 || !IsValidEdict(i_Weapon)) {
		SetEntProp(client, Prop_Data, "m_afButtonDisabled", 0);
		return Plugin_Stop;
	}

	if (GetEntProp(i_Weapon, Prop_Data, "m_bInReload")) {
		return Plugin_Continue;
	}

	SetEntProp(client, Prop_Data, "m_afButtonDisabled", 0);
	return Plugin_Stop;
}

/*
public Action:OnPlayerRunCmd(client, &buttons, &impulse, float vel[3], float angles[3], &weapon)
{

	if (GetEntProp(i_Weapon, Prop_Data, "m_bInReload")) {
		Client_RemoveButtons(client, IN_ATTACK2);

		return Plugin_Changed;
	}

	return Plugin_Continue;
}
*/
