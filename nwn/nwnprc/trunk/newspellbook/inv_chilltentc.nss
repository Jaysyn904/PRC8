//::///////////////////////////////////////////////
//:: Name      Chilling Tentacles - OnHeartbeat
//:: FileName  inv_chilltentc.nss
//::///////////////////////////////////////////////

//#include "prc_inc_spells"
//#include "prc_alterations"
#include "prc_inc_combmove"
#include "inv_inc_invfunc"

void DecrementTentacleCount(object oTarget, string sVar)
{
    SetLocalInt(oTarget, sVar, GetLocalInt(oTarget, sVar) - 1);
}

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    int nInvokerLevel = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(oCaster, nInvokerLevel);
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , oCaster)
            && !GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL)
            && oTarget != oCaster)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_CHILLING_TENTACLES));

            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                //apply cold damage - always happens
                effect eColdDamage = EffectDamage(d6(2), DAMAGE_TYPE_COLD);
                eColdDamage = EffectLinkEffects(eColdDamage, EffectVisualEffect(VFX_IMP_FROST_S));
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eColdDamage, oTarget);
            }

            //now do grappling and stuff
            int nGrappleSucessful = FALSE;
            //this spell doesnt need to make a touch attack
            //as defined in the spell
            int nAttackerGrappleMod = nInvokerLevel+4+4;
            nGrappleSucessful = _DoGrappleCheck(OBJECT_INVALID, oTarget, nAttackerGrappleMod);
            if(nGrappleSucessful)
            {
                //if already being grappled, apply damage
                if(GetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF)))
                {
                    //apply the damage
                    int nDamage = d6();
                    nDamage += 4;
                    effect eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
                //now being grappled
                AssignCommand(oTarget, ClearAllActions());
                effect eHold = EffectCutsceneImmobilize();
                effect eEntangle = EffectVisualEffect(VFX_DUR_SPELLTURNING_R);
                effect eLink = EffectLinkEffects(eHold, eEntangle);
                //eLink = EffectKnockdown();
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
                SetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF),
                    GetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF))+1);
                DelayCommand(6.1, DecrementTentacleCount(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF)));
            }
        }
        oTarget = GetNextInPersistentObject();
    }
}
