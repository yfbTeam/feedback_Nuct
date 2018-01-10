using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class Table_Header
    {
        public int Id { get; set; }
        public string Header { get; set; }
        public int Sort { get; set; }

        public string CustomCode { get; set; }

        public string Value { get; set; }

        public int Type { get; set; }
    }
}
