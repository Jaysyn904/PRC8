<var:iBuild=18> 

<comment>
	The directory name uses \\ for a specific reason...
	When you use / in the file names it converts them to \ instead, in order
	to remove those \ you need to put them in the initial string as \\
	
	So we can each copy/paste our test directories   =)
	C:\\Games\\NeverwinterNights\\NWN\\localvault\\
	D:\\NeverwinterNights\\DocGen\\Tools\\BuildGen\\builds\\	
</comment>

<var:iBuildDir="C:\\Games\\NeverwinterNights\\NWN\\localvault\\">
<var:iBuildList= <var:iBuildDir> + "*.*">

<var:playerlist=[]>
<vault:<var:playerlist> <var:iBuildList> >

<for:vault <var:playerlist>>
<var:iLink= <~> - <var:iBuildDir> - "bic" + "rar">
<var:iText= <var:iBuildDir>+<var:iLink>-"rar"+"html">

<comment>
	In order for this to output .rar files
	you must copy the rar.exe program into the same directory as the .bic files
</comment>
<var:sCommand= <var:iBuildDir>+"rar.exe a -ep "+<var:iBuildDir>+<var:iLink>+" "+<~>>
<system:<var:sCommand>>
<var:BicHandle=<var:$fh>>
<file:create TEXT <var:iText> "text">
<comment>
	this is what should be prefixed before each text line
	<file:write TEXT <qq:
	and then this has to be added to the end
	>>
	so \n becomes <file:write TEXT <qq:\n>>
	Also, any field reference, e.g. <Lawful> need to be modified
	so that it reads 
	<gff:get 'Lawful' <options:handle=<var:BicHandle>>>
	
	Its a lot of boring copy/paste, which is why I havnt done it yet ;)
</comment
\n
\<html\> \n
\<head\> \n
\t\<title\>Player Resource Consortium :: Articles\</title\> \n
\t\<link type="text/css" href="../../styles/main_builds.css" rel="stylesheet"\> \n
\</head\> \n

\n
\<body scroll="auto"\>\n
\n

\<table class="main_table" cellpadding=5 cellspacing=0\>\n
\<tr\> \n

\t\<td nowrap width=40%\>\n
\t\t\<a class="title1" href=<var:iLink>\> <Firstname> <Lastname> \</a\> \n

\t\t\<br\> \<hr\> \n

\t\t <lq:{xql="gender[i=<Gender>]:."}>    \<br\> \n
\t\t <lq:{xql="racialtypes[i=<Race>]:."}> \<br\> \n
\t\t

<if: <LawfulChaotic> gt 65>
  Lawful 
<elsif:<LawfulChaotic> le 65 && <LawfulChaotic> ge 34>
  Neutral 
<elsif:<LawfulChaotic> lt 34>
  Chaotic 
</if>

<if: <GoodEvil> gt 65>
  Good 
<elsif:<GoodEvil> le 65 && <GoodEvil> ge 34>
  Neutral 
<elsif:<GoodEvil> lt 34>
  Evil 
</if>

\n
\t\t\<br\> \<hr\> \n

<#: List Class Totals>
<for:field 'ClassList'>
\t\t<lq:{xql="classes[i=<~/Class>]:."}> (<~/ClassLevel>) \n

<# Wizard Schools>
<if:<~/School> == "">
  &nbsp;
<else>
  &nbsp;[<lq:{xql="Schools[i=<~/School>]:."}>]
</if>

<# Clerical Domains - Working>
<if:<~/Domain1> == "">
  &nbsp;
<else>
  &nbsp[<lq:{xql="Domains[i=<~/Domain1>]:."}>, 
</if>

<if:<~/Domain2> == "">
  &nbsp;
<else>
  &nbsp;<lq:{xql="Domains[i=<~/Domain2>]:."}>]
</if>

\<br\>\n
</for>

\t\t \<hr\> \n
\t\</td\>\n

\t\<td valign=top\>\n
\t\t\<table cellpadding=3 cellspacing=0\>\n

\t\t\t
<#: Attribute & Stats table>

