//::///////////////////////////////////////////////
//:: Name listener_spawn
//:: Copyright (c) 2005
//:://////////////////////////////////////////////
/*
    Modified spawn script, includes PRC
        and listen patterns
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Oct 9, 2005
//:://////////////////////////////////////////////

void main()
{


    //Shout Listen Patterns
    SetListenPattern(OBJECT_SELF, "(lvl|level) *n", 5000);
    
    SetListenPattern(OBJECT_SELF, "(gp|gold) *n", 5004);
    
    SetListenPattern(OBJECT_SELF, "reset (levels|me)", 5001);
    
    
    SetListenPattern(OBJECT_SELF, "(ge|good(|/| )evil) *n", 5002);
    
    SetListenPattern(OBJECT_SELF, "(lc|(law|lawful)(|/| )(chaos|chaotic)) *n", 5003);
    
    //SetListenPattern(OBJECT_SELF, "shop *a", 5005);
    
    SetListenPattern(OBJECT_SELF, "(recharge|recharge me)", 5006);
    
    SetListenPattern(OBJECT_SELF, "(xp|experience|exp) *n", 5007);
    
    //SetListenPattern(OBJECT_SELF, "**", 6000);
    SetListening(OBJECT_SELF, TRUE);
    
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), OBJECT_SELF);
    
}