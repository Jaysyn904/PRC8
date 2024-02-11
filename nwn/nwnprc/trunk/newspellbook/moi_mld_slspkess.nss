/*
Essentia: When you allocate essentia to your soulspark familiar, you can select one of the following effects. All essentia invested must be put toward the same effect.

Attack Bonus: Every point of essentia grants the soulspark a +1 bonus on its attack rolls and damage rolls.
Deflection Bonus: Every point of essentia grants the soulspark a +1 deflection bonus to Armor Class.
Healing: Every point of essentia invested grants the soulspark a certain amount of fast healing. A least soulspark gains fast healing equal to 1 × the points of essentia invested, a lesser
soulspark gains fast healing equal to 2 × the points of essentia invested, a standard soulspark gains fast healing equal to 3 × the points of essentia invested, and a greater soulspark gains
fast healing equal to 4 × the points of essentia invested.
Saving Throw Bonus: Every point of essentia grants the soulspark a +1 resistance bonus on all saving throws.
*/

void main()
{
    object oMeldshaper = OBJECT_SELF;
    string sString;
    
    int nEssentia = GetLocalInt(oMeldshaper, "SoulsparkEssentiaChoice")+1;
    
    if (nEssentia == 1) sString = "Deflection AC";
    else if (nEssentia == 2) sString = "Healing";
    else if (nEssentia == 3) sString = "Saving Throws";
    else // Loop back to beginning
    {
    	sString = "Attacks";
    	nEssentia = 0;
    }	
    
    SetLocalInt(oMeldshaper, "SoulsparkEssentiaChoice", nEssentia);
    FloatingTextStringOnCreature("You are adding Soulspark Familiar essentia to "+sString, oMeldshaper, FALSE);
}