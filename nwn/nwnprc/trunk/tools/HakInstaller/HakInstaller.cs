using System;
using System.Collections;
using System.Collections.Specialized;
using System.Diagnostics;
using System.IO;
using System.Globalization;
using System.Reflection;
using System.Threading;
using HakInstaller.Utilities;
using NWN;
using NWN.FileTypes;
using NWN.FileTypes.Gff;

namespace HakInstaller
{
	/// <summary>
	/// This class stores the data for a hif conflict.
	/// </summary>
	public class HifConflict
	{
		#region public properties/methods
		/// <summary>
		/// Gets the name of the module in conflict
		/// </summary>
		public string Module { get { return module; } }

		/// <summary>
		/// Gets the name of the hif in conflict
		/// </summary>
		public string Hif { get { return hif; } }

		/// <summary>
		/// Gets the version of the hif installed in the module
		/// </summary>
		public float InstalledVersion { get { return installedVersion; } }

		/// <summary>
		/// Gets the version of the hif that is going to be installed
		/// </summary>
		public float CurrentVersion { get { return currentVersion; } }

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="module">The module in conflict</param>
		/// <param name="hif">The hif in conflict</param>
		/// <param name="installedVersion">The version of the hif installed in the module</param>
		/// <param name="currentVersion">The version of the hif that is going to be installed</param>
		public HifConflict(string module, string hif, float installedVersion, float currentVersion)
		{
			this.module = module;
			this.hif = hif;
			this.installedVersion = installedVersion;
			this.currentVersion = currentVersion;
		}

		/// <summary>
		/// Override of ToString() that returns a nice formatted value.
		/// </summary>
		/// <returns></returns>
		public override string ToString()
		{
			System.Text.StringBuilder b = new System.Text.StringBuilder();
			b.AppendFormat("'{0}' contains '{1}'{2}{3}", module, hif,
				0 == installedVersion ? "" : " version ",
				0 == installedVersion ? "" : installedVersion.ToString("0.00"));
			return b.ToString();
		}
		#endregion

		#region private fields/properties/methods
		private string module;
		private string hif;
		private float installedVersion;
		private float currentVersion;
		#endregion
	}


	/// <summary>
	/// This class defines a type safe collection of HifConflict objects.
	/// </summary>
	public class HifConflictCollection: CollectionBase
	{
		#region public properties/methods
		/// <summary>
		/// Indexer to index into the collection to get FileConflict objects.
		/// </summary>
		public HifConflict this[int index] 
		{ get { return InnerList[index] as HifConflict; } }

		/// <summary>
		/// Default constructor
		/// </summary>
		public HifConflictCollection()
		{}

		/// <summary>
		/// Adds a conflict to the collection.
		/// </summary>
		/// <param name="conflict"></param>
		public void Add(HifConflict conflict)
		{
			InnerList.Add(conflict);
		}
		#endregion
	}


	/// <summary>
	/// This class stores the data for a file conflict, and how to resolve the
	/// conflict.
	/// </summary>
	public class FileConflict
	{
		#region public properties/methods
		public string ModuleFile { get { return moduleFile; } }

		public string HakFile { get { return hakFile; } }

		public string FileName { get { return Path.GetFileName(moduleFile); } }

		public bool ReplaceFile
		{
			get { return replaceFile; }
			set { replaceFile = value; }
		}

		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="moduleFile">The module file in conflict</param>
		/// <param name="hakFile">The hak file in conflict</param>
		public FileConflict(string moduleFile, string hakFile)
		{
			this.moduleFile = moduleFile;
			this.hakFile = hakFile;
			this.replaceFile = true;
		}

		/// <summary>
		/// Replace ToString() with something more reasonable.
		/// </summary>
		/// <returns>The FileName property</returns>
		public override string ToString()
		{
			return FileName;
		}
		#endregion

		#region private fields/properties/methods
		private string moduleFile;
		private string hakFile;
		private bool replaceFile;
		#endregion
	}


	/// <summary>
	/// This class defines a type save collection of FileConflict objects.
	/// </summary>
	public class FileConflictCollection: CollectionBase
	{
		#region public properties/methods
		/// <summary>
		/// Indexer to index into the collection to get FileConflict objects.
		/// </summary>
		public FileConflict this[int index] 
		{ get { return InnerList[index] as FileConflict; } }

		/// <summary>
		/// Default constructor
		/// </summary>
		public FileConflictCollection()
		{}

		/// <summary>
		/// Adds a conflict to the collection.
		/// </summary>
		/// <param name="conflict"></param>
		public void Add(FileConflict conflict)
		{
			InnerList.Add(conflict);
		}

		/// <summary>
		/// Generates a copy of the FileConflictCollection
		/// </summary>
		/// <returns></returns>
		public FileConflictCollection Clone()
		{
			FileConflictCollection copy = new FileConflictCollection();
			foreach (object o in InnerList)
				copy.InnerList.Add(o);
			return copy;
		}

		/// <summary>
		/// Removes a conflict from the collection.
		/// </summary>
		/// <param name="conflict">The conflict to remove</param>
		public void Remove(FileConflict conflict)
		{
			InnerList.Remove(conflict);
		}
		#endregion
	}


	/// <summary>
	/// This class contains the information needed to describe an overwrite warning.
	/// This warns the user that one file is going to get overwritten by another,
	/// but they have no choice in which overwrites which (as opposed to a FileConflict
	/// where they do).
	/// </summary>
	public class OverwriteWarning
	{
		#region public properties/methods
		/// <summary>
		/// Gets the file being overwritten.
		/// </summary>
		public string File { get { return file; } }

		/// <summary>
		/// Gets the source who's file is being overwritten.
		/// </summary>
		public string Source { get { return source; } }

		/// <summary>
		/// gets the file that is overwriting the source.
		/// </summary>
		public string Replacer { get { return replacer; } }

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="file">The file getting overwritten</param>
		/// <param name="source">The source hak/module/erf</param>
		/// <param name="replacer">The overwriting hak/module/erf</param>
		public OverwriteWarning(string file, string source, string replacer)
		{
			this.file = file;
			this.source = source;
			this.replacer = replacer;
		}

		/// <summary>
		/// Override of ToString() to give back a formatted value.
		/// </summary>
		/// <returns></returns>
		public override string ToString()
		{
			System.Text.StringBuilder b = new System.Text.StringBuilder();
			b.AppendFormat("{0} will overwrite {1} in {2}", replacer, file, source);
			return b.ToString();
		}
		#endregion

		#region private fields/properties/methods
		private string file;
		private string source;
		private string replacer;
		#endregion
	}


	/// <summary>
	/// This class defines a type safe collection of OverwriteWarning objects.
	/// </summary>
	public class OverwriteWarningCollection: CollectionBase
	{
		#region public properties/methods
		/// <summary>
		/// Indexer to get the index'th OverwriteWarning.
		/// </summary>
		public OverwriteWarning this[int index]
		{
			get { return InnerList[index] as OverwriteWarning; }
		}

		/// <summary>
		/// Adds an OverwriteWarning.
		/// </summary>
		/// <param name="warning"></param>
		public void Add(OverwriteWarning warning)
		{
			InnerList.Add(warning);
		}

