/*
   ----------------
   Warchief Tribal Frenzy
   
   prc_wchf_frenzy
   ----------------
*/

#include "prc_inc_spells"
#include "inc_addragebonus"

void FrenzyHB(object oPC, int nStr)
{
    //--------------------------------------------------------------------------
    // Check if the combat is over or if the PC turned it off
    //--------------------------------------------------------------------------
    if (DEBUG) DoDebug("prc_wchf_frenzy: IsInCombat: " + IntToString(GetIsInCombat(oPC)));
    if (DEBUG) DoDebug("prc_wchf_frenzy: LocalInt: " + IntToString(GetLocalInt(oPC, "WarchiefFrenzy")));
    if (!GetIsInCombat(oPC) || !GetLocalInt(oPC, "WarchiefFrenzy"))
    {
        PRCRemoveSpellEffects(SPELL_TRIBAL_FRENZY, oPC, oPC);
        if (DEBUG) DoDebug("prc_wchf_frenzy: Exit Function");
        return;
    }

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE);
    while (GetIsObjectValid(oTarget))
    {
        if (DEBUG) DoDebug("prc_wchf_frenzy: Entered Loop");
        if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
        {
            if(DEBUG) DoDebug("prc_wchf_frenzy: Friends");
            int nRacialType = MyPRCGetRacialType(oTarget);
            // Gotta be alive to Frenzy
            if(nRacialType != RACIAL_TYPE_CONSTRUCT && nRacialType != RACIAL_TYPE_UNDEAD)
            {
                if (DEBUG) DoDebug("prc_wchf_frenzy: Racial Type");
                // This is the damage they take for being in a frenzy
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetHitDice(oTarget)), oTarget);

                effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
                eStr = ExtraordinaryEffect(eStr);
                int StrBeforeBonuses = GetAbilityScore(oTarget, ABILITY_STRENGTH);
                int ConBeforeBonuses = GetAbilityScore(oTarget, ABILITY_CONSTITUTION);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oTarget, 6.5);
                // Because +10 is almost certain to hit the cap
                DelayCommand(0.1, GiveExtraRageBonuses(1, StrBeforeBonuses, ConBeforeBonuses, nStr, 0, 0, DAMAGE_TYPE_BASE_WEAPON, oTarget));
                if (DEBUG) DoDebug("prc_wchf_frenzy: Heartbeat Apply Bonus");
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE);
    }

    // Power keeps doing till duration is over.
    DelayCommand(6.0f, FrenzyHB(oPC, nStr));
}

void main()
{
    object oPC = OBJECT_SELF;
    string nMes = "";

    if(!GetHasSpellEffect(SPELL_TRIBAL_FRENZY, oPC))
    {
        int nWarChief = GetLevelByClass(CLASS_TYPE_WARCHIEF, oPC);
        int nBonus = (nWarChief + 1) / 2;

        SetLocalInt(oPC, "WarchiefFrenzy", TRUE);
        FrenzyHB(oPC, nBonus * 2);
        nMes = "*Tribal Frenzy Activated*";
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oPC);
    }
    else
    {
        // Removes effects
        if (DEBUG) DoDebug("prc_wchf_frenzy: Remove Effects");
        PRCRemoveSpellEffects(SPELL_TRIBAL_FRENZY, oPC, oPC);
        nMes = "*Tribal Frenzy Deactivated*";
        DeleteLocalInt(oPC, "WarchiefFrenzy");
    }

    FloatingTextStringOnCreature(nMes, oPC, FALSE); 
}