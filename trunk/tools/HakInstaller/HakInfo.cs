using System;
using System.Collections;
using System.Collections.Specialized;
using System.Globalization;
using System.IO;
using System.Threading;
using HakInstaller.Utilities;

namespace HakInstaller
{
	/// <summary>
	/// This class is a dictionary of hak properties.  Each property contains
	/// a string collection of values tied to the property.
	/// </summary>
	public class HakPropertyDictionary: DictionaryBase
	{
		#region public properties/methods
		/// <summary>
		/// Indexer to get the StringCollection for a given property
		/// </summary>
		public StringCollection this[string property]
		{
			get { return InnerHashtable[property] as StringCollection; }
		}

		/// <summary>
		/// Default Constructor
		/// </summary>
		public HakPropertyDictionary()
		{
		}

		/// <summary>
		/// Adds a new property to the collection, creating a blank StringCollection
		/// for it.
		/// </summary>
		/// <param name="property"></param>
		public void Add(string property)
		{
			InnerHashtable.Add(property, new StringCollection());
		}
		#endregion
	}


	/// <summary>
	/// This class represents a .hif file.  This file contains information about
	/// a 'hak' (hak in this case consisting of a collection of ERF, TLK, and HAK
	/// files, along with a list of items in the module to modify).  It provides
	/// functionality to read the file into memory and access the various pieces of
	/// the file.
	/// </summary>
	public class HakInfo
	{
		#region public properties/methods
		/// <summary>
		/// Gets the name of the HIF minus the extension.
		/// </summary>
		public string Name
		{ get { return Path.GetFileNameWithoutExtension(fileInfo.Name); } }

		/// <summary>
		/// Gets the title of the HIF.  This is the HIF's title property if
		/// it has one, or it's file name if it doesn't.
		/// </summary>
		public string Title
		{
			get
			{
				StringCollection title = GetStrings(TitleKey, string.Empty);
				return null == title || 0 == title.Count || string.Empty == title[0] ?
					Name : title[0];
			}
		}

		/// <summary>
		/// Gets the version number of the HIF.
		/// </summary>
		public float Version
		{
			get
			{
				try
				{
					StringCollection version = GetStrings(VersionKey, string.Empty);
					return (float) Convert.ToDouble(version[0], cultureUSA);
				}
				catch (Exception)
				{
					return 0;
				}
			}
		}

		/// <summary>
		/// Gets the version of the HIF as a text string.
		/// </summary>
		public string VersionText
		{
			get
			{
				try
				{
					return GetStrings(VersionKey, string.Empty)[0];
				}
				catch (Exception)
				{
					return string.Empty;
				}
			}
		}

		/// <summary>
		/// Gets the minimum version number of NWN required to install the HIF.
		/// </summary>
		public float RequiredNWNVersion
		{
			get
			{
				try
				{
					// Get the required string array and look for a string that starts with a 
					// digit, that would be the NWN version, return it if we find it.
					StringCollection required = GetStrings(RequiredNWNVersionKey, string.Empty);
					foreach (string s in required)
					{
						if (Char.IsDigit(s[0])) return (float) Convert.ToDouble(required[0], cultureUSA);
					}
					return 0;
				}
				catch (Exception)
				{
					return 0;
				}
			}
		}

		/// <summary>
		/// Returns true if XP1 is required.
		/// </summary>
		public bool IsXP1Required
		{
			get
			{
				try
				{
					// Get the required string array and look for "XP1" or "Undrentide".
					StringCollection required = GetStrings(RequiredNWNVersionKey, string.Empty);
					foreach (string s in required)
					{
						if (0 == string.Compare("XP1", s, true, CultureInfo.InvariantCulture) ||
							0 == string.Compare("Undrentide", s, true, CultureInfo.InvariantCulture))
							return true;
					}
				}
				catch (Exception)
				{}

				return false;
			}
		}

		/// <summary>
		/// Returns true if XP2 is required.
		/// </summary>
		public bool IsXP2Required
		{
			get
			{
				try
				{
					// Get the required string array and look for "XP1" or "Undrentide".
					StringCollection required = GetStrings(RequiredNWNVersionKey, string.Empty);
					foreach (string s in required)
					{
						if (0 == string.Compare("XP2", s, true, CultureInfo.InvariantCulture) ||
							0 == string.Compare("Underdark", s, true, CultureInfo.InvariantCulture))
							return true;
					}
				}
				catch (Exception)
				{}

				return false;
			}
		}

