using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class CourseSection
    {

        public int? SectionId { get; set; }

        public int? Sort { get; set; }

        public string Value { get; set; }

        public string Type { get; set; }

        public string DisPlayName { get; set; }

        public DateTime? CreateTime { get; set; }

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public int? Id { get; set; }

        public string Key { get; set; }

        public int? Pid { get; set; }

        public byte? Study_IsEnable { get; set; }

        public byte? IsEnable { get; set; }

        public int ReguState { get; set; }

        public string State { get; set; }
    }
}