<var:iStr=<Str>>
<var:iDex=<Dex>>
<var:iCon=<Con>>
<var:iInt=<Int>>
<var:iWis=<wis>>
<var:iCha=<Cha>>
<var:iStr=0+<var:iStr>+<lq:{xql="racialtypes[i=<Race>]:stradjust"}>>
<var:iDex=0+<var:iDex>+<lq:{xql="racialtypes[i=<Race>]:dexadjust"}>>
<var:iCon=0+<var:iCon>+<lq:{xql="racialtypes[i=<Race>]:conadjust"}>>
<var:iInt=0+<var:iInt>+<lq:{xql="racialtypes[i=<Race>]:intadjust"}>>
<var:iWis=0+<var:iWis>+<lq:{xql="racialtypes[i=<Race>]:wisadjust"}>>
<var:iCha=0+<var:iCha>+<lq:{xql="racialtypes[i=<Race>]:chaadjust"}>>

<var:iStrb=<Str>>
<var:iDexb=<Dex>>
<var:iConb=<Con>>
<var:iIntb=<Int>>
<var:iWisb=<wis>>
<var:iChab=<Cha>>
<var:iStrb=0+<var:iStrb>+<lq:{xql="racialtypes[i=<Race>]:stradjust"}>>
<var:iDexb=0+<var:iDexb>+<lq:{xql="racialtypes[i=<Race>]:dexadjust"}>>
<var:iConb=0+<var:iConb>+<lq:{xql="racialtypes[i=<Race>]:conadjust"}>>
<var:iIntb=0+<var:iIntb>+<lq:{xql="racialtypes[i=<Race>]:intadjust"}>>
<var:iWisb=0+<var:iWisb>+<lq:{xql="racialtypes[i=<Race>]:wisadjust"}>>
<var:iChab=0+<var:iChab>+<lq:{xql="racialtypes[i=<Race>]:chaadjust"}>>


<for:field 'LvlStatList'>

<if:<~/LvlStatAbility> ne "">
  <if:<~/LvlStatAbility> eq 0>
      <var:iStr=<var:iStr>-1>
  </if>

  <if:<~/LvlStatAbility> eq 1>
      <var:iDex=<var:iDex>-1>
  </if>

  <if:<~/LvlStatAbility> eq 2>
      <var:iCon=<var:iCon>-1>
  </if>

  <if:<~/LvlStatAbility> eq 3>
      <var:iInt=<var:iInt>-1>
  </if>

  <if:<~/LvlStatAbility> eq 4>
      <var:iWis=<var:iwis>-1>
  </if>

  <if:<~/LvlStatAbility> eq 5>
      <var:iCha=<var:iCha>-1>
  </if>
</if>
  <for:field '~/FeatList'>
    <if:<~/Feat> eq 764><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 765><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 766><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 767><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 768><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 769><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 770><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 771><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 772><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 773><var:iCha=<var:iCha>-1></if>
    <if:<~/Feat> eq 774><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 775><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 776><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 777><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 778><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 779><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 780><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 781><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 782><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 783><var:iCon=<var:iCon>-1></if>
    <if:<~/Feat> eq 784><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 785><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 786><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 787><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 788><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 789><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 790><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 791><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 792><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 793><var:iDex=<var:iDex>-1></if>
    <if:<~/Feat> eq 794><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 795><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 796><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 797><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 798><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 799><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 800><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 801><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 802><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 803><var:iInt=<var:iInt>-1></if>
    <if:<~/Feat> eq 804><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 805><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 806><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 807><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 808><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 809><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 810><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 811><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 812><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 813><var:iWis=<var:iWis>-1></if>
    <if:<~/Feat> eq 814><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 815><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 816><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 817><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 818><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 819><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 820><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 821><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 822><var:iStr=<var:iStr>-1></if>
    <if:<~/Feat> eq 823><var:iStr=<var:iStr>-1></if>
  </for>
</for>

\n
\t\t\t\<tr\>\<td COLSPAN=3 width=150 nowrap class=title2\>Starting Stats\</td\>\<td COLSPAN=3 width=150 nowrap class=title2\>Ending Stats\</td\>\n

