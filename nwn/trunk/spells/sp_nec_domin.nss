//::///////////////////////////////////////////////
//:: Name      Necrotic Domination
//:: FileName  sp_nec_domin.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Domination
Necromancy [Evil]
Level: Clr 4, sor/wiz 4
Components: V S, F
Target: Living creature with necrotic cyst

This spell functions like dominate person,
except you can dominate any humanoid that
harbors a necrotic cyst.


*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "spinc_necro_cyst"
#include "inc_utility"
#include "prc_add_spell_dc"

void main()
{
    // Set the spellschool
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_NECROTIC_DOMINATION, oPC);

    if(!GetCanCastNecroticSpells(oPC))
    return;

    if(!GetHasNecroticCyst(oTarget))
    {
        // "Your target does not have a Necrotic Cyst."
        SendMessageToPCByStrRef(oPC, nNoNecCyst);
        return;
    }
    //Domination

    effect eDom1 = EffectDominated();
    effect eDom = PRCGetScaledEffect(eDom1, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link duration effects
    effect eLink = EffectLinkEffects(eMind, eDom);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nCasterLevel = CasterLvl;
    int nDuration = 2 + nCasterLevel/3;
    nDuration = PRCGetScaledDuration(nDuration, oTarget);

    int nRacial = MyPRCGetRacialType(oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
    nCasterLevel +=SPGetPenetr();
    //Make sure the target is a humanoid
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        if  ((nRacial == RACIAL_TYPE_DWARF)||
        (nRacial == RACIAL_TYPE_ELF) ||
        (nRacial == RACIAL_TYPE_GNOME)||
        (nRacial == RACIAL_TYPE_HALFLING)||
        (nRacial == RACIAL_TYPE_HUMAN)||
        (nRacial == RACIAL_TYPE_HALFELF)||
        (nRacial == RACIAL_TYPE_HALFORC))
        {

            //Make SR Check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLevel))
            {
                //Make Will Save
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
                {
                    //Check for metamagic extension
                    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
                    {
                        nDuration = (nDuration * 2);
                    }
                    //Apply linked effects and VFX impact
                    DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name

    //SPEvilShift(oPC);
}






