/*:://////////////////////////////////////////////
//:: Name (Monster) Ability Include file
//:: FileName SMP_INC_ABILITY
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    This includes some handy things for abilties.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Immunities (Includes constants)
#include "SMP_INC_RESIST"

// SMP_INC_ABILITY. This returns a DC based on 2 factors:
// 1. Half the levels provided by nClass
// 2. The modifier for the ability nAbility
// So, it'll return 10 + Half of nClass level's + Ability modifier of nAbility
int SMP_GetAbilitySaveDC(int nClass, int nAbility);

// SMP_INC_ABILITY. This sets oTarget to be immune to this spells effect from
// oCreature forever.
// Sets a local int retrievable by SMP_GetIsImmuneToAbility().
void SMP_SetIsImmuneToAbility(object oTarget, int nId, object oCreature = OBJECT_SELF);

// SMP_INC_ABILITY. This will return TRUE if oTarget is immune to futher uses of
// nId ability used by oCreature.
int SMP_GetIsImmuneToAbility(object oTarget, int nId, object oCreature = OBJECT_SELF);

// SMP_INC_ABILITY. Monster non-spell ability save.
// - Uses     SAVING_THROW_WILL, SAVING_THROW_REFLEX, SAVING_THROW_FORT.
// functions: WillSave           ReflexSave           FortitudeSave.
int SMP_SavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// This returns a DC based on 2 factors:
// 1. Half the levels provided by nClass
// 2. The modifier for the ability nAbility
// So, it'll return 10 + Half of nClass level's + Ability modifier of nAbility
int SMP_GetAbilitySaveDC(int nClass, int nAbility)
{
    // Start DC at 10...
    // * Add half the levels of nClass
    // * Add the nAbility modifer
    return 10 + (GetLevelByClass(nClass)/2) + GetAbilityModifier(nAbility);
}

// This sets oTarget to be immune to this spells effect from oCreature forever.
// Sets a local int retrievable by SMP_GetIsImmuneToAbility().
void SMP_SetIsImmuneToAbility(object oTarget, int nId, object oCreature = OBJECT_SELF)
{
    SetLocalInt(oCreature, "SMP_IMMMUNE_TO_ABILITY" + IntToString(nId) + ObjectToString(oTarget), TRUE);
}

// This will return TRUE if oTarget is immune to futher uses of nId ability
// used by oCreature.
int SMP_GetIsImmuneToAbility(object oTarget, int nId, object oCreature = OBJECT_SELF)
{
    return GetLocalInt(oCreature, "SMP_IMMMUNE_TO_ABILITY" + IntToString(nId) + ObjectToString(oTarget));
}

// Monster non-spell ability save.
// - Uses     SAVING_THROW_WILL, SAVING_THROW_REFLEX, SAVING_THROW_FORT.
// functions: WillSave           ReflexSave           FortitudeSave.
int SMP_SavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // This does not decrease the save if there are things like Protection from
    // Spells.
    // Declare things
    effect eVis;
    int bValid = FALSE;
    // Fortitude saving throw
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    // Reflex saving throw
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    // Will saving throw
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }
    /* No error checking (keeps it fast) we'd know anyway of errors!

       Finally:
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST

        We ignore 2, and say it is 0.
    */
    // If 2, ignore
    if(bValid == 2)
    {
        bValid = 0;
    }
    // If we save, apply save effect.
    else if(bValid == 1)
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}
