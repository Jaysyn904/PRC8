/*:://////////////////////////////////////////////
//:: Spell Name Irresistible Dance
//:: Spell FileName PHS_S_IrresDance
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 6, Sor/Wiz 8
    Components: V
    Casting Time: 1 standard action
    Range: Touch
    Target: Living creature touched
    Duration: 1d4+1 rounds
    Saving Throw: None
    Spell Resistance: Yes

    The subject feels an undeniable urge to dance and begins doing so, complete
    with foot shuffling and tapping. The spell effect makes it impossible for the
    subject to do anything other than caper and prance in place. The effect
    imposes a -4 penalty to Armor Class and a -10 penalty on Reflex saves. The
    target also unequips anything it is holding to dance. The dancing subject
    may even provoke attacks of opportunity each round if it starts to do dives
    or ballet
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies a confusion effect, really...

    It links the penalties in.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_IRRESISTIBLE_DANCE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in rounds, 1d4 + 1.
    float fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic, 1);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    //Declare effects
    effect eAC = EffectACDecrease(4, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
    effect eReflex = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 10, SAVING_THROW_TYPE_ALL);
    effect eDance = EffectConfused();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_IRRESISTIBLE_DANCE);

    // Link effects
    effect eLink = EffectLinkEffects(eAC, eReflex);
    eLink = EffectLinkEffects(eLink, eDance);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Signal Spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_IRRESISTIBLE_DANCE);

    // Melee Touch attack
    if(PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE))
    {
        // Only living creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget) &&
            PHS_GetIsAliveCreature(oTarget, "You must target a living creature to dance"))
        {
            // Spell resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Do dancing, baby, yeah!
                PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
            }
        }
    }
}
