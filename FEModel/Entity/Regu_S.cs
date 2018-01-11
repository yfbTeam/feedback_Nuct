using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class Regu_S
    {

        public int? SectionId { get; set; }

        public string DisPlayName { get; set; }

        public string CreateName { get; set; }

        public string ReguName { get; set; }

        public string CreateUID { get; set; }

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public DateTime? CreateTime { get; set; }

        public string State { get; set; }     

        public string TableName { get; set; }

        public int? Id { get; set; }

        public byte? LookType { get; set; }

        public int ReguState { get; set; }
    }
}
