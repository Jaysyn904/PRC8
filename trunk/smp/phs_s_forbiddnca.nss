/*:://////////////////////////////////////////////
//:: Spell Name Forbiddance: On Enter
//:: Spell FileName PHS_S_ForbiddncA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, creates an AOE:

    - Large and permament (takes 6 rounds to cast!)
    - Party members immune to its effects (And SR + Save applieS)
    - Always blocks Planar Travel
    - Does damage to those who don't enter in the first few seconds:
      - 1 Alignment difference, (EG: N cast, LN goes in) 6d6 damage (divine?) (will half)
      - 2 alignment difference, (EG: N cast, LG goes in) 12d6 damage. (divine?) (will half)

    Material component worth 4000 too!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check the AOE creator
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    int nGoodEvilSelf = GetAlignmentGoodEvil(oCaster);
    int nLawChaosSelf = GetAlignmentLawChaos(oCaster);
    int nGoodEvilTarget = GetAlignmentGoodEvil(oTarget);
    int nLawChaosTarget = GetAlignmentLawChaos(oTarget);
    int nVFX, nDam;

    // Get a viusal based on our alignment (good/evil)
    if(nGoodEvilSelf == ALIGNMENT_EVIL)
    {
        nVFX = VFX_IMP_HEAD_EVIL;
    }
    else if(nGoodEvilSelf == ALIGNMENT_GOOD)
    {
        nVFX = VFX_IMP_HEAD_HOLY;
    }
    else //if(nGoodEvilSelf == ALIGNMENT_NEUTRAL)
    {
        nVFX = VFX_IMP_HEAD_ODD;
    }

    // Get alignment "difference"
    int nDifference = 0;
    // 1 differnce (more)
    if(nGoodEvilSelf != nGoodEvilTarget)
    {
        nDifference += 1;
    }
    // 1 differnce (more)
    if(nLawChaosSelf != nLawChaosTarget)
    {
        nDifference += 1;
    }

    // Declare major effects
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(nVFX);

    //Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FORBIDDANCE);

    // Always apply the "Dimensional Lock"
    PHS_AOE_OnEnterEffects(eDur, oTarget, PHS_SPELL_FORBIDDANCE);

    // PvP Check, needs to not be of equal alignment
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
       !GetFactionEqual(oTarget, oCaster) &&
    // Alignment difference of 1 or 2
        nDifference >= 1 &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Spell resistance check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Damage based on nDifference
            if(nDifference == 1)
            {
                // 6d6 damage
                nDam = PHS_MaximizeOrEmpower(6, 6, nMetaMagic);
            }
            else //if(nDifference == 2)
            {
                // 12d6 damage
                nDam = PHS_MaximizeOrEmpower(12, 6, nMetaMagic);
            }
            // Will save for half
            nDam = PHS_GetAdjustedDamage(SAVING_THROW_WILL, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster);

            if(nDam > 0)
            {
                // Do damage
                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_MAGICAL);
            }
        }
    }
}
