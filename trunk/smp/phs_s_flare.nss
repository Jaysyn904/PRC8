/*:://////////////////////////////////////////////
//:: Spell Name Flare
//:: Spell FileName PHS_S_Flare
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    8M range. Fort and SR negates. -1 attack, -1 spot/Search for 1 minute.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Dazzel? Well, look at the spells include for attack modifiers.

    It is -1 to attack rolls, melee and ranged, and -1 spot/Search.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FLARE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Duration is 1 turn.
    float fDuration = PHS_GetDuration(PHS_MINUTES, 1, nMetaMagic);

    // Declare effects
    effect eDazzle = PHS_DazzleEffectLink();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eLink = EffectLinkEffects(eDazzle, eCessate);

    // Signal spell cast at event (If we affect them or not)
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FLARE);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Make sure they are not blind
        if(PHS_GetCanSee(oTarget) &&
          !PHS_GetIsDazzled(oTarget))
        {
            // Spell resistance and immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Fortitude save
                if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC))
                {
                    // Apply impact and penalties.
                    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
            }
        }
    }
}
