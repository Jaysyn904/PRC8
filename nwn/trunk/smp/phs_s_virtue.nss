/*:://////////////////////////////////////////////
//:: Spell Name Virtue
//:: Spell FileName PHS_S_Virtue
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 0, Drd 0, Pal 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min.
    Saving Throw: Fortitude negates (harmless)
    Spell Resistance: Yes (harmless)

    The subject gains 1 temporary hit point.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Simple. Very easy.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck()) return;

    //Declare target variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration - 1 minute
    float fDuration = PHS_GetDuration(PHS_MINUTES, 1, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eTempHP = EffectTemporaryHitpoints(1);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eTempHP, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Apply the HP
    PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
}
