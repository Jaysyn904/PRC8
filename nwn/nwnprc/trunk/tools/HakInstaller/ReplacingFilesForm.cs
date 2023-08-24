using System;
using System.Drawing;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.IO;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using HakInstaller;
using HakInstaller.Utilities;

namespace HakInstaller
{
	/// <summary>
	/// This form displays is a comfirmation box asking the user if the
	/// application should continue with replacing the listed files with
	/// files from added hak(s).
	/// </summary>
	public class ReplacingFilesForm : System.Windows.Forms.Form
	{
		#region public properties/methods
		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="conflicts">The list of file conflicts.</param>
		public ReplacingFilesForm(FileConflictCollection conflicts)
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			// Ignore events while initializing the form.
			ignoreEvents = true;

			pictureBox.Image = SystemIcons.Exclamation.ToBitmap();

			// There appears to be a bug in the 1.0 version of the framework.  On my
			// 3.2ghz machine, if listBox.Items.Add(conflict) is placed in the
			// foreach array it hangs, unless you slow it down somehow.  Moving
			// the add outside the loop and changing it to an AddRange() to add all
			// of the conflicts in one shot makes it work correctly, thus the change
			// to the code.

			// Add all of the conflicts to the list box.
			FileConflict[] conflictArray = new FileConflict[conflicts.Count];
			for (int i = 0; i < conflicts.Count; i++)
				conflictArray[i] = conflicts[i];
			listBox.Items.AddRange(conflictArray);

			// Loop through all of the conflicts setting their check state as appropriate.
			foreach (FileConflict conflict in conflicts)
			{
				int index = listBox.Items.IndexOf(conflict);
				listBox.SetItemChecked(index, conflict.ReplaceFile);
			}

			ignoreEvents = false;
		}
		#endregion

