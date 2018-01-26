using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class Eva_QuestionModel
    {

        public int? SectionID { get; set; }

        public string DisPlayName { get; set; }

        public string TeacherUID { get; set; }

        public string TeacherName { get; set; }

        public string CourseID { get; set; }

        public string CourseName { get; set; }

        public string DepartmentID { get; set; }

        public string DepartmentName { get; set; }

        public int? TableID { get; set; }

        public string TableName { get; set; }

        public int? State { get; set; }

        public decimal? Score { get; set; }

        public int Num { get; set; }

        public int? ReguID { get; set; }

        public string ReguName { get; set; }

        public string AnswerUID { get; set; }

        public string AnswerName { get; set; }

        public int? Id { get; set; }

        //public int? RoleID { get; set; }

        public IEnumerable<int?> RoleList { get; set; }
    }
}
