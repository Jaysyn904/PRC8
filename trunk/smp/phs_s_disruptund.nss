/*:://////////////////////////////////////////////
//:: Spell Name Disrupt Undead
//:: Spell FileName phs_s_disruptund
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Disrupt Undead
    Necromancy
    Level: Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: Yes

    You direct a ray of positive energy. You must make a ranged touch attack to
    hit, and if the ray hits an undead creature, it deals 1d6 points of damage
    to it.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Holy ray and 1d6 divine damage. Easy peasy :-)

    Requires a touch attack - ray based.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_DISRUPT_UNDEAD)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDamage;

    // Touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_COM_HIT_DIVINE); // Smaller hit then VFX_IMP_SUNSTRIKE

    // Signal Spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISRUPT_UNDEAD);

    // Beam visual
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_HOLY, nTouch, 1.0);

    // Touch ray attack
    if(nTouch)
    {
        // Make sure the target is undead
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            // PvP check
            if(!GetIsReactionTypeFriendly(oTarget) &&
            // Make sure they are not immune to spells
               !PHS_TotalSpellImmunity(oTarget))
            {
                // Spell resistance
                if(!PHS_SpellResistanceCheck(oCaster, oTarget))
                {
                    // Damage is 1d6 Divine
                    nDamage = PHS_MaximizeOrEmpower(6, 1, nMetaMagic, 0, nTouch);

                    // Apply damage and hit effects
                    PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_DIVINE);
                }
            }
        }
    }
}

