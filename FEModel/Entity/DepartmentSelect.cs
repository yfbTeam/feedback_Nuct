using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class DepartmentSelect
    {

        public string DepartMentID { get; set; }

        public string DepartmentName { get; set; }
    }

    public class DepartmentSelectComparer : EqualityComparer<DepartmentSelect>
    {
        public override bool Equals(DepartmentSelect x, DepartmentSelect y)
        {
            return x.DepartMentID == y.DepartMentID;
        }
        public override int GetHashCode(DepartmentSelect obj)
        {
            return obj.DepartMentID.GetHashCode();
        }
    }
}
