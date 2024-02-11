using System;
using System.Collections;
using System.Collections.Specialized;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using NWN.FileTypes.Gff;

namespace NWN.FileTypes
{
	/// <summary>
	/// This class defines the functionality for a .IFO file, which contains 
	/// information about the module.  This is based on the GFF file format;
	/// this class derives form Gff and provised IFO specific functionality.
	/// </summary>
	public class ModuleInfo: NWN.FileTypes.Gff.Gff
	{
		#region public properties/methods
		public const string FileName = "module.ifo";

		/// <summary>
		/// Indexer allowing get/set access to any of the module's exposed
		/// properties.  Exposed properties are added to the properties
		/// dictionary, which provides a translation between a human readable
		/// name and the property's label.
		/// </summary>
		public string this[string property]
		{
			get
			{
				// Look up the property in our dictionary to get the label name, if it
				// is not there then throw an exception.
				GffFieldSchema schema = properties[property];
				if (null == schema) throw new NWNException("{0} is not a valid module property", property);

				// Look up the field for the label.  If we cannot look it up then
				// it has not been added to the module info file, we need to add
				// it ourselves.
				GffField field = GetField(schema);

				// Figure out what to return based on the field's type.  Currently
				// only ResRef and ExoString fields are supported.
				switch (field.Type)
				{
					case GffFieldType.ExoString:
					case GffFieldType.ResRef:
						return (string) field.Value;
					default:
						throw new InvalidCastException("propety is not a text property");
				}
			}
			set
			{
				// Look up the property in our dictionary to get the label name, if it
				// is not there then throw an exception.
				GffFieldSchema schema = properties[property];
				if (null == schema) throw new NWNException("{0} is not a valid module property", property);

				// Look up the field for the label.  If we cannot look it up then
				// it has not been added to the module info file, we need to add
				// it ourselves.
				GffField field = GetField(schema);

				// Figure out what to do based on the field's type, currently only
				// ResRef and ExoString types are supported.
				switch (field.Type)
				{
					case GffFieldType.ExoString:
					case GffFieldType.ResRef:
						field.Value = value;
						break;
					default:
						throw new InvalidCastException("propety is not a text property");
				}
			}
		}

		/// <summary>
		/// Gets/sets the custom tlk property.
		/// </summary>
		public string CustomTlk
		{
			get
			{
				// Get the schema for the field and get it, creating it if it is not there.
				// Then return the field's value.
				GffFieldSchema schema = properties["customtlk"];
				GffExoStringField field = (GffExoStringField) GetField(schema);
				return field.Value;
			}
			set
			{
				// Get the schema for the field and get it, creating it if it is not there.
				// Then set the field's value.
				GffFieldSchema schema = properties["customtlk"];
				GffExoStringField field = (GffExoStringField) GetField(schema);
				field.Value = value;
			}
		}

		/// <summary>
		/// Gets the list of haks currently attached to the module.
		/// </summary>
		public StringCollection Haks
		{
			get
			{
				// Get the hak list field.
				GffListField listField = (GffListField) GetField(properties[HakList]);
				GffFieldCollection list = listField.Value;

				// Create a string collection object and loop through all of the 
				// structs in the hak list adding the haks.
				StringCollection haks = new StringCollection();
				foreach (GffStructField field in list)
				{
					// Get the string entry for the value.
					GffFieldDictionary dict = field.Value;
					GffField structValue = dict[HakEntry];
					haks.Add(structValue.Value.ToString());
				}

				return haks;
			}
		}

		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="path">The path to the module info file, this should NOT
		/// contain the file name</param>
		public ModuleInfo(string path) : base(Path.Combine(path, FileName))
		{
			Construct();
		}

		/// <summary>
		/// Class constructor to create the object from a stream, useful for creating
		/// the module info object without decompressing the module.  The current seek
		/// position of the stream must point to the start of the module info file.
		/// </summary>
		/// <param name="stream">The stream to read the file data from.</param>
		public ModuleInfo(Stream stream) : base(stream)
		{
			Construct();
		}