		/// <summary>
		/// Gets the list of ERF files to add to the collection.
		/// </summary>
		public StringCollection Erfs  { get { return components[ErfKey] as StringCollection; } }

		/// <summary>
		/// Gets the dictionary of module properties that must be added/modified.
		/// </summary>
		public HakPropertyDictionary ModuleProperties
		{ get { return components[ModuleKey] as HakPropertyDictionary; } }

		/// <summary>
		/// Class constructor to load a .hif file from disk.
		/// </summary>
		/// <param name="fileName">The name of the hif file, hif files should
		/// all live in the hak directory.</param>
		public HakInfo(string fileName)
		{
			// Force the thread to use the invariant culture to make the install
			// code work on foreign language versions of windows.
			CultureInfo currentCulture = Thread.CurrentThread.CurrentCulture;
			Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
			try
			{
				fileInfo = new FileInfo(fileName);

				InitializeComponents();
				using(StreamReader reader = new StreamReader(fileName))
				{
					// Loop through all of the lines in the file.
					for (int i = 1; reader.Peek() > -1; i++)
					{
						// Read the references line and split off the 2da file name and the references.
						string line = reader.ReadLine();
						line = line.Trim();

						// If the line is blank or begins with a '#' ignore it.
						if (0 == line.Length || '#' == line[0]) continue;

						// Split the line into the type and references.  If we don't get both
						// parts the the line has a syntax error.
						string[] strings = line.Split(':');
						if (2 != strings.Length)
							ThrowException("{0}: line {1}: syntax error", fileName, i.ToString());

						// Save the component type and data.
						string componentType = strings[0].Trim().ToLower();
						string data = strings[1].Trim();

						// Check to see if the component has a property.  If there is
						// a '.' in the name then it has a sub type, we need to split
						// the component type into the type and property.
						string componentProperty = string.Empty;
						if (-1 != componentType.IndexOf('.'))
						{
							strings = componentType.Split('.');
							componentType = strings[0];
							componentProperty = strings[1];
						}

						// Split the various values, in case this can contain multiple
						// values, and add each to the collection.
						strings = data.Split(',');
						StringCollection coll = GetStrings(componentType, componentProperty);
						foreach (string s in strings)
							coll.Add(s.Trim());
					}
				}

				// The hak may or may not have a version number in it, if it doesn't add 0 so
				// we always have a version number for lookup.
				StringCollection version = GetStrings(VersionKey, string.Empty);
				if (0 == version.Count) version.Add("0");
			}
			finally
			{
				Thread.CurrentThread.CurrentCulture = currentCulture;
			}
		}

		/// <summary>
		/// Validates the HIF to make sure that it can be installed, returning an error
		/// message if it cannot.
		/// </summary>
		/// <param name="error">The error message if the HIF cannot be installed, or 
		/// string.Empty if the HIF can be installed</param>
		/// <returns>True if the HIF can be installed, false if it cannot.</returns>
		public bool Validate(out string error)
		{
			error = string.Empty;

			// If the HIF has a minimum required version and the current NWN install isn't
			// high enough then error out right away.
			if (RequiredNWNVersion > 0 && 
				(float) Convert.ToDouble(NWN.NWNInfo.Version, cultureUSA) < RequiredNWNVersion)
			{
				error = StringResources.GetString("ValidateNWNVersionError",
					Title, RequiredNWNVersion, NWN.NWNInfo.Version);
				return false;
			}

			// If the content requires XP1 then validate it.
			if (IsXP1Required && !NWN.NWNInfo.IsXP1Installed)
			{
				error = StringResources.GetString("ValidateNWNXP1Error", Title);
				return false;
			}

			// If the content requies XP2 then validate it.
			if (IsXP2Required && !NWN.NWNInfo.IsXP2Installed)
			{
				error = StringResources.GetString("ValidateNWNXP2Error", Title);
				return false;
			}

			// Build a list of ALL of the files referenced by the HIF.
			StringCollection files = new StringCollection();
			StringCollection strings = this.GetStrings(ErfKey, string.Empty);
			foreach (string s in strings) files.Add(NWN.NWNInfo.GetFullFilePath(s));
			strings = GetStrings(ModuleKey, "hak");
			foreach (string s in strings) files.Add(NWN.NWNInfo.GetFullFilePath(s));
			strings = GetStrings(ModuleKey, "tlk");
			foreach (string s in strings) files.Add(NWN.NWNInfo.GetFullFilePath(s));

			// Loop through all of the files checking to see which, if any, are missing.
			string missingFiles = string.Empty;
			foreach (string file in files)
			{
				// If the file is missing add it to our missing files string.
				if (!File.Exists(file))
				{
					if (0 == missingFiles.Length) missingFiles += "\r\n";
					missingFiles += "\r\n\t";
					missingFiles += NWN.NWNInfo.GetPartialFilePath(Path.GetFileName(file));
				}
			}

			// If there are missing files then format the error message and return it.
			if (missingFiles.Length > 0)
				error = StringResources.GetString("ValidateMissingFilesError", Title, missingFiles);

			return 0 == error.Length;
		}

