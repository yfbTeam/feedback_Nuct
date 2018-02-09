using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class TNModel
    {

        public string TeacherDepartmentName { get; set; }

        public string TeacherName { get; set; }

        public string TeacherUID { get; set; }
    }

    public class TNModelComparer : EqualityComparer<TNModel>
    {
        public override bool Equals(TNModel x, TNModel y)
        {
            return x.TeacherUID == y.TeacherUID;
        }
        public override int GetHashCode(TNModel obj)
        {
            return obj.TeacherName.GetHashCode();
        }
    }
}
