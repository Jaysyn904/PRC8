//::///////////////////////////////////////////////
//:: Name      Call Dretch Horde
//:: FileName  sp_call_dretch.nss
//:://////////////////////////////////////////////
/**@file Call Dretch Horde
Conjuration (Calling) [Evil]
Level: Demonologist 3, Mortal Hunter 4, Sor/Wiz 5
Components: V S, Soul
Casting Time: 1 minute
Range: Close (25 ft. + 5 ft./2 levels)
Effect: 2d4 dretches
Duration: One year
Saving Throw: None
Spell Resistance: No

The caster calls 2d4 dretches from the Abyss to where
she is, offering them the soul that she has prepared.
In exchange, they will serve the caster for one year
as guards, slaves, or whatever else she needs them
for. They are profoundly stupid, so the caster cannot
give them more complicated tasks than can be described
in about ten words.

No matter how many times the caster casts this spell,
she can control no more than 2 HD worth of fiends per
caster level. If she exceeds this number, all the newly
called creatures fall under the caster's control, and
any excess from previous castings become uncontrolled.
The caster chooses which creatures to release.

Author:    Tenjac
Created:   5/7/2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;
          
     PRCSetSchool(SPELL_SCHOOL_CONJURATION);
          
          
    object oPC = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    location lLoc = PRCGetSpellTargetLocation();
    string sResRef = "prc_sum_dretch";
    effect eModify = EffectModifyAttacks(2);      

    MultisummonPreSummon();
    if(GetPRCSwitch(PRC_MULTISUMMON))
    {
        effect eSummon = EffectSummonCreature(sResRef);
               eSummon = SupernaturalEffect(eSummon);    
        
        //determine how many to take control of
        int nTotalCount = d4(2);
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
        FloatingTextStringOnCreature("Currently have "+IntToString(nTotalControlled)+"HD out of "+IntToString(nMaxHDControlled)+"HD.", OBJECT_SELF);
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