		/// <summary>
		/// Makes a clone of the collection
		/// </summary>
		/// <returns>The clone</returns>
		public OverwriteWarningCollection Clone()
		{
			OverwriteWarningCollection copy = new OverwriteWarningCollection();
			foreach (object o in InnerList)
				copy.InnerList.Add(o);
			return copy;
		}

		/// <summary>
		/// Removes an overwrite warning from the collection
		/// </summary>
		/// <param name="warning">The warning to remove</param>
		public void Remove(OverwriteWarning warning)
		{
			InnerList.Remove(warning);
		}
		#endregion
	}


	/// <summary>
	/// This enum defines the different types of warnings that
	/// </summary>
	public enum OverwriteWarningType
	{
		HifsOverwritesModule,
		ModuleOverwritesHifs
	}


	/// <summary>
	/// Interface used to display progress information for the install.
	/// </summary>
	public interface IHakInstallProgress
	{
		#region properties/methods
		/// <summary>
		/// Gets whether the user cancelled the install.
		/// </summary>
		bool IsCancelled { get; }

		/// <summary>
		/// Gets/sets the number of steps for the progress bar.
		/// </summary>
		int ProgressSteps { get; set; }

		/// <summary>
		/// Advances the progress bar 1 step.
		/// </summary>
		void Step();

		/// <summary>
		/// Sets the currently displayed progress message.
		/// </summary>
		/// <param name="format">Format string</param>
		/// <param name="args">Message arguments</param>
		void SetMessage(string format, params object[] args);

		/// <summary>
		/// This methods should ask the user for confirmation of replacing
		/// the listed files in the module with files from sources in the
		/// hif files, as this operation may break the module.
		/// </summary>
		/// <param name="replacedFiles">The list of file conflicts.  The method
		/// may alter the list to indicate what the resolution of the conflict
		/// should be on a file by file basis.</param>
		/// <returns>true if the files should be replaced, false if adding
		/// the hak(s) to the module should be aborted</returns>
		bool ShouldReplaceFiles(FileConflictCollection conflicts);

		/// <summary>
		/// This method should ask the user for confirmation of overwriting
		/// the listed files.  If fatal is true then there is no confirmation,
		/// it is just an informational message that the operation must be aborted.
		/// </summary>
		/// <param name="warnings">The list of warnings</param>
		/// <param name="fatal">True if the warnings are fatal</param>
		/// <param name="type">The type of overwrite being confirmed</param>
		/// <returns>True if the operation should proceed</returns>
		bool ShouldOverwrite(OverwriteWarningCollection warnings, bool fatal, 
			OverwriteWarningType type);

		/// <summary>
		/// Displays an error message to the user.
		/// </summary>
		/// <param name="error">The error message to display</param>
		void DisplayErrorMessage(string error);

		/// <summary>
		/// Displays a message to the user.
		/// </summary>
		/// <param name="error">The message to display</param>
		void DisplayMessage(string message);
		#endregion
	}


	/// <summary>
	/// Exception used by the hak installer to cancel the install, when
	/// the IHakInstallProgress.IsCancelled property returns true.
	/// </summary>
	internal class InstallCancelledException: Exception
	{
		#region public properties/methods
		public InstallCancelledException() {}
		#endregion
	}


	/// <summary>
	/// Delegate for methods that handle the setting of properties.
	/// </summary>
	internal delegate void PropertyHandler(Erf module, object source, string property, 
		StringCollection values);


	/// <summary>
	/// This attribute is used to tag methods that handle module properties
	/// in the HakInstaller.
	/// </summary>
	[AttributeUsage(AttributeTargets.Method,
		 AllowMultiple = true,
		 Inherited = false)]
	internal class PropertyHandlerAttribute: Attribute
	{
		#region public properties/methods
		/// <summary>
		/// Gets the name of the object containing the property.
		/// </summary>
		public string Object { get { return obj; } }

		/// <summary>
		/// Gets the name of the property.
		/// </summary>
		public string Property { get { return property; } }

		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="obj">The object containing the property</param>
		/// <param name="property">The name of the property</param>
		public PropertyHandlerAttribute(string obj, string property)
		{
			this.obj = obj;
			this.property = property;
		}
		#endregion

		#region public static methods
		/// <summary>
		/// Gets the handler collection for the specified object.  This collection
		/// contains all of the methods tagged with the [PropertyHandler] attribute.
		/// </summary>
		/// <param name="sourceObject">The source object for which to get the
		/// collection</param>
		/// <returns>The property handler collection</returns>
		public static ObjectProperyHandlerDictionary GetHandlerCollection(object sourceObject)
		{
			ObjectProperyHandlerDictionary objects = new ObjectProperyHandlerDictionary();

			// Get all of the methods of the type and look for ones that have the [DBQuery] attached.
			Type sourceType = sourceObject.GetType();
			MethodInfo[] methods = sourceType.GetMethods (
				BindingFlags.Public | BindingFlags.NonPublic | 
				BindingFlags.Static | BindingFlags.Instance);
			foreach (MethodInfo method in methods)
			{
				// Try to get the method's [PropertyHandler] attribute.  If it 
				// doesn't have one then ignore it.
				Attribute[] atts = method.GetCustomAttributes (
					typeof (PropertyHandlerAttribute), false) as Attribute[];
				if (null == atts || 0 == atts.Length) continue;

				// Create a delegate for the method.
				PropertyHandler handler = (PropertyHandler) (method.IsStatic ?
					PropertyHandler.CreateDelegate (typeof (PropertyHandler), method) :
					PropertyHandler.CreateDelegate(typeof (PropertyHandler), sourceObject, method.Name));

				// Add the handler once for each property it handles.  Handlers may
				// handle more than one property thus the attribute array may have
				// multiple entries.
				foreach (Attribute att in atts)
				{
					PropertyHandlerAttribute handlerAtt = (PropertyHandlerAttribute) att;

					// Look up the handler dictionary for the object, if there isn't one
					// yet then create on.
					PropertyHandlerDictionary handlers = objects[handlerAtt.Object];
					if (null == handlers)
					{
						handlers = new PropertyHandlerDictionary(handlerAtt.Object);
						objects.Add(handlerAtt.Object, handlers);
					}

					handlers.Add(handlerAtt.Property, handler);
				}
			}

			return objects;
		}
		#endregion

		#region private fields/properties/methods
		private string obj;
		private string property;
		#endregion
	}


	/// <summary>
	/// This class defines a dictionary of PropertyHandler objects,
	/// allowing for the handler for a particular property to be looked up.
	/// </summary>
	internal class PropertyHandlerDictionary: DictionaryBase
	{
		#region public properties/methods
		/// <summary>
		/// Gets the object for which this collection contains property handlers.
		/// </summary>
		public string Object { get { return obj; } }

		/// <summary>
		/// Indexer to look up a handler for a property.
		/// </summary>
		public PropertyHandler this[string property]
		{
			get { return InnerHashtable[property.ToLower()] as PropertyHandler; }
		}

		/// <summary>
		/// Default constructor
		/// </summary>
		/// <param name="obj">The type of object that this dictionary
		/// contains handlers for</param>
		public PropertyHandlerDictionary(string obj)
		{
			this.obj = obj;
		}

