using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class Table_View
    {
        public string Name { get; set; }
        public int IsScore { get; set; }

        public int IsEnable { get; set; }

        public int Table_Id { get; set; }

        List<Table_Header> table_Header_List = new List<Table_Header>();
        /// <summary>
        /// 表头
        /// </summary>
        public List<Table_Header> Table_Header_List
        {
            get { return table_Header_List; }
            set { table_Header_List = value; }
        }

        List<Table_Detail_Dic> table_Detail_Dic_List = new List<Table_Detail_Dic>();
        /// <summary>
        /// 表格详情
        /// </summary>
        public List<Table_Detail_Dic> Table_Detail_Dic_List
        {
            get { return table_Detail_Dic_List; }
            set { table_Detail_Dic_List = value; }
        }

        public object Info { get; set; }
    }
}
