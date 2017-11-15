using System;
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
                int i = 0;
                foreach (var item in searcher.Get())
                {
                    var name = item["Name"];
                    var deviceId = item["DeviceID"];
                    var guid = item["ClassGuid"];

                    if (name != null)
                    {
                        listBox1.Items.Add($"{i}) " + name.ToString());
                    }
                    else
                    {
                        listBox1.Items.Add($"{i}) " + "");
                    }


                    if (deviceId != null)
                    {
                        listBox2.Items.Add($"{i}) " + deviceId.ToString());
                    }
                    else
                    {
                        listBox2.Items.Add($"{i}) " + "");
                    }

                    if (guid != null)
                    {
                        listBox3.Items.Add($"{i}) " + guid.ToString());
                    }
                    else
                    {
                        listBox3.Items.Add($"{i}) " + "");
                    }

                    i++;
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
