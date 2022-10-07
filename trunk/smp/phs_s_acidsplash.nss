/*:://////////////////////////////////////////////
//:: Spell Name Acid Splash
//:: Spell FileName PHS_S_AcidSplash
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Acid]
    Level: Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: One missile of acid
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    You fire a small orb of acid at the target. You must succeed on a ranged
    touch attack to hit your target. The orb deals 1d3 points of acid damage.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Notes about this: No spell resistance or spell turning. Only check spell
    immunity :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Requires a touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE);
    // Damage + Double for a critical hit.
    int nDamage = PHS_MaximizeOrEmpower(3, 1, nMetaMagic, FALSE, nTouch);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    // Check PvP
    if(!GetIsReactionTypeFriendly(oTarget) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Fire cast spell at event for the specified target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ACID_SPLASH);

        // Do we even hit?
        if(nTouch)
        {
            //Apply the VFX impact and damage effect
            PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_ACID);
        }
        // Else we miss - do nothing
    }
}
