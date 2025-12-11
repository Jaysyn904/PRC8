void Cleanup(object oArea)
{
	if (GetResRef(oArea) == "bdd_cave")
	{
		DestroyArea(GetObjectByTag("bdd_basinrim"));
		//DestroyArea(GetObjectByTag("bdd_cave"));
		DestroyArea(GetObjectByTag("bdd_smelter"));
	}	
	
	DestroyArea(oArea);
}

void main()
{
    object oPC = GetPlaceableLastClickedBy();
    object oArea = GetArea(oPC);
    ClearAllActions();
	AssignCommand(oPC, JumpToLocation(GetLocalLocation(oPC, "EA_Return")));
	DelayCommand(1.0, ClearAllActions());
	//DelayCommand(3.0, Cleanup(oArea));
}
