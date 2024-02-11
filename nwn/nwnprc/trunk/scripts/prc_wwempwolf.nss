//::///////////////////////////////////////////////
//:: Summons a Wolf or Dire Wolf
//:: prc_wwempwolf
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 11, 2004
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_feat_const"
#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    string sWolf = "prc_s_wolf";

    //Can only turn into a werewolf if level 2 in werewolf class
    if (!GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
    {
        FloatingTextStringOnCreature("You can only use your wolf empathy skills if you are at least level 2 in the werewolf class", oPC, FALSE);
        IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_WOLF_EMPATHY);
        return;
    }

    int nLevel = GetLevelByClass(CLASS_TYPE_WEREWOLF);
    string sLevel;

    sLevel = "00" + IntToString(nLevel);

    sWolf += sLevel;

    //Apply the VFX impact and summon effect
    //MultisummonPreSummon(OBJECT_SELF);
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSummonCreature(sWolf, VFX_FNF_NATURES_BALANCE, 0.0, 1), oPC);

    int iHench = GetMaxHenchmen();
    SetMaxHenchmen(iHench + 1);
    object oWolf;
    effect eVis = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
    oWolf = CreateObject(OBJECT_TYPE_CREATURE, sWolf, GetSpellTargetLocation());
    AddHenchman(OBJECT_SELF, oWolf);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    SetMaxHenchmen(iHench);
}
