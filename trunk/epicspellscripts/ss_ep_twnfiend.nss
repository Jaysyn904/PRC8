//::///////////////////////////////////////////////
//:: Epic Spell: Twinfiend
//:: Author: Boneshank (Don Armstrong)

//#include "x2_inc_toollib"
#include "prc_alterations"
#include "inc_epicspells"
//#include "x2_inc_spellhook"
#include "nw_i0_generic"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_TWINF))
    {
        //Declare major variables
        float fDuration = RoundsToSeconds(20);
        object oFiend, oFiend2;
        // effect eSummon;
        effect eVis = EffectVisualEffect(460);
        effect eVis2 = EffectVisualEffect(VFX_IMP_UNSUMMON);
        if(GetPRCSwitch(PRC_MULTISUMMON))
        {
            string sSummon = "twinfiend_demon";
            effect eSummon = EffectSummonCreature(sSummon, 460);
            MultisummonPreSummon();
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, 
                PRCGetSpellTargetLocation(), fDuration);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, 
                PRCGetSpellTargetLocation(), fDuration);
            DelayCommand(0.5, AugmentSummonedCreature(sSummon));
        }
        else
        {
            DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation()));
            oFiend = CreateObject(OBJECT_TYPE_CREATURE, "twinfiend_demon", PRCGetSpellTargetLocation());
            oFiend2 = CreateObject(OBJECT_TYPE_CREATURE, "twinfiend_demon", PRCGetSpellTargetLocation());
            SetMaxHenchmen(GetMaxHenchmen() + 2);
            AddHenchman(OBJECT_SELF, oFiend);
            AddHenchman(OBJECT_SELF, oFiend2);
            SetMaxHenchmen(GetMaxHenchmen() - 2);
            AssignCommand(oFiend, DetermineCombatRound());
            AssignCommand(oFiend2, DetermineCombatRound());
            DestroyObject(oFiend, fDuration);
            DelayCommand(fDuration, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oFiend)));
            DestroyObject(oFiend2, fDuration);
            DelayCommand(fDuration, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oFiend2)));
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


