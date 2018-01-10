using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class ClsModel
    {
        public string ClassID { get; set; }

        public string ClassName { get; set; }

        public string Major_ID { get; set; }
    }

    public class ClsModelComparer : EqualityComparer<ClsModel>
    {
        public override bool Equals(ClsModel x, ClsModel y)
        {
            return x.ClassID == y.ClassID;
        }
        public override int GetHashCode(ClsModel obj)
        {
            return obj.ClassID.GetHashCode();
        }
    }
}
