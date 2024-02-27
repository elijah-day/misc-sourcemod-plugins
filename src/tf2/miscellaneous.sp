#include <sdktools>
#include <sourcemod>
#include <tf2>
#include <tf2_stocks>

public Plugin myinfo = {
    
    name = "Miscellaneous",
    author = "",
    description = "",
    version = "1.0.0",
    url = ""
}

public bool rayHitPlayer(entity, mask, any: data) {
    
    if(entity == data) return false;
    else return true;
}

public Action SOAS(Handle timer) {
    
    for(int i = 1; i < 25; i++) {
        
        if(IsClientInGame(i)) {
            
            new weapon = GetEntPropEnt(i, Prop_Send, "m_hActiveWeapon");
            new weaponIndex = GetEntProp(
                
                weapon,
                Prop_Send,
                "m_iItemDefinitionIndex"
            );
            
            /*if(weaponIndex == 349 || weaponIndex == 442 || weaponIndex == 1123)*/
                
            TF2_AddCondition(i, 11, TFCondDuration_Infinite, 0);
            TF2_RemoveCondition(i, 11);
        }
    }
}

public Action Command_Spell(int client, int args) {
    
    float pos[3];
    GetClientEyePosition(client, pos);
    new EntIndex = CreateEntityByName("halloween_souls_pack");
    DispatchSpawn(EntIndex);
    ActivateEntity(EntIndex);
    TeleportEntity(EntIndex, pos, NULL_VECTOR, NULL_VECTOR);
    return Plugin_Handled;
}

public Action Command_TP(int client, int args) {
    
    float pos[3];
    float opos[3];
    float angles[3];
    GetClientEyePosition(client, pos);
    GetClientEyePosition(client, opos);
    GetClientEyeAngles(client, angles);
    
    Handle hTraceRay = TR_TraceRayFilterEx(
        
        pos,
        angles,
        MASK_PLAYERSOLID,
        RayType_Infinite,
        rayHitPlayer,
        client
    );
    
    if(TR_DidHit(hTraceRay)) TR_GetEndPosition(pos, hTraceRay);
    delete hTraceRay;
    
    TeleportEntity(client, pos, NULL_VECTOR, NULL_VECTOR);
    
    /*new EntIndex = CreateEntityByName("tf_zombie");
    DispatchSpawn(EntIndex);
    ActivateEntity(EntIndex);
    TeleportEntity(EntIndex, opos, NULL_VECTOR, NULL_VECTOR);*/
    
    return Plugin_Handled;
}

public Action Command_Swap(int client, int args) {
    
    float pos[3], epos[3], angles[3], eangles[3];
    int eclient = GetClientAimTarget(client, true);
    
    GetClientAbsOrigin(client, pos);
    GetClientAbsOrigin(eclient, epos);
    
    GetClientAbsAngles(client, angles);
    GetClientAbsAngles(eclient, eangles);
    
    TeleportEntity(client, epos, eangles, NULL_VECTOR);
    TeleportEntity(eclient, pos, angles, NULL_VECTOR);
    
    return Plugin_Handled;
}

public void OnPluginStart() {
    
    RegConsoleCmd("sm_tp", Command_TP);
    RegConsoleCmd("sm_spell", Command_Spell);
    RegConsoleCmd("sm_swap", Command_Swap);
}
