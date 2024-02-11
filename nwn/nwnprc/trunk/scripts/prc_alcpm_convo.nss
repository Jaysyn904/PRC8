//:://////////////////////////////////////////////
//:: Craft Poison or Alchemical Item
//:: prc_alcpm_convo.nss
//:://////////////////////////////////////////////
/** @file
    This is used to created poisons and alchemical items.


    @author Tenjac
    @date   Created  - 2008.09.16
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                           =0;
const int STAGE_POISON                          =1;
const int STAGE_ALCHEM                          =2;
const int STAGE_CONFIRM                         =3;

//Choice constants
const int CHOICE_ABORT_CRAFT                    =10;
const int CHOICE_CONFIRM_CRAFT                  =11;
const int CHOICE_BACK                           =12;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);
    
    int nSkill;
    int nCost;
    int nPoison = GetSkillRank(SKILL_CRAFT_POISON, oPC);
    int nAlchem = GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC);
    int nDC;
    string sItem;
    
    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_ENTRY)
            {
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                    SetHeader("What do you want to do?");
                    AddChoice("Craft a poison.", 1);
                    AddChoice("Craft an alchemical item.", 2);
                    
                    MarkStageSetUp(nStage, oPC);
                    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values            
            }
            
            else if (nStage == STAGE_POISON)
            {
                    //Poison                          
                    SetHeader("What type of poison would you like to craft?");
                    
                    //Poisons, alphabetically
                    AddChoice("Arsenic", 1);
                    AddChoice("Balor Bile", 2);
                    AddChoice("Bebilith Venom", 3);
                    AddChoice("Black Adder Venom", 4);
                    AddChoice("Black Lotus Extract", 5);
                    AddChoice("Bloodroot", 6);
                    AddChoice("Blue Whinnis", 7);
                    AddChoice("Burning Angel Wing Fumes", 8);
                    AddChoice("Burnt Othur Fumes", 9);
                    AddChoice("Carrion Crawler Brain Juice", 10);
                    AddChoice("Centipede Poison - Tiny", 11);
                    AddChoice("Centipede Poison - Small", 12);
                    AddChoice("Centipede Poison - Medium", 13);
                    AddChoice("Centipede Poison - Large", 14);
                    AddChoice("Centipede Poison - Huge", 15);
                    AddChoice("Centipede Poison - Gargantuan", 16);
                    AddChoice("Centipede Poison - Colossal", 17);
                    AddChoice("Chaos Mist", 18);
                    AddChoice("Dark Reaver Powder", 19);
                    AddChoice("Deathblade", 20);
                    AddChoice("Dragon Bile", 21);
                    AddChoice("Eyeblast", 22);
                    AddChoice("Giant Wasp Poison", 23);
                    AddChoice("Greenblood Oil", 24);
                    AddChoice("Id Moss", 25);
                    AddChoice("Ishentav", 26);
                    AddChoice("Lich Dust", 27);
                    AddChoice("Malyss Root Paste", 28);
                    AddChoice("Mist of Nourn", 29);
                    AddChoice("Nightshade", 30);
                    AddChoice("Nitharit", 31);
                    AddChoice("Oil of Taggit", 32);
                    AddChoice("Purple Worm Poison", 33);
                    AddChoice("Ravage - Celestial Ligthsblood", 34);
                    AddChoice("Ravage - Golden Ice", 35);
                    AddChoice("Ravage - Jade Water", 36);
                    AddChoice("Ravage - Purified Couatl Venom", 37);
                    AddChoice("Ravage - Unicorn Blood", 38);
                    AddChoice("Sasson Juice", 39);
                    AddChoice("Sasson Leaf Residue", 40);
                    AddChoice("Scorpion Vemon - Tiny", 41);
                    AddChoice("Scorpion Venom - Small", 42);
                    AddChoice("Scorpion Venom - Medium", 43);
                    AddChoice("Scorpion Venom - Large", 44);
                    AddChoice("Scorpion Venom - Huge", 45);
                    AddChoice("Scorpion Venom - Gargantuan", 46);
                    AddChoice("Scorpion Venom - Colossal", 47);
                    AddChoice("Shadow Essence", 48);
                    AddChoice("Spider Venom - Tiny", 49);
                    AddChoice("Spider Venom - Small", 50);
                    AddChoice("Spider Venom - Medium", 51);
                    AddChoice("Spider Venom - Large", 52);
                    AddChoice("Spider Venom - Huge", 53);
                    AddChoice("Spider Venom - Gargantuan", 54);
                    AddChoice("Spider Venom - Colossal", 55);
                    AddChoice("Striped Toadstool", 56);
                    AddChoice("Sufferfume", 57);
                    AddChoice("Terinav Root", 58);
                    AddChoice("Ungol Dust", 59);
                    AddChoice("Urthanyk", 60);
                    AddChoice("Vilestar", 61);
                    AddChoice("Wyvern Poison", 62);
                    AddChoice("Wyvern Poison - Epic", 63);
                    
                    MarkStageSetUp(nStage, oPC);
                    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values                                                       
            }
            
            else if (nStage == STAGE_ALCHEM)
            {
                    SetHeader("What alchemical item would you like to craft?");                              
                    
                    AddChoice("Acid Flask", 1);
                    AddChoice("Acidic Fire",2);
                    AddChoice("Agony",3);
                    AddChoice("Alchemical Sleep Gas",4);
                    AddChoice("Alchemist's Fire",5);
                    AddChoice("Alchemist's Frost",6);
                    AddChoice("Alchemist's Spark",7);
                    AddChoice("Antitoxin",8);
                    AddChoice("Baccaran",9);
                    AddChoice("Bile Droppings",10);
                    AddChoice("Blend Cream",11);
                    AddChoice("Brittlebone",12);
                    AddChoice("Crackle Powder",13);
                    AddChoice("Devilweed",14);
                    AddChoice("Embalming Fire",15);
                    AddChoice("Fareye Oil",16);
                    AddChoice("Festering Bomb",17);
                    AddChoice("Flash Pellet",18);
                    AddChoice("Healer's Balm",19);
                    AddChoice("Keenear Powder",20);
                    AddChoice("Lockslip Grease",21);
                    AddChoice("Luhix",22);
                    AddChoice("Mushroom Powder",23);
                    AddChoice("Nature's Draught",24);
                    AddChoice("Nerv",25);
                    AddChoice("Sannish",26);
                    AddChoice("Screaming Flask",27);
                    AddChoice("Shedden",28);
                    AddChoice("Shedden +2",29);
                    AddChoice("Shedden +3",30);
                    AddChoice("Shedden +4",31);
                    AddChoice("Shedden +5",32);
                    AddChoice("Softfoot",33);
                    AddChoice("Tanglefoot Bag",34);
                    AddChoice("Terran Brandy",35);
                    AddChoice("Thunderstone",36);
                    AddChoice("Vodare",37);
                    AddChoice("Weeping Stone",38);
                    
                    MarkStageSetUp(nStage, oPC);
                    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values                        
            }
            
            else if (nStage == STAGE_CONFIRM)
            {
                    SetHeader("Are you sure you want to create this item?");
                    
                    AddChoice("Back", CHOICE_BACK, oPC);
                    
                    if(GetGold(oPC) >= nCost) AddChoice("Confirm", CHOICE_CONFIRM_CRAFT, oPC);
                    MarkStageSetUp(nStage);
            }                    
            
            else
            {
                    if(DEBUG) DoDebug("Invalid Stage: " + IntToString(nStage));
                    return;
            }        
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
            // Add any locals set through this conversation
            DeleteLocalInt(oPC, "PRC_CRAFT_COST");
            DeleteLocalInt(oPC, "PRC_CRAFT_DC");
            DeleteLocalString(oPC, "PRC_CRAFT_RESREF");
            DeleteLocalInt(oPC, "PRC_CRAFT_SKILLUSED");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
            DeleteLocalInt(oPC, "PRC_CRAFT_COST");
            DeleteLocalInt(oPC, "PRC_CRAFT_DC");
            DeleteLocalString(oPC, "PRC_CRAFT_RESREF");
            DeleteLocalInt(oPC, "PRC_CRAFT_SKILLUSED");
        // Add any locals set through this conversation
        if(DEBUG) DoDebug("prc_craft: ERROR: Conversation abort section run");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
                if(nChoice == 1) nStage = STAGE_POISON;
                
                else if(nChoice == 2) nStage = STAGE_ALCHEM;
            // Move to another stage based on response, for example
            //nStage = STAGE_QUUX;
        }
        
        else if(nStage == STAGE_POISON)
        {         
                if(nChoice == 1)
                {
                        sItem = "2dapoison023";
                        nCost = 60;
                        nDC = 15;
                }
                else if(nChoice == 2)
                {
                        sItem = "2dapoison135";
                        nCost = 500;
                        nDC = 25;
                }
                
                else if(nChoice == 3)
                {
                        sItem = "2dapoison029";
                        nCost = 450;
                        nDC = 20;
                }
                
                else if(nChoice == 4)
                {
                        sItem = "2dapoison011";
                        nCost = 60;
                        nDC = 15;
                }
                
                else if(nChoice == 5)
                {
                        sItem = "2dapoison019";
                        nCost = 2250;
                        nDC = 35;
                }
                
                else if(nChoice == 6)
                {
                        sItem = "2dapoison004";
                        nCost = 50;
                        nDC = 15;
                }
                
                else if(nChoice == 7)
                {
                        sItem = "2dapoison008";
                        nCost = 60;
                        nDC = 15;
                }
                
                else if(nChoice == 8)
                {
                        sItem = "2dapoison142";
                        nCost = 1400;
                        nDC = 27;
                }
                
                else if(nChoice == 9)
                {
                        sItem = "2dapoison027";
                        nCost = 1050;
                        nDC = 25;
                }
                
                else if(nChoice == 10)
                {
                        sItem = "2dapoison018";
                        nCost = 100;
                        nDC = 15;
                }
                
                else if(nChoice == 11)
                {
                        sItem = "2dapoison122";
                        nCost = 20;
                        nDC = 15;
                }
                
                else if(nChoice == 12)
                {
                        sItem = "2dapoison001";
                        nCost = 45;
                        nDC = 15;
                }                        
                
                else if(nChoice == 13)
                {
                        sItem = "2dapoison123";
                        nCost = 55;
                        nDC = 15;
                }
                
                else if(nChoice == 14)
                {
                        sItem = "2dapoison124";
                        nCost = 75;
                        nDC = 18;
                }
                
                else if(nChoice == 15)
                {
                        sItem = "2dapoison125";
                        nCost = 105;
                        nDC = 20;
                }
                
                else if(nChoice == 16)
                {
                        sItem = "2dapoison126";
                        nCost = 475;
                        nDC = 20;
                }
                
                else if(nChoice == 17)
                {
                        sItem = "2dapoison127";
                        nCost = 1450;
                        nDC = 30;
                }
                
                else if(nChoice == 18)
                {
                        sItem = "2dapoison028";
                        nCost = 400;
                        nDC = 20;
                }
                
                else if(nChoice == 19)
                {
                        sItem = "2dapoison025";
                        nCost = 150;
                        nDC = 25;
                }
                
                else if(nChoice == 20)
                {
                        sItem = "2dapoison012";
                        nCost = 900;
                        nDC = 25;
                }
                
                else if(nChoice == 21)
                {
                        sItem = "2dapoison015";
                        nCost = 750;                        
                        nDC = 30;
                }
                
                else if(nChoice == 22)
                {
                        sItem = "2dapoison134";
                        nCost = 250;
                        nDC = 23;
                }
                
                else if(nChoice == 23)
                {
                        sItem = "2dapoison009";
                        nCost = 105;
                        nDC = 20;
                }
                
                else if(nChoice == 24)
                {
                        sItem = "2dapoison003";
                        nCost = 50;
                        nDC = 15;
                }
                
                else if(nChoice == 25)
                {
                        sItem = "2dapoison021";
                        nCost = 63;
                        nDC = 15;
                }
                
                else if(nChoice == 26)
                {
                        sItem = "2dapoison141";                                 
                        nCost = 250;
                        nDC = 25;
                }
                
                else if(nChoice == 27)
                {
                        sItem = "2dapoison024";
                        nCost = 125;
                        nDC = 20;
                }
                
                else if(nChoice == 28)
                {
                        sItem = "2dapoison013";
                        nCost = 250;
                        nDC = 20;
                }
                
                else if(nChoice == 29)
                {
                        sItem = "2dapoison140";
                        nCost = 3500;
                        nDC = 35;
                }
                
                else if(nChoice == 30)
                {
                        sItem = "2dapoison000";                        
                        nCost = 50;
                        nDC = 15;
                }
                
                else if(nChoice == 31)
                {
                        sItem = "2dapoison014";
                        nCost = 325;
                        nDC = 20;
                }
                
                else if(nChoice == 32)
                {
                        sItem = "2dapoison020";
                        nCost = 45;                        
                        nDC = 15;
                }
                
                else if(nChoice == 33)
                {
                        sItem = "2dapoison005";
                        nCost = 350;
                        nDC = 20;
                }
                
                else if(nChoice == 34)
                {
                        sItem = "2dapoison143";
                        nCost = 1250;
                        nDC = 28;
                }
                
                else if(nChoice == 35)
                {
                        sItem = "2dapoison100";
                        nCost = 600;
                        nDC = 25;
                }
                        
                else if(nChoice == 36)
                {
                        sItem = "2dapoison144";
                        nCost = 175;
                        nDC = 20;
                }
                
                else if(nChoice == 37)
                {
                        sItem = "2dapoison145";
                        nCost = 1500;
                        nDC = 34;
                }
                
                else if(nChoice == 38)
                {
                        sItem = "2dapoison146";
                        nCost = 250;
                        nDC = 20;
                }
                                         
                else if(nChoice == 39)
                {
                        sItem = "2dapoison137";
                        nCost = 250;
                        nDC = 22;
                }
                
                else if(nChoice == 40)
                {
                        sItem = "2dapoison016";
                        nCost = 150;
                        nDC = 20;
                }
                
                else if(nChoice == 41)
                {
                        sItem = "2dapoison128";
                        nCost = 45;
                        nDC = 15;
                }
                
                else if(nChoice == 42)
                {
                        sItem = "2dapoison129";
                        nCost = 50;
                        nDC = 15;
                }
                
                else if(nChoice == 43)
                {
                        sItem = "2dapoison130";
                        nCost = 88;
                        nDC = 18;
                }
                
                else if(nChoice == 44)
                {
                        sItem = "2dapoison006";
                        nCost = 100;
                        nDC = 20;
                }
                
                else if(nChoice == 45)
                {
                        sItem = "2dapoison131";
                        nCost = 600;
                        nDC = 25;
                }
                
                else if(nChoice == 46)
                {
                        sItem = "2dapoison132";
                        nCost = 1500;
                        nDC = 32;
                }
                
                else if(nChoice == 47)
                {
                        sItem = "2dapoison133";
                        nCost = 4500;
                        nDC = 35;
                }
                
                else if(nChoice == 48)
                {
                        sItem = "2dapoison010";
                        nCost = 125;
                        nDC = 20;
                }
                
                else if(nChoice == 49)
                {
                        sItem = "2dapoison034";
                        nCost = 45;
                        nDC = 15;
                }
                
                else if(nChoice == 50)
                {
                        sItem = "2dapoison035";
                        nCost = 50;
                        nDC = 15;
                }
                
                else if(nChoice == 51)
                {
                        sItem = "2dapoison036";
                        nCost = 75;
                        nDC = 18;
                }
                
                else if(nChoice == 52)
                {
                        sItem = "2dapoison037";
                        nCost = 88;
                        nDC = 18;
                }
                
                else if(nChoice == 53)
                {
                        sItem = "2dapoison038";
                        nCost = 500;
                        nDC = 20;
                }
                
                else if(nChoice == 54)
                {
                        sItem = "2dapoison039";
                        nCost = 1250;
                        nDC = 26;
                }
                
                else if(nChoice == 55)
                {
                        sItem = "2dapoison040";
                        nCost = 1500;
                        nDC = 28;
                }
                
                else if(nChoice == 56)
                {
                        sItem = "2dapoison022";
                        nCost = 90;
                        nDC = 15;
                }
                
                else if(nChoice == 57)
                {
                        sItem = "2dapoison138";
                        nCost = 600;
                        nDC = 21;
                }
                
                else if(nChoice == 58)
                {
                        sItem = "2dapoison017";
                        nCost = 375;
                        nDC = 25;
                }
                
                else if(nChoice == 59)
                {
                        sItem = "2dapoison026";
                        nCost = 500;
                        nDC = 20;
                }
                
                else if(nChoice == 60)
                {
                        sItem = "2dapoison139";
                        nCost = 1000;
                        nDC = 26;
                }
                
                else if(nChoice == 61)
                {
                        sItem = "2dapoison136";
                        nCost = 3000;
                        nDC = 34;
                }
                
                else if(nChoice == 62)
                {
                        sItem = "2dapoison007";
                        nCost = 1500;
                        nDC = 25;
                }
                
                else if(nChoice == 63)
                {
                        sItem = "2dapoison044";
                        nCost = 3000;
                        nDC = 34;
                }
                                                                     
                nSkill = SKILL_CRAFT_POISON;             
                
                //Use alchemy skill if it is 5 or more higher than craft(poisonmaking). DC is increased by 4.
                if((nAlchem - nPoison) >4)
                {
                        nSkill = SKILL_CRAFT_ALCHEMY;
                        nDC += 4;
                }
                
                //set locals
                SetLocalInt(oPC, "PRC_CRAFT_ALCPOS_COST", nCost);
                SetLocalInt(oPC, "PRC_CRAFT_ALCPOS_DC", nDC);
                SetLocalString(oPC, "PRC_CRAFT_ALCPOS_RESREF", sItem);
                SetLocalInt(oPC, "PRC_CRAFT_SKILLUSED", nSkill);
        }
        
        //Alchemy
        else if(nStage == STAGE_ALCHEM)
        {                
                if(nChoice == 1)
                {
                        sItem = "x1_wmgrenade001";
                        nCost = 10;
                        nDC = 15;
                }
                
                else if(nChoice == 2)
                {
                        sItem = "prc_it_acidfire";
                        nCost = 15;
                        nDC = 25;
                }
                
                else if(nChoice == 3)
                {
                        sItem = "prc_agony";
                        nCost = 100;                                         
                        nDC = 25;                                            
                }                                                            
                                                                             
                else if(nChoice == 4)                                        
                {                                                            
                        sItem = "prc_it_alcslpgas.";                         
                        nCost = 15;                                            
                        nDC = 25;                                              
                }                                                            
                                                                             
                else if(nChoice == 5)                                        
                {                                                            
                        sItem = "x1_wmgrenade002";                                          
                        nCost = 10;                                            
                        nDC = 20;                                              
                }                                                            
                                                                             
                else if(nChoice == 6)                                        
                {                                                            
                        sItem = "prc_it_alcfrost";                           
                        nCost = 10;                                            
                        nDC = 22;                                              
                }                                                            
                                                                             
                else if(nChoice == 7)                                        
                {                                                            
                        sItem = "prc_it_alcspark";                           
                        nCost = 13;                                            
                        nDC = 22;                                              
                }                                                            
                                                                             
                else if(nChoice == 8)                                        
                {                                                            
                        sItem = "prc_it_antitox";                            
                        nCost = 50;                                            
                        nDC = 25;                                              
                }                                                            
                
                else if(nChoice == 9)
                {
                        sItem = "prc_baccaran";
                        nCost = 5;
                        nDC = 20;
                }
                
                else if(nChoice == 10)
                {
                        sItem = "prc_it_biledrp";
                        nCost = 25;
                        nDC = 15;
                }
                
                else if(nChoice == 11)
                {
                        sItem = "prc_it_blendcrm";
                        nCost = 25;
                        nDC = 20;
                }
                
                else if(nChoice == 12)
                {
                        sItem = "prc_brittlebn";
                        nCost = 15;
                        nDC = 20;
                }
                
                else if(nChoice == 13)
                {
                        sItem = "prc_it_crcklpdr";
                        nCost = 15;
                        nDC = 20;
                }
                
                else if(nChoice == 14)
                {
                        sItem = "prc_devilweed";
                        nCost = 3;
                        nDC = 20;
                }
                
                else if(nChoice == 15)
                {
                        sItem = "prc_it_emblmfr";
                        nCost = 10;
                        nDC = 20;
                }
                
                else if(nChoice == 16)
                {
                        sItem = "prc_it_fareyeoil";
                        nCost = 13;
                        nDC = 20;
                }
                
                else if(nChoice == 17)
                {
                        sItem = "prc_it_festerbmb";
                        nCost = 25;
                        nDC = 22;
                }
                
                else if(nChoice == 18)
                {                                                                                
                        sItem = "prc_it_flashplt";                                               
                        nCost = 25;                                                                
                        nDC = 25;                                                                  
                }                                                                                
                                                                                                 
                else if(nChoice == 19)                                                           
                {                                                                                
                        sItem = "prc_it_healblm";                                                
                        nCost = 5;                                                                
                        nDC = 20;                                                                  
                }                                                                                
                                                                                                 
                else if(nChoice == 20)                                                           
                {                                                                                
                        sItem = "prc_it_keenear";                                                
                        nCost = 10;                                                                
                        nDC = 20;                                                                  
                }                                                                                
                                                                                                 
                else if(nChoice == 21)                                                           
                {                                                                                
                        sItem = "prc_it_lockslip";                                               
                        nCost = 25;                                                                
                        nDC = 20;                                                                  
                }                                                                                
                                                                                                 
                else if(nChoice == 22)                                                           
                {                                                                                
                        sItem = "prc_luhix";                                                     
                        nCost = 1000;                                                            
                        nDC = 30;                                                                
                }                                                                                
                                                                                                 
                else if(nChoice == 23)                                                           
                {                                                                                
                        sItem = "prc_mshrm_pwdr";                                                
                        nCost = 50;                                                              
                        nDC = 25;
                }
                
                else if(nChoice == 24)
                {
                        sItem = "prc_it_natdrgt";
                        nCost = 25;
                        nDC = 25;
                }
                
                else if(nChoice == 25)
                {
                        sItem = "prc_it_nerv";
                        nCost = 13;
                        nDC = 25;
                }
                
                else if(nChoice == 26)
                {
                        sItem = "prc_sannish";
                        nCost = 8;
                        nDC = 20;
                }
                
                else if(nChoice == 27)
                {
                        sItem = "prc_it_scrmflsk";
                        nCost = 20;
                        nDC = 25;
                }
                
                else if(nChoice == 28)
                {
                        sItem = "prc_it_shedden";
                        nCost = 75;
                        nDC = 20;
                }
                
                else if(nChoice == 29)
                {
                        sItem = "prc_it_shedden2";
                        nCost = 200;
                        nDC = 24;
                }
                
                else if(nChoice == 30)
                {
                        sItem = "prc_it_shedden3";
                        nCost = 500;
                        nDC = 28;
                }
                
                else if(nChoice == 31)
                {
                        sItem = "prc_it_shedden4";
                        nCost = 1000;
                        nDC = 32;
                }
                
                else if(nChoice == 32)
                {
                        sItem = "prc_it_shedden5";
                        nCost = 2000;
                        nDC = 36;
                }
                
                else if(nChoice == 33)
                {
                        sItem = "prc_it_softfoot";
                        nCost = 25;
                        nDC = 20;
                }
                
                else if(nChoice == 34)
                {
                        sItem = "x1_wmgrenade006";
                        nCost = 30;
                        nDC = 25;
                }
                
                else if(nChoice == 35)
                {
                        sItem = "prc_terran_brndy";
                        nCost = 250;
                        nDC = 30;
                }
                
                else if(nChoice == 36)
                {
                        sItem = "x1_wmgrenade007";
                        nCost = 20;
                        nDC = 25;
                }
                
                else if(nChoice == 37)
                {
                        sItem = "prc_vodare";
                        nCost = 20;
                        nDC = 15;
                }
                
                else if(nChoice == 38)
                {
                        sItem = "prc_it_weepstn";
                        nCost = 50;
                        nDC = 25;
                }
                
                else if(nChoice == CHOICE_BACK)
                {
                        nStage = STAGE_ENTRY;
                }
                
                //set locals
                SetLocalInt(oPC, "PRC_CRAFT_COST", nCost);
                SetLocalInt(oPC, "PRC_CRAFT_DC", nDC);
                SetLocalString(oPC, "PRC_CRAFT_RESREF", sItem);
                SetLocalInt(oPC, "PRC_CRAFT_SKILLUSED", SKILL_CRAFT_ALCHEMY);
        }
        
        else if(nStage == STAGE_CONFIRM)
        {
                if(nChoice == CHOICE_ABORT_CRAFT)
                {
                        nStage = STAGE_ENTRY;
                }
                
                else if(nChoice == CHOICE_CONFIRM_CRAFT)
                {
                        int nRank = GetSkillRank(nSkill, oPC);                        
                        TakeGoldFromCreature(GetLocalInt(oPC, "PRC_CRAFT_COST"), oPC, TRUE);
                        if(GetIsSkillSuccessful(oPC, GetLocalInt(oPC,"PRC_CRAFT_SKILLUSED"), GetLocalInt(oPC, "PRC_CRAFT_DC"))) CreateItemOnObject(GetLocalString(oPC, "PRC_CRAFT_RESREF"), oPC, 1);
                        AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }                
        }  
        
        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}