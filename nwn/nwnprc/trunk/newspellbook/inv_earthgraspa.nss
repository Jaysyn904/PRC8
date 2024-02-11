//::///////////////////////////////////////////////
//:: Name      Earthen Grasp - OnEnter
//::           Stony Grasp - OnEnter
//:: FileName  inv_earthgraspa.nss
//::///////////////////////////////////////////////

#include "prc_inc_combmove"
#include "inv_inc_invfunc"

void main()
{
    object oAoE = OBJECT_SELF;
    SetAllAoEInts(INVOKE_AOE_EARTHEN_GRASP_GRAPPLE, oAoE, GetSpellSaveDC());

    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nCasterLevel = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(oCaster);
    int StrMod = 2 + nCasterLevel / 3;

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , oCaster)
    && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE
    && !GetLocalInt(oAoE, "AlreadyGrappling")
    && !GetLocalInt(oTarget, "SourceOfGrapple"))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_EARTHEN_GRASP));

        //now do grappling and stuff
        //cant already be grappled so no need to check that
        int nGrappleSucessful = FALSE;
        //this spell doesnt need to make a touch attack
        //as defined in the spell
        int nAttackerGrappleMod = nCasterLevel + StrMod;
        nGrappleSucessful = _DoGrappleCheck(OBJECT_INVALID, oTarget, nAttackerGrappleMod);
        if(nGrappleSucessful)
        {
            //now being grappled
            AssignCommand(oTarget, ClearAllActions());
            effect eHold = EffectCutsceneImmobilize();
            effect eEntangle = EffectVisualEffect(VFX_DUR_SPELLTURNING_R);
            effect eLink = EffectLinkEffects(eHold, eEntangle);
            //eLink = EffectKnockdown();
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
            SetLocalInt(oAoE, "AlreadyGrappling", TRUE);
            SetLocalObject(oAoE, "CurrentlyGrappling", oTarget);
        }
    }
}