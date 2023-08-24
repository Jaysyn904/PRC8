//::///////////////////////////////////////////////
//:: Frightful Presence
//:: prc_fright_presence
//::///////////////////////////////////////////////
/** 
    When you charge, attack, or cast a spell while wearing the helm, 
    your frightful presence might affect enemies within 30 feet who 
    have fewer Hit Dice than you. Creatures of 4 or fewer Hit Dice 
    become panicked for 1 minute, and creatures of 5 or more Hit 
    Dice become shaken for 1 minute. A successful Will save (DC 17
    or 15 + your Cha modifier, whichever is higher) negates either 
    effect. Whether the saving throw succeeds or fails, the creature
    is immune to your frightful presence for 24 hours. Dragons are immune
    to your frightful presence regardless of their Hit Dice. 
    
    @author Stratovarius
    @date   Created - 20.07.2020
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
		object oPC = OBJECT_SELF;
		effect eShaken   = ExtraordinaryEffect(EffectShaken());
        // Construct Panicked effect
        effect ePanicked = EffectLinkEffects(eShaken, EffectFrightened());
               ePanicked = EffectLinkEffects(ePanicked, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
        // Make the effects extraordinary
        ePanicked        = ExtraordinaryEffect(ePanicked);

        // Radius = 30ft
        float fRadius    = FeetToMeters(30.0f);
        float fDuration;

        int nDC = 17;            
        if (15 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
            nDC = 20 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
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
               spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))   // Only hostiles
            {
                // Set the marker that tells we tried to affect someone
                bDoVFX = TRUE;

                // Let the target know something hostile happened
                SignalEvent(oTarget, EventSpellCastAt(oPC, -1, TRUE));

                // Will save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oPC) &&
                   !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oPC) &&  // Explicit immunity check, because of the fucking stupid BW immunity handling
                   MyPRCGetRacialType(oTarget) != RACIAL_TYPE_DRAGON)
                {
                    // Roll duration
                    fDuration = 60.0;

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
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(GetGender(oPC) == GENDER_FEMALE ? VFX_FNF_HOWL_WAR_CRY_FEMALE : VFX_FNF_HOWL_WAR_CRY), oPC);
}
