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

#include "prc_inc_sp_tch"
void main()
{

    object oTarget = PRCGetSpellTargetObject();
    int nChr = GetAbilityModifier(ABILITY_CHARISMA);

    // Added by Starlight 2004-5-14
    // Check whether the character has "Hand of A Healer Feat" and
    // with 13+ Charisma
    // If yes, +2 to Charisma Score during casting Lay On Hands
    // i.e. +1 bonus to Charisma Modifier
    if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD){
        if (GetHasFeat(FEAT_HAND_HEALER)){
            nChr = nChr + 1;
        }
    }
    // End of Hand of Healer Code

    if (nChr < 0)
    {
        nChr = 0;
    }
    int nLevel = GetLevelByClass(CLASS_TYPE_PALADIN);

    //--------------------------------------------------------------------------
    // July 2003: Add Divine Champion levels to lay on hands ability
    //--------------------------------------------------------------------------
    nLevel += GetLevelByClass(CLASS_TYPE_DIVINECHAMPION);
    nLevel += GetLevelByClass(CLASS_TYPE_HOSPITALER);
    nLevel += GetLevelByClass(CLASS_TYPE_COC);
	nLevel += GetEssentiaInvestedFeat(OBJECT_SELF, FEAT_AZURE_TOUCH);

    //--------------------------------------------------------------------------
    // Caluclate the amount to heal, min is 1 hp
    //--------------------------------------------------------------------------
    int nHeal = nLevel * nChr;
    if(nHeal <= 0)
    {
        nHeal = 1;
    }
    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eEVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eEVis2 = EffectVisualEffect(VFX_IMP_DESTRUCTION);
    effect eDam;
    int nTouch;

// evil paladins should not heal non-undead, they should do damage, and heal undead. ~ Lock

     if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
    {
     if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget)>0
     || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
     {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS, FALSE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEVis2, oTarget);
       }
       else
     {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
        //Make a ranged touch attack
        nTouch = PRCDoMeleeTouchAttack(oTarget);;

        //----------------------------------------------------------------------
        // GZ: The PhB classifies Lay on Hands as spell like ability, so it is
        //     subject to SR. No more cheesy demi lich kills on touch, sorry.
        //----------------------------------------------------------------------
        int nResist = PRCDoResistSpell(OBJECT_SELF, oTarget, nLevel + SPGetPenetr());
        if (nResist == 0 )
        {
            if(nTouch > 0)
            {
                if(nTouch == 2)
                {
                    nHeal *= 2;
                }
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
                eDam = PRCEffectDamage(oTarget, nHeal, DAMAGE_TYPE_DIVINE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eEVis, oTarget);
            }
        }
       }
    }

    //--------------------------------------------------------------------------
    // A good-aligned paladin can use his lay on hands ability to damage undead creatures
    // having undead class levels qualifies as undead as well
    //--------------------------------------------------------------------------

if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD || GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
{
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget)>0
    || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
        //Make a ranged touch attack
        nTouch = PRCDoMeleeTouchAttack(oTarget);;

        //----------------------------------------------------------------------
        // GZ: The PhB classifies Lay on Hands as spell like ability, so it is
        //     subject to SR. No more cheesy demi lich kills on touch, sorry.
        //----------------------------------------------------------------------
        int nResist = PRCDoResistSpell(OBJECT_SELF, oTarget, nLevel + SPGetPenetr());
        if (nResist == 0 )
        {
            if(nTouch > 0)
            {
                if(nTouch == 2)
                {
                    nHeal *= 2;
                }
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
                eDam = PRCEffectDamage(oTarget, nHeal, DAMAGE_TYPE_DIVINE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            }
        }
    }
    else
    {

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS, FALSE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}

}

