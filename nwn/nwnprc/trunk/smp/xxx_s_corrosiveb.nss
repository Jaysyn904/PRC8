/*:://////////////////////////////////////////////
//:: Spell Name Corrosive Blast
//:: Spell FileName XXX_S_CorrosiveB
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Acid]
    Level: Sor/Wiz 6
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Orb of acid; Exposion 6.67M-radius spread (20 ft); see text
    Duration: Instantaneous
    Saving Throw: None, Reflex Half; See text
    Spell Resistance: Yes
    Source: Various (cthulhu)

    With the completion of this spell, a glass orb full of green, wispy gas
    appears in front of the caster and flies toward the intended target. If the
    caster succeeds at a ranged touch attack the orb shatters against the
    intended target, exploding in a violent cloud of corrosive gas. If the
    caster misses the intended target, the orb simply explodes nearby and
    doesn't do target impact damage.

    The initial impact on the target does 2d6 acid damage and 3d6 piercing
    damage and the target cannot make any save against damage from the spell
    (although spell resistance still applies). The spread does d6 acid
    damage/caster level (max 15d6) to all creatures in the area of effect, with
    a successful Reflex save halfing the damage from the burst. If the target
    suceeds on resisting the impact damage, they recieve no splash damage from
    the blast either.

    If the ball misses the intended target, then they recieve a reflex save as
    normal.

    M: a small, glass bead that expands into the hurled ball.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Material component needed.

    This is a slightly-different (but some ways very much so) fireball spell.

    Its the same AOE, but a few levels higher, can do up to 15d6 damage, and also
    has a special impact damage.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_CORROSIVE_BLAST)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    object oIntendedTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oIntendedTarget); //GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nDam;
    int bIntendedFullDam = FALSE;
    int bDamVar = FALSE;
    float fDelay;

    // Limit dice to 15d6
    int nDice = SMP_LimitInteger(nCasterLevel, 15);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(SMP_VFX_FNF_CORROSIVE_BLAST);
    SMP_ApplyLocationVFX(lTarget, eImpact);

    // We do damage to the target intended first - on a touch attack!
    if(GetIsObjectValid(oIntendedTarget) &&
      !GetIsReactionTypeFriendly(oIntendedTarget, oCaster))
    {
        // We attempt a touch attack
        if(SMP_SpellTouchAttack(SMP_TOUCH_RANGED, oIntendedTarget))
        {
            // Spell resistance check
            if(!SMP_SpellResistanceCheck(oCaster, oIntendedTarget))
            {
                // We hit - thus we do full damage
                bIntendedFullDam = TRUE;

                // We do an extra 2d6 acid and 3d6 piercing.
                nDam = SMP_MaximizeOrEmpower(6, 2, nMetaMagic);
                SMP_ApplyDamageVFXToObject(oIntendedTarget, eVis, nDam, DAMAGE_TYPE_ACID);
                // Do piercing
                nDam = SMP_MaximizeOrEmpower(6, 3, nMetaMagic);
                SMP_ApplyDamageToObject(oIntendedTarget, nDam, DAMAGE_TYPE_PIERCING);
            }
            else
            {
                // Passed, we set bIntendedFullDam to -1, we make it so
                //this spell won't do additional damage
                bIntendedFullDam = -1;
            }
        }
    }

    // Get all targets in a sphere, 6.67M radius, creatures.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CORROSIVE_BLAST);

            // Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Check if intended target
            if(oTarget == oIntendedTarget)
            {
                if(bIntendedFullDam == TRUE)
                {
                    // Hit, no save.
                    bDamVar = TRUE;
                }
                else if(bIntendedFullDam == FALSE)
                {
                    // Normal, missed
                    bDamVar = FALSE;
                }
                else
                {
                    // Resisted
                    bDamVar = -1;
                }
            }
            // -1 Means the intended target resisted it before.
            if(bDamVar != -1)
            {
                // Spell resistance And immunity checking.
                if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Roll damage for each target
                    nDam = SMP_MaximizeOrEmpower(6, nDice, nMetaMagic);

                    // Only can save if bDamVar is FALSE. If TRUE, no save!
                    if(bDamVar == FALSE)
                    {
                        // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                        nDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster, fDelay);
                    }
                    // Need to do damage to apply visuals
                    if(nDam > 0)
                    {
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_ACID));
                    }
                }
            }
            bDamVar = FALSE;
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