		/// <summary>
		/// Adds the passed hif name / version number to the list of hifs installed on
		/// the module.  Both arrays must be the same length.
		/// </summary>
		/// <param name="hifs">The hifs to add</param>
		/// <param name="versions">The version numbers of the hifs</param>
		public void AddInstalledHakInfos(string[] hifs, float[] versions)
		{
			// Get the current values if any.
			string[] currentHifs;
			float[] currentVersions;
			GetInstalledHakInfos(out currentHifs, out currentVersions);

			// Create StringCollections for them so we can use IndexOf() for searching.
			StringCollection colHifs = new StringCollection();
			colHifs.AddRange(currentHifs);
			ArrayList colVersions = new ArrayList();
			colVersions.AddRange(currentVersions);

			// Check for duplicates, pruning duplicates out of the current list.
			foreach (string hif in hifs)
			{
				// Find the hif in the current values, if we don't find it then
				// skip it.
				int index = colHifs.IndexOf(hif);
				if (-1 == index) continue;

				// Remove it from the current list.
				colHifs.RemoveAt(index);
				colVersions.RemoveAt(index);
			}

			// Now build a string with all of the current hifs/version numbers then
			// all of the added hif/version numbers.
			System.Text.StringBuilder b = new StringBuilder();
			for (int i = 0; i < colHifs.Count; i++)
			{
				if (b.Length > 0) b.Append(";");
				b.AppendFormat("{0};{1}", colHifs[i], colVersions[i].ToString());
			}
			for (int i = 0; i < hifs.Length; i++)
			{
				if (b.Length > 0) b.Append(";");
				b.AppendFormat("{0};{1}", hifs[i], versions[i].ToString());
			}

			// Get the schema for the field and get it, creating it if it is not there.
			// Then save the StringBuilder text as the field's value.
			GffFieldSchema schema = properties["installedhifs"];
			GffExoStringField field = (GffExoStringField) GetField(schema);
			field.Value = b.ToString();
		}

		/// <summary>
		/// Gets the list of hifs that are currently installed on the module, and their version
		/// numbers.
		/// </summary>
		/// <param name="hifs">Returns the list of hifs</param>
		/// <param name="versions">Returns the version numbers of the hifs</param>
		public void GetInstalledHakInfos(out string[] hifs, out float[] versions)
		{
			// Get the schema for the field and get it, creating it if it is not there.
			// Then return the field's value.
			GffFieldSchema schema = properties["installedhifs"];
			GffExoStringField field = (GffExoStringField) GetField(schema);

			// Split the string into the list of hif and version numbers.  If the
			// field is empty then we will get back 1 string, an empty string.
			string[] strings = field.Value.Split(';');

			// Create string arrays for the hif names and version numbers.
			hifs = new string[strings.Length / 2];
			versions = new float[strings.Length / 2];

			if (strings.Length > 1)
			{
				// Fill in the hif/version arrays with the string values.
				for (int i = 0, index = 0; i < strings.Length; i += 2, index++)
					hifs[index] = strings[i];
				for (int i = 1, index = 0; i < strings.Length; i += 2, index++)
					versions[index] = (float) Convert.ToDouble(strings[i]);
			}
		}

		/// <summary>
		/// This method adds an array of area files to the module info's area list.  It prunes
		/// duplicates before adding the areas.
		/// </summary>
		/// <param name="areas"></param>
		public void AddAreas(string[] areas)
		{
			UpdateList(AreaList, AreaEntry, AreaStructID, GffFieldType.ResRef, areas);
		}

		/// <summary>
		/// This method adds an array of hak files to the module info.  It prunes
		/// duplicates before adding the haks.
		/// </summary>
		/// <param name="haks">The list of haks to add</param>
		public void AddHaks(string[] haks)
		{
			UpdateList(HakList, HakEntry, HakStructID, GffFieldType.ExoString, haks);
		}

		/// <summary>
		/// This method adds an array of scripts to the module's cache list.  It 
		/// prunes duplicates before adding the scripts.
		/// </summary>
		/// <param name="scripts">The list of scripts to add</param>
		public void AddToCache(string[] scripts)
		{
			UpdateList(CacheList, CacheEntry, CacheStructID, GffFieldType.ResRef, scripts);
		}
		#endregion

		#region private fields/properties/methods
		private const string HakList = "Mod_HakList";
		private const string HakEntry = "Mod_Hak";
		private const string CacheList = "Mod_CacheNSSList";
		private const string CacheEntry = "ResRef";
		private const string AreaList = "Mod_Area_list";
		private const string AreaEntry = "Area_Name";

		private const uint HakStructID = 8;
		private const uint CacheStructID = 9;
		private const uint AreaStructID = 6;

		private GffSchemaCollection properties;

