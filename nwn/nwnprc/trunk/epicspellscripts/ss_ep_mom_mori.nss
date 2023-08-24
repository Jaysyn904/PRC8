//::///////////////////////////////////////////////
//:: Epic Spell: Momento Mori
//:: Author: Boneshank (Don Armstrong)

#include "prc_alterations"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_MORI))
    {
        //Declare major variables
        object oTarget = PRCGetSpellTargetObject();
        int nDamage;
        effect eDam;
        effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
        effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
            GetHitDice(oTarget) < 50 && oTarget != OBJECT_SELF)
        {
            //Make SR check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF)))
               {
                 //Make Fortitude save
                 if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget)+10, SAVING_THROW_TYPE_DEATH))
                 {
                    DeathlessFrenzyCheck(oTarget);
                    //Apply the death effect and VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                 }
                 else
                 {
                    //Roll damage
                    nDamage = d6(3) + 20;
				if (GetHasMettle(oTarget, SAVING_THROW_FORT))
				// This script does nothing if it has Mettle, bail
					nDamage = 0;                       
                    //Set damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    //Apply damage effect and VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
            }
        }
        else SendMessageToPC(OBJECT_SELF, "Spell failure - the target was not valid.");
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
