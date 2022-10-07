/*:://////////////////////////////////////////////
//:: Spell Name Inflict XXX Wounds, Mass
//:: Spell FileName PHS_S_InflictMas
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Inflict Name     | d8 | Caster Limit
    Light, Mass      | 1  | 25
    Moderate, Mass   | 2  | 30
    Serious, Mass    | 3  | 35
    Critical, Mass   | 4  | 40

    Target: One creature/level, no two of which can be more than 30 ft. apart
    Duration: Instantaneous
    Saving Throw: Will half
    Spell Resistance: Yes

    Negative energy spreads out in all directions from the point of origin,
    dealing 1d8 points of damage +1 point per caster level (maximum +25) to
    nearby living enemies.

    Like other inflict spells, mass inflict light wounds cures undead in its
    area rather than damaging them. A cleric capable of spontaneously casting
    inflict spells can also spontaneously cast mass inflict spells.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell.

    1 creature/level.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Get the spell being cast (No sub-spells)
    int nSpellId = GetSpellId();
    // Spell Hook Check
    if(!PHS_SpellHookCheck(nSpellId)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDice, nCasterBonus, nToHeal, nVis, nCount;
    float fDelay;

    if(nSpellId == PHS_SPELL_INFLICT_LIGHT_WOUNDS_MASS)
    {
        nDice = 1;
        nVis = PHS_VFX_IMP_INFLICTING_S;//VFX_IMP_HEALING_S
    }
    else if(nSpellId == PHS_SPELL_INFLICT_MODERATE_WOUNDS_MASS)
    {
        nDice = 2;
        nVis = PHS_VFX_IMP_INFLICTING_M;
    }
    else if(nSpellId == PHS_SPELL_INFLICT_SERIOUS_WOUNDS_MASS)
    {
        nDice = 3;
        nVis = PHS_VFX_IMP_INFLICTING_L;
    }
    else if(nSpellId == PHS_SPELL_INFLICT_CRITICAL_WOUNDS_MASS)
    {
        nDice = 4;
        nVis = PHS_VFX_IMP_INFLICTING_G;
    }

    // Limit how much we are limiting the caster level
    // 25, 30, 35, 40... (20 + nDice * 5)
    nCasterBonus = PHS_LimitInteger(nCasterLevel, (20 + (nDice * 5)));

    // Visual effect
    effect eVis = EffectVisualEffect(nVis);
    effect eHeal;

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Loop all enemies in a shpere of radius 15ft.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_15, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) &&  nCount < nCasterLevel)
    {
        // Make sure they are not immune to spells
        if(!PHS_TotalSpellImmunity(oTarget))
        {
            // Get delay
            fDelay = GetDistanceBetweenLocations(GetLocation(oTarget), lTarget) / 20;

            // Check if alive to start
            if(PHS_GetIsAliveCreature(oTarget))
            {
                // PvP Check - must be an enemy
                if(GetIsReactionTypeHostile(oTarget))
                {
                    // One more affected
                    nCount++;

                    // Get total damage to be done
                    nToHeal = PHS_MaximizeOrEmpower(8, nDice, nMetaMagic, nCasterBonus);

                    // Spell resistance check
                    if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                    {
                        // Will save for half damage
                        if(PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                        {
                            nToHeal /= 2;
                        }
                        // Check nToHeal
                        if(nToHeal > 0)
                        {
                            // Do damage and visual
                            DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nToHeal, DAMAGE_TYPE_NEGATIVE));
                        }
                    }
                }
            }
            // Check racial type
            else if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                // Make sure they are a friend
                if(GetIsFriend(oTarget))
                {
                    // Add one to count
                    nCount++;

                    // Get total healing to be done
                    nToHeal = PHS_MaximizeOrEmpower(8, nDice, nMetaMagic, nCasterBonus);

                    // Declare what to heal
                    eHeal = EffectHeal(nToHeal);

                    // Do the healing and visual
                    DelayCommand(fDelay, PHS_ApplyInstantAndVFX(oTarget, eVis, eHeal));
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_15, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
