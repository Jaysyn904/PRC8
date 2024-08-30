//:://////////////////////////////////////////////
//:: Shifter - Learn Shape
//:: pnp_shft_lrnshap
//:://////////////////////////////////////////////

#include "prc_shifter_info"
#include "prc_inc_shifting"

void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    //Reload from target, as some modules load a template and modify it; but we can't get the modifications.
    object oTemplate = _prc_inc_load_template_from_resref(GetResRef(oTarget), GetHitDice(oPC));

    int nIndex = GetCreatureIsKnown(oPC, SHIFTER_TYPE_SHIFTER, oTemplate);
        //Returns 0 if shape is not known, index+1 if it is known
        
    if (DEBUG) DoDebug("pnp_shft_lrnshap: oPC "+GetName(oPC)+" oTarget "+GetName(oTarget)+" ResRef "+GetResRef(oTarget)+" nIndex "+IntToString(nIndex));

    if (nIndex)
    {
        string sName = GetName(oTemplate);
        string sMessage = ReplaceString(GetStringByStrRef(57480+0x01000000), "%(SHAPENAME)", sName); //"You already know <shape>"
        FloatingTextStringOnCreature(sMessage, oPC, FALSE);

        string sNamesArray = SHIFTER_NAMES_ARRAY + IntToString(SHIFTER_TYPE_SHIFTER);
        string sKnownName = persistant_array_get_string(oPC, sNamesArray, nIndex-1);

        int i = FindSubString(sKnownName, " (");
        if (i != -1)
            sKnownName = GetSubString(sKnownName, 0, i);
        if (sName != sKnownName)
        {
            //If the template was learned under a different name, tell what that name is
            sMessage = ReplaceString(GetStringByStrRef(57486+0x01000000), "%(SHAPENAME)", sKnownName); //"(Known as <shape>)"
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
        }

        //int bDebug = GetLocalInt(oPC, "prc_shift_debug");
        DelayCommand(1.0f, _prc_inc_PrintShape(oPC, oTemplate, DEBUG));
    }
    else if(GetCanShiftIntoCreature(oPC, SHIFTER_TYPE_SHIFTER, oTemplate))
    {
        StoreShiftingTemplate(oPC, SHIFTER_TYPE_SHIFTER, oTemplate);
        string sMessage = ReplaceString(GetStringByStrRef(57478+0x01000000), "%(SHAPENAME)", GetName(oTemplate)); //"Learned <shape>"
        FloatingTextStringOnCreature(sMessage, oPC, FALSE);
        //int bDebug = GetLocalInt(oPC, "prc_shift_debug");
        DelayCommand(1.0f, _prc_inc_PrintShape(oPC, oTemplate, DEBUG));
    }
    else
    {
        string sMessage = ReplaceString(GetStringByStrRef(57479+0x01000000), "%(SHAPENAME)", GetName(oTemplate)); //"Cannot learn <shape>"
        FloatingTextStringOnCreature(sMessage, oPC, FALSE);
        //int bDebug = GetLocalInt(oPC, "prc_shift_debug");
        if (DEBUG || GetLocalInt(oPC, "prc_shifter_print"))
            DelayCommand(1.0f, _prc_inc_PrintShape(oPC, oTemplate, DEBUG));
    }

    DelayCommand(SHIFTER_TEMPLATE_DESTROY_DELAY, MyDestroyObject(oTemplate));
}
