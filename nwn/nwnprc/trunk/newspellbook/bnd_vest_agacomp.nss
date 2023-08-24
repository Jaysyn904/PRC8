/*
03/03/21 by Stratovarius

Agares, Truth Betrayed
  
Agares died at the hands of his allies for a wrong he did not commit. As a vestige, not only does he give binders the ability to weaken foes and knock them prone, but he also makes his summoner fearless.

Vestige Level: 4th
Binding DC: 22
Special Requirement: You must draw Agares’s seal upon either the earth or an expanse of unworked stone.

Influence: Agares’s loyalty in life and his anger at the betrayal perpetrated by his lieutenants has become a hatred of falsehood. When influenced
by Agares, you speak forthrightly and with confidence. You cannot use the Bluff skill, and when asked a direct question, you must answer truthfully and directly.

Granted Abilities: 
Agares gives you the power to exalt yourself and your allies, to make the earth tremble beneath your feet, and to render foes weak.

Elemental Companion: You can summon an earth elemental to accompany you and fight for you. If you lose your elemental, you cannot summon it again for 1 hour. 
The size of the earth elemental you can summon depends on your effective binder level. Below 11th, small. Below 15th, medium. Below 19th, large. 19th and above, huge.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    
	if (GetLocalInt(oBinder, "AgaresDelay")) return;    
    
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_AGARES);
    string sSummon = "bnd_agares_small";
    
    if (nBinderLevel >= 19) sSummon = "bnd_agares_huge";
    else if (nBinderLevel >= 15) sSummon = "bnd_agares_large";
    else if (nBinderLevel >= 11) sSummon = "bnd_agares_med";
    
    int i = 1;
    int nCheck;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oBinder, i);
    while(GetIsObjectValid(oSummon))
    {
        if (GetResRef(oSummon) == "bnd_agares_small" ||
            GetResRef(oSummon) == "bnd_agares_med" ||
            GetResRef(oSummon) == "bnd_agares_large" ||
            GetResRef(oSummon) == "bnd_agares_huge")
            return;
        
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oBinder, i);            
    }    
        
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sSummon, VFX_FNF_SUMMON_MONSTER_3), PRCGetSpellTargetLocation(), HoursToSeconds(24));
    SetLocalInt(oBinder, "AgaresSummoned", TRUE);
}