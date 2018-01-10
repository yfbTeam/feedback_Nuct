using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class DPModel
    {
        public string Major_ID { get; set; }

        public string DepartmentName { get; set; }


    }

    public class DPModelComparer : EqualityComparer<DPModel>
    {
        public override bool Equals(DPModel x, DPModel y)
        {
            return x.Major_ID == y.Major_ID;
        }
        public override int GetHashCode(DPModel obj)
        {
            return obj.Major_ID.GetHashCode();
        }
    }
}
