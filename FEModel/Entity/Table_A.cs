using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    /// <summary>
    /// 定期表格设计用
    /// </summary>
    public class Table_A
    {
        /// <summary>
        /// 教学内容
        /// </summary>
        public string indicator_type_tname { get; set; }
        /// <summary>
        /// Indicator_type_tid
        /// </summary>
        public long indicator_type_tid { get; set; }

        public string indicator_type_value { get; set; }

        /// <summary>
        /// Indicator_list
        /// </summary>
        public List<indicator_list> indicator_list { get; set; }
    }
}