		/// <summary>
		/// This method constructs the ModuleInfo object.
		/// </summary>
		private void Construct()
		{
			// Create our property schema, filling it in with the properties we
			// manipulate.  This is not a complete schema, it is only for the
			// properties considered 'interesting'.
			properties = new GffSchemaCollection();
			properties.Add(new GffFieldSchema("onacquireitem", "Mod_OnAcquirItem", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onactivateitem", "Mod_OnActvtItem", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("oncliententer", "Mod_OnClientEntr", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onclientleave", "Mod_OnClientLeav", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("oncutsceneabort", "Mod_OnCutsnAbort", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onheartbeat", "Mod_OnHeartbeat", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onmoduleload", "Mod_OnModLoad", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onmodulestart", "Mod_OnModStart", GffFieldType.ResRef));
            properties.Add(new GffFieldSchema("onplayerchat", "Mod_OnPlrChat", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onplayerdeath", "Mod_OnPlrDeath", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onplayerdying", "Mod_OnPlrDying", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onplayerequipitem", "Mod_OnPlrEqItm", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onplayerlevelup", "Mod_OnPlrLvlUp", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onplayerrest", "Mod_OnPlrRest", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onplayerunequipitem", "Mod_OnPlrUnEqItm", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onplayerrespawn", "Mod_OnSpawnBtnDn", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onunaquireitem", "Mod_OnUnAqreItem", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("onuserdefined", "Mod_OnUsrDefined", GffFieldType.ResRef));
			properties.Add(new GffFieldSchema("customtlk", "Mod_CustomTlk", GffFieldType.ExoString));

			// This field is not part of the bioware schema for a module info file, we add it to keep
			// track of what HIFs have been installed on a module.  The value is a string with
			// the following format "HIF;Version;HIF;Version;...".  We make it a string instead of
			// a list because a list would require us to assign a structure ID, and worry about
			// BioWare using the ID later.
			properties.Add(new GffFieldSchema("installedhifs", "InstalledHIFs", GffFieldType.ExoString));

			// These properties aren't exposed out to the user, so we don't give them real names, we just
			// use the tag as the ui name.
			properties.Add(new GffFieldSchema("Mod_Area_list", "Mod_Area_list", GffFieldType.List));
			properties.Add(new GffFieldSchema("Mod_HakList", "Mod_HakList", GffFieldType.List));
			properties.Add(new GffFieldSchema("Mod_CacheNSSList", "Mod_CacheNSSList", GffFieldType.List));
		}

		/// <summary>
		/// This method updates the cache and hak list properties in the module
		/// info, adding the passed array of strings to the appropriate property.
		/// Both of these lists consist of an array of structures with 1 string
		/// item in each struture.
		/// </summary>
		/// <param name="listTag">The property name for the list</param>
		/// <param name="entryTag">The property name for each string in the list's 
		/// structures</param>
		/// <param name="structID">The structure ID of the structures in the list</param>
		/// <param name="stringType">The data type of the string in the list, either
		/// ExoString or ResRef</param>
		/// <param name="values">The array of strings to add, duplicates are pruned</param>
		private void UpdateList(string listTag, string entryTag, uint structID, 
			GffFieldType stringType, string[] values)
		{
			// Get the array of elements in the list.
			GffListField listField = (GffListField) GetField(properties[listTag]);
			GffFieldCollection list = listField.Value;

			// Create a string collection containing lower case copies of all of
			// the strings.
			StringCollection strings = new StringCollection();
			strings.AddRange(values);
			for (int i = 0; i < strings.Count; i ++)
				strings[i] = strings[i].ToLower();

			// Make a first pass and eliminate any strings that are already
			// in the module.
			foreach (GffStructField field in list)
			{
				// Get the string entry for the value.
				GffFieldDictionary dict = field.Value;
				GffField structValue = dict[entryTag];

				// Check to see if the hak is in the list of haks to add if it is
				// then remove it.
				int index = strings.IndexOf((string) structValue.Value);
				if (-1 != index) strings.RemoveAt(index);
			}

			// Now loop through all of the remaining strings and add them to the
			// beginning of the list.  We walk the list backwards adding the items
			// to the beginning of the list's collection, so when we are done
			// all of the added items are in order at the FRONT of the list.
			for (int i = strings.Count - 1; i >= 0; i--)
			{
				// Create a ExoString field for the hak file name.
				GffField structValue = GffFieldFactory.CreateField(stringType);
				structValue.Value = strings[i];

				// Create a GffStructField for the new list element and
				// save the exoString hak name in it.
				GffStructField listStruct = (GffStructField) 
					GffFieldFactory.CreateField(GffFieldType.Struct);
				listStruct.StructureType = structID;
				listStruct.Value = new GffFieldDictionary();
				listStruct.Value.Add(entryTag, structValue);

				// Add the structure to the list.
				list.Insert(0, listStruct);
			}
		}
		#endregion
	}
}
