/*
15/02/19 by Stratovarius

Curtain of Shadows

Initiate, Veil of Shadows 
Level/School: 5th/Transmutation 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: Shadowy wall 
Duration: 1 minute/level 
Saving Throw: None 
Spell Resistance: No

You create a wall of frigid shadow that wracks all who pass through it with cold.

You create a wall of shadow. Any creature passing through the wall takes 1d6 points of cold damage per caster level (maximum 15d6).
*/

void DecrementTentacleCount(object oTarget, string sVar)
{
    SetLocalInt(oTarget, sVar, GetLocalInt(oTarget, sVar) - 1);
}

#include "shd_inc_shdfunc"
#include "prc_inc_combmove"

void main()
{
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    //Declare major variables
    object oShadow = GetAreaOfEffectCreator();
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST); 

    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow) && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(oShadow, SPELL_EVARDS_BLACK_TENTACLES));
            //now do grappling and stuff
            int nGrappleSucessful = FALSE;
            //this spell doesnt need to make a touch attack
            //as defined in the spell
            int nAttackerGrappleMod = myst.nShadowcasterLevel + 8;
            nGrappleSucessful = _DoGrappleCheck(OBJECT_INVALID, oTarget, nAttackerGrappleMod);
            if(nGrappleSucessful)
            {
                //if already being grappled, apply damage
                if(GetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF)))
                {
                    //apply the damage
                    int nDamage = MetashadowsDamage(myst, 6, 1, 4);
                    effect eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
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
