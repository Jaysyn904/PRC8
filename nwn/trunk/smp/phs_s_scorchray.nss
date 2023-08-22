/*:://////////////////////////////////////////////
//:: Spell Name Scorching Ray
//:: Spell FileName PHS_S_ScorchRay
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Fire, close range, 1 or more rays are the effect. SR applies. No save.
    Fire 1 ray, plus one additional ray for every four levels beyond 3rd
    (to a maximum of three rays at 11th level). Each ray requires a ranged touch
    attack to hit and deals 4d6 points of fire damage.

    The rays may be fired at the same or different targets, but all bolts must
    be aimed at targets within 30 feet of each other and fired simultaneously.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The choice of "Lots of" or "Single" target is made in the spell menu choice.

    One target must be targeted, however.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_SCORCHING_RAY)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCnt, nDam;
    float fDelay;
    // Needs a touch ranged attack for each ray
    int nTouch;
    // Get number of rays
    int nRays = PHS_LimitInteger((nCasterLevel - 3)/4, 3);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    // Loop number of rays
    for(nCnt = 1; nCnt <= nRays; nCnt++)
    {
        // Touch attack result
        nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RANGED, oTarget, TRUE);
        // Do hit/miss of beam
        DelayCommand(fDelay, PHS_ApplyTouchBeam(oTarget, VFX_BEAM_FLAME, nTouch, 0.4));
        fDelay += 0.5;

        // Check reaction type and if it hits
        if(!GetIsReactionTypeFriendly(oTarget) && nTouch)
        {
            // Spell resistance and immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Get Damage to be done (for this ray)
                nDam = PHS_MaximizeOrEmpower(6, 4, nMetaMagic, 0, nTouch);

                // Do damage and visual after delay
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_FIRE));
            }
        }
    }
}
