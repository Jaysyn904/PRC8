/*
    prc_pyro_death

    Target saves or dies

    By: Flaming_Sword
    Created: Dec 7, 2007
    Modified: Dec 7, 2007
*/

#include "prc_alterations"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    if(!UsePsionicFocus(oPC))
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }
    object oTarget = PRCGetSpellTargetObject();
    int nDamageType = GetPersistantLocalInt(oPC, "PyroDamageType");
    int nImpactVFX = GetPersistantLocalInt(oPC, "PyroImpactVFX");
    int nImpactBigVFX = GetPersistantLocalInt(oPC, "PyroImpactBigVFX");
    int nDC = 14 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nDice = 4;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAT_DEATH));

        //Make Forttude save
        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, GetPersistantLocalInt(oPC, "PyroSave")))
        {
            DeathlessFrenzyCheck(oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nImpactBigVFX), oTarget);

            //Apply the death effect and VFX impact
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
            //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        else
        {
            // Target shouldn't take damage if they are immune to death magic.
            if (!(GetHasMettle(oTarget, SAVING_THROW_FORT)))
            {
                int nDam = (nDamageType == DAMAGE_TYPE_SONIC) ? d6(nDice) : d8(nDice);  //reduced damage dice
                if((nDamageType == DAMAGE_TYPE_COLD) || (nDamageType == DAMAGE_TYPE_ELECTRICAL) || (nDamageType == DAMAGE_TYPE_ACID))
                    nDam = max(nDice, nDam - nDice);  //minimum of 1 per die

                //Apply damage effect and VFX impact
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, nDamageType), oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nImpactVFX), oTarget);
            }
        }
    }
}
