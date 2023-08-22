//::///////////////////////////////////////////////
//:: Summon Undead
//:: X2_S2_SumUndead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     The level of the Pale Master determines the
     type of undead that is summoned.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated By: Georg Zoeller, Oct 2003
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void PMUpgradeSummon(object oSelf, string sScript)
{
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oSelf);
    ExecuteScript ( sScript, oSummon);
}

void main()
{
    //Declare major variables
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF);
    int nDuration = 14 + nCasterLevel;


    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    //Summon the appropriate creature based on the summoner level
    if (nCasterLevel <= 5)
    {
        //Ghoul
        eSummon = EffectSummonCreature("NW_S_GHOUL",VFX_IMP_HARM,0.0f,0);
    }
    else if (nCasterLevel == 6)
    {
        //Shadow
        eSummon = EffectSummonCreature("NW_S_SHADOW",VFX_IMP_HARM,0.0f,0);
    }
    else if (nCasterLevel == 7)
    {
        //Ghast
        eSummon = EffectSummonCreature("NW_S_GHAST",VFX_IMP_HARM,0.0f,1);
    }
    else if (nCasterLevel == 8)
    {
        //Wight
        eSummon = EffectSummonCreature("NW_S_WIGHT",VFX_FNF_SUMMON_UNDEAD,0.0f,1);
    }
    else if (nCasterLevel >= 9)
    {
        //Wraith
        eSummon = EffectSummonCreature("X2_S_WRAITH",VFX_FNF_SUMMON_UNDEAD,0.0f,1);
    }
    // * Apply the summon visual and summon the two undead.
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_LOS_EVIL_10),PRCGetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), HoursToSeconds(nDuration));

    // * If the character has a special pale master item equipped (variable set via OnEquip)
    // * run a script on the summoned monster.
    string sScript = GetLocalString(OBJECT_SELF,"X2_S_PM_SPECIAL_ITEM");
    if (sScript != "")
    {
        object oSelf = OBJECT_SELF;
        DelayCommand(1.0,PMUpgradeSummon(oSelf,sScript));
    }
//   object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
//   CorpseCrafter(OBJECT_SELF, oSummon);     
}


