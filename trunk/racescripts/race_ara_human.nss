//::///////////////////////////////////////////////
//:: [Aranea Alternate Form: Humanoid]
//:: [race_ara_human.nss]
//:: [Jaysyn / ebonfowl / PRC 20220421]
//::///////////////////////////////////////////////
/**@file  Alternate Form (Su): An aranea's natural form is that of a large 
monstrous spider.  It can assume two other forms.  The first is a Medium-size 
humanoid (the exact form is fixed at birth).  The second form is a Medium-size, 
spider-humanoid hybrid.  Changing form is a standard action.

The aranea keeps its ability scores and can cast spells, but cannot use webs or 
poison in humanoid form.

In hybrid form, an aranea looks like a humanoid at first glance, but a closer 
inspection will reveal its fangs & spinneretes.  The aranea can use weapons & 
webs in this form.

//////////////////////////////////////////////////////////////////////////////*/

#include "prc_inc_shifting"
#include "prc_inc_natweap"

void main()
{
	object oPC = OBJECT_SELF;
	string sCWL = GetResRef(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC));
	
	StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);
	ShiftIntoResRef(oPC, SHIFTER_TYPE_ARANEA, "prc_ara_human", FALSE);
	
	SetLocalInt(oPC, "AraneaHumanoidForm", 1);
	DeleteLocalInt(oPC, "AraneaHybridForm");
   
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_c");
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_d");
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_f");
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_g");
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_h");
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_l");
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_m");
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_s");
        RemoveNaturalPrimaryWeapon(oPC, "prc_ara_bite_t");
	
	if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC)))
	{ 
        if ((sCWL == "prc_ara_bite_c")
        || (sCWL == "prc_ara_bite_d")
        || (sCWL == "prc_ara_bite_f")
        || (sCWL == "prc_ara_bite_g")
        || (sCWL == "prc_ara_bite_h")
        || (sCWL == "prc_ara_bite_l")
        || (sCWL == "prc_ara_bite_m")        
        || (sCWL == "prc_ara_bite_s")        
        || (sCWL == "prc_ara_bite_t"))
        
        MyDestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC));
	}
}