\n
\t\t\t\<tr\>\<td width=30%\>STR\</td\>\<td width=10%\><var:iStr>\</td\>\<td width=10% nowrap\><math:floor((<var:iStr>-10)/2)>\</td\>\<td width=30%\>STR\</td\>\<td width=10%\><var:iStrb>\</td\>\<td width=10% nowrap\><math:floor((<var:iStrb>-10)/2)>\</td\>\</tr\>\n
\t\t\t\<tr\>\<td\>DEX\</td\>\<td\><var:iDex>\</td\>\<td nowrap\><math:floor((<var:iDex>-10)/2)>\</td\>\<td\>DEX\</td\>\<td\><var:iDexb>\</td\>\<td nowrap\><math:floor((<var:iDexb>-10)/2)>\</td\>\</tr\>\n
\t\t\t\<tr\>\<td\>CON\</td\>\<td\><var:iCon>\</td\>\<td nowrap\><math:floor((<var:iCon>-10)/2)>\</td\>\<td\>CON\</td\>\<td\><var:iConb>\</td\>\<td nowrap\><math:floor((<var:iConb>-10)/2)>\</td\>\</tr\>\n
\t\t\t\<tr\>\<td\>INT\</td\>\<td\><var:iInt>\</td\>\<td nowrap\><math:floor((<var:iInt>-10)/2)>\</td\>\<td\>INT\</td\>\<td\><var:iIntb>\</td\>\<td nowrap\><math:floor((<var:iIntb>-10)/2)>\</td\>\</tr\>\n
\t\t\t\<tr\>\<td\>WIS\</td\>\<td\><var:iWis>\</td\>\<td nowrap\><math:floor((<var:iWis>-10)/2)>\</td\>\<td\>WIS\</td\>\<td\><var:iWisb>\</td\>\<td nowrap\><math:floor((<var:iWisb>-10)/2)>\</td\>\</tr\>\n
\t\t\t\<tr\>\<td\>CHA\</td\>\<td\><var:iCha>\</td\>\<td nowrap\><math:floor((<var:iCha>-10)/2)>\</td\>\<td\>CHA\</td\>\<td\><var:iChab>\</td\>\<td nowrap\><math:floor((<var:iChab>-10)/2)>\</td\>\</tr\>\n

\n
\t\t\t\<tr\>\<td COLSPAN=3\>AC <ArmorClass>\<br\>HP <MaxHitPoints>\</td\>
\t\t\t\<td COLSPAN=3 nowrap\>Experience: <Experience>\<br\>Next Level: <lq:{xql="exptable[level=<math:1+<LvlStatList?count>>]:xp"}>\</td\>\</tr\>\n

\n
\t\t\t\<tr\>\<td COLSPAN=6\>\n
\t\t\t\t\<span class='label1'\>Fortitude:\</span\> <FortSaveThrow>\<br\>\n
\t\t\t\t\<span class='label1'\>Reflex:\</span\> <RefSaveThrow>\<br\>\n
\t\t\t\t\<span class='label1'\>Will:\</span\> <WillSaveThrow>\<br\>\n
\t\t\t\t\<span class='label1'\>BAB:\</span\> <BaseAttackBonus>\<br\>\n
\t\t\t\t\<span class='label1'\>SR:\</span\> <CombatInfo/SpellResistance>\<br\>\n
\t\t\t\t\<span class='label1'\>Gold:\</span\> <Gold> \n
\t\t\t\</td\>\</tr\>\n
\t\t\</table\>\n

\t\</td\>\n\n
\t\<td valign=top width=150 \>\n

\t\t<#: Current Skill Totals>

\<table cellpadding=3 cellspacing=0\>\n

\t\t\t\<tr\>\<td nowrap colspan=2 class=title2\>Skill Totals\</td\> \</tr\>\n
  <for:field '~/SkillList'>
    <unless:<~/Rank>><next></unless>
    \t\t\t\<tr\>\<td\><lq:{xql="skills[i=<~?index>]:."}>\</td\>\<td\><~/Rank>\</td\>\</tr\>\n
  </for>
  
\t\t\</table\>\n
\t\</td\> \n\n

\</tr\>  \n

\<tr\> \n
\t\<td valign=top colspan=3\> \n

<#: Feats Listing>

