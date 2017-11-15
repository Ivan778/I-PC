using System.Management;

namespace DeviceManager
{
    public class WmiManager
    {
        public static ManagementObjectCollection Devices
        {
            get
            {
                var serialQuery = new SelectQuery("SELECT * FROM Win32_PnPEntity");
                var searcher = new ManagementObjectSearcher(new ManagementScope(), serialQuery);
                return searcher.Get();
            }
        }
    }
}