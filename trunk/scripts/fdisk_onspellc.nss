/*
Tenser's Floating Disk script

Disk's OnSpellCastAt script.

Created by: xwarren
Created: August 15, 2009
*/
#include "prc_alterations"
#include "psi_inc_psifunc"

void main()
{
object oMaster = GetMaster();
object oSCaster = GetLastSpellCaster();
int nMasterCLevel = PRCGetCasterLevel(oMaster);
int nSCLevel = PRCGetCasterLevel(oSCaster);
int nSpell = GetLastSpell();
int nTest;

switch(nSpell)
  {
  case SPELL_LESSER_DISPEL            : nTest = d20(1) + min(5, nSCLevel); break;
  case SPELL_DISPEL_MAGIC             : nTest = d20(1) + min(10, nSCLevel); break;
  case SPELL_DISPELLING_TOUCH         : nTest = d20(1) + min(10, nSCLevel); break;
  case SPELL_SLASHING_DISPEL          : nTest = d20(1) + min(10, nSCLevel); break;
  case POWER_DISPELPSIONICS           : nTest = d20(1) + min(15, GetManifesterLevel(oSCaster)); break;
  case SPELL_GREATER_DISPELLING       : nTest = d20(1) + min(20, nSCLevel); break;
  case SPELL_GREAT_WALL_OF_DISPEL     : nTest = d20(1) + min(20, nSCLevel); break;
  case SPELL_MORDENKAINENS_DISJUNCTION: nTest = d20(1) + min(40, nSCLevel); break;
  case 4061                           : nTest = d20(1) + min(40, nSCLevel); break;//Superb Dispelling
  default                            : nTest = 0; break;
  }
  if (nTest >= 11 + nMasterCLevel)
  {
     ExecuteScript("fdisk_end", OBJECT_SELF);
  }
  else
  {
     if(!GetLocalInt(OBJECT_SELF, "bDiskBussy"))
     {
         ClearAllActions(TRUE);
         ActionMoveToObject(oMaster, TRUE, 2.0);
     }
  }
}




