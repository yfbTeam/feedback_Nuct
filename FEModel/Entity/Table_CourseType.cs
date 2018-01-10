using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class Table_CourseType
    {
        public string Course_Key { get; set; }

        public string Course_Value { get; set; }

        public List<Eva_Table> Eva_Table_List { get; set; }

        public int Eva_Role { get; set; }
    }
}