		/// <summary>
		/// Adds a handler to the collection
		/// </summary>
		/// <param name="property">The property the handler handles</param>
		/// <param name="handler">The handler</param>
		public void Add(string property, PropertyHandler handler)
		{
			InnerHashtable.Add(property.ToLower(), handler);
		}
		#endregion

		#region private fields/properties/methods
		private string obj;
		#endregion
	}


	/// <summary>
	/// This class defines a dictionary collectoin of PropertyHandlerDictionary
	/// objects, each of those handling properties for a particular object.
	/// </summary>
	internal class ObjectProperyHandlerDictionary: DictionaryBase
	{
		#region public properties/methods
		/// <summary>
		/// Indexer to look up a handler dictionary for an object.
		/// </summary>
		public PropertyHandlerDictionary this[string obj]
		{
			get { return InnerHashtable[obj.ToLower()] as PropertyHandlerDictionary; }
		}

		/// <summary>
		/// Default constructor
		/// </summary>
		public ObjectProperyHandlerDictionary()
		{
		}

		/// <summary>
		/// Adds a handler to the collection
		/// </summary>
		/// <param name="obj">The object that the handlers handle properties for</param>
		/// <param name="handlers">The handler collection</param>
		public void Add(string obj, PropertyHandlerDictionary handlers)
		{
			InnerHashtable.Add(obj.ToLower(), handlers);
		}
		#endregion
	}


	/// <summary>
	/// Summary description for HakInstaller.
	/// </summary>
	public class HakInstaller
	{
		#region public static methods
		/// <summary>
		/// This method checks to see if any of the proposed hifs are installed on any of the
		/// given modules, returning a collection of conflicts that can be displayed to the user.
		/// </summary>
		/// <param name="proposedHifs">The list of hifs that the user wants to add to the modules</param>
		/// <param name="modules">The list of modules</param>
		/// <returns>A collection containing the list of conflicts, or null if there are no
		/// conflicts</returns>
		public static HifConflictCollection CheckInstalledHifs(HakInfo[] proposedHifs, string[] modules)
		{
			// Force the thread to use the invariant culture to make the install
			// code work on foreign language versions of windows.
			CultureInfo currentCulture = Thread.CurrentThread.CurrentCulture;
			Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
			try
			{
				HifConflictCollection conflicts = null;
				foreach (string module in modules)
				{
					// Load the module info data and create an object for it.
					MemoryStream stream = Erf.GetFile(NWNInfo.GetFullFilePath(module), ModuleInfo.FileName);
					if (null == stream) NWN.FileTypes.Tools.NWNLogger.Log(10, "HakInstaller.CheckInstalledHifs, Erf.GetFile() returned null!!!");
					ModuleInfo info = new ModuleInfo(stream);

					// Load the installed hifs in module if any.
					string[] installedHifs;
					float[] installedVersions;
					info.GetInstalledHakInfos(out installedHifs, out installedVersions);

					// Create a StringCollection of the proposed hifs so we can use IndexOf(),
					// then check to see if there are any hif conflicts, if there are then
					// add them to the conflict list.
					StringCollection proposedHifsColl = new StringCollection();
					foreach (HakInfo hif in proposedHifs)
						proposedHifsColl.Add(Path.GetFileNameWithoutExtension(hif.Name).ToLower());
					for (int i = 0; i < installedHifs.Length; i++)
					{
						if (proposedHifsColl.Contains(installedHifs[i].ToLower()))
						{
							HifConflict conflict = new HifConflict(module, 
								installedHifs[i], installedVersions[i], 0);
							if (null == conflicts) conflicts = new HifConflictCollection();
							conflicts.Add(conflict);
						}
					}
				}

				return conflicts;
			}
			finally
			{
				Thread.CurrentThread.CurrentCulture = currentCulture;
			}
		}

		/// <summary>
		/// Installs the listed haks (defined by hif files) on the listed
		/// modules.  
		/// </summary>
		/// <param name="hifs">The list of haks to add</param>
		/// <param name="modules">The list of modules to add the haks to</param>
		/// <param name="progress">An interface used to an object used to display
		/// progress information, or null if no progress information is desired</param>
		public static void InstallHaks(HakInfo[] hifs, string[] modules,
			IHakInstallProgress progress)
		{
			// Force the thread to use the invariant culture to make the install
			// code work on foreign language versions of windows.
			CultureInfo currentCulture = Thread.CurrentThread.CurrentCulture;
			Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
			try
			{
				// If no progress was given then use a dummy one which does nothing.
				if (null == progress) progress = new DummyProgress();

				// Invoke the private method on the singleton to do all the real work.
				Singleton.DoInstall(hifs, modules, progress);
			}
			finally
			{
				Thread.CurrentThread.CurrentCulture = currentCulture;
			}
		}

		/// <summary>
		/// Installs the listed haks (defined by hif files) on the module.
		/// </summary>
		/// <param name="hifs">The list of haks to add</param>
		/// <param name="moduleFile">The module to add the haks to</param>
		/// <param name="progress">An interface used to an object used to display
		/// progress information, or null if no progress information is desired</param>
		public static void InstallHaks(HakInfo[] hifs, string moduleFile,
			IHakInstallProgress progress)
		{
			// Force the thread to use the invariant culture to make the install
			// code work on foreign language versions of windows.
			CultureInfo currentCulture = Thread.CurrentThread.CurrentCulture;
			Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
			try
			{
				// If no progress was given then use a dummy one which does nothing.
				if (null == progress) progress = new DummyProgress();

				// Invoke the private method on the singleton to do all the real work.
				Singleton.DoInstall(hifs, new string[] { moduleFile }, progress);
			}
			finally
			{
				Thread.CurrentThread.CurrentCulture = currentCulture;
			}
		}
		#endregion

		#region module property handlers
		/// <summary>
		/// Property handler for all of the module event properties.  It sets
		/// the specified events on the appropriate event handler, creating
		/// another script to execute all scripts in the chain if there are
		/// multiple scripts on the event.
		/// </summary>
		/// <param name="module">The module being modified</param>
		/// <param name="source">The source object, a ModuleInfo object in this case</param>
		/// <param name="property">The property to set</param>
		/// <param name="values">The collection containing the property values</param>
		[PropertyHandler("Module", "OnAcquireItem")]
		[PropertyHandler("Module", "OnActivateItem")]
		[PropertyHandler("Module", "OnClientEnter")]
		[PropertyHandler("Module", "OnClientLeave")]
		[PropertyHandler("Module", "OnCutsceneAbort")]
		[PropertyHandler("Module", "OnHeartbeat")]
		[PropertyHandler("Module", "OnModuleLoad")]
		[PropertyHandler("Module", "OnModuleStart")]
        [PropertyHandler("Module", "OnPlayerChat")]
		[PropertyHandler("Module", "OnPlayerDeath")]
		[PropertyHandler("Module", "OnPlayerDying")]
		[PropertyHandler("Module", "OnPlayerEquipItem")]
		[PropertyHandler("Module", "OnPlayerLevelUp")]
		[PropertyHandler("Module", "OnPlayerRest")]
		[PropertyHandler("Module", "OnPlayerUnEquipItem")]
		[PropertyHandler("Module", "OnPlayerRespawn")]
		[PropertyHandler("Module", "OnUnaquireItem")]
		[PropertyHandler("Module", "OnUserDefined")]
		private void Module_SetEvent(Erf module, object source, string property, 
			StringCollection values)
		{
			ModuleInfo moduleInfo = (ModuleInfo) source;

			// Get the current event handler on the module, if any.
			string currentEvent = moduleInfo[property];

			// Get the total number of event handlers.
			int count = values.Count + (string.Empty == currentEvent ? 0 : 1);

			// If there is only 1 handler then this is easy, just set the handler.
			if (1 == count)
			{
				moduleInfo[property] = values[0];
				return;
			}

			// There are multiple events, we must build a new script that
			// invokes the events.
			string newScript = CreateExecuteScript(module, property, currentEvent, values);
			moduleInfo[property] = newScript;
		}

