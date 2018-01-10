using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class ReguModel
    {
        public int? SectionId { get; set; }

        public string Value { get; set; }

        public string DisPlayName { get; set; }

        public int? Id { get; set; }

        public byte? Study_IsEnable { get; set; }

        public DateTime? EndTime { get; set; }

        public int ReguState { get; set; }



        public DateTime? ReguStartTime { get; set; }

        public DateTime? ReguEndTime { get; set; }
    }
}
