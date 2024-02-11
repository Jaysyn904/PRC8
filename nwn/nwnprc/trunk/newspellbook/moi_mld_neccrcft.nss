/**
Necrocarnum Circlet

Chakra Bind (Crown)

A matching coil of necrocarnum forms around the head of a corpse. Filled with the dark power of necrocarnum, the corpse shambles to its feet, its flesh and mind overtaken by the curse of undeath. 

When you shape this soulmeld and bind it to your crown chakra, you can animate an undead creature. This requires a full-round action and provokes attacks of opportunity; in addition, you take 
damage equal to the necrocarnum zombie�s Hit Dice, which may not be healed as long as the zombie remains animated. You may only have one zombie.
 */

#include "moi_inc_moifunc"

void NecroCircletHB(object oMeldshaper, object oCreature)
{
    int nCurHP = GetCurrentHitPoints(oMeldshaper);
    int nMaxHP = GetMaxHitPoints(oMeldshaper);
    int nPen = GetLocalInt(oMeldshaper, "NecrocarnumCircletPen");
    
    // Does the PC have too many hit points?    
    if (nCurHP > (nMaxHP - nPen))
    {
        int nHP = nMaxHP - nPen;
        if (!GetIsResting(oMeldshaper)) SetCurrentHitPoints(oMeldshaper, nHP);
    }
    // Keep it going or...
    if (GetHasSpellEffect(MELD_NECROCARNUM_CIRCLET, oMeldshaper) && GetIsMeldBound(oMeldshaper, MELD_NECROCARNUM_CIRCLET) == CHAKRA_CROWN) DelayCommand(0.25, NecroCircletHB(oMeldshaper, oCreature));
    else DestroyObject(oCreature);
}

void main()
{
	object oMeldshaper = OBJECT_SELF;
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_NECROCARNUM_CIRCLET);
	int nLevel = GetMeldshaperLevel(oMeldshaper, nClass, MELD_NECROCARNUM_CIRCLET);
	int nNecro = GetLevelByClass(CLASS_TYPE_NECROCARNATE, oMeldshaper);
	
    int i, nCount;
    for(i=1;i<=10;i++)
    {
    	object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
        if (GetResRef(oHench) == "prc_sum_dbl"   ||
            GetResRef(oHench) == "prc_sum_dk"    ||
            GetResRef(oHench) == "prc_sum_vamp2" ||
            GetResRef(oHench) == "prc_sum_bonet" ||
            GetResRef(oHench) == "prc_sum_wight" ||
            GetResRef(oHench) == "prc_sum_vamp1" ||
            GetResRef(oHench) == "prc_sum_grav"  ||
            GetResRef(oHench) == "prc_sum_sklch" ||
            GetResRef(oHench) == "prc_sum_zlord" ||
            GetResRef(oHench) == "prc_sum_mohrg" ||
            GetResRef(oHench) == "prc_tn_fthug")
        {
        	nCount += 1;
        	if (nCount == 1 && nNecro >= 13) // Do nothing
        	{
        	}
        	else
        	{
        		FloatingTextStringOnCreature("You already the maximum number of necrocarnum zombies", oMeldshaper, FALSE);
        		return;
        	}	
        }	
	}
    
    string sSummon;
    effect eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
    object oCreature;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

    if (nLevel > 37)        sSummon = "prc_sum_dbl";
    else if (nLevel > 34)   sSummon = "prc_sum_dk";
    else if (nLevel > 31)   sSummon = "prc_sum_vamp2";
    else if (nLevel > 28)   sSummon = "prc_sum_bonet";
    else if (nLevel > 25)   sSummon = "prc_sum_wight";
    else if (nLevel > 22)   sSummon = "prc_sum_vamp1";
    else if (nLevel > 19)   sSummon = "prc_sum_grav";
    else if (nLevel > 16)   sSummon = "prc_tn_fthug";
    else if (nLevel > 13)   sSummon = "prc_sum_sklch";
    else if (nLevel > 10)   sSummon = "prc_sum_zlord";
    else                    sSummon = "prc_sum_mohrg";    

   oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
   int nMaxHenchmen = GetMaxHenchmen();
   SetMaxHenchmen(99);
   AddHenchman(oMeldshaper, oCreature);
   int nHP = GetHitDice(oCreature);
   if (nNecro >= 6) nHP /= 2;
   SetLocalInt(oMeldshaper, "NecrocarnumCircletPen", nHP + GetLocalInt(oMeldshaper, "NecrocarnumCircletPen"));
   NecroCircletHB(oMeldshaper, oCreature);
   SetMaxHenchmen(nMaxHenchmen);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}
