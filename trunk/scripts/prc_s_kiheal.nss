//::///////////////////////////////////////////////
//:: Lay_On_Hands
//:: NW_S2_LayOnHand.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Paladin is able to heal his Chr Bonus times
    his level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:: Updated On: Oct 20, 2003
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nWis = GetAbilityModifier(ABILITY_WISDOM);
    int nBonus = nWis;
    int nLevel = GetLevelByClass(CLASS_TYPE_RED_AVENGER);

    if(GetHasFeat(FEAT_FREE_KI_2, OBJECT_SELF))
        nBonus += nWis;
    if(GetHasFeat(FEAT_FREE_KI_3, OBJECT_SELF))
        nBonus += nWis;
    if(GetHasFeat(FEAT_FREE_KI_4, OBJECT_SELF))
        nBonus += nWis;

    // Caluclate the amount to heal, min is 1 hp
    int nHeal = nLevel * nBonus;
    //over level 8 its Greater Healing
    if(nLevel >= 8)
        nHeal *= 2;
    if(nHeal <= 0)
        nHeal = 1;
    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eDam;
    int nTouch;
    
/* Doesnt mention Undead harming in the rules
    //Undead are damaged instead of healed
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget)>0)
    {
        //Make a ranged touch attack
        nTouch = PRCDoMeleeTouchAttack(oTarget);;

        int nResist = MyResistSpell(OBJECT_SELF,oTarget);
        if (nResist == 0 )
        {
            if(nTouch > 0)
            {
                if(nTouch == 2)
                {
                    nHeal *= 2;
                }

                eDam = EffectDamage(nHeal, DAMAGE_TYPE_DIVINE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            }
        }
    }
    else
    {
    */
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    //}

}

