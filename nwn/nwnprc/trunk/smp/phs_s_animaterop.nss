/*:://////////////////////////////////////////////
//:: Spell Name Animate Rope
//:: Spell FileName PHS_S_AnimateRop
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Animate Rope
    Transmutation
    Level: Brd 1, Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Target: One ropelike object, in your inventory
    Duration: 1 round/level
    Saving Throw: None
    Spell Resistance: No

    You can animate a nonliving ropelike object.

    The rope can enwrap only a creature or an object within 1 foot of it-it does
    not snake outward-so it must be thrown near the intended target. Doing so
    requires a successful ranged touch attack roll. A typical 1- inch-diameter
    hempen rope requires a DC 23 Strength check to burst it. The rope does not
    deal damage, but can be used to cause a single opponent that fails a Reflex
    saving throw to become entangled.

    An entangled creature can break free with a DC 23 Strength check each
    futher round they are entangled, until the duration of the spell expires.
    They can not be entangled by more then one animated rope.

    The rope itself and any knots tied in it are not magical, and so cannot be
    resisted by spell resistance nor spell immunities.

    The spell cannot animate objects carried or worn by another creature, and
    any rope animated is lost in battle.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This needs a ranged touch attack to work. Once it has hit, if the target
    failes a reflex save (spell save DC), they are entangled.

    they stay entangled until the duration until a strength check of 23 is
    achieved.

    It requires a item of the tag "PHS_Rope" to be in the inventory. This is
    lost AFTER any use magical device checks are made.

    Ranged attack means no spell turning.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Delayed every 6 seconds we have duration for. This performs the
// strength burst check.
void RopeRoundCheck(object oTarget, object oCaster, int nRoundsRemaining);
// Strength checks, at DC 23 by default. Reports to oTarget and oCaster
// of the result.
int RopeStrengthCheck(object oTarget, object oCaster, int nDC = 23);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // We need a rope.... ("PHS_Rope")
    if(!PHS_ComponentExactItem(PHS_ITEM_ROPE, "Rope", "Animate Rope")) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration is every 6 seconds, remove one from rounds counter
    int nRounds = nCasterLevel;
    if(nMetaMagic == METAMAGIC_EXTEND)
    {
        nRounds *= 2;
    }
    // Need this for visual
    float fDuration = RoundsToSeconds(nRounds);

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_ENTANGLE);
    effect eEntangle = EffectEntangle();
    effect eLink = EffectLinkEffects(eDur, eEntangle);

    // We make sure we are not targeting someone in bad PvP
    // And we make sure they are not already affected with the spell
    if(!GetIsReactionTypeFriendly(oTarget) &&
       !GetHasSpellEffect(PHS_SPELL_ANIMATE_ROPE, oTarget) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        //Fire cast spell at event for the specified target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ANIMATE_ROPE, TRUE);

        // Must hit the target - Ranged spell touch attack
        if(PHS_SpellTouchAttack(PHS_TOUCH_RANGED, oTarget, TRUE))
        {
            // Reflex save to negate
            if(!PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellSaveDC))
            {
                PHS_ApplyDuration(oTarget, eLink, fDuration);
                // Every 6 seconds apply a new effect.
                DelayCommand(6.0, RopeRoundCheck(oTarget, oCaster, nRounds));
            }
        }
    }
}
// Strength checks, at DC 23 by default. Reports to oTarget and oCaster
// of the result.
int RopeStrengthCheck(object oTarget, object oCaster, int nDC = 23)
{
    // Set default results.
    string sResult = "FAIL";
    int bReturn = FALSE;

    // Strenght modifier.
    int nModifier = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    string sMod = "+" + IntToString(nModifier);
    // Should have a -X, so remove the +X, if negative.
    if(nModifier < 0)
    {
        sMod = IntToString(nModifier);
    }
    // Roll.
    int nRoll = d20();
    string sRoll = IntToString(nRoll);
    // Did we pass?
    if((nRoll + nModifier) >= nDC)
    {
        sResult = "PASS";
        bReturn = TRUE;
    }
    // Send result messages.
    string sReport = "Strength Check: DC + "+IntToString(nDC)+". Roll: "+sRoll+". Modifier: "+sMod+". " + sResult;
    SendMessageToPC(oTarget, sReport);
    SendMessageToPC(oCaster, sReport);

    return bReturn;
}
// Delayed every 6 seconds we have duration for. This performs the
// strength burst check.
void RopeRoundCheck(object oTarget, object oCaster, int nRoundsRemaining)
{
    // Break if dead.
    if(!GetIsDead(oTarget) && GetIsObjectValid(oCaster) && GetIsObjectValid(oTarget) &&
        GetHasSpellEffect(PHS_SPELL_ANIMATE_ROPE, oTarget))
    {
        int nNewRounds = nRoundsRemaining - 1;
        // A strengh check to break out. Sends a message to PC and caster.
        if(RopeStrengthCheck(oTarget, oCaster))
        {
            PHS_RemoveSpellEffects(PHS_SPELL_ANIMATE_ROPE, oCaster, oTarget);
            nNewRounds = 0;
        }
        if(nNewRounds > 0)
        {
            DelayCommand(6.0, RopeRoundCheck(oTarget, oCaster, nNewRounds));
        }
    }
}
