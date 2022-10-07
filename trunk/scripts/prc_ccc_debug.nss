// get DoDebug()
#include "inc_debug"
#include "inc_array"
#include "ccc_inc_misc"

void main()
{
    object oPC = OBJECT_SELF;
    DoDebug("Name: "+GetName(oPC));
    DoDebug("Tag:  "+GetTag(oPC));
    DoDebug("Stage:  "+IntToString(GetLocalInt(oPC, "Stage")));
    // feats
    int nArraySize = array_get_size(oPC, "Feats");
    int i;
    for(i = 0; i < nArraySize; i++)
    {
        int nFeat = array_get_int(oPC, "Feats", i);
        DoDebug("Feat: " + IntToString(nFeat));
    }
    DoDebug("Str:  "+IntToString(GetLocalInt(oPC, "Str")));
    DoDebug("Dex:  "+IntToString(GetLocalInt(oPC, "Dex")));
    DoDebug("Con:  "+IntToString(GetLocalInt(oPC, "Con")));
    DoDebug("Int:  "+IntToString(GetLocalInt(oPC, "Int")));
    DoDebug("Wis:  "+IntToString(GetLocalInt(oPC, "Wis")));
    DoDebug("Cha:  "+IntToString(GetLocalInt(oPC, "Cha")));
    DoDebug("Race:  "+IntToString(GetLocalInt(oPC, "Race")));
    DoDebug("Class:  "+IntToString(GetLocalInt(oPC, "Class")));
    DoDebug("HitPoints:  "+IntToString(GetLocalInt(oPC, "HitPoints")));
    DoDebug("Gender:  "+IntToString(GetLocalInt(oPC, "Gender")));
    DoDebug("LawfulChaotic:  "+IntToString(GetLocalInt(oPC, "LawfulChaotic")));
    DoDebug("GoodEvil:  "+IntToString(GetLocalInt(oPC, "GoodEvil")));
    DoDebug("Familiar:  "+IntToString(GetLocalInt(oPC, "Familiar")));
    DoDebug("AnimalCompanion:  "+IntToString(GetLocalInt(oPC, "Companion")));
    DoDebug("Domain1:  "+IntToString(GetLocalInt(oPC, "Domain1")));
    DoDebug("Domain2:  "+IntToString(GetLocalInt(oPC, "Domain2")));
    DoDebug("School:  "+IntToString(GetLocalInt(oPC, "School")));
    DoDebug("SpellsPerDay0:  "+IntToString(GetLocalInt(oPC, "SpellsPerDay0")));
    DoDebug("SpellsPerDay1:  "+IntToString(GetLocalInt(oPC, "SpellsPerDay1")));
    DoDebug("Wings:  "+IntToString(GetLocalInt(oPC, "Wings")));
    DoDebug("Tail:  "+IntToString(GetLocalInt(oPC, "Tail")));
    DoDebug("Portrait:  "+IntToString(GetLocalInt(oPC, "Portrait")));
    DoDebug("Appearance:  "+IntToString(GetLocalInt(oPC, "Appearance")));
    DoDebug("Soundset:  "+IntToString(GetLocalInt(oPC, "Soundset")));
    DoDebug("Skin:  "+IntToString(GetLocalInt(oPC, "Skin")));
    DoDebug("Hair:  "+IntToString(GetLocalInt(oPC, "Hair")));
    DoDebug("Head:  "+IntToString(GetLocalInt(oPC, "Head")));
    DoDebug("Points:  "+IntToString(GetLocalInt(oPC, "Points")));
    DoDebug("i:  "+IntToString(GetLocalInt(oPC, "i")));
    DoDebug("ccc_active_pc:  "+ DebugObject2Str(GetLocalObject(GetModule(), "ccc_active_pc")));
}
