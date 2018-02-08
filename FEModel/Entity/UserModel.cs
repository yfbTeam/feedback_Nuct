using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class UserModel
    {
        public int Num { get; set; }

        public string UniqueNo { get; set; }

        public string Name { get; set; }

        public byte? Sex { get; set; }

        public string DepartmentID { get; set; }

        public string DepartmentName { get; set; }

        public string SubDepartmentName { get; set; }

        public string ClassName { get; set; }

        public string ClassID { get; set; }

        public int? TeacherBirthday { get; set; }

        public int? TeacherSchooldate { get; set; }

        public string Status { get; set; }
    }
}
