/*:://////////////////////////////////////////////
//:: Spell Name Produce Flame
//:: Spell FileName PHS_S_ProduceFla
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Fire]
    Level: Drd 1, Fire 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Effect: Flame in your palm
    Duration: 1 min./level (D)
    Saving Throw: None
    Spell Resistance: Yes

    Flames as bright as a torch appear in your open hand. The flames harm
    neither you nor your equipment.

    In addition to providing illumination, the flames can be hurled or used to
    touch enemies. To do this, mearly use your caster item to aim the flame. If
    you are within touch range of a target, you attempt to melee attack them,
    else, you hurl the flames up to 20M, and attempt to range attack them. You
    deal fire damage equal to 1d6 +1 point per caster level (maximum +5) for
    both forms of attack.

    No sooner do you hurl the flames than a new set appears in your hand, unless
    the duration has expired. You can throw a total of 1 per caster level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Projectile will be able to do the visual.

    This, as it states, will do a special thing with it.

    Ok, this is how it'll work:

    - If cast from a new spell/item/whatever, it sets a new duration effect
      (and caster level) and also will fire the spell, of course!
    - If used from caster item, it will fail if not got duration on self, else,
      it will check times used against caster level (and remove it if need be),
      and hit the target as above.

    So, simple really.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PRODUCE_FLAME)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nUses;
    int nCasterLevel;// = PHS_GetCasterLevel();
    string sLocal = "PHS_PRODUCE_FLAME";
    string sUsesLocal = sLocal + "USES";

    // Check the caster item
    if(GetTag(GetSpellCastItem()) != PHS_ITEM_CLASS_ITEM)
    {
        // New duration effect
        nCasterLevel = PHS_GetCasterLevel();
        // Set limit of things back to X, the caster level
        SetLocalInt(oCaster, sLocal, nCasterLevel);
        SetLocalInt(oCaster, sUsesLocal, nCasterLevel);
        float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);
        effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        PHS_ApplyDuration(oTarget, eCessate, fDuration);

    }
    else
    {
        // Get uses
        nUses = GetLocalInt(oCaster, sUsesLocal);
        nCasterLevel = GetLocalInt(oCaster, sLocal);

        // Have we got duration effect
        if(!GetHasSpellEffect(PHS_SPELL_PRODUCE_FLAME, oCaster))
        {
            FloatingTextStringOnCreature("*Produce flame failed, you are not producing any more flame*", oCaster, FALSE);
            return;
        }
        else if(nUses > 0)
        {
            // Check uses
            nUses = GetLocalInt(oCaster, sUsesLocal);

            // Take one off
            nUses--;

            // Now, check if 0
            if(nUses <= 0)
            {
                // Delete uses
                DeleteLocalInt(oCaster, sUsesLocal);
                PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_PRODUCE_FLAME, oCaster);
            }
            else
            {
                // Set new uses
                SetLocalInt(oCaster, sUsesLocal, nUses);
            }
        }
        else
        {
            PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_PRODUCE_FLAME, oCaster);
        }
    }

    // Do damage! (maybe!)
    int nTouch;
    if(GetDistanceToObject(oTarget) <= 2.25)
    {
        // Melee
        nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);
    }
    else
    {
        // Ranged
        nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RANGED, oTarget, TRUE);
    }

    // Damage is 1d6 + 1
    int nBonus = PHS_LimitInteger(nCasterLevel, 5);
    int nDam = PHS_MaximizeOrEmpower(6, 1, nMetaMagic, nBonus, nTouch);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PRODUCE_FLAME);

    // Touch attack
    if(nTouch)
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply effects
                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_FIRE);
            }
        }
    }
}