\t\t\<table cellpadding=3 cellspacing=0\>\n

\t\t\t\<tr\>\<td class=title2\>Feats\</td\>\</tr\> \n

\t\t\t\<tr\>\<td\>
  <var:strFeatList="">
  <for:field 'FeatList'>
    <if: <?index> eq <=:<FeatList?count>-1>>
      <var:strFeatList=<var:strFeatList> + <lq:{xql="feat[i=<~/Feat>]:."}>>
    <else:>
      <var:strFeatList=<var:strFeatList> + <lq:{xql="feat[i=<~/Feat>]:."}> + ", ">
    </if>
  </for>
  <var:strFeatList>
  \</td\>\</tr\>\n
  
\t\t\</table\>\n

\t\</td\> \n
\</tr\>  \n



<#: Per level choices>

\<tr\>\n
\t\<td colspan=3\>\n
\t\t\<table cellpadding=3 cellspacing=0 width=100%\>\n

\t\t\t\<tr\>\<td class=title2\>Lvl\</td\>\<td class=title2\>Class\</td\>\<td class=title2\>HP\</td\>\<td class=title2\>Ability\</td\>\<td class=title2 nowrap\>[Unused] Skills \</td\>\<td class=title2\>Feats\</td\>\<td class=title2\>Spells\</td\>\</tr\>\n


<var:i=0>
<for:field 'LvlStatList'>
<var:i=<math:<var:i>=<var:i>+1>>

<#: Level>
<if: <var:i>%2=0>
  \t\t\t\<tr class=title3\> \n
  \t\t\t\t\<td valign=top\><=:<~?index> + 1>\</td\>\n
<else>
  \t\t\t\<tr\> \n
  \t\t\t\t\<td valign=top\><=:<~?index> + 1>\</td\>\n
</if>
<var: i=<var:i>+1>

<#: Class>
  \t\t\t\t\<td nowrap valign=top\><lq:{xql="classes[i=<~/LvlStatClass>]:."}>\</td\>\n

<#: HP>
  \t\t\t\t\<td valign=top\><~/LvlStatHitDie>\</td\>\n

<#: Ability increases>
  \t\t\t\t\<td valign=top center\>

<if:<~/LvlStatAbility> == "">
  &nbsp;
<else>
  +<lq:{xql="abilities[i=<~/LvlStatAbility>]:."}>
</if>

\</td\>\n

<#: Skills>
  \t\t\t\t\<td valign=top\> [<~/SkillPoints>] \<br\> \n 
  <for:field '~/SkillList'>
    <unless:<~/Rank>><next></unless>
    <var:totals[<~?index>]=0+<var:totals[<~?index>]>+<~/Rank>>
    <lq:{xql="skills[i=<~?index>]:."}> <~/Rank> \<br\>
  </for>
  \</td\> \n

<#: Feats>
  \t\t\t\t\<td valign=top\><for:field '~/FeatList'>
    <lq:{xql="feat[i=<~/Feat>]:."}>\<br\>
  </for>
  \</td\> \n

<#: Spells>
  \t\t\t\t\<td valign=top\><for:field '~/KnownList0'>
    L0: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList1'>
    L1: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList2'>
    L2: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList3'>
    L3: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList4'>
    L4: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList5'>
    L5: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList6'>
    L6: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList7'>
    L7: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList8'>
    L8: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  <for:field '~/KnownList9'>
    L9: <lq:{xql="spells[i=<~/Spell>]:."}>\<br\>
  </for>

  \</td\> \n
\t\t\t\</tr\>\n
</for>

\t\t\</table\>\n
\t\</td\>\n
\</tr\>\n
\</table\>\n\n


\<p\>Build <var:iBuild> of the NWN character export script by \<a href="mailto:kragus_nwn@hotmail.com"\>Kragus\</a\>.  Thanks to \<a href="http://weathersong.infopop.cc/"\>dragonsong\</a\> for the \<a href="http://sourceforge.net/projects/leto" target="_blank"\>Leto\</a\> family of products that this script uses... and his help making this script possible.\</p\> \n\n

\</body\>\n
\</html\>
<file:save TEXT>
<file:close TEXT>
</for>