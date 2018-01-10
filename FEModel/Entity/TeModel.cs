using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class TeModel
    {

        public string TeacherUID { get; set; }

        public string TeacherName { get; set; }
    }

    public class TeModelComparer : EqualityComparer<TeModel>
    {
        public override bool Equals(TeModel x, TeModel y)
        {
            return x.TeacherUID == y.TeacherUID;
        }
        public override int GetHashCode(TeModel obj)
        {
            return obj.TeacherUID.GetHashCode();
        }
    }
}
