//::///////////////////////////////////////////////
//:: Draconian Death Throes
//:: race_deaththroes.nss
//::///////////////////////////////////////////////
/*
    Handles the after-death effects of Draconians
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 09, 2008
//:://////////////////////////////////////////////

#include "prc_inc_spells"

//function to handle the damage from a kapak's acid pool
void DoKapakAcidDamage(object oPC, location lTarget)
{
    float fRadius = FeetToMeters(5.0);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
        {
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            int nDamage = d6();
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

            // Apply effects to the currently selected target.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void main()
{
 /*   int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("race_deaththroes running, event: " + IntToString(nEvent));

    // Init the PC.
    object oPC;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        oPC = OBJECT_SELF;
        // Hook in the events
        if(DEBUG) DoDebug("race_deaththroes: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYERDEATH, "race_deaththroes", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ONPLAYERDEATH)
    {
        oPC = GetLastPlayerDied();
        object oEnemy = GetLastHostileActor();
        if(DEBUG) DoDebug("race_deaththroes - OnDeath");

        int nRace = GetRacialType(oPC);
        if(nRace == RACIAL_TYPE_BOZAK)
        {
            location lTarget = GetLocation(oPC);
            int nDC = 10 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_FIRE), lTarget);

            object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while (GetIsObjectValid(oTarget))
            {
                if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
                {
                    float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                    int nDamage = d6();
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_NONE);
                    if(nDamage)
                    {
                        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                }
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
        }
        else if(nRace == RACIAL_TYPE_KAPAK)
        {
            int nDuration = d6();
            location lTarget = GetLocation(oPC);

            //use a switch to set the proper amount of "pulses" of damage
            switch(nDuration)
            {
                case 6:
                    DelayCommand(RoundsToSeconds(5), DoKapakAcidDamage(oPC, lTarget));
                case 5:
                    DelayCommand(RoundsToSeconds(4), DoKapakAcidDamage(oPC, lTarget));
                case 4:
                    DelayCommand(RoundsToSeconds(3), DoKapakAcidDamage(oPC, lTarget));
                case 3:
                    DelayCommand(RoundsToSeconds(2), DoKapakAcidDamage(oPC, lTarget));
                case 2:
                    DelayCommand(RoundsToSeconds(1), DoKapakAcidDamage(oPC, lTarget));
                case 1:
                    DoKapakAcidDamage(oPC, lTarget); break;
            }
        }
        else if(nRace == RACIAL_TYPE_BAAZ)
        {
            //disarm code
            if(GetIsCreatureDisarmable(oEnemy) && !GetPRCSwitch(PRC_PNP_DISARM))
            {
                if(DEBUG) DoDebug("race_deaththroes: Disarming Enemy");
                AssignCommand(oEnemy, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEnemy), oPC));
            }
            else
                if(DEBUG) DoDebug("race_deaththroes: Enemy not disarmable.");
        }
    }*/
}