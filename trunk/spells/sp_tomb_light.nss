//::///////////////////////////////////////////////
//:: Name      Tomb of Light
//:: FileName  sp_tomb_light.nss
//:://////////////////////////////////////////////
/**@file Tomb of Light
Transmutation [Good]
Level: Clr 7, Sor/Wiz 7
Components: V, S, M
Casting Time: 1 round
Range: Touch
Target: Evil extraplanar creature touched
Duration: Concentration
Saving Throw: Fortitude negates
Spell Resistance: Yes

When you cast this spell, you attempt to draw out
the impure substance of an evil extraplanar
creature and replace it with your own pure
substance. The spell is draining for you to cast,
but it is deadly to evil outsiders and other
extraplanar creatures with the taint of evil.

When you touch the target creature, it must make a
Fortitude saving throw. If it succeeds, it is
unaffected by the spell.

If it fails, its skin becomes translucent and
faintly radiant and the creature is immobilized,
standing helpless. The subject is aware and
breathes normally, but cannot take any physical
actions, even speech. It can, however, execute
purely mental actions (such as using a spell-like
ability). The effect is similar to hold person.

Each round you maintain the spell, the creature
must attempt another Fortitude save. If it fails
the save, it takes 1d6 points of permanent
Constitution drain. Each round you maintain the
spell, however, you take 1d6 points of non-lethal
damage. If you fall unconscious, or if the
creature succeeds at its Fortitude save, the spell
ends.

Material Component: A pure crystal or clear
gemstone worth at least 50 gp.

Author:    Tenjac
Created:   7/7/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_sp_func"

void TombLoop(object oPC, object oTarget);

void EFConcentrationHB(object oPC, object oTarget, int nSpellID)
{
    if(GetBreakConcentrationCheck(oPC) > 0)
    {
        //FloatingTextStringOnCreature("Crafting: Concentration lost!", oPC);
        //DeleteLocalInt(oPC, PRC_CRAFT_HB);
        //return;
        SetLocalInt(oPC, "EFConcBroken", 1);
    }
    else
        DelayCommand(6.0f, EFConcentrationHB(oPC, oTarget, nSpellID));
}

#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nSpellID = PRCGetSpellId();

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oPC, PRCGetSpellId()));

    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        if(PRCDoMeleeTouchAttack(oTarget))
        {
            if((GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) && (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER))
            {
                SetLocalInt(oPC, "CONC_SPELL_LEVEL", PRCGetSpellLevel(oPC, nSpellID));
                DelayCommand(6.0f, EFConcentrationHB(oPC, oTarget, nSpellID));
                TombLoop(oPC, oTarget);
            }
        }
    }

    //SPGoodShift(oPC);
    PRCSetSchool();
}


void TombLoop(object oPC, object oTarget)
{
    // if target creature is dead/invalid, or if caster breaks concentration, stop
    if(GetIsDead(oTarget) || !GetIsObjectValid(oTarget) || GetLocalInt(oPC, "EFConcBroken") == 1)
    {
        RemoveEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc"); // double check it's gone
        DeleteLocalInt(oPC, "CONC_SPELL_LEVEL");
        DeleteLocalInt(oPC, "EFConcBroken");
        return;
    }

    //Save

    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oPC), SAVING_THROW_TYPE_GOOD))
    {
        //Hold
        effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), EffectParalyze());
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.02f);

        //Ability Drain
        ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, d6(1), DURATION_TYPE_PERMANENT, TRUE, 0.0f);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);

        //Damage self
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, d6(1), DAMAGE_TYPE_MAGICAL), oPC);

        DelayCommand(6.0f, TombLoop(oPC, oTarget));
    }
    else // tidy up
    {
        RemoveEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc"); // double check it's gone
        DeleteLocalInt(oPC, "CONC_SPELL_LEVEL");
        DeleteLocalInt(oPC, "EFConcBroken");
    }
}