		/// <summary>
		/// Property handler for the cache property, it adds all of the scripts to
		/// the module's cache list.
		/// </summary>
		/// <param name="module">The module being modified</param>
		/// <param name="source">The source object, a ModuleInfo object in this case</param>
		/// <param name="property">The property to set</param>
		/// <param name="values">The collection containing the property values</param>
		[PropertyHandler("Module", "Cache")]
		private void Module_ScriptCache(Erf module, object source, string property,
			StringCollection values)
		{
			ModuleInfo moduleInfo = (ModuleInfo) source;

			// Copy the haks to a flat array and add them to the module.
			string[] scripts = new string[values.Count];
			for (int i = 0; i < scripts.Length; i++)
				scripts[i] = (values[i].ToLower());
			moduleInfo.AddToCache(scripts);
		}

		/// <summary>
		/// Property handler for the module's custom tlk property.  It sets
		/// the first string in the collection to be the module's custom tlk.
		/// </summary>
		/// <param name="module">The module being modified</param>
		/// <param name="source">The source object, a ModuleInfo object in this case</param>
		/// <param name="property">The property to set</param>
		/// <param name="values">The collection containing the property values</param>
		[PropertyHandler("Module", "CustomTlk")]
		private void Module_CustomTlk(Erf module, object source, string property,
			StringCollection values)
		{
			// If we have a merge tlk then do not set the custom tlk, the
			// conflict resolution code for tlk's did that already.
			if (string.Empty != mergeTlk) return;

			string tlk = Path.GetFileNameWithoutExtension(values[0].ToLower());

			// If the tlk is being set to the same tlk then do nothing.
			ModuleInfo moduleInfo = (ModuleInfo) source;
			if (0 == string.Compare(moduleInfo.CustomTlk, tlk, true, CultureInfo.InvariantCulture)) return;

			// Check to see if the module already has a custom tlk file, if it does
			// then we are dead; we cannot change it w/o breaking the module but the
			// hak won't run w/o it's custom tlk either.
			if (string.Empty != moduleInfo.CustomTlk)
				throw new NWNException(
					"The module {0} already contains a custom tlk {1}, hak cannot be added",
					moduleInfo.Name, values[0]);

			moduleInfo.CustomTlk = tlk;
		}

		/// <summary>
		/// Property handler for the module's hak property.  It adds all of the haks
		/// to the module.
		/// </summary>
		/// <param name="module">The module being modified</param>
		/// <param name="source">The source object, a ModuleInfo object in this case</param>
		/// <param name="property">The property to set</param>
		/// <param name="values">The collection containing the property values</param>
		[PropertyHandler("Module", "Hak")]
		private void Module_Hak(Erf module, object source, string property,
			StringCollection values)
		{
			ModuleInfo moduleInfo = (ModuleInfo) source;

			// Copy the haks to a flat array and add them to the module.
			string[] haks = new string[values.Count];
			for (int i = 0; i < haks.Length; i++)
				haks[i] = Path.GetFileNameWithoutExtension(values[i].ToLower());
			moduleInfo.AddHaks(haks);
		}

		/// <summary>
		/// Property handler for the module's hak property.  It adds all of the haks
		/// to the module.
		/// </summary>
		/// <param name="module">The module being modified</param>
		/// <param name="source">The source object, a ModuleInfo object in this case</param>
		/// <param name="property">The property to set</param>
		/// <param name="values">The collection containing the property values</param>
		[PropertyHandler("Module", "Areas")]
		private void Module_Areas(Erf module, object source, string property,
			StringCollection values)
		{
			ModuleInfo moduleInfo = (ModuleInfo) source;

			// Copy the haks to a flat array and add them to the module.
			string[] areas = new string[values.Count];
			for (int i = 0; i < areas.Length; i++)
				areas[i] = values[i].ToLower();
			moduleInfo.AddAreas(areas);
		}
		#endregion

		#region private nested classes
		/// <summary>
		/// This class implements a null IHakInstallProgress implementation, i.e.
		/// all of the properties and methods on the interface are no-ops.
		/// </summary>
		private class DummyProgress: IHakInstallProgress
		{
			#region implementation
			/// <summary>
			/// Gets whether the user cancelled the install.
			/// </summary>
			bool IHakInstallProgress.IsCancelled { get { return false;} }

			/// <summary>
			/// Gets/sets the number of steps for the progress bar.
			/// </summary>
			int IHakInstallProgress.ProgressSteps { get { return steps; } set { steps = value;} }

			/// <summary>
			/// Advances the progress bar 1 step.
			/// </summary>
			void IHakInstallProgress.Step() {}

			/// <summary>
			/// Sets the currently displayed progress message.
			/// </summary>
			/// <param name="format">Format string</param>
			/// <param name="args">Message arguments</param>
			void IHakInstallProgress.SetMessage(string format, params object[] args) {}

			/// <summary>
			/// This methods should ask the user for confirmation of replacing
			/// the listed files in the module with files from sources in the
			/// hif files, as this operation may break the module.
			/// </summary>
			/// <param name="replacedFiles">The list of replaced files</param>
			/// <returns>true if the files should be replaced, false if adding
			/// the hak(s) to the module should be aborted</returns>
			bool IHakInstallProgress.ShouldReplaceFiles(FileConflictCollection conflicts)
			{
				return true;
			}

			/// <summary>
			/// This method should ask the user for confirmation of overwriting
			/// the listed files.  If fatal is true then there is no confirmation,
			/// it is just an informational message that the operation must be aborted.
			/// </summary>
			/// <param name="warnings">The list of warnings</param>
			/// <param name="fatal">True if the warnings are fatal</param>
			/// <param name="type">The type of overwrite being confirmed</param>
			/// <returns>True if the operation should proceed</returns>
			bool IHakInstallProgress.ShouldOverwrite(OverwriteWarningCollection warnings, 
				bool fatal, OverwriteWarningType type)
			{
				return true;
			}

			/// <summary>
			/// Displays an error message to the user.
			/// </summary>
			/// <param name="error">The error message to display</param>
			void IHakInstallProgress.DisplayErrorMessage(string error) {}

			/// <summary>
			/// Displays a message to the user.
			/// </summary>
			/// <param name="error">The message to display</param>
			void IHakInstallProgress.DisplayMessage(string message) {}

			private int steps = 0;
			#endregion
		}
		#endregion

		#region private fields/properties/methods
		private string currentTempDir;
		private string mergeTlk;
		private string mergeHak;
		private ObjectProperyHandlerDictionary objects;

