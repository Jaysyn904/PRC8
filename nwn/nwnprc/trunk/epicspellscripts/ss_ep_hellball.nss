//::///////////////////////////////////////////////
//:: Hellball
//:: X2_S2_HELLBALL
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
//:: Created By: Andrew Noobs, Georg Zoeller
//:: Created On: 2003-08-20
//:://////////////////////////////////////////////
/*
    Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/

#include "prc_alterations"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_HELBALL))
    {
        //Declare major variables
        int nDamage1, nDamage2, nDamage3, nDamage4;
        float fDelay;
        effect eExplode = EffectVisualEffect(464);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        effect eVis2 = EffectVisualEffect(VFX_IMP_ACID_L);
        effect eVis3 = EffectVisualEffect(VFX_IMP_SONIC);

 
        // if this option has been enabled, the caster will take damage for casting
        // epic spells, as descripbed in the ELHB
        if (GetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE) == TRUE)
        {
            effect eCast = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            int nDamage5 = d6(10);
            effect eDam5 = EffectDamage(nDamage5, DAMAGE_TYPE_NEGATIVE);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam5, OBJECT_SELF);
        }



        effect eDam1, eDam2, eDam3, eDam4, eDam5, eKnock;
        eKnock= EffectKnockdown();

        location lTarget = PRCGetSpellTargetLocation();

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

        int nTotalDamage;
        while (GetIsObjectValid(oTarget))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {

            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));

            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20 + 0.5f;
               //Roll damage for each target
                nDamage1 = d6(10);
                nDamage2 = d6(10);
                nDamage3 = d6(10);
                nDamage4 = d6(10);

                // no we don't care about evasion. there is no evasion to hellball
                if (PRCMySavingThrow(SAVING_THROW_REFLEX,oTarget,GetEpicSpellSaveDC(OBJECT_SELF, oTarget),SAVING_THROW_TYPE_SPELL,OBJECT_SELF,fDelay) >0)
                {
                    nDamage1 /=2;
                    nDamage2 /=2;
                    nDamage3 /=2;
                    nDamage4 /=2;
                }
                nTotalDamage = nDamage1+nDamage2+nDamage3+nDamage4;
                //Set the damage effect
                eDam1 = EffectDamage(nDamage1, DAMAGE_TYPE_ACID);
                eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_ELECTRICAL);
                eDam3 = EffectDamage(nDamage3, DAMAGE_TYPE_FIRE);
                eDam4 = EffectDamage(nDamage4, DAMAGE_TYPE_SONIC);

                if(nTotalDamage > 0)
                {
                    if (nTotalDamage > 50)
                    {
                        DelayCommand(fDelay+0.3f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget,3.0f, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
                    }

                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam3, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam4, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay+0.2f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                    DelayCommand(fDelay+0.5f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
                 }
            }
           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

