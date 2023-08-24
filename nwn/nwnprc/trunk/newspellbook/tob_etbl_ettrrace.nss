/*
   ----------------
   Eternal Training racial type
   attack and damage bonus

   tob_etbl_ettrrace.nss
   ----------------

    10 MAR 09 by GC
*/ /** @file

    Sets attack and damage bonus against
    target's racial type.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"
#include "prc_inc_combat"

void main()
{
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();

    if (!PreManeuverCastCode())
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook

    // Blade guide check
    if(GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        FloatingTextStringOnCreature("*Cannot use ability without blade guide*", oInitiator, FALSE);
        return;
    }
    // Used in encounter already?
    if(GetLocalInt(oInitiator, "ETBL_Eternal_Training_Expended"))
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        FloatingTextStringOnCreature("*Eternal Training expended already*", oInitiator, FALSE);
        return;
    }
    // Check Intelligence modifier, exit if <= 0
    int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oInitiator);
    if(nInt <= 0)
    {
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
        FloatingTextStringOnCreature("*Intelligence modifier zero or less*", oInitiator, FALSE);
        return;
    }

    struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);

    if(move.bCanManeuver)
    {
        object oWeapon  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
        int nRace       = MyPRCGetRacialType(oTarget);
        int nDamageType = GetWeaponDamageType(oWeapon);
        if(DEBUG) DoDebug("Target raialtype: " + IntToString(nRace));

        effect eLink = VersusRacialTypeEffect(EffectAttackIncrease(nInt), nRace);
               eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nInt, nDamageType), nRace));
             //eLink = VersusRacialTypeEffect(eLink, nRace);
               eLink = ExtraordinaryEffect(eLink);
             //eLink = SupernaturalEffectEffect(eLink);

            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oInitiator);

        // Expend ability
        SetLocalInt(oInitiator, "ETBL_Eternal_Training_Expended", TRUE);
    }
    else
        IncrementRemainingFeatUses(oInitiator, FEAT_ETBL_ETERNAL_TRAINING);
}