		/// <summary>
		/// Default constructor, private to force singleton implementation.
		/// </summary>
		private HakInstaller()
		{
			objects = PropertyHandlerAttribute.GetHandlerCollection(this);
		}

		/// <summary>
		/// Gets the number of progress steps required given a source list of
		/// hifs and modules.
		/// </summary>
		/// <param name="hifs">The list of hifs</param>
		/// <param name="modules">The list of modules</param>
		/// <returns>The number of progress steps required.</returns>
		private int GetProgressCount(HakInfo[] hifs, string[] modules)
		{
			// Count the number of erfs and files in the erfs.
			int fileCount, erfCount;
			CountAddedFiles(hifs, out fileCount, out erfCount);

			// Start with 3 steps per module, to load, decompress, and save.
			int count = modules.Length * 3;

			// Add one step per hif to load them.
			count += hifs.Length;

			// Add 2 steps per erf, one to load one to decompress.
			count += erfCount * 2;

			// Add a number of steps to add each file to each module.
			count += modules.Length * fileCount;

			// Add 1 steps for each (module, hif) pair to wire up events. 
			count += modules.Length * hifs.Length;

			return count;
		}

		/// <summary>
		/// Counts the number of files in the hifs that will be added to a
		/// module, to allow for progress bar movement.
		/// </summary>
		/// <param name="hifs">The list of hifs</param>
		/// <param name="fileCount">Returns the number of files in the erfs.</param>
		/// <param name="erfCount">Returns the number of erf files.</param>
		private void CountAddedFiles(HakInfo[] hifs, out int fileCount, out int erfCount)
		{
			fileCount = 0;
			erfCount = 0;

			// Now loop through all of the haks and add them to the module.
			foreach (HakInfo hif in hifs)
			{
				erfCount += hif.Erfs.Count;
				foreach (string erf in hif.Erfs)
					fileCount += Erf.GetFileCount(Path.Combine(NWNInfo.GetPathForFile(erf), erf));
			}
		}

		/// <summary>
		/// Decompresses an ERF file, returning the temp director that the
		/// file is decompressed to.
		/// </summary>
		/// <param name="erf">The erf to decompress</param>
		/// <param name="tempDirs">The string collection in which to place
		/// the temp directory.</param>
		/// <returns>The temp directory that the ERF was decompressed to, this
		/// is also added to the StringCollection</returns>
		private string Decompress (Erf erf, StringCollection tempDirs)
		{
			string tempDir = erf.FileName + ".Temp";
			tempDirs.Add(tempDir);
			erf.Decompress(tempDir);
			return tempDir;
		}

		/// <summary>
		/// Loads a collection of hifs into memory.
		/// </summary>
		/// <param name="hifs">The hifs to load</param>
		/// <param name="progress">An interface used to an object used to display
		/// progress information, or null if no progress information is desired</param>
		/// <returns>An array of HakInfo objects representing the hifs</returns>
		private HakInfo[] LoadHifs(string[] hifs, IHakInstallProgress progress)
		{
			// Loop through the array of hif files loading them into HakInfo objects.
			HakInfo[] hakInfos = new HakInfo[hifs.Length];
			for (int i = 0; i < hifs.Length; i++)
			{
				// Load the hif file, stepping the progress bar.
				Progress(progress, true, "Reading {0}", hifs[i]);
				if (progress.IsCancelled) throw new InstallCancelledException();
				hakInfos[i] = new HakInfo(Path.Combine(NWNInfo.HakInfoPath, hifs[i]));
			}

			return hakInfos;
		}

		/// <summary>
		/// Decompresses all of the ERF files in the hak info objects, returning
		/// a collection of the temp directories they are in.
		/// </summary>
		/// <param name="hakInfos">The array of hak infos for which to decompress
		/// the erfs</param>
		/// <param name="progress">An interface used to an object used to display
		/// progress information, or null if no progress information is desired</param>
		/// <returns>A string collection of all of the directories in which the
		/// ERF's have been decompressed.</returns>
		private StringCollection DecompressHifErfs(HakInfo[] hakInfos, 
			IHakInstallProgress progress)
		{
			StringCollection tempDirs = new StringCollection();
			foreach (HakInfo hakInfo in hakInfos)
			{
				// Add any erf files to the module.
				foreach (string erf in hakInfo.Erfs)
				{
					// Load the erf.
					Progress(progress, true, "Loading {0}", erf);
					if (progress.IsCancelled) throw new InstallCancelledException();
					Erf hakErf = Erf.Load(Path.Combine(NWNInfo.GetPathForFile(erf), erf));

					// Decompress the erf into it's own temporary directory, saving the
					// directory for later cleanup.
					Progress(progress, true, "Decompressing {0}", erf);
					Decompress(hakErf, tempDirs);
				}
			}

			return tempDirs;
		}

		/// <summary>
		/// Method to display a progress message.  It displays the message,
		/// steps the progress bar, and checks to see if the operation has
		/// been cancelled throwing a InstallCancelledException if it has.
		/// </summary>
		/// <param name="progress">The progress object</param>
		/// <param name="step">If true steps the progress bar</param>
		/// <param name="format">Message format string</param>
		/// <param name="args">Message arguments</param>
		private void Progress(IHakInstallProgress progress, bool step,
			string format, params object[] args)
		{
			// If the operation has been cancelled then abort.
			if (progress.IsCancelled) throw new InstallCancelledException();

			// Display the message and step the progress bar.
			progress.SetMessage(format, args);
			if (step) progress.Step();
		}
		#endregion

		#region private methods to deal with conflict resolution
		/// <summary>
		/// This method creates a conflict collection from the module.
		/// </summary>
		/// <param name="module"></param>
		/// <returns></returns>
		private FileConflictCollection CreateConflictCollection(Erf module)
		{
			FileConflictCollection conflicts = new FileConflictCollection();
			StringCollection replacedFiles = module.ReplacedFiles;
			foreach (string file in replacedFiles)
			{
				// Generate the full path of the module file, which has the same name
				// but is decompressed to the current temp directory.
				string moduleFile = Path.Combine(currentTempDir, Path.GetFileName(file));

				// Create the conflict object and add it to the collection.
				FileConflict conflict = new FileConflict(moduleFile, file);
				conflicts.Add(conflict);
			}
			return conflicts;
		}

