//::///////////////////////////////////////////////
//:: Thousand Faces
//:: no_sw_thouface
//:://////////////////////////////////////////////
/*
    Allows the Ninjamastah to appear as various
    NPCs of PC playable races.
*/
//:://////////////////////////////////////////////
//:: Created By: Tim Czvetics (NamelessOne)
//:: Created On: Dec 17, 2003
//:://////////////////////////////////////////////
//taken from
//::///////////////////////////////////////////////
//:: Name        Rak disguise
//:: FileName    race_rkdisguise
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
#include "pnp_shft_poly"

void main()
{
    int iSpell = GetSpellId();
    StoreAppearance(OBJECT_SELF);
    int nCurForm = GetAppearanceType(OBJECT_SELF);
    int nPCForm = GetTrueForm(OBJECT_SELF);
    effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

    // Switch to lich
    if (nPCForm == nCurForm)
    {
        //Determine subradial selection
        if(iSpell == SPELLABILITY_NS_DWARF)   //DWARF
        {
            DoDisguise(RACIAL_TYPE_DWARF);
        }
        else if (iSpell == SPELLABILITY_NS_ELF) //ELF
        {
            DoDisguise(RACIAL_TYPE_ELF);
        }
        else if (iSpell == SPELLABILITY_NS_HALF_ELF) //HALF_ELF
        {
            DoDisguise(RACIAL_TYPE_HALFELF);
        }
        else if (iSpell == SPELLABILITY_NS_HALF_ORC) //HALF_ORC
        {
            DoDisguise(RACIAL_TYPE_HALFORC);
        }
        else if (iSpell == SPELLABILITY_NS_HUMAN) //HUMAN
        {
            DoDisguise(RACIAL_TYPE_HUMAN);
        }
        else if (iSpell == SPELLABILITY_NS_GNOME) //GNOME
        {
            DoDisguise(RACIAL_TYPE_GNOME);
        }
        else if (iSpell == SPELLABILITY_NS_HALFLING) //HALFLING
        {
            DoDisguise(RACIAL_TYPE_HALFLING);
        }
        else if (iSpell == SPELLABILITY_NS_OFF) //RETURN TO ORIGINAL APPEARANCE
        {
            //re-use unshifter code from shifter instead
            //this will also remove complexities with lich/shifter characters
            SetShiftTrueForm(OBJECT_SELF);
            //SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
        }
    }
    else // Switch to PC
    {
        //re-use unshifter code from shifter instead
        //this will also remove complexities with lich/shifter characters
        SetShiftTrueForm(OBJECT_SELF);
        //SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
    }

    //Apply the vfx
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
}