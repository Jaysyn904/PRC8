//::///////////////////////////////////////////////
//:: Soulknife: Mindblade OnHit
//:: psi_sk_onhit
//::///////////////////////////////////////////////
/*
    Handles Psychic Strike + Knife To The Soul
    and various mindblade enhancements that
    need special handling
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 08.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "inc_dispel"
#include "psi_inc_psifunc"

// Notes to self
// - While bladewind is active, lose Psych Strike normally, but store it and affect all based on that (or not)

// * returns true if oCreature does not have a mind
int PRCIsMindless(object oCreature)
{
    int nRacialType = MyPRCGetRacialType(oCreature);
    int nMindless;
    switch(nRacialType)
    {
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_VERMIN:
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_OOZE:
        nMindless = TRUE;
    }
    if(GetAbilityScore(oCreature, ABILITY_INTELLIGENCE) > 3)
        nMindless = FALSE;

    return nMindless;
}

void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(oPC);
    object oItem   = PRCGetSpellCastItem(oPC);
    int nFlags = GetPersistantLocalInt(oPC, MBLADE_FLAGS);

/*
// motu99: obsolate, is handled in PRCGetSpellCastItem
	// Scripted combat system
	if(!GetIsObjectValid(oItem))
	{
		oItem = GetLocalObject(oPC, "PRC_CombatSystem_OnHitCastSpell_Item");
	}
*/

    /* In order to bypass a BioBug where when the last item in a stack of throwable weapons is thrown,
     * GetSpellCastItem returns OBJECT_INVALID, the stack size is increased to be one larger than the amount the PC
     * is allowed to throw.
     * If the stack size has reached 1, ie. we are handling the last they are supposed to throw, delete the remaining thrown weapon.
     */
    if(GetTag(oItem) == "prc_sk_mblade_th" && GetItemStackSize(oItem) == 1)
    {
        MyDestroyObject(oItem);
    }

    int bMainHandPStrk = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem && GetLocalInt(oPC, PSYCHIC_STRIKE_MAINH);
    int bOffHandPStrk  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)  == oItem && GetLocalInt(oPC, PSYCHIC_STRIKE_OFFH);

    //SendMessageToPC(oPC, "Debug: starting main part of psi_sk_onhit");

    // Handle Psychic Strike
    if(bMainHandPStrk || bOffHandPStrk || GetLocalInt(oPC, "PRC_Soulknife_BladewindAndPStrike"))
    {
        // Check if the target is valid for Psychic Strike
        int nRacialType = MyPRCGetRacialType(oTarget);
        if(// A creature
           GetObjectType(oTarget) == OBJECT_TYPE_CREATURE
           && !( // And not
             // Non-living or
             nRacialType == RACIAL_TYPE_UNDEAD              ||
             (nRacialType == RACIAL_TYPE_CONSTRUCT && !GetIsWarforged(oTarget)) ||
             // Mindless or
             PRCIsMindless(oTarget)                      ||
             // Immune to mind-affecting
             GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)
             )
           )
        {
            // Lose Psychic Strike, unless this was a Bladewind attack other than the first
            if(bMainHandPStrk)
                SetLocalInt(oPC, PSYCHIC_STRIKE_MAINH, FALSE);
            if(bOffHandPStrk)
                SetLocalInt(oPC, PSYCHIC_STRIKE_OFFH, FALSE);
            // If we are Bladewinding and had Psychic Strike at the start, mark it
            if((bMainHandPStrk || bOffHandPStrk) && GetLocalInt(oPC, BLADEWIND))
            {
                // When Bladewinding, lose both main and offhand charges
                SetLocalInt(oPC, PSYCHIC_STRIKE_MAINH, FALSE);
                SetLocalInt(oPC, PSYCHIC_STRIKE_OFFH, FALSE);

                // Mark the Bladewind so that every target hit gets Psychic Striked
                SetLocalInt(oPC, "PRC_Soulknife_BladewindAndPStrike", TRUE);
                DelayCommand(1.0, DeleteLocalInt(oPC, "PRC_Soulknife_BladewindAndPStrike"));
            }
            FloatingTextStringOnCreature("* " + GetStringByStrRef(16824456) + " *", oPC);// * Psychic Strike *

            int nPsychDice = (GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC) + 1) / 4;
            int nKTTSDice  = GetLocalInt(oPC, KTTS) >>> 2;
            int nKTTSType  = GetLocalInt(oPC, KTTS) & KTTS_TYPE_MASK;

            // Calculate Psychic Strike dice left unused and apply KTTS
            if(nKTTSType != KTTS_TYPE_OFF && nKTTSDice > 0)
            {
                nPsychDice -= nKTTSDice;
                if(nPsychDice < 0){
                    nKTTSDice += nPsychDice;
                    nPsychDice = 0;
                }
                FloatingTextStringOnCreature("* " + GetStringByStrRef(16824466) + " *", oPC); // * Knife to the Soul *

                //SendMessageToPC(oPC, "KTTS - Type: " + IntToString(nKTTSType) + "; Dice: " + IntToString(nKTTSDice));

                ApplyAbilityDamage(oTarget, nKTTSType == KTTS_TYPE_INT ? ABILITY_INTELLIGENCE :
                                            nKTTSType == KTTS_TYPE_WIS ? ABILITY_WISDOM :
                                            ABILITY_CHARISMA
                                          , nKTTSDice, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
            }

            // Apply Psychic Strike damage if there are any dice left
            if(nPsychDice)
            {
                effect eDam = EffectDamage(d8(nPsychDice), DAMAGE_TYPE_MAGICAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oTarget);
            }
        }// end if - target is valid for Psychic Strike
    }// end if - try dealing Psychic Strike damage

    //SendMessageToPC(oPC, "Flags: " + IntToString(nFlags));

    // Apply the various enhancement effects
    if(nFlags & MBLADE_FLAG_VICIOUS)
    {// A vicious mindblade creates a flash of disruptive energy whenever it hits, dealing 2d6 damage to the target hit and 1d6 to the wielder.
        //SendMessageToPC(oPC, "Vicious");
        effect eDam = EffectDamage(d6(2), DAMAGE_TYPE_MAGICAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        eDam = EffectDamage(d6(1), DAMAGE_TYPE_MAGICAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
    }
    if(nFlags & MBLADE_FLAG_MINDCRUSHER)
    {// Any psionic creature struck by the mindblade loses a number of power points equal to half a roll of the weapon's base damage. If the creature is out of power points must succeed on a DC 17 Will save or take 1d2 points of Wisdom damage.
        //SendMessageToPC(oPC, "Mindcrusher");
        if(GetIsPsionicCharacter(oTarget))
        {
            int nPPLoss;
            switch(GetBaseItemType(oItem))
            {
                case BASE_ITEM_SHORTSWORD:   nPPLoss = d6(); break;
                case BASE_ITEM_LONGSWORD:    nPPLoss = d8(); break;
                case BASE_ITEM_BASTARDSWORD: nPPLoss = d10(); break;
                case BASE_ITEM_THROWINGAXE:  nPPLoss = d6(); break;

                default:
                    WriteTimestampedLogEntry("Wrong type of item firing psi_sk_onhit: " + IntToString(GetBaseItemType(oItem)));
                    return;
            }

            int nPP = GetCurrentPowerPoints(oTarget);
            if(nPP > 0)
                LosePowerPoints(oTarget, nPPLoss);
            else
            {
                // Make a DC 17 will save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 17))
                {
                    ApplyAbilityDamage(oTarget, ABILITY_WISDOM, d2(), DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
                }
            }
        }
    }
    if(nFlags & MBLADE_FLAG_SUPPRESSION)
    {// When an opponent is struck with a suppressing mindblade, they are subject to a targeted dispel psionics power. The wielder makes a power check (1d20 + 5 + SK level, maximum of +15) against a DC of 11+ manifester level of power to be dispelled.
        //SendMessageToPC(oPC, "Suppression");
        int nCasterLevel = 5 + GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC);
            nCasterLevel = nCasterLevel > 20 ? 20 : nCasterLevel;
        effect eVis    = EffectVisualEffect(VFX_IMP_BREACH);
        effect eImpact = EffectVisualEffect(VFX_FNF_DISPEL);
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
        if(GetLocalInt(GetModule(), "BIODispel"))
            spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
        else
            spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);
    }
    if(nFlags & MBLADE_FLAG_WOUNDING)
    {// On hit, the mindblade deals 1 point of Constitution damage to the target. Creatures immune to critical hits are immune to this damage.
        //SendMessageToPC(oPC, "Wounding");
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
        {
            ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
        }
    }
    if(nFlags & MBLADE_FLAG_DISRUPTING)
    {// On each hit with the mindblade, unless the target succeeds at a DC 3/7 * (SK level + 16) Will save, it is dazed for a round.
        //SendMessageToPC(oPC, "Disrupting");
        int nDC = FloatToInt(3.0 / 7.0 * IntToFloat(GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC) + 16));
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
        {
            effect eDaze = EffectDazed();
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDaze), oTarget, 6.0f);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DAZED_S), oTarget);
        }
    }
    if(nFlags & MBLADE_FLAG_SOULBREAKER)
    {// On a successfull hit with the mindblade, the target must make a DC 18 fortitude save or gain a negative level.
        //SendMessageToPC(oPC, "Soulbreaker");
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 18))
        {
            effect eLevelLoss = EffectNegativeLevel(1);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLevelLoss), oTarget, HoursToSeconds(24));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_10), oTarget);
        }
    }
}
