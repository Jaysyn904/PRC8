//::///////////////////////////////////////////////
//:: Soul Tyrant
//:: race_wrsl_tyrant.nss
//:://////////////////////////////////////////////
/*
     As a swift action, a warsoul can draw arcane 
	power from a willing hobgoblin within 30 feet who has 10 
	or fewer hit points. That hobgoblin is immediately slain, 
	leaving behind a desiccated corpse. The warsoul heals 1 
	hit point per Hit Die she has, and she receives a +2 bonus 
	to the save DC of the next spell she casts. She also gains 
	a +2 bonus on any attack roll required by the next spell 
	she casts. If that spell deals damage, the warsoul receives 
	a bonus on the damage roll equal to her Hit Dice.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Oct 27th, 2024
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_npc"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    string sRes = GetResRef(oTarget);
    object oMaster = GetMaster(oTarget);

    // If it has no master, it can be cleaned up as well
    if (OBJECT_SELF == oMaster || !GetIsObjectValid(oMaster))
    {
        if(sRes == "prc_wrsl_war")
        {
            DestroyObject(oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetHitDice(OBJECT_SELF)), OBJECT_SELF); 
            SetLocalInt(OBJECT_SELF, "WarsoulTyrant", 2);
        }
    }
}
