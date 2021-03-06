#if defined _nd_balancer2_included
  #endinput
#endif
#define _nd_balancer2_included

/**
 * Retreive the average skill on the server
 * Currently on a scale of 1-80 level and 80-120 enhanced skill
 *
 * @return the average skill as a float value
 */
native Float:GetAverageSkill();

#define GAS_AVAILBLE() (GetFeatureStatus(FeatureType_Native, "GetAverageSkill") == FeatureStatus_Available)

/**
 * Refresh the team balancer cache
 *
 */
native RefreshTBCache();

#define RTBC_AVAILIBLE() (GetFeatureStatus(FeatureType_Native, "RefreshTBCache") == FeatureStatus_Available)

forward void TB_OnTeamPlacement(int client, int team);


/**
 * Return if after shuffle team locks are currently enabled
 *
 */
native bool TB_TeamsLocked();

#define TB_TL_AVAILIBLE() (GetFeatureStatus(FeatureType_Native, "TB_TeamsLocked") == FeatureStatus_Available)

stock bool TB_AreTeamsLocked() {
	return TB_TL_AVAILIBLE() && TB_TeamsLocked();
}