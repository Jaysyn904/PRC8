//::///////////////////////////////////////////////
//:: Metabreath - Quickslots
//:: prc_metabrth_qs.nss
//::///////////////////////////////////////////////
/*
    Sets Clinging, Lingering, or Heighten Breath values.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 23, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
     int nModifier;
                  
     if(GetSpellId() == SPELL_HEIGHTEN_QS1)
     {   nModifier = GetPersistantLocalInt(oPC, "HeightenBreathSlot1");
         sMes = "*Heighten Breath set to" + IntToString(nModifier) + "*";
         SetLocalInt(oPC,"HeightenBreath", nModifier);
     }
     
     if(GetSpellId() == SPELL_HEIGHTEN_QS2)
     {   nModifier = GetPersistantLocalInt(oPC, "HeightenBreathSlot2");
         sMes = "*Heighten Breath set to" + IntToString(nModifier) + "*";
         SetLocalInt(oPC,"HeightenBreath", nModifier);
     }
     
     if(GetSpellId() == SPELL_CLINGING_QS1)
     {   nModifier = GetPersistantLocalInt(oPC, "ClingingBreathSlot1");
         sMes = "*Clinging Breath set to" + IntToString(nModifier) + "*";
         SetLocalInt(oPC,"ClingingBreath", nModifier);
     }
     
     if(GetSpellId() == SPELL_CLINGING_QS2)
     {   nModifier = GetPersistantLocalInt(oPC, "ClingingBreathSlot2");
         sMes = "*Clinging Breath set to" + IntToString(nModifier) + "*";
         SetLocalInt(oPC,"ClingingBreath", nModifier);
     }
     
     if(GetSpellId() == SPELL_CLINGING_QS3)
     {   nModifier = GetPersistantLocalInt(oPC, "ClingingBreathSlot3");
         sMes = "*Clinging Breath set to" + IntToString(nModifier) + "*";
         SetLocalInt(oPC,"ClingingBreath", nModifier);
     }
     
     if(GetSpellId() == SPELL_LINGERING_QS1)
     {   nModifier = GetPersistantLocalInt(oPC, "LingeringBreathSlot1");
         sMes = "*Lingering Breath set to" + IntToString(nModifier) + "*";
         SetLocalInt(oPC,"LingeringBreath", nModifier);
     }
     
     if(GetSpellId() == SPELL_LINGERING_QS2)
     {   nModifier = GetPersistantLocalInt(oPC, "LingeringBreathSlot2");
         sMes = "*Lingering Breath set to" + IntToString(nModifier) + "*";
         SetLocalInt(oPC,"LingeringBreath", nModifier);
     }
     
     if(GetSpellId() == SPELL_LINGERING_QS3)
     {   nModifier = GetPersistantLocalInt(oPC, "LingeringBreathSlot3");
         sMes = "*Lingering Breath set to" + IntToString(nModifier) + "*";
         SetLocalInt(oPC,"LingeringBreath", nModifier);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}