		/// <summary>
		/// This function checks for tlk conflicts, checking to see if the module
		/// and hifs have tlk files.  If there are multiple tlk files it will attempt
		/// to generate a merge tlk file, if this cannot be done it will display an
		/// error message and throw an InstallCancelledException to cancel the install.
		/// </summary>
		/// <param name="hakInfos">The hak infos being added to the module</param>
		/// <param name="module">The module</param>
		/// <param name="moduleInfo">The module info</param>
		/// <param name="progress">The object implemening the progress interface</param>
		private void CheckForTlkConflicts(HakInfo[] hakInfos,
			Erf module, ModuleInfo moduleInfo,
			IHakInstallProgress progress)
		{
			// Create a tlk string collection and add the module's tlk if it has one.
			StringCollection tlks = new StringCollection();
			if (string.Empty != moduleInfo.CustomTlk) 
				tlks.Add(moduleInfo.CustomTlk.ToLower() + ".tlk");

			// Add all of the tlk's from all of the HIFs.
			foreach (HakInfo hif in hakInfos)
			{
				StringCollection hifTlks = hif.ModuleProperties["customtlk"];
				if (null != hifTlks && hifTlks.Count > 0)
				{
					// Loop through the tlk's individually to exclude duplicates.
					foreach (string hifTlk in hifTlks)
					{
						string lower = hifTlk.ToLower();
						if (!tlks.Contains(lower)) tlks.Add(lower);
					}
				}
			}

			// If we have less than 2 tlks there is no conflict to resolve.
			if (tlks.Count < 2) return;

			// We have 2 or more tlk files, create a conflict resolver to
			// build a merge tlk file.
			ConflictResolver resolver = new ConflictResolver(progress);
			string[] tlkStrings = new string[tlks.Count];
			tlks.CopyTo(tlkStrings, 0);
			mergeTlk = resolver.ResolveTlkConflict(module, tlkStrings);

			// If we don't get a merge tlk back from the conflict resolver then we couldn't
			// resolve the conflict.  This is a fatal error so display an error message and
			// cancel the install.
			if (string.Empty == mergeTlk)
			{
				progress.DisplayErrorMessage("The module and custom content contain tlk files " +
					"that cannot be merged.  The module update will be aborted.");
				throw new InstallCancelledException();
			}

			// Save the merge tlk as the module's custom tlk.
			moduleInfo.CustomTlk = Path.GetFileNameWithoutExtension(mergeTlk.ToLower());
		}

		/// <summary>
		/// This function checks for hak conflicts, checking to see if any files
		/// in the hifs will overwrite files in the module or vica versa.  If 
		/// overwrites will happen, it prompts the user to see if we should continue,
		/// throwing an InstallCancelledException() if the user chooses to cancel.
		/// </summary>
		/// <param name="hakInfos">The hak infos being added to the module</param>
		/// <param name="decompressedErfs">The decompressed erfs</param>
		/// <param name="module">The module</param>
		/// <param name="moduleInfo">The module info</param>
		/// <param name="progress">The object implemening the progress interface</param>
		private void CheckForHakConflicts(HakInfo[] hakInfos, 
			StringCollection decompressedErfs, Erf module, ModuleInfo moduleInfo,
			IHakInstallProgress progress)
		{
			// Create a hashtable for fast lookup and add all of the files in all
			// of the decompressed erf's to it.
			Hashtable hifErfHash = new Hashtable(10000);
			foreach(string directory in decompressedErfs)
			{
				// Strip the ".temp" off the end of the name.
				string erf = Path.GetFileNameWithoutExtension(directory);
				string[] files = Directory.GetFiles(directory);
				foreach (string file in files)
				{
					// Only add the ERF file if it's not already there.  We assume that
					// the ERF's in the HIF play well together so we ignore duplicates.
					string key = Path.GetFileName(file).ToLower();
					if ("exportinfo.gff" != key && !hifErfHash.Contains(key)) hifErfHash.Add(key, erf.ToLower());
				}
			}

			// Build a list of all of the added haks.
			StringCollection hakInfoHaks = new StringCollection();
			foreach (HakInfo hakInfo in hakInfos)
			{
				StringCollection temp = hakInfo.ModuleProperties["hak"] as StringCollection;
				if (null != temp)
				{
					foreach (string tempString in temp)
						hakInfoHaks.Add(tempString.ToLower());
				}
			}

			// Add all of the files in all of the haks to the hash table.
			Hashtable hifHakHash = new Hashtable(10000);
			foreach (string hakName in hakInfoHaks)
			{
				Erf hak = Erf.Load(NWNInfo.GetFullFilePath(hakName));
				StringCollection files = hak.Files;
				foreach (string file in files)
					try
					{
						string key = file.ToLower();
						string hakNameLower = hakName.ToLower();
						hifHakHash.Add(key, hakNameLower);
					}
					catch (ArgumentException)
					{}
			}

			// At this point we have built a lookup hash table that contains every
			// file going into the module (either directly in an erf or indirectly
			// in a hak).  Now we need to loop through all of the files in the
			// module (and all of it's haks) and check to see if any of them are
			// going to get overwritten.  At this point we have several cases.
			// 1. Module content is going to get replaced by erf content.  We 
			//    do not handle that case now, we wait until the end and allow
			//    the user to selectivly overwrite whatever they wish.
			// 2. Module content is going to get replaced by hak content.  We must
			//    warn the user that module files will not be used and the module
			//    may not work.
			// 3. Module hak content is going to get replaced by hak content.  Same
			//    as above.
			// 4. Module hak content is going to overwrite erf content from the hif.
			//    In this case the hif's content is the content that is going to be
			//    ignored, again the user has to be warned.
			OverwriteWarningCollection hakWarnings = new OverwriteWarningCollection();
			OverwriteWarningCollection erfWarnings = new OverwriteWarningCollection();

			string moduleFileName = Path.GetFileName(module.FileName);

			// Loop through all of the files in the module checking to see if files in
			// added haks will overwrite them.
			StringCollection moduleFiles = module.Files;
			foreach (string file in moduleFiles)
			{
				string source = hifHakHash[file.ToLower()] as string;
				if (null != source)
					hakWarnings.Add(new OverwriteWarning(file.ToLower(), moduleFileName, source));
			}

			// Loop through all of the files in the module's haks checking to see if
			// files in the added haks will overwrite them or if they will overwrite
			// files in added erf's.
			StringCollection moduleHaks = moduleInfo.Haks;
			foreach (string moduleHak in moduleHaks)
			{
				// Check to see if the hak in the module is one of the haks being added (this is
				// a no-op condition which will result in 100% duplicates, no need to check it).
				string hak = moduleHak + ".hak";
				if (hakInfoHaks.Contains(hak.ToLower())) continue;

				Erf erf = Erf.Load(NWNInfo.GetFullFilePath(hak));
				StringCollection hakFiles = erf.Files;
				foreach (string file in hakFiles)
				{
					// If the file is in the hak hash then it is going to be
					// overwritten by the hif's haks.
					string key = file.ToLower();
					string source = hifHakHash[key] as string;
					if (null != source)
						hakWarnings.Add(new OverwriteWarning(key, 
							Path.GetFileName(erf.FileName.ToLower()), source));

					// If the file is in the erf hash then it will overwrite the
					// hif's erf.
					source = hifErfHash[key] as string;
					if (null != source)
						erfWarnings.Add(new OverwriteWarning(key, source, 
							Path.GetFileName(erf.FileName.ToLower())));
				}
			}

			// We have built the list of conflicts, before asking the user try to resolve the
			// conflicts as we may be able to generate a merge hak to resolve some of them.
			if (hakWarnings.Count > 0)
			{
				ConflictResolver resolver = new ConflictResolver(progress);
				mergeHak = resolver.ResolveConflicts(hakInfos, module, moduleInfo, hakWarnings);
			}

			// We have finished checking for files that are going to get overwritten.
			// If we have any warnings to issue to the user then do so now.
			if (hakWarnings.Count > 0 && 
				!progress.ShouldOverwrite(hakWarnings, false, OverwriteWarningType.HifsOverwritesModule))
				throw new InstallCancelledException();

			if (erfWarnings.Count > 0 && 
				!progress.ShouldOverwrite(erfWarnings, false, OverwriteWarningType.ModuleOverwritesHifs))
				throw new InstallCancelledException();
		}
		#endregion