		/// <summary>
		/// Override of ToString() to return the name of the HIF.
		/// </summary>
		/// <returns></returns>
		public override string ToString()
		{
			return Name;
		}

		#endregion

		#region private static fields/properties/methods
		// Create a CultureInfo for US English to do proper number conversion.
		private static CultureInfo cultureUSA = new CultureInfo(0x0409);
		#endregion

		#region private fields/properties/methods
		/// <summary>
		/// Gets the string collection for the specified (type, property) from the
		/// hash table.
		/// </summary>
		/// <param name="componentType">The component type</param>
		/// <param name="componentProperty">The property, or string.Empty if
		/// the type does not support properties</param>
		/// <returns>The string collection for the (type, property).</returns>
		private StringCollection GetStrings(string componentType, string componentProperty)
		{
			// Get the value for the given component if we can't find it
			// then throw an exception.
			object o = components[componentType];
			if (null == o) ThrowException("Unknown type {0}", componentType);

			if (string.Empty == componentProperty)
			{
				// No sub-type, the value for this component type should be
				// a string collection.
				if (!(o is StringCollection)) ThrowException("Type {0} requires a property", componentType);
				return (StringCollection) o;
			}
			else
			{
				// Get the hashtable for the type, if there is no hashtable
				// then throw an exception.
				HakPropertyDictionary hash = o as HakPropertyDictionary;
				if (null == hash) ThrowException("Type {0} cannot have properties", componentType);

				// Get the string collection for the property, if there is no
				// collection for the property yet then create one.
				StringCollection coll = hash[componentProperty];
				if (null == coll)
				{
					hash.Add(componentProperty);
					coll = hash[componentProperty];
				}
				return coll;
			}
		}

		/// <summary>
		/// Initializes the components hash table.
		/// </summary>
		private void InitializeComponents()
		{
			// Create the hashtable then walk the key/value arrays, creating
			// the proper value objects for the keys.
			components = new Hashtable();
			for (int i = 0; i < Keys.Length; i++)
			{
				System.Reflection.ConstructorInfo ci = Types[i].GetConstructor(new Type[0]);
				object val = ci.Invoke(new object[0]);
				components.Add(Keys[i], val);
			}
		}

		/// <summary>
		/// Throws an exception with the specified message.
		/// </summary>
		/// <param name="format">Format string</param>
		/// <param name="args">Format arguments</param>
		private void ThrowException(string format, params object[] args)
		{
			System.Text.StringBuilder b = new System.Text.StringBuilder();
			b.AppendFormat(format, args);
			throw new Exception(b.ToString());
		}

		// Define constants for the various component types.
		private const string ErfKey = "erf";
		private const string ModuleKey = "module";
		private const string VersionKey = "version";
		private const string RequiredNWNVersionKey = "minnwnversion";
		private const string TitleKey = "title";

		// Arrays that define the supported component types.  Keys is an array of
		// key values which match what is on the left of the ':' in the hif file.
		// Types is the type of object that is placed in the hash table for each
		// key.
		private string[] Keys = new string[]
		{ 
			VersionKey,
			RequiredNWNVersionKey,
			ErfKey, 
			TitleKey,
			ModuleKey
		};
		private Type[] Types = new Type[]
		{ 
			typeof(StringCollection),
			typeof(StringCollection),
			typeof(StringCollection), 
			typeof(StringCollection),
			typeof(HakPropertyDictionary)
		};

		private Hashtable components;
		private FileInfo fileInfo;
		#endregion
	}
}
