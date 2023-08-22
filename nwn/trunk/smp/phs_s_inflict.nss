/*:://////////////////////////////////////////////
//:: Spell Name Inflict XXX Wounds
//:: Spell FileName PHS_S_Inflict
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Inflict Name     | d8 | Caster Limit
    Minor            | 0  | 1
    Light            | 1  | 5
    Moderate         | 2  | 10
    Serious          | 3  | 15
    Critical         | 4  | 20

    It does the same damage to non-undead (Will for half, SR applies) which
    requires a touch attack.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spells.
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
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDice, nCasterBonus, nToHeal, nVis;

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    if(nSpellId == PHS_SPELL_INFLICT_MINOR_WOUNDS)
    {
        nToHeal = 1;
        nVis = VFX_IMP_HEAD_EVIL;
    }
    else if(nSpellId == PHS_SPELL_INFLICT_LIGHT_WOUNDS)
    {
        nDice = 1;
        nVis = PHS_VFX_IMP_INFLICTING_S;//VFX_IMP_HEALING_S
    }
    else if(nSpellId == PHS_SPELL_INFLICT_MODERATE_WOUNDS)
    {
        nDice = 2;
        nVis = PHS_VFX_IMP_INFLICTING_M;
    }
    else if(nSpellId == PHS_SPELL_INFLICT_SERIOUS_WOUNDS)
    {
        nDice = 3;
        nVis = PHS_VFX_IMP_INFLICTING_L;
    }
    else if(nSpellId == PHS_SPELL_INFLICT_CRITICAL_WOUNDS)
    {
        nDice = 4;
        nVis = PHS_VFX_IMP_INFLICTING_G;
    }
    if(nToHeal == 0)
    {
        // Limit how much we are limiting the caster level
        // 5, 10, 15, 20...
        nCasterBonus = PHS_LimitInteger(nCasterLevel, nDice * 5);
    }
    // Visual effect
    effect eVis = EffectVisualEffect(nVis);

    // Check if alive to start
    if(PHS_GetIsAliveCreature(oTarget))
    {
        // Damage on touch attack
        int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget);
        // Does it hit?
        if(nTouch)
        {
            // Get total damage to be done
            nToHeal = PHS_MaximizeOrEmpower(8, nDice, nMetaMagic, nCasterBonus, nTouch);

            // Spell resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
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
                    PHS_ApplyDamageVFXToObject(oTarget, eVis, nToHeal, DAMAGE_TYPE_NEGATIVE);
                }
            }
        }
    }
    // Check racial type
    else if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        // Get total healing to be done
        nToHeal = PHS_MaximizeOrEmpower(8, nDice, nMetaMagic, nCasterBonus);

        // Declare what to heal
        effect eHeal = EffectHeal(nToHeal);
        // Do the healing and visual
        PHS_ApplyInstantAndVFX(oTarget, eVis, eHeal);
    }
}