		#region private methods to do the install work.
		/// <summary>
		/// Installs the listed haks (defined by hif files) on the module.
		/// </summary>
		/// <param name="hakInfos">The array of loaded hif files to install.</param>
		/// <param name="decompressedErfs">The string collection of decompressed
		/// erf files from the hifs.  The values in here should be the
		/// temp directories in which the erfs have been decompressed to.  If this
		/// collection is empty then the erfs will be decompressed to temp directories
		/// and the directories returned in this collection.  It will be the caller's
		/// responsibility to delete them.</param>
		/// <param name="moduleFile">The module to add the haks to</param>
		/// <param name="progress">An interface used to an object used to display
		/// progress information, or null if no progress information is desired</param>
		private void DoInstall(HakInfo[] hakInfos, StringCollection decompressedErfs,
			string moduleFile, IHakInstallProgress progress)
		{
			mergeHak = string.Empty;
			mergeTlk = string.Empty;

			StringCollection tempDirs = new StringCollection();
			try
			{
				// Load the module file.
				Progress(progress, true, "Loading {0}", moduleFile);
				if (progress.IsCancelled) return;
				Erf module = Erf.Load(NWNInfo.GetFullFilePath(moduleFile));

				// Decompress the module to a temp directory.
				Progress(progress, true, "Decompressing {0}", moduleFile);
				currentTempDir = Decompress(module, tempDirs);

				// Load the moduleInfo for the module.
				ModuleInfo moduleInfo = new ModuleInfo(currentTempDir);

				// Check for any tlk file conflicts and abort the install if they
				// cannot be resolved.
				CheckForTlkConflicts(hakInfos, module, moduleInfo, progress);

				// Check for any file conflicts and make sure it is OK with the user.
				Progress(progress, false, "Checking for overwrites");
				CheckForHakConflicts(hakInfos, decompressedErfs, module, moduleInfo,
					progress);

				// Add any erf files to the module.
				foreach (string erfDir in decompressedErfs)
				{
					// Add each of the erf files to the module.
					string[] files = Directory.GetFiles(erfDir);
					foreach (string file in files)
					{
						// Add the file to the module.
						Progress(progress, true, "Adding {1} to\n{0}", moduleFile, Path.GetFileName(file));
						module.AddFile(Path.Combine(erfDir, file), true);

						// If the file is an area file then add it to the module's area list.
						if (0 == string.Compare(".are", Path.GetExtension(file), true, CultureInfo.InvariantCulture))
							moduleInfo.AddAreas(new string[] { Path.GetFileNameWithoutExtension(file) });
					}
				}

				// If we are overwriting files in the module then warn the user that
				// they are doing so and give them a chance to abort.
				if (module.ReplacedFiles.Count > 0)
				{
					// Create a conflict collection and ask the user what to do.  If
					// they cancel then trow a cancel exception to abort adding the
					// hak(s).
					FileConflictCollection conflicts = CreateConflictCollection(module);
					if (!progress.ShouldReplaceFiles(conflicts))
						throw new InstallCancelledException();

					// The user may have chosen to keep some of the original module
					// files, un-add any file that they chose not to replace.
					foreach (FileConflict conflict in conflicts)
						if (!conflict.ReplaceFile)
							module.RemoveFileFromAddedList(conflict.HakFile);
				}

				// Now loop through all of the haks and make any module changes
				// required.
				foreach (HakInfo hakInfo in hakInfos)
				{
					// Set all of the module properties.
					Progress(progress, true, "Setting module properties for {0}", moduleFile);
					PropertyHandlerDictionary handlers = objects["Module"];
					foreach (DictionaryEntry entry in hakInfo.ModuleProperties)
					{
						if (progress.IsCancelled) throw new InstallCancelledException();

						// Resolve the DictionaryEntry to native data.
						string property = (string) entry.Key;
						StringCollection values = (StringCollection) entry.Value;
						if (0 == values.Count) continue;

						// Look up the handler for the property, throwing an exception
						// if we don't find one, then invoke it.
						PropertyHandler handler = handlers[property];
						if (null == handler) 
							throw new InvalidOperationException("Unknown module property " + property);
						handler(module, moduleInfo, property, values);
					}
				}

				// If we have a merge hak then add it now so it goes to the top of
				// the hak list.
				if (string.Empty != mergeHak)
				{
					StringCollection mergeHakCollection = new StringCollection();
					mergeHakCollection.Add(mergeHak);
					Module_Hak(module, moduleInfo, "hak", mergeHakCollection);
				}

				// Build string arrays of the hif names and versions of all of the HakInfo
				// objects we added to the module, then update the module's installed
				// HakInfo property.  This is a custom property used by this tool to
				// keep track of what is installed on a module.
				string[] hifs = new string[hakInfos.Length];
				float[] versions = new float[hakInfos.Length];
				for (int i = 0; i < hakInfos.Length; i++)
				{
					hifs[i] = hakInfos[i].Name;
					versions[i] = hakInfos[i].Version;
				}
				moduleInfo.AddInstalledHakInfos(hifs, versions);

				// Save the changes to the module info file.
				moduleInfo.Save();

				// Backup the old module file before saving.
                // changed to not use the same extension as the toolset
				string backupName = Path.Combine(NWNInfo.GetPathForFile(moduleFile), 
					Path.GetFileNameWithoutExtension(moduleFile) + ".prc.BackupMod");
                // if a backup already exists, this means the module installer has been
                // used before. We don't want to overwrite it, otherwise the original is lost
                if(!File.Exists(backupName))
				    File.Copy(NWNInfo.GetFullFilePath(moduleFile), backupName, false);

				// Recreate the module file with our changed files.
				Progress(progress, true, "Saving {0}", moduleFile);
				module.RecreateFile();

				// If we created merge files then display a message to the user
				// telling them what we did.
				if (string.Empty != mergeHak || string.Empty != mergeTlk)
				{
					string files = "\r\n\r\n\t";
					if (string.Empty != mergeHak) files += NWN.NWNInfo.GetPartialFilePath(mergeHak);
					if (string.Empty != mergeTlk)
					{
						if (string.Empty != files) files += "\r\n\t";
						files += NWN.NWNInfo.GetPartialFilePath(mergeTlk);
					}

					progress.DisplayMessage(string.Format(
						"There were conflicts between the custom content you are trying to add and " +
						"the files already used by the module '{0}'.  Merge files were created to resolve " +
						"these conflicts, you should delete these files when you are finished " +
						"with your module." + files, Path.GetFileNameWithoutExtension(module.FileName)));
				}
			}
			catch (Exception e)
			{
				// Delete any merge files we created, the install is failing.s
				if (string.Empty != mergeTlk) File.Delete(NWN.NWNInfo.GetFullFilePath(mergeTlk));
				if (string.Empty != mergeHak) File.Delete(NWN.NWNInfo.GetFullFilePath(mergeHak));

				// If the exception isn't an InstallCancelledException then throw it.
				// InstallCancelledExceptions are thrown to abort the install, we want to eat those.
				if (!(e is InstallCancelledException)) throw;
			}
			finally
			{
				// Always clean up temp dirs no matter what.
				foreach (string dir in tempDirs)
					try
					{
						if (Directory.Exists(dir)) Directory.Delete(dir, true);
					}
					catch{}
			}
		}

