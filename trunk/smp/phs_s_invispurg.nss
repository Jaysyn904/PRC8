/*:://////////////////////////////////////////////
//:: Spell Name Invisibility Purge
//:: Spell FileName PHS_S_InvisPurg
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Level: Clr 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level (D)

    You surround yourself with a sphere of power with a radius of 1.67M per
    2 caster levels (Maximum 16.67M at level 20) that negates all forms of
    invisibility. Anything invisible has thier invisibility removed while in
    the area. Natural hiding is not affected.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    I altered it so people wouldn't be put under a false impression.

    Anyones invsibility is removed!

    The AOE changes per 2 caster levels - not per 1, this makes it more
    manageable for NwN, and is still a huge radius as the spell progresses
    in levels!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_INVISIBILITY_PURGE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nAOE;

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Determine duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Get AOE
    if(nCasterLevel <= 2)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_05;
    }
    else if(nCasterLevel <= 4)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_10;
    }
    else if(nCasterLevel <= 6)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_15;
    }
    else if(nCasterLevel <= 8)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_20;
    }
    else if(nCasterLevel <= 10)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_25;
    }
    else if(nCasterLevel <= 12)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_30;
    }
    else if(nCasterLevel <= 14)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_35;
    }
    else if(nCasterLevel <= 16)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_40;
    }
    else if(nCasterLevel <= 18)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_45;
    }
    else //if(nCasterLevel <= 20)
    {
        nAOE = PHS_AOE_MOB_INVISIBILITY_PURGE_50;
    }

    // Declare effects
    effect eAOE = EffectAreaOfEffect(nAOE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAOE, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_INVISIBILITY_PURGE, oTarget);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INVISIBILITY_PURGE, FALSE);

    // Apply VFX and effect.
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
