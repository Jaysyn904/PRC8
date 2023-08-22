//::///////////////////////////////////////////////
//:: Name      Call Lemure Horde
//:: FileName  sp_call_lemure.nss
//:://////////////////////////////////////////////
/**@file Call Lemure Horde
Conjuration (Calling) [Evil]
Level: Mortal Hunter 4, Sor/Wiz 5
Components: V S, Soul
Casting Time: 1 minute
Range: Close (25 ft. + 5 ft./2 levels)
Effect: 3d4 1emures
Duration: One year
Saving Throw: None
Spell Resistance: No

The caster calls 3d4 lemures from the Nine Hells to
where he is, offering them the soul that he has
prepared. In exchange, they will serve the caster
for one year as guards, slaves, or whatever else
he needs them for. They are non­-intelligent,
so the caster cannot give them more complicated
tasks than can be described in about five words.

No matter how many times the caster casts this
spell, he can control no more than 2 HD worth
of fiends per caster level. If he exceeds this
number, all the newly called creatures fall under
the caster's control, and any excess from previous
castings become uncontrolled. The caster chooses
which creatures to release.

Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    location lLoc = PRCGetSpellTargetLocation();
    string sResRef = "prc_sum_lemure";
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);


    MultisummonPreSummon();
    if(GetPRCSwitch(PRC_MULTISUMMON))
    {
        effect eSummon = EffectSummonCreature(sResRef);
        eSummon = SupernaturalEffect(eSummon);    
        //determine how many to take control of
        int nTotalCount = d4(2);
         effect eModify = EffectModifyAttacks(1);        
        int i;
        int nMaxHDControlled = nCasterLvl * 2;
        int nTotalControlled = GetControlledFiendTotalHD(oPC);
        //Summon loop
        while(nTotalControlled < nMaxHDControlled
            && i < nTotalCount)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, oPC, 9999.0f);
            i++;    
            nTotalControlled = GetControlledFiendTotalHD(oPC);
        }
        FloatingTextStringOnCreature(" You currently have "+IntToString(nTotalControlled)+"HD out of "+IntToString(nMaxHDControlled)+"HD.", OBJECT_SELF);
    }
    else
    {
        //non-multisummon
        //this has a swarm type effect since dretches are useless individually        
        effect eSummon = EffectSwarm(TRUE, sResRef);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, oPC, 9999.0f);
    }
    //SPEvilShift(oPC);
    PRCSetSchool();
}
