#include "inc_pers_array"
#include "inc_newspellbook"

void del_tmp(object oPC, string sArray)
{
    persistant_array_delete(oPC, sArray);
}

void DeleteArrays(object oPC, int nClass)
{
    string sArray1 = "Spellbook";
    string sArray2 = "NewSpellbookMem_";
    DelayCommand(0.1, del_tmp(oPC, sArray2+IntToString(nClass)));
    int j;
    for(j = 0; j <= 9; j++)
    {
        DelayCommand(0.1*j, del_tmp(oPC, sArray1+IntToString(j)+"_"+IntToString(nClass)));
    }
        DelayCommand(0.2, del_tmp(oPC, sArray1+IntToString(nClass)));
    //advanced learning:
    if(nClass == CLASS_TYPE_WARMAGE || nClass == CLASS_TYPE_BEGUILER)
        DeletePersistantLocalInt(oPC, "AdvancedLearning_"+IntToString(nClass));
}


void main()
{
    object oPC = OBJECT_SELF;

    int i;
    for(i = 1; i <= 8; i++)
    {
        int nClass = GetClassByPosition(i, oPC);
        DelayCommand(0.5*i, DeleteArrays(oPC, nClass));
    }
    DelayCommand(10.0, WipeSpellbookHideFeats(oPC));
}
