//::///////////////////////////////////////////////
//:: Exalted feat: Stigmata
//:: gensp_stigmata
//:://////////////////////////////////////////////
/*
    User takes an amount of Constituation damage.
    In exchange, all allies in short radius are
    healed by their HD * ConDam / 2 and are
    cured of diseases.

    The constitution damage cannot be healed for an
    hour, so it is applied to hide for that duration.
    Once the hour has run out, the damage is applied
    as a temporary effect.
    Also, Stigmata cannot be used again during this
    hour.
*/
//:://////////////////////////////////////////////
//:: Created By: Lauduc (?)
//:: Modified By: Ornedan
//:: Modified On: 25.04.2005
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    // Build main variables
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oTarget = PRCGetSpellTargetObject();
    int nSpell = PRCGetSpellId();
    int nStigmataDamage;

    // Cannot use twice within an hour, check for marker local
    if(GetLocalInt(oPC, "StigmataUsed")){
        FloatingTextStringOnCreature("You must wait before you can use this feat again", oPC);
        return;
    }

    // Exalted feat, so non-good cannot use
    if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD) return;

    // Only affects allies
    if(!spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
    {
        FloatingTextStringOnCreature("Only works on Allies", oPC);
        return;
    }

    // Get the Con damage to be dealt
    switch(PRCGetSpellId())
    {
        case SPELL_STIGMATA2: nStigmataDamage = 2; break;
        case SPELL_STIGMATA3: nStigmataDamage = 4; break;
        case SPELL_STIGMATA4: nStigmataDamage = 6; break;
        case SPELL_STIGMATA5: nStigmataDamage = 8; break;

        default:
            WriteTimestampedLogEntry("Unknown SpellID in gensp_stigmata: " + IntToString(PRCGetSpellId()));
            return;
    }

    // Make sure that user has enough Con left to sacrifice
    if(GetAbilityScore(oPC, ABILITY_CONSTITUTION) <= nStigmataDamage)
    {
        FloatingTextStringOnCreature("You do not have enough Constitution left to use this feat", oPC);
        return;
    }

    // Mark Stigmata as used for one hour
    SetLocalInt(oPC, "StigmataUsed", TRUE);

    /* Apply Constitution damage */
    // First, make it permanent on the hide
    int nCurVal = TotalAndRemoveProperty(oSkin, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CON);
    int nVal = nStigmataDamage;
    if((nCurVal + nVal) > 20)
    {
        nCurVal = 20;
        nVal = 0;
    }
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CON, nCurVal + nVal), oSkin, HoursToSeconds(1));

    // After the permanent version has worn off, apply it as temporary effect, wearing off at rate of 1 point per day on it's own
    // The 0.3 is a fudge factor for making sure the effects do not overlap even if the game happens to lag a bit
    DelayCommand(HoursToSeconds(1) + 0.3f, ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, nStigmataDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));

    // Some decorative VFX on the user
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR), oPC, HoursToSeconds(1));


    // Effect main target
    effect eHeal = EffectLinkEffects(EffectVisualEffect(VFX_IMP_HEALING_X), EffectHeal(GetHitDice(oTarget) * nStigmataDamage / 2));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR), oTarget, TurnsToSeconds(1));

    // Since forcing a resave is not possible, and this implementation will be somewhat poorer compared to
    // the PnP version due to inability to store charges, the diseases will just be removed
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == EFFECT_TYPE_DISEASE)
            RemoveEffect(oTarget, eCheck);
        eCheck = GetNextEffect(oTarget);
    }


    // Effect secondary targets
    int nTargets = nStigmataDamage - 1;
    object oSecondary = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, GetLocation(oPC));
    while(GetIsObjectValid(oSecondary) && nTargets > 0)
    {
        // Don't affect self, primary target or non-friendlies
        if(oSecondary != oPC && oSecondary != oTarget && spellsIsTarget(oSecondary, SPELL_TARGET_ALLALLIES, oPC))
        {
            // Apply effects
            effect eHeal = EffectLinkEffects(EffectVisualEffect(VFX_IMP_HEALING_X), EffectHeal(GetHitDice(oSecondary) * nStigmataDamage / 2));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oSecondary);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR), oSecondary, TurnsToSeconds(1));

            // Since forcing a resave is not possible, and this implementation will be somewhat poorer compared to
            // the PnP version due to inability to store charges, the diseases will just be removed
            effect eCheck = GetFirstEffect(oSecondary);
            while(GetIsEffectValid(eCheck))
            {
                if(GetEffectType(eCheck) == EFFECT_TYPE_DISEASE)
                    RemoveEffect(oSecondary, eCheck);
                eCheck = GetNextEffect(oSecondary);
            }

            // Mark one more target slot as used
            nTargets--;
        }

        // Get next potential target
        oSecondary = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, GetLocation(oPC));
    }
}
