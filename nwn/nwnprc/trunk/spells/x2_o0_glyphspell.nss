#include "prc_alterations"
#include "psi_inc_psifunc"

void main()
{
   int nSpell = GetLastSpell();
   int nMyLevel = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_LEVEL");
   int nVsLevel = PRCGetCasterLevel(GetLastSpellCaster());
   int nTest;

   switch(nSpell)
   {
      case SPELL_LESSER_DISPEL            : nTest = d20(1) + min(5, nVsLevel); break;
      case SPELL_DISPEL_MAGIC             : nTest = d20(1) + min(10, nVsLevel); break;
      case SPELL_DISPELLING_TOUCH         : nTest = d20(1) + min(10, nVsLevel); break;
      case SPELL_SLASHING_DISPEL          : nTest = d20(1) + min(10, nVsLevel); break;
      case POWER_DISPELPSIONICS           : nTest = d20(1) + min(15, GetManifesterLevel(GetLastSpellCaster())); break;
      case SPELL_GREATER_DISPELLING       : nTest = d20(1) + min(20, nVsLevel); break;
      case SPELL_GREAT_WALL_OF_DISPEL     : nTest = d20(1) + min(20, nVsLevel); break;
      case SPELL_MORDENKAINENS_DISJUNCTION: nTest = d20(1) + min(40, nVsLevel); break;
      case 4061                           : nTest = d20(1) + min(40, nVsLevel); break;//Superb Dispelling
      default                            : nTest = 0; break;
   }
   if (nTest >= 11 + nMyLevel)
   {
      DestroyObject(OBJECT_SELF);
   }
}