		/// <summary>
		/// Installs the listed haks (defined by hif files) on the listed
		/// modules.  
		/// </summary>
		/// <param name="hifs">The list of haks to add</param>
		/// <param name="modules">The list of modules to add the haks to</param>
		/// <param name="progress">An interface used to an object used to display
		/// progress information, or null if no progress information is desired</param>
		private void DoInstall(HakInfo[] hifs, string[] modules,
			IHakInstallProgress progress)
		{
			StringCollection tempDirs = null;
			try
			{
				// Calcualte the number of steps needed for the progress bar.  The
				// hard coded numbers are based on the number of step calls in
				// DoInstall().
				progress.ProgressSteps = GetProgressCount(hifs, modules);

				// Load the hif files and decompress them to temp directories.
				tempDirs = DecompressHifErfs(hifs, progress);

				// Now apply the hifs to each module in turn.
				foreach (string module in modules)
					DoInstall(hifs, tempDirs, module, progress);
			}
			finally
			{
				// Always clean up temp dirs no matter what.
				if (null != tempDirs)
				{
					foreach (string dir in tempDirs)
						try
						{
							if (Directory.Exists(dir)) Directory.Delete(dir, true);
						}
						catch{}
				}
			}
		}
		#endregion

		#region private methods to generate merge scripts
		/// <summary>
		/// This method creates a script that calls ExecuteScript() to invoke
		/// multiple scripts.  It is designed to allow multiple scripts to wire up
		/// to an event handler.  The script is created and compiled and both
		/// the NSS and NCS files are added to the module.
		/// </summary>
		/// <param name="module">The module to modify</param>
		/// <param name="property">The property to which the scripts are being attached</param>
		/// <param name="originalScript">The original script on the property, or
		/// string.Empty if none</param>
		/// <param name="otherScripts">A list of other scripts to execute</param>
		/// <returns>The ResRef of the newly created script</returns>
		private string CreateExecuteScript(Erf module, string property, 
			string originalScript, StringCollection otherScripts)
		{
			// If the original script and the otherScripts are the same then
			// there is nothing to do, just return originalScript as the RefRef
			if (1 == otherScripts.Count && 
				0 == string.Compare(otherScripts[0], originalScript, true, CultureInfo.InvariantCulture))
				return originalScript.ToLower();

			// Build the file name and full name of the script file.
			string substring = property.Length > 12 ? property.Substring(0, 12) : property;
			string sourceName = "hif_" + substring + ".nss";
			string fullSourceName = Path.Combine(currentTempDir, sourceName);
			System.Text.StringBuilder b = new System.Text.StringBuilder();

			// Check to see if the original script is one of our generated scripts
			// (the name will start with "hif_" if it is).  If so then we need to
			// open the file and read the list of scripts currently being called
			// and add them to the list of scripts to call.
			StringCollection scriptsToExecute = new StringCollection();
			bool createScript = 
				0 != string.Compare(originalScript, Path.GetFileNameWithoutExtension(sourceName), true, CultureInfo.InvariantCulture);
			if (!createScript)
			{
				// Read the list of scripts currently being executed from the hif_
				// script file.
				string[] scripts = null;
				using (StreamReader reader = new StreamReader(fullSourceName))
				{
					// Read the first line, strip the comment prefix off, and
					// split the line into all of the scripts that the script
					// executes.
					string line = reader.ReadLine();
					line = line.Trim();
					line = line.Substring(3, line.Length - 3);
					scripts = line.Split(',');
				}

				// Add all of the scripts currently in the file, and then add
				// all of the scripts in the otherScripts collection if they aren't
				// already there.
				scriptsToExecute.AddRange(scripts);
				foreach (string script in otherScripts)
					if (!scriptsToExecute.Contains(script)) scriptsToExecute.Insert(0, script);
			}
			else
			{
                // Add all of the other scripts to our execute list, then add the
                // original script if there was one.
                // modified by fluffyamoeba 2008-06-16 
                // swapped so original script is executed last
				foreach (string script in otherScripts)
					scriptsToExecute.Add(script);
                if (string.Empty != originalScript) scriptsToExecute.Add(originalScript);
			}

			// Create the script file.
			using (StreamWriter writer = new StreamWriter(fullSourceName, false, 
					   System.Text.Encoding.ASCII))
			{
				// Make the first line be a list of the scripts being executed
				// so we can do updates to the file later.
				b.Length = 0;
				foreach (string script in scriptsToExecute)
				{
					if (b.Length > 0) b.Append(",");
					b.Append(script);
				}
				writer.WriteLine("// {0}", b.ToString());

				// Write out a comment header.
				writer.WriteLine("/////////////////////////////////////////////////////////////////////");
				writer.WriteLine("//");
				writer.WriteLine("// This script has been auto-generated by HakInstaller to call");
				writer.WriteLine("// multiple handlers for the {0} event.", property);
				writer.WriteLine("//");
				writer.WriteLine("/////////////////////////////////////////////////////////////////////");
				writer.WriteLine("");

				writer.WriteLine("void main()");
				writer.WriteLine("{");

				// Add an execute line for each script in the collection.
				foreach (string script in scriptsToExecute)
					writer.WriteLine("    ExecuteScript(\"{0}\", OBJECT_SELF);", script);

				writer.WriteLine("}");
				writer.Flush();
				writer.Close();
			}
			
			// Build the name of the obj file.
			string objName = Path.GetFileNameWithoutExtension(sourceName) + ".ncs";
			string fullObjName = Path.Combine(currentTempDir, objName);

			// Generate the compiler command line.
			string compiler = Path.Combine(NWNInfo.ToolsPath, "clcompile.exe");
			b.Length = 0;
			b.AppendFormat("\"{0}\" \"{1}\"", fullSourceName, currentTempDir);

			// Start the compiler process and wait for it.
			ProcessStartInfo info = new ProcessStartInfo();
			info.FileName = compiler;
			info.Arguments = b.ToString();
			info.CreateNoWindow = true;
			info.WindowStyle = ProcessWindowStyle.Hidden;
			Process process = Process.Start(info);
			process.WaitForExit();

			// If the compiler didn't work then we have a problem.
			if (0 != process.ExitCode)
				throw new NWNException("Could not run the NWN script compiler");

			// Add the source and object files to the module, if we have created new
			// files.  If the original script was a hif_ script that we just changed
			// then the file is already part of the module, no need to add it.
			if (createScript)
			{
				module.AddFile(fullSourceName, true);
				module.AddFile(fullObjName, true);
			}

			// Return the ResRef for the new script file.
			return Path.GetFileNameWithoutExtension(sourceName).ToLower();
		}
		#endregion

		#region private static fields/properties/methods
		private static HakInstaller singleton;

		/// <summary>
		/// Gets the singleton HakInstaller object.
		/// </summary>
		private static HakInstaller Singleton
		{
			get
			{
				// Create the singleton if we haven't already, and return it.
				if (null == singleton) singleton = new HakInstaller();
				return singleton;
			}
		}
		#endregion
	}
}
