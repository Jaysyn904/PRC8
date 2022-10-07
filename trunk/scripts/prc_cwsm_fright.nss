//::///////////////////////////////////////////////
//:: Complete Warrior Samurai Frightful Presence
//:: prc_cwsm_fright
//::///////////////////////////////////////////////
/** @file prc_cwsm_fright
    A 20th-level Samurais bravery, honor, and
    fighting prowess have become legendary. When
    the samurai draws his blade, opponents within
    30 feet must succeed on a Will save(DC 20 + Cha
    Modifier) or become panicked for 4d6 rounds (if
    they have 4 or fewer Hit Dice) or shaken for 4d6
    rounds (if they have more than 4 Hit Dice, but
    fewer than the Samurai). Creatures with more Hit
    Dice then the Samurai are not affected.
    Any foe that successfully resists the effect
    cannot be affected again by the same samurai's
    frightful presence for 24 hours.

    SRD on panicked:
    A panicked creature must drop anything it holds and
    flee at top speed from the source of its fear, as
    well as any other dangers it encounters, along a
    random path. It can’t take any other actions.
    In addition, the creature takes a –2 penalty on all
    saving throws, skill checks, and ability checks. If
    cornered, a panicked creature cowers and does not
    attack, typically using the total defense action in
    combat. A panicked creature can use special abilities,
    including spells, to flee; indeed, the creature must
    use such means if they are the only way to escape.

    SRD on shaken:
    A shaken character takes a –2 penalty on attack rolls,
    saving throws, skill checks, and ability checks.

    @author Ornedan
    @date   Created - 2006.07.05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC   = GetItemLastEquippedBy();
    object oItem = GetItemLastEquipped();

    // Check if the character should still have this eventhook
    if(!GetHasFeat(FEAT_CWSM_FRIGHTFUL_PRESENCE, oPC))
    {
        // Missing the feat, unhook and abort
        RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "prc_cwsm_fright", TRUE, FALSE);
        return;
    }

    // To save CPU use, don't run this for both weapons in a double-equip. Implemented as a 2 second lock between uses.
    // This doesn't make any difference to the effectiveness of the ability, since anyone that wasn't already affected
    // by the first draw will be immune for 24h anyway
    if(GetLocalInt(oPC, "PRC_CWSM_Fright_Lock"))
        return;

    // Determine if a blade was drawn. In this case, blade = katana || short sword
    if(GetBaseItemType(oItem) == BASE_ITEM_KATANA || GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD)
    {
        // Set the lock variable and queue unlock
        SetLocalInt(oPC, "PRC_CWSM_Fright_Lock", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oPC, "PRC_CWSM_Fright_Lock"));

		effect eShaken   = ExtraordinaryEffect(EffectShaken());
        // Construct Panicked effect
        effect ePanicked = EffectLinkEffects(eShaken, EffectFrightened());
               ePanicked = EffectLinkEffects(ePanicked, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
        // Make the effects extraordinary
        ePanicked        = ExtraordinaryEffect(ePanicked);

        // Radius = 30ft
        float fRadius    = FeetToMeters(30.0f);
        float fDuration;

        // DC = 20 + Samurai's Cha mod
        int nDC          = 20 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
        int nPCHitDice   = GetHitDice(oPC);
        int nTargetHitDice;
        int bDoVFX = FALSE;

        // The samurai's object ID for enforcing the 24h rule
        string sPCOid = ObjectToString(oPC);

        // Loop over creatures in range
        location lTarget = GetLocation(oPC);
        object oTarget   = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
        while (GetIsObjectValid(oTarget))
        {
            // Target validity check
            if(oTarget != oPC                                              && // Can't affect self
               !GetLocalInt(oTarget, "PRC_CWSM_Fright_SavedVs" + sPCOid)   && // Hasn't saved successfully against this samurai's Frightful Presence in the last 24h
               spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && // Only hostiles
               nPCHitDice > (nTargetHitDice = GetHitDice(oTarget))            // Target must have less HD than the samurai
               )
            {
                // Set the marker that tells we tried to affect someone
                bDoVFX = TRUE;

                // Let the target know something hostile happened
                SignalEvent(oTarget, EventSpellCastAt(oPC, -1, TRUE));

                // Will save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oPC) &&
                   !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oPC) // Explicit immunity check, because of the fucking stupid BW immunity handling
                   )
                {
                    // Roll duration
                    fDuration = RoundsToSeconds(d6(4));

                    // HD 4 or less - panicked
                    if(nTargetHitDice <= 4)
                    {
                        // Assign commands to drop items in left & right hands
                        if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)))
                            AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)));
                        if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
                            AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)));

                        // Apply the effect
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePanicked, oTarget, fDuration);
                    }
                    // More then 4 HD, less than the samurai - shaken
                    else
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, fDuration);
                }
                // Successfull save, set marker and queue marker deletion
                else
                {
                    SetLocalInt(oTarget, "PRC_CWSM_Fright_SavedVs" + sPCOid, TRUE);

                    // Add variable deletion to the target's queue. That way, if the samurai logs out, it will still get cleared
                    AssignCommand(oTarget, DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "PRC_CWSM_Fright_SavedVs" + sPCOid)));
                }
            }// end if - Target validity check

            // Get next target in area
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
        }// end while - Loop over creatures in 30ft area

        // If we tried to affect someone, do war cry VFX
        if(bDoVFX)
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(GetGender(oPC) == GENDER_FEMALE ? VFX_FNF_HOWL_WAR_CRY_FEMALE : VFX_FNF_HOWL_WAR_CRY),
                                oPC
                                );
    }// end if - Equipped a "blade"
}
