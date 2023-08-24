//::///////////////////////////////////////////////
//:: Name:      Power Leech
//:: Filename:  sp_power_leech.nss
//::///////////////////////////////////////////////
/**@file Power Leech
Necromancy [Evil]
Level: Corrupt 5
Components: V, S, Corrupt
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Target: One living creature
Duration: 1 round/level
Saving Throw: Will negates
Spell Resistance: Yes

The caster creates a conduit of evil energy between
himself and another creature. Through the conduit,
the caster can leech off ability score points at
the rate of 1 point per round. The other creature
takes 1 point of drain from an ability score of
the caster's choosing, and the caster gains a +1
enhancement bonus to the same ability score per
point drained during the casting of this spell.
In other words, all points drained during this
spell stack with each other to determine the
enhancement bonus, but they don't stack with
other castings of power leech or with other
enhancement bonuses.

The enhancement bonus lasts for 10 minutes per
caster level.

Corruption Cost: 1 point of Wisdom drain.


@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "inc_dynconv"

void main()
{

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Spellhook
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nAbility;
    int nSpell = GetSpellId();
    int nRoundCounter = nCasterLvl;
    float fRemove = (nCasterLvl * 600.0f);
    effect eDur  = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_POWER_LEECH, oPC);

    //Check for Extend
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        fRemove = (fRemove * 2);
    }

    //Set float
    SetLocalFloat(oPC, "PRC_Power_Leech_fDur", fRemove);

    //Set counter int
    SetLocalInt(oPC, "PRC_Power_Leech_Counter", nRoundCounter);

    // don't allow it to be cast again on the same object if it's still under the effect
    if (array_exists(OBJECT_SELF, "PRC_PowerLeechTarget"))
    {
        int nArraySize = array_get_size(oPC, "PRC_PowerLeechTarget");
        int i;
        object oCompare;
        for(i = 0; i < nArraySize; i++)
        {
            oCompare = array_get_object(oPC, "PRC_PowerLeechTarget", i);
            if (oCompare == oTarget) // the the target is still under the spell's effects
            {
                // spell has no effect
                FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE); // "Target already has this effect!"
                PRCSetSchool();
                return;
            }
        }
        array_set_object(oPC, "PRC_PowerLeechTarget", nArraySize, oTarget);
    }
    else if (PRCGetIsAliveCreature(oTarget))
    {
        // Add target to local object array
        array_create(oPC, "PRC_PowerLeechTarget");
        array_set_object(oPC, "PRC_PowerLeechTarget", array_get_size(oPC, "PRC_PowerLeechTarget"), oTarget);
        
    	//Clear actions for the convo
        ClearAllActions(TRUE);

    	//Check for ability to drain

    	/*  <Stratovarius> That would be easiest to do as a convo I think
            <Stratovarius> just steal the animal affinity one from psionics and modify*/

    	StartDynamicConversation("power_leech", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);        
    }

    //Corruption Cost
    {
        DelayCommand(fRemove, DoCorruptionCost(oPC, ABILITY_WISDOM, 1, 1));
    }

    //Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 10, FALSE);

    //SPEvilShift(oPC);

    PRCSetSchool();
}