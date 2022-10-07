//::///////////////////////////////////////////////
//:: Name      Sarcophagus of Stone
//:: FileName  sp_sarc_stone.nss
//:://////////////////////////////////////////////
/**@file Sarcophagus of Stone
Conjuration (Creation) [Earth]
Level: Clr 6
Components: V S M DF
Casting Time: 1 standard action
Duration: Instantaneous
Range: Close (25 ft + 5 ft/2 lvls)
Target: 1 medium or smaler creature
Spell Resistance: No
Saving Throw: Reflex negates

This spell creates an airtight
stone coffin that forms around
the target. The stone is 1 inch thick, has
hardness 8, and requires 15 points of
damage to break through. Decreasing
its size does not change the thickness
of the walls; the coffin is always just
large enough to hold the subject. This
coffin is sealed upon formation and
completely impervious to air and gas. A
creature trapped within a sarcophagus of
stone has 1 hour worth of air, and after
that time will begin to suffocate. A creature 
that has no need to breathe needs not
fear suffocation, but it remains trapped
within the sarcophagus until it breaks
free or is freed.

A creature within the coffin can
attack the stone with a natural weapon
or light melee weapon. A creature can
attempt a DC 26 Strength check to
break free of the stone, and allies can
also help to break the trapped creature
free.

Material Component: A fragment of a
sarcophagus.

Author:    Tenjac
Created:   6/25/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"
#include "prc_add_spell_dc"

void GaspGaspCroak(object oTarget, int nCounter);

void SarcMonitor(object oSarc, object oTarget);

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    string sSarc = "prc_sarc_stone";
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nCasterLvl = PRCGetCasterLevel(oPC);

    //Save
    if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
    {
        effect eHide = EffectLinkEffects(EffectCutsceneGhost(), EffectCutsceneImmobilize());
        eHide = EffectLinkEffects(eHide, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
        eHide = EffectLinkEffects(eHide, EffectVisualEffect(VFX_DUR_BLIND));

        location lLoc = GetLocation(oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHide, oTarget, HoursToSeconds(24), FALSE, SPELL_SARCOPHAGUS_OF_STONE, nCasterLvl);

        ///Create the sarcophagus
        object oSarc = CreateObject(OBJECT_TYPE_PLACEABLE, sSarc, lLoc, FALSE);

        //Make sure it's locked
        SetLocked(oTarget, TRUE);

        //Watch for sarcophagus destruction
        SarcMonitor(oSarc, oTarget);

        AssignCommand(oTarget, ClearAllActions(TRUE));

        //Start convo for Str check
        StartDynamicConversation("sarc_stone", oTarget, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

        //Set up 1 hour counter
        int nCounter = FloatToInt(HoursToSeconds(1) + RoundsToSeconds(3));

        //Start Suffocation function
        GaspGaspCroak(oTarget, nCounter);
    }
    PRCSetSchool();
}

void GaspGaspCroak(object oTarget, int nCounter)
{
    if(nCounter <1)
    {
        //If living
        if(PRCGetIsAliveCreature(oTarget) && !GetHasFeat(FEAT_BREATHLESS, oTarget))
        {
            //Kill it.
            effect eDeath = EffectDeath();
            eDeath = SupernaturalEffect(eDeath);
            DeathlessFrenzyCheck(oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
            return;
        }
    }
    nCounter--;
    DelayCommand(RoundsToSeconds(1),GaspGaspCroak(oTarget, nCounter));
}

void SarcMonitor(object oSarc, object oTarget)
{
    //if sarc is destroyed
    if(GetCurrentHitPoints(oSarc) < 1)
    {
        //remove spell effects
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectSpellId(eTest) == SPELL_SARCOPHAGUS_OF_STONE)
            {
                RemoveEffect(oTarget, eTest);
            }
            eTest = GetNextEffect(oTarget);
        }
    }
    else DelayCommand(3.0f, SarcMonitor(oSarc, oTarget));
}