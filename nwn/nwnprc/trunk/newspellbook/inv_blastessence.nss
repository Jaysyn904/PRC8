//::///////////////////////////////////////////////
//:: Warlock Eldritch Blast Essences
//:: inv_blastessence.nss
//::///////////////////////////////////////////////
/*
    Handles the Essence invocations for Warlocks
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 29, 2008
//:://////////////////////////////////////////////
#include "inv_inc_invfunc"

int DamageFlagToRow(int nFlag)  
{  
    int i;  
    for(i = 0; i <= 27; i++)  
    {  
        if(nFlag == (1 << i))  
            return i;  
    }  
    return 0; // fallback, shouldn't happen  
}

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();
    int bSecondEssenceActive = GetLocalInt(oPC, "UsingSecondEssence");

    if(GetLocalInt(oPC, "BlastEssence") == nSpellID)
    {
        DeleteLocalInt(oPC, "BlastEssence");
        DeleteLocalInt(oPC, "EssenceData");
        FloatingTextStringOnCreature("*Blast Essence Removed*", oPC, FALSE);
        return;
    }

    if(GetLocalInt(oPC, "BlastEssence2") == nSpellID)
    {
        DeleteLocalInt(oPC, "BlastEssence2");
        DeleteLocalInt(oPC, "EssenceData2");
        FloatingTextStringOnCreature("*Second Blast Essence Removed*", oPC, FALSE);
        return;
    }

    int nLevel, nRace = -1, nDamage = DAMAGE_TYPE_UNTYPED;
    string sEssenceData, sBlastEssence, sMes;
    if(bSecondEssenceActive)
    {
        sBlastEssence = "BlastEssence2";
        sEssenceData  = "EssenceData2";
    }
    else
    {
        sBlastEssence = "BlastEssence";
        sEssenceData  = "EssenceData";
    }

    switch(nSpellID)
    {
        case INVOKE_LORD_OF_ALL_ESSENCES:
             if(bSecondEssenceActive)
             {
                 DeleteLocalInt(oPC, "UsingSecondEssence");
                 sMes = "*Modifying First Essence*";
             }
             else
             {
                 SetLocalInt(oPC, "UsingSecondEssence", TRUE);
                 sMes = "*Modifying Second Essence*";
             }
             break;

        case INVOKE_FRIGHTFUL_BLAST:
             nLevel = 2;
             sMes = "*Frightful Blast Essence Applied*";
             break;

        case INVOKE_HAMMER_BLAST:
             nLevel = 2;
             sMes = "*Hammer Blast Essence Applied*";
             break;

        case INVOKE_SICKENING_BLAST:
             nLevel = 2;
             sMes = "*Sickening Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_ABERRATION:
             nLevel = 3;
             nRace = RACIAL_TYPE_ABERRATION;
             sMes = "*Abberation Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_BEAST:
             nLevel = 3;
             nRace = RACIAL_TYPE_BEAST;
             sMes = "*Beast Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_CONSTRUCT:
             nLevel = 3;
             nRace = RACIAL_TYPE_CONSTRUCT;
             sMes = "*Construct Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_DRAGON:
             nLevel = 3;
             nRace = RACIAL_TYPE_DRAGON;
             sMes = "*Dragon Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_DWARF:
             nLevel = 3;
             nRace = RACIAL_TYPE_DWARF;
             sMes = "*Dwarf Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_ELEMENTAL:
             nLevel = 3;
             nRace = RACIAL_TYPE_ELEMENTAL;
             sMes = "*Elemental Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_ELF:
             nLevel = 3;
             nRace = RACIAL_TYPE_ELF;
             sMes = "*Elf Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_FEY:
             nLevel = 3;
             nRace = RACIAL_TYPE_FEY;
             sMes = "*Fey Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_GIANT:
             nLevel = 3;
             nRace = RACIAL_TYPE_GIANT;
             sMes = "*Giant Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_GOBLINOID:
             nLevel = 3;
             nRace = RACIAL_TYPE_HUMANOID_GOBLINOID;
             sMes = "*Goblinoid Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_GNOME:
             nLevel = 3;
             nRace = RACIAL_TYPE_GNOME;
             sMes = "*Gnome Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_HALFLING:
             nLevel = 3;
             nRace = RACIAL_TYPE_HALFLING;
             sMes = "*Halfling Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_HUMAN:
             nLevel = 3;
             nRace = RACIAL_TYPE_HUMAN;
             sMes = "*Human Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_MONSTROUS:
             nLevel = 3;
             nRace = RACIAL_TYPE_HUMANOID_MONSTROUS;
             sMes = "*Monstrous Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_ORC:
             nLevel = 3;
             nRace = RACIAL_TYPE_HUMANOID_ORC;
             sMes = "*Orc Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_OUTSIDER:
             nLevel = 3;
             nRace = RACIAL_TYPE_OUTSIDER;
             sMes = "*Outsider Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_PLANT:
             nLevel = 3;
             nRace = RACIAL_TYPE_PLANT;
             sMes = "*Plant Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_REPTILIAN:
             nLevel = 3;
             nRace = RACIAL_TYPE_HUMANOID_REPTILIAN;
             sMes = "*Reptilian Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_SHAPECHANGER:
             nLevel = 3;
             nRace = RACIAL_TYPE_SHAPECHANGER;
             sMes = "*Shapechanger Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_UNDEAD:
             nLevel = 3;
             nRace = RACIAL_TYPE_UNDEAD;
             sMes = "*Undead Blast Essence Applied*";
             break;

        case INVOKE_BANEFUL_BLAST_VERMIN:
             nLevel = 3;
             nRace = RACIAL_TYPE_VERMIN;
             sMes = "*Vermin Blast Essence Applied*";
             break;

        case INVOKE_BESHADOWED_BLAST:
             nLevel = 4;
             sMes = "*Beshadowed Blast Essence Applied*";
             break;

        case INVOKE_BRIMSTONE_BLAST:
             nLevel = 3;
             nDamage = DAMAGE_TYPE_FIRE;
             sMes = "*Brimstone Blast Essence Applied*";
             break;

        case INVOKE_HELLRIME_BLAST:
             nLevel = 4;
             nDamage = DAMAGE_TYPE_COLD;
             sMes = "*Hellrime Blast Essence Applied*";
             break;

        case INVOKE_BEWITCHING_BLAST:
             nLevel = 4;
             sMes = "*Bewitching Blast Essence Applied*";
             break;

        case INVOKE_HINDERING_BLAST:
             nLevel = 4;
             sMes = "*Hindering Blast Essence Applied*";
             break;

        case INVOKE_NOXIOUS_BLAST:
             nLevel = 6;
             sMes = "*Noxious Blast Essence Applied*";
             break;

        case INVOKE_PENETRATING_BLAST:
             nLevel = 6;
             sMes = "*Penetrating Blast Essence Applied*";
             break;

        case INVOKE_VITRIOLIC_BLAST:
             nLevel = 6;
             nDamage = DAMAGE_TYPE_ACID;
             sMes = "*Vitriolic Blast Essence Applied*";
             break;
			 
        case INVOKE_REPELLING_BLAST:
             nLevel = 6;
             sMes = "*Repelling Blast Essence Applied*";
             break;			 

        case INVOKE_BINDING_BLAST:
             nLevel = 7;
             sMes = "*Binding Blast Essence Applied*";
             break;

        case INVOKE_UTTERDARK_BLAST:
             nLevel = 8;
             nDamage = DAMAGE_TYPE_NEGATIVE;
             sMes = "*Utterdark Blast Essence Applied*";
             break;

        case INVOKE_CORRUPTING_BLAST:
             nLevel = 1;
             sMes = "*Corrupting Blast Applied*";
             break;
    }

    if(nLevel)
    {
        nRace++;//bias race info
        //Essence data format:
        //  8 bits: [24...31] : ***UNUSED / IGNORED***
        //  8 bits: [16...23] : bane race (biased by +1 == 0 if none)
        // 12 bits: [ 4...15] : damage type (magical by default)
        //  4 bits: [ 0... 3] : essence level
        int nData = ((nRace   & 0xFF) << 16) |
                    //((nDamage & 0xFFF) <<  4) |
					((DamageFlagToRow(nDamage) & 0x1F) <<  4) |
                    (nLevel & 0xF);

        SetLocalInt(oPC, sBlastEssence, nSpellID);
        SetLocalInt(oPC, sEssenceData, nData);
    }

    FloatingTextStringOnCreature(sMes, oPC, FALSE);
}