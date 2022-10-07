//::///////////////////////////////////////////////
//:: Epic Spell: Enslave
//:: Author: Boneshank (Don Armstrong)

#include "prc_alterations"
#include "inc_epicspells"

void RemoveDomination(object oCreature, object oSlaver = OBJECT_SELF)
{
    effect eComp = SupernaturalEffect(EffectCutsceneDominated());
    effect e = GetFirstEffect(oCreature);
    
    while (GetIsEffectValid(e))
    {
        if (GetEffectType(e) == GetEffectType(eComp) && GetEffectCreator(e) == oSlaver)
        {
            RemoveEffect(oCreature, e);
        }
        e = GetNextEffect(oCreature);
    }
}
    

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ENSLAVE))
    {
        //Declare major variables
        object oTarget = PRCGetSpellTargetObject();
        object oOldSlave = GetLocalObject(OBJECT_SELF, "EnslavedCreature");
        effect eDom = EffectCutsceneDominated();
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        //Link domination and persistant VFX
        effect eLink = EffectLinkEffects(eMind, eDom);
        eLink = EffectLinkEffects(eLink, eDur);
        effect eLink2 = SupernaturalEffect(eLink);

        effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_MONSTER, FALSE));
        //Make sure the target is a monster
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Make SR Check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF)) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) && !GetIsImmune(oTarget, IMMUNITY_TYPE_DOMINATE) && !GetIsPC(oTarget))
            {
                //Make a Will Save
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Release old slave
                    if (GetIsObjectValid(oOldSlave)) RemoveDomination(oOldSlave);

                    //Apply linked effects and VFX Impact
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    SetLocalObject(OBJECT_SELF, "EnslavedCreature", oTarget);
                }
                else 
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
            }
            else 
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
        }
        else 
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
