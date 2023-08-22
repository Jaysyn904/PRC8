//::///////////////////////////////////////////////
//:: Name      Plague of Undead
//:: FileName  sp_plaguedead.nss
//:://////////////////////////////////////////////
/**@file Plague of Undead
Necromancy [Evil]
Level: Clr 9, Dn 9, Wiz 9
Components: V, S
Casting Time: 1 standard action
Range: Close
Effect: Raise Undead
Duration: Permanent

You summon 4 Bone Warriors. These last until they are killed.

Author:    Stratovarius
Created:   5/17/2009
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel();
    int nMaxHD = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER) > 7 ?
                  nCasterLevel * (4 + GetAbilityModifier(ABILITY_CHARISMA)) : nCasterLevel * 4;
    int nTotalHD = GetControlledUndeadTotalHD();
    int nHD = 20;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon = SupernaturalEffect(EffectSummonCreature("prc_sum_bonewar"));

    MultisummonPreSummon();
    int i;
    for(i = 1; i < 5; i++) // 4 monsters
    {
        if(nTotalHD + nHD <= nMaxHD)
        {
            nTotalHD += nHD;
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, lTarget);
        }
        else
            FloatingTextStringOnCreature("You cannot create more undead at this time.", OBJECT_SELF);
    }

    FloatingTextStringOnCreature("Currently have "+IntToString(nTotalHD)+"HD out of "+IntToString(nMaxHD)+"HD.", OBJECT_SELF);

    PRCSetSchool();
}