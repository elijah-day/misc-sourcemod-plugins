#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>

/*
 * TODO:
 * - Make a mechanism that allows players to change their bonus that doesn't
 *   respawn them.  (But it only takes effect when they respawn.)
 *   - For all intents and purposes, each player has a "bonus" var that can be set
 *     to one thing or another.  On respawn it loads the effects that the player
 *     should have.  Look into per-players vars?
 * - Make it more modular.  (Load each bonus in from a file/database on server 
 *   startup.)
 * - Add more bonuses.
 * - 
 */

/*BONUS_LIST Length*/
/*Only the first dimension on this one.*/
char BONUS_LIST[7][2][128] = {
    
    {"critical","Any damage you do or receive becomes mini-crits."},
    {"bumper" , "Ride a bumper car into battle."},
    {"ghost", "Live on past death and haunt your enemies as an (almost) useless spirit."},
    {"lucky", "Survive any damage that would have normally killed you.  (One use per life!)"},
    {"speedy", "Gain a permanent speed boost."},
    {"stealthy", "Remain cloaked while not immediately attacking, coming at the cost of defense."},
    {"tank", "Take reduced damage with a speed loss."}
}

public Plugin myinfo = {
        
        name = "Bonus",
        author = "",
        description = "",
        version = "1.0.0",
        url = ""
}

void setPlayerBonus(int client, int bonusID) {
    
    switch(bonusID) {
       
        case 0: {
            
            TF2_AddCondition(client, 19, TFCondDuration_Infinite, 0);
            TF2_AddCondition(client, 48, TFCondDuration_Infinite, 0);
        }
        
        case 1: 
            TF2_AddCondition(client, 82, TFCondDuration_Infinite, 0);
        case 2: 
            TF2_AddCondition(client, 76, TFCondDuration_Infinite, 0);
        case 3: 
            TF2_AddCondition(client, 70, TFCondDuration_Infinite, 0);
        case 4:
            TF2_AddCondition(client, 32, TFCondDuration_Infinite, 0);
        case 5: {
            
            TF2_AddCondition(client, 66, TFCondDuration_Infinite, 0);
            TF2_AddCondition(client, 48, TFCondDuration_Infinite, 0);
        }
        case 6: {
        
            TF2_AddCondition(client, 42, TFCondDuration_Infinite, 0);
            TF2_StunPlayer(client, 999999999.00, 0.35, TF_STUNFLAG_SLOWDOWN, 0);
        }
    }
}

void printBonusList(int client) {
    
    /*BONUS_LIST Length*/
    PrintToChat(client, "Bonus List (More To Come!):");
    for(int i = 0; i < 7; i++)
    PrintToChat(client, "\"%s\": %s", BONUS_LIST[i][0], BONUS_LIST[i][1]);
}

public Action Command_Bonus(int client, int args) {
    
    char arg1[32];
    GetCmdArg(1, arg1, sizeof(arg1));
    if(strcmp(arg1, "") == 0) {
        
        PrintToChat(client, "Usage:");
        PrintToChat(client, "/bonus <bonus name>");
        PrintToChat(client, "/bonus list");
    }
    
    else if(strcmp(arg1, "list") == 0) printBonusList(client);
    else {
        
        /*BONUS_LIST Length*/
        for(int i = 0; i < 7; i++) {
            
            if(strcmp(arg1, BONUS_LIST[i][0]) == 0) {
            
                TF2_RespawnPlayer(client);
                setPlayerBonus(client, i);
                break;
            }
        } 
    }
    
    return Plugin_Handled;
}

public void OnPluginStart() {
    
    RegConsoleCmd("sm_bonus", Command_Bonus);
}
