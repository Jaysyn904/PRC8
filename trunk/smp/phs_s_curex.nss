/*:://////////////////////////////////////////////
//:: Spell Name Cure XXX Wounds
//:: Spell FileName PHS_S_CureX
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Cure wounds Name | d8 | Caster Limit
    Minor            | 0  | 1
    Light            | 1  | 5
    Moderate         | 2  | 10
    Serious          | 3  | 15
    Critical         | 4  | 20

    It does the same damage to undead (Will for half, SR applies) which requires
    a touch attack.
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
    int nDice, nCasterBonus, nToHeal, nVisual;

    if(nSpellId == PHS_SPELL_CURE_MINOR_WOUNDS)
    {
        nVisual = VFX_IMP_HEAD_HEAL;
        nToHeal = 1;
    }
    else if(nSpellId == PHS_SPELL_CURE_LIGHT_WOUNDS)
    {
        nVisual = VFX_IMP_HEALING_S;
        nDice = 1;
    }
    else if(nSpellId == PHS_SPELL_CURE_MODERATE_WOUNDS)
    {
        nVisual = VFX_IMP_HEALING_M;
        nDice = 2;
    }
    else if(nSpellId == PHS_SPELL_CURE_SERIOUS_WOUNDS)
    {
        nVisual = VFX_IMP_HEALING_L;
        nDice = 3;
    }
    else if(nSpellId == PHS_SPELL_CURE_CRITICAL_WOUNDS)
    {
        nVisual = VFX_IMP_HEALING_G;
        nDice = 4;
    }
    if(nToHeal == 0)
    {
        // Limit how much we are limiting the caster level
        // 5, 10, 15, 20...
        nCasterBonus = PHS_LimitInteger(nCasterLevel, nDice * 5);
    }
    // Visual effect
    effect eVis;

    // Check racial type
    if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        // Damage on touch attack
        int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget);

        // Does it hit?
        if(nTouch)
        {
            // Get total damage to be done
            if(nToHeal == 0)
            {
                nToHeal = PHS_MaximizeOrEmpower(8, nDice, nMetaMagic, nCasterBonus, nTouch);
            }
            else if(nTouch == 2)
            {
                nToHeal *= 2;
            }

            // Spell resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Will save for half damage
                if(PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DIVINE))
                {
                    nToHeal /= 2;
                }
                // Check nToHeal
                if(nToHeal > 0)
                {
                    // Visual effect
                    eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
                    // Do damage and visual
                    PHS_ApplyDamageVFXToObject(oTarget, eVis, nToHeal, DAMAGE_TYPE_POSITIVE);
                }
            }
        }
    }
    else if(PHS_GetIsAliveCreature(oTarget, "You must target a living creature to heal"))
    {
        // Get total healing to be done
        if(nToHeal == 0)
        {
            nToHeal = PHS_MaximizeOrEmpower(8, nDice, nMetaMagic, nCasterBonus);
        }
        // Declare what to heal
        effect eHeal = EffectHeal(nToHeal);
        eVis = EffectVisualEffect(nVisual);
        // Do the healing and visual
        PHS_ApplyInstantAndVFX(oTarget, eVis, eHeal);
    }
}
