﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Management;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DeviceManager
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            var connectionScope = new ManagementScope();
            var serialQuery = new SelectQuery("SELECT * FROM Win32_PnPEntity");
            var searcher = new ManagementObjectSearcher(connectionScope, serialQuery);

            try
            {
                foreach (var item in searcher.Get())
                {
                    var name = item["Name"];
                    if (name != null)
                    {
                        listBox1.Items.Add(name.ToString());
                    }
                }
            }
            catch (ManagementException ex)
            {
                Console.WriteLine(ex);
                throw;
            }
        }
    }
}