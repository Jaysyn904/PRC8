//Spell script for reserve feat touch attacks
//prc_reservtch
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nSpellID = PRCGetSpellId();

    effect eEffect, eLink, eVis, eVisFail;

    int nDamageType, iAttackRoll, nDuration, nPartial, nDC;
    int nDamage = 0;

    //Define individual spell parameters
    switch (nSpellID)
    {
        case SPELL_CLAP_OF_THUNDER:
        {
	        nDamage = d6(GetLocalInt(oPC, "ClapOfThunderBonus"));
            nDamageType = DAMAGE_TYPE_SONIC;
            nDuration = 1;
            nPartial = 0;
            nDC = 10 + GetLocalInt(oPC, "ClapOfThunderBonus") + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);
            
            eEffect = EffectDeaf();
            eEffect = SupernaturalEffect(eEffect);
            eVis = EffectVisualEffect(VFX_IMP_SONIC);
	        eVisFail = EffectVisualEffect(VFX_IMP_STUN);

            if (!GetLocalInt(oPC, "ClapOfThunderBonus")) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }
            break;
        }

        case SPELL_SICKENING_GRASP:
        {
            nDuration = GetLocalInt(oPC, "SickeningGraspBonus");
            nPartial = 1;
            nDC = 10 + GetLocalInt(oPC, "SickeningGraspBonus") + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);
            
            eEffect = EffectAttackDecrease(2);
            eEffect = EffectLinkEffects(EffectDamageDecrease(2, DAMAGE_TYPE_SLASHING), eEffect);
            eEffect = EffectLinkEffects(EffectSavingThrowDecrease(SAVING_THROW_ALL, 2), eEffect);
            eEffect = EffectLinkEffects(EffectSkillDecrease(SKILL_ALL_SKILLS, 2), eEffect);
            eEffect = SupernaturalEffect(eEffect);
            eVis = EffectVisualEffect(VFX_IMP_ACID_S);
	        eVisFail = EffectVisualEffect(VFX_IMP_STUN);

            //Sanity checks
            if (!GetLocalInt(oPC, "SickeningGraspBonus")) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            if (GetLocalInt(oTarget, "HasSickeningGrasp") == TRUE)
            {
                FloatingTextStringOnCreature("Target is already sickened", oPC, FALSE);
                return;
            }
            break;
        }
    }

    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        SignalEvent(oTarget, EventSpellCastAt(oPC, nSpellID, TRUE));

        iAttackRoll = PRCDoMeleeTouchAttack(oTarget);

        if (iAttackRoll > 0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            if (nDamage > 0) ApplyTouchAttackDamage(oPC, oTarget, iAttackRoll, nDamage, nDamageType);
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisFail, oTarget);
                if (nPartial == 1)
                {
                    SetLocalInt(oTarget, "HasSickeningGrasp", TRUE);
                    DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(oTarget, "HasSickeningGrasp"));
                }
            }
            else if (nPartial == 1)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(1));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisFail, oTarget);
                SetLocalInt(oTarget, "HasSickeningGrasp", TRUE);
                DelayCommand(6.0, DeleteLocalInt(oTarget, "HasSickeningGrasp"));
            }
        }
    }
}