		#region protected fields/properties/methods
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}
		#endregion

		#region functionality for Win32 PlaySound API
		[Flags] private enum SoundFlags
		{
			Sync		= 0x00000000,	/* play synchronously (default) */
			Async		= 0x00000001,	/* play asynchronously */
			NoDefault	= 0x00000002,	/* silence (!default) if sound not found */
			Memory		= 0x00000004,	/* pszSound points to a memory file */
			Loop		= 0x00000008,	/* loop the sound until next sndPlaySound */
			NoStop		= 0x00000010,	/* don't stop any currently playing sound */
			NoWait		= 0x00002000,	/* don't wait if the driver is busy */
			Alias		= 0x00010000,	/* name is a registry alias */
			AliasId		= 0x00110000,	/* alias is a pre d ID */
			Filename	= 0x00020000,	/* name is file name */
			Resource	= 0x00040004,	/* name is resource name or atom */
			Purge		= 0x00000040,	/* purge non-static events for task */
			Application	= 0x00000080	/* look for application specific association */
		}

		public static void PlaySoundEvent(string sound)
		{
			PlaySound(sound, 0, 
				(int) (SoundFlags.Async | SoundFlags.Alias | SoundFlags.NoWait));
		}

		[DllImport("winmm.dll", EntryPoint="PlaySound",CharSet=CharSet.Auto)]
		private static extern int PlaySound(String pszSound, int hmod, int flags);
		#endregion

		#region Windows Form Designer generated code
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Button buttonContinue;
		private System.Windows.Forms.Button button2;
		private System.Windows.Forms.PictureBox pictureBox;
		private System.Windows.Forms.CheckedListBox listBox;
		private System.Windows.Forms.MenuItem menuItemViewHakFile;
		private System.Windows.Forms.MenuItem menuItemViewModFile;
		private System.Windows.Forms.ContextMenu contextMenuView;
		private System.Windows.Forms.Button buttonSelectAll;
		private System.Windows.Forms.Button buttonClearAll;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.label1 = new System.Windows.Forms.Label();
			this.buttonContinue = new System.Windows.Forms.Button();
			this.button2 = new System.Windows.Forms.Button();
			this.pictureBox = new System.Windows.Forms.PictureBox();
			this.listBox = new System.Windows.Forms.CheckedListBox();
			this.contextMenuView = new System.Windows.Forms.ContextMenu();
			this.menuItemViewHakFile = new System.Windows.Forms.MenuItem();
			this.menuItemViewModFile = new System.Windows.Forms.MenuItem();
			this.buttonSelectAll = new System.Windows.Forms.Button();
			this.buttonClearAll = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(72, 16);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(328, 56);
			this.label1.TabIndex = 0;
			this.label1.Text = "The following files in the module are being replaced by files in the hak\'s erfs. " +
				" This may cause the module to not run properly.   Select cancel to abort adding " +
				"the hak, or check the files that you want to replace in the module and select co" +
				"ntinue.";
			// 
			// buttonContinue
			// 
			this.buttonContinue.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.buttonContinue.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.buttonContinue.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonContinue.Location = new System.Drawing.Point(16, 278);
			this.buttonContinue.Name = "buttonContinue";
			this.buttonContinue.Size = new System.Drawing.Size(96, 24);
			this.buttonContinue.TabIndex = 4;
			this.buttonContinue.Text = "C&ontinue";
			// 
			// button2
			// 
			this.button2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.button2.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.button2.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.button2.Location = new System.Drawing.Point(128, 278);
			this.button2.Name = "button2";
			this.button2.Size = new System.Drawing.Size(96, 24);
			this.button2.TabIndex = 5;
			this.button2.Text = "&Cancel";
			// 
			// pictureBox
			// 
			this.pictureBox.Location = new System.Drawing.Point(24, 16);
			this.pictureBox.Name = "pictureBox";
			this.pictureBox.Size = new System.Drawing.Size(32, 32);
			this.pictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
			this.pictureBox.TabIndex = 3;
			this.pictureBox.TabStop = false;
			// 
			// listBox
			// 
			this.listBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.listBox.ContextMenu = this.contextMenuView;
			this.listBox.Location = new System.Drawing.Point(16, 80);
			this.listBox.Name = "listBox";
			this.listBox.Size = new System.Drawing.Size(296, 184);
			this.listBox.Sorted = true;
			this.listBox.TabIndex = 1;
			this.listBox.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.listBox_ItemCheck);
			// 
			// contextMenuView
			// 
			this.contextMenuView.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																							this.menuItemViewHakFile,
																							this.menuItemViewModFile});
			this.contextMenuView.Popup += new System.EventHandler(this.contextMenuView_Popup);
			// 
			// menuItemViewHakFile
			// 
			this.menuItemViewHakFile.Index = 0;
			this.menuItemViewHakFile.Text = "View &Hak File";
			this.menuItemViewHakFile.Click += new System.EventHandler(this.menuItemViewHakFile_Click);
			// 
			// menuItemViewModFile
			// 
			this.menuItemViewModFile.Index = 1;
			this.menuItemViewModFile.Text = "View &Module File";
			this.menuItemViewModFile.Click += new System.EventHandler(this.menuItemViewModFile_Click);
			// 
			// buttonSelectAll
			// 
			this.buttonSelectAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonSelectAll.Location = new System.Drawing.Point(328, 88);
			this.buttonSelectAll.Name = "buttonSelectAll";
			this.buttonSelectAll.Size = new System.Drawing.Size(72, 24);
			this.buttonSelectAll.TabIndex = 2;
			this.buttonSelectAll.Text = "&Select All";
			this.buttonSelectAll.Click += new System.EventHandler(this.buttonSelectAll_Click);
			// 
			// buttonClearAll
			// 
			this.buttonClearAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonClearAll.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonClearAll.Location = new System.Drawing.Point(328, 128);
			this.buttonClearAll.Name = "buttonClearAll";
			this.buttonClearAll.Size = new System.Drawing.Size(75, 24);
			this.buttonClearAll.TabIndex = 3;
			this.buttonClearAll.Text = "Clear &All";
			this.buttonClearAll.Click += new System.EventHandler(this.buttonClearAll_Click);
			// 
			// ReplacingFilesForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(416, 310);
			this.ControlBox = false;
			this.Controls.Add(this.buttonClearAll);
			this.Controls.Add(this.buttonSelectAll);
			this.Controls.Add(this.listBox);
			this.Controls.Add(this.pictureBox);
			this.Controls.Add(this.buttonContinue);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.button2);
			this.MinimumSize = new System.Drawing.Size(424, 344);
			this.Name = "ReplacingFilesForm";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Replace Files?";
			this.Load += new System.EventHandler(this.ReplacingFilesForm_Load);
			this.ResumeLayout(false);

		}
		#endregion

		#region private fields/properties/methods
		private bool ignoreEvents;
		#endregion

		#region form event handlers
		/// <summary>
		/// Handler for the load event.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void ReplacingFilesForm_Load(object sender, System.EventArgs e)
		{
			PlaySoundEvent("SystemExclamation");
		}
		#endregion

		#region control event handlers
		/// <summary>
		/// Handler for the list box's item check event.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listBox_ItemCheck(object sender, System.Windows.Forms.ItemCheckEventArgs e)
		{
			if (ignoreEvents) return;

			// Update the ReplaceFile property of the FileConflict object being clicked on
			// based on the new state of the check.
			FileConflict conflict = (FileConflict) listBox.Items[e.Index];
			conflict.ReplaceFile = CheckState.Checked == e.NewValue;
		}

		/// <summary>
		/// Handler for the view hak file menu pick, just runs wordpad to view
		/// the file (only works for text files obviously).
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuItemViewHakFile_Click(object sender, System.EventArgs e)
		{
			// Just run wordpad to view the file.
			FileConflict conflict = (FileConflict) listBox.SelectedItem;
			string args = "\"" + conflict.HakFile + "\"";
			System.Diagnostics.Process.Start("wordpad.exe", args);
		}

		/// <summary>
		/// Handler for the view module file menu pick, just runs wordpad to view
		/// the file (only works for text files obviously).
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuItemViewModFile_Click(object sender, System.EventArgs e)
		{
			// Just run notepad to view the file.
			FileConflict conflict = (FileConflict) listBox.SelectedItem;
			string args = "\"" + conflict.ModuleFile + "\"";
			System.Diagnostics.Process.Start("wordpad.exe", args);
		}

		/// <summary>
		/// Handler ofr the context menu's popup event, enables/disables menu items
		/// and sets their text appropriately.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void contextMenuView_Popup(object sender, System.EventArgs e)
		{
			int index = listBox.SelectedIndex;
			FileConflict conflict = index >= 0 ? (FileConflict) listBox.SelectedItem : null;

			// Menu picks are only enabled if a script source ".NSS" file is selected.
			bool enabled = index >= 0 && 
				0 == string.Compare(Path.GetExtension(conflict.FileName), ".nss", true, CultureInfo.InvariantCulture);

			menuItemViewHakFile.Enabled = enabled;
			menuItemViewModFile.Enabled = enabled;

			// Glue the selected file name onto the menu picks if they are enabled.
			if (enabled)
			{
				menuItemViewHakFile.Text = StringResources.GetString("ViewHakFileFormat", 
					listBox.SelectedItem.ToString());
				menuItemViewModFile.Text = StringResources.GetString("ViewModFileFormat", 
					listBox.SelectedItem.ToString());
			}
			else
			{
				menuItemViewHakFile.Text = StringResources.GetString("ViewHakFile");
				menuItemViewModFile.Text = StringResources.GetString("ViewModFile");
			}
		}

		/// <summary>
		/// Handler for the select all button, selects all files for replacing
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void buttonSelectAll_Click(object sender, System.EventArgs e)
		{
			listBox.BeginUpdate();
			for (int i = 0; i < listBox.Items.Count; i++)
				listBox.SetItemChecked(i, true);
			listBox.EndUpdate();
		}

		/// <summary>
		/// Handler for the clear all button, clears all files to prevent replacement.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void buttonClearAll_Click(object sender, System.EventArgs e)
		{
			listBox.BeginUpdate();
			for (int i = 0; i < listBox.Items.Count; i++)
				listBox.SetItemChecked(i, false);
			listBox.EndUpdate();
		}
		#endregion
